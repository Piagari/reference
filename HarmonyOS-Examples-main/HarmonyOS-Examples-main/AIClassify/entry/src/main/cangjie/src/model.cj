package ohos_app_cangjie_entry

import ohos.hilog.Hilog
import ohos_app_cangjie_entry.common.CommonConstants
import ohos_app_cangjie_entry.mindspore.*;
import std.random.Random
import std.math.round
import std.collection.ArrayList
import std.collection.HashSet

// c function
foreign func malloc(size: UIntNative): CPointer<Unit>
foreign func free(ptr: CPointer<Unit>): Unit
foreign func memcpy(dest: CPointer<Unit>, src: CPointer<Unit>, size: UIntNative): Unit

public class Model {
  // 图像尺寸计算
  private let image_area = Int64(CommonConstants.MODEL_INPUT_HEIGHT) * Int64(CommonConstants.MODEL_INPUT_WIDTH)
  private let input_buffer_size = UIntNative(this.image_area * 3)
  private let input_buffer_bytes = this.input_buffer_size * 4

  // 模型资源
  private var p_model_buffer: CPointer<UInt8> = CPointer<UInt8>()
  private var model_buffer_size: UIntNative = 0

  // 输入缓冲区
  private var p_input_unit_buffer: CPointer<Unit> = CPointer<Unit>()
  private var p_input_buffer: CPointer<Float32> = CPointer<Float32>()

  // 张量句柄
  private var model: OH_AI_ModelHandle = OH_AI_ModelHandle()
  private var inputs: OH_AI_TensorHandleArray = OH_AI_TensorHandleArray()
  private var outputs: OH_AI_TensorHandleArray = OH_AI_TensorHandleArray()
  private var p_outputs: CPointer<OH_AI_TensorHandleArray> = unsafe {
    CPointer<OH_AI_TensorHandleArray>(malloc(sizeOf<OH_AI_TensorHandleArray>()))
  }

  // 分配输入缓冲区
  func malloc_input_buffer() {
    Hilog.info(0, "malloc", "===== malloc input output buffer =====")
    this.p_input_unit_buffer = unsafe { malloc(this.input_buffer_bytes) }
    this.p_input_buffer = unsafe { CPointer<Float32>(this.p_input_unit_buffer) }
  }

  func is_empty_model(): Bool {
    return this.model.isNull();
  }

  // 加载模型文件
  func load_model_buffer(): Bool {
    // 拷贝模型给C指针
    let stage_context = getStageContext(get_context())
    let resource_manager = ResourceManager.getResourceManager(stage_context)

    try {
      let model_buffer = resource_manager.getRawFileContent("mobilenetv2.ms")
      this.model_buffer_size = UIntNative(model_buffer.size)
      this.p_model_buffer = unsafe { CPointer<UInt8>(malloc(this.model_buffer_size)) }

      var temp_p = this.p_model_buffer
      for (i in 0..model_buffer.size) {
        unsafe {
          temp_p.write(model_buffer[i])
          temp_p = temp_p + 1
        }
      }
      return true
    } catch(e: Exception) {
      Hilog.error(0, "load_model", "===== load model error: ${e.message}")
      return false
    }
  }

  // 构建模型上下文并加载模型
  func build_model(): Bool {
    let context = oh_ai_context_create()
    if (context.isNull()) {
      return false
    }
    oh_ai_context_set_threadnum(context, 2)
    oh_ai_context_set_thread_affinity_mode(context, 1)
    let cpu_info = oh_ai_device_info_create(OH_AI_DeviceTypeEnum.OH_AI_DEVICETYPE_CPU)
    if (cpu_info.isNull()) {
      oh_ai_context_destroy(context)
      return false
    }
    oh_ai_device_info_set_enable_fp16(cpu_info, true)
    oh_ai_context_add_device_info(context, cpu_info)
    this.model = oh_ai_model_create()
    if (this.model.isNull()) {
      oh_ai_context_destroy(context)
      return false
    }
    let status = oh_ai_model_build(
      model,
      CPointer<Unit>(this.p_model_buffer),
      UIntNative(this.model_buffer_size),
      OH_AI_ModelTypeEnum.OH_AI_MODELTYPE_MINDIR,
      context
    )
    if (status != OH_AI_StatusEnum.OH_AI_STATUS_SUCCESS) {
      oh_ai_model_destroy(this.model)
      Hilog.error(0, "build model", "===== Model failed: ${OH_AI_StatusEnum.get_error_message(status)} =====")
      return false
    }

    return true
  }

  // 绑定输入输出张量
  func bind_io(): Bool {
    this.inputs = oh_ai_model_get_inputs(model)
    this.outputs = oh_ai_model_get_outputs(model)

    if (inputs.handle_list.isNull() ||
        inputs.handle_num != 1 ||
        outputs.handle_list.isNull() ||
        outputs.handle_num != 1
    ) {
      oh_ai_model_destroy(this.model)
      return false
    }
    let first_input = unsafe { this.inputs.handle_list.read() }
    oh_ai_tensor_set_data(first_input, this.p_input_unit_buffer)
    unsafe { this.p_outputs.write(this.outputs) }
    return true
  }

  // 预处理图像数据
  public func preprocess(input_uint8_buffer: Array<UInt8>) {
    var p = this.p_input_buffer
    for (i in 0..input_uint8_buffer.size) {
      if ((i + 1) % 4 == 0) {
        unsafe {
          p.write(Float32((Float64(input_uint8_buffer[i - 3]) / Float64(CommonConstants.RGB_MAX_VALUE) - CommonConstants.MEANS[0]) / CommonConstants.STDS[0])); p += 1
          p.write(Float32((Float64(input_uint8_buffer[i - 2]) / Float64(CommonConstants.RGB_MAX_VALUE) - CommonConstants.MEANS[1]) / CommonConstants.STDS[1])); p += 1
          p.write(Float32((Float64(input_uint8_buffer[i - 1]) / Float64(CommonConstants.RGB_MAX_VALUE) - CommonConstants.MEANS[2]) / CommonConstants.STDS[2])); p += 1
        }
      }
    }
  }

  // 执行推理
  func run_inference(): OH_AI_Status {
    return oh_ai_model_predict(this.model, this.inputs, this.p_outputs, CPointer<Unit>(), CPointer<Unit>())
  }

  // 解析输出张量
  func parse_output(): VArray<Float32, $500> {
    let first_output_handle = unsafe { this.outputs.handle_list.read() }
    let p_first_output = oh_ai_tensor_get_data(first_output_handle)
    if (p_first_output.isNull()) {
      return VArray<Float32, $500>({_: Int64 => 0.0})
    }

    var outputs_array = VArray<Float32, $500>({_: Int64 => 0.0})
    var p_temp_output = unsafe { CPointer<Float32>(p_first_output) }
    for (ii in 0..outputs_array.size) {
      outputs_array[ii] = unsafe { p_temp_output.read() }
      unsafe { p_temp_output = p_temp_output + 1 }
    }
    return outputs_array
  }

  // 后处理：取前5个最大值及索引
  public func postprocess(outputs_array: VArray<Float32, $500>): (Float32, Array<Int64>, Array<Int64>) {
    var max_value: Float32 = 0.0
    let max_value_array = Array<Int64>(5, { _: Int64 => 0 })
    let max_index_array = Array<Int64>(5, { _: Int64 => 0 })
    var has_seen = HashSet<Int64>()

    for (x in 0..5) {
      max_value = outputs_array[0]
      var max_index = 0
      for (j in 1..CommonConstants.LABELS_NAME_MAP.size) {
        if (outputs_array[j] > max_value && !has_seen.contains(j)) {
          max_value = outputs_array[j]
          max_index = j
          has_seen.put(j)
        }
      }
      max_value_array[x] = Int64(round(max_value * Float32(CommonConstants.TEN_THOUSAND)))
      max_index_array[x] = max_index
    }

    return (max_value, max_value_array, max_index_array)
  }

  // 公共接口：执行推理
  public func inference(image_buffer: Array<UInt8>): (Float32, Array<Int64>, Array<Int64>) {
    this.preprocess(image_buffer)
    if (this.model.isNull()) {
      return defaultResult()
    }

    let result = run_inference()
    if (result != OH_AI_StatusEnum.OH_AI_STATUS_SUCCESS) {
      return defaultResult()
    }
    return postprocess(parse_output())
  }

  // 默认返回结果
  private func defaultResult(): (Float32, Array<Int64>, Array<Int64>) {
    let defVal = Array<Int64>(5, { _: Int64 => 0 })
    return (0.0, defVal, defVal)
  }

  // 释放资源
  public func free() {
    if (!this.model.isNull()) {
      oh_ai_model_destroy(this.model)
    }
    if (!this.p_model_buffer.isNull()) {
      unsafe { free(CPointer<Unit>(this.p_model_buffer)) }
    }
    if (!this.p_input_unit_buffer.isNull()) {
      unsafe { free(CPointer<Unit>(this.p_input_unit_buffer)) }
    }
    unsafe { free(CPointer<Unit>(this.p_outputs)) }
  }
}