package ohos_app_cangjie_entry.mindspore
import std.fs.File
import std.fs.Path
import std.collection.ArrayList
import ohos.hilog.Hilog

// 模型推理结果
public enum InferenceStatus {
  Failed | Success | NotLoadModel
}

func print_log(str: String) {
  Hilog.info(0, "MindSporeLite", str);
}


func println_log(str: String) {
  Hilog.info(0, "MindSporeLite", "${str}\n");
}

func eprint_log(str: String) {
  Hilog.error(0, "MindSporeLite", str);
}


func eprintln_log(str: String) {
  Hilog.error(0, "MindSporeLite", "${str}\n");
}


public class MindSporeLite {
  // 准备读取模型的指针
  public var p_model_buffer: CPointer<UInt8> = CPointer<UInt8>();
  var raw_model_buffer: CPointer<Unit> = CPointer<Unit>();
  var model_buffer_size: UIntNative = 0;
  // 准备一个空模型，等编译的时候再初始化
  var model: OH_AI_ModelHandle = OH_AI_ModelHandle();

  // 一些模型参数
  // 单次最大推理长度
  var max_prefill_length: UInt32 = 1;
  // kv-cache最大长度
  var kv_cache_length: UInt32 = 1;
  // 是否开启fp16
  var use_fp16: Bool = false;
  var num_hidden_layers: UInt32 = 1;
  var num_key_value_heads: UInt32 = 1;
  var per_head_dim: UInt32 = 1;
  var vocab_size: UInt32 = 1;

  // 推理的时候记录输入信息
  // 已经缓存的真实kv_cache长度
  var real_kv_size: Int64 = 0;
  // 本次推理传入的kv_size数值
  var past_kv_size: Int64 = 1;
  // 本次输入定位位置
  var input_pos: Int64 = 0;

  // === 准备一些输入内存空间 ===
  // input_ids[1, max_prefill_length]
  var raw_input_ids: CPointer<Unit> = CPointer<Unit>();
  var p_input_ids: CPointer<Int32> = CPointer<Int32>();
  var input_ids_size: Int64 = 0;
  var input_ids_bytes: UIntNative = 0;

  // attention_mask[1, max_prefill_length + kv_cache_length]
  var raw_attention_mask: CPointer<Unit> = CPointer<Unit>();
  var p_attention_mask: CPointer<Int32> = CPointer<Int32>();
  var attention_mask_size: Int64 = 0;
  var attention_mask_bytes: UIntNative = 0;

  // position_ids[1, max_prefill_length]
  var raw_position_ids: CPointer<Unit> = CPointer<Unit>();
  var p_position_ids: CPointer<Int32> = CPointer<Int32>();
  var position_ids_size: Int64 = 0;
  var position_ids_bytes: UIntNative = 0;

  // past_key_values[1, num_hidden_layers * 2 * num_key_value_heads, kv_cache_length, per_head_dim]
  var raw_past_key_values: CPointer<Unit> = CPointer<Unit>();
  // Todo 貌似原始指针不支持float16,先用float32顶着，后面看看能否优化。
  var p_past_key_values_float: CPointer<Float32> = CPointer<Float32>();
  var past_key_value_size: Int64 = 0;
  var past_key_value_bytes: UIntNative = 0;

  // === 尝试准备一些输出信息 ===
  // logits[1, 1, vocab_size, 1]
  var raw_logits: CPointer<Unit> = CPointer<Unit>();
  var p_logits: CPointer<Float32> = CPointer<Float32>();
  var logits_size: Int64 = 0;
  var logits_bytes: UIntNative = 0;
  // new_kv_cache[1, num_hidden_layers * 2 * num_key_value_head, temp_seq_len, per_head_dim]
  // 注：temp_seq_len目前固定是1，等支持动态输入后，才能是其它的
  var raw_new_kv_cache: CPointer<Unit> = CPointer<Unit>();
  var p_new_kv_cache: CPointer<Float32> = CPointer<Float32>();
  var new_kv_cache_size: Int64 = 0;
  var new_kv_cache_bytes: UIntNative = 0;

  // 持久化一个array数组，用于读取输出结果
  var logits_output: Array<Float32> = Array<Float32>();

  // 由于推理的时候，outputs这边传入的是指针，所以还需要求outputs指针所在地址
  // 创建一个绑定输出结构体的指针,
  var p_outputs: CPointer<OH_AI_TensorHandleArray> = unsafe{
     CPointer<OH_AI_TensorHandleArray>(
          malloc(sizeOf<OH_AI_TensorHandleArray>())
     )
  };

  public func load_params(
    num_hidden_layers!: UInt32,
    num_key_value_heads!: UInt32,
    per_head_dim!: UInt32,
    vocab_size!: UInt32,
    max_prefill_length!: UInt32 = 1,
    kv_cache_length!: UInt32 = 1024,
    use_fp16!: Bool = false
  ) {
    println_log("=== INFO num_hidden_layers = ${num_hidden_layers} ===")
    println_log("=== INFO num_key_value_heads = ${num_key_value_heads} ===")
    println_log("=== INFO per_head_dim = ${per_head_dim} ===")
    println_log("=== INFO vocab_size = ${vocab_size} ===")
    println_log("=== INFO max_prefill_length = ${max_prefill_length} ===")
    println_log("=== INFO kv_cache_length = ${kv_cache_length} ===")
    println_log("=== INFO use_fp16 = ${use_fp16} ===")
    this.num_hidden_layers = num_hidden_layers;
    this.num_key_value_heads = num_key_value_heads;
    this.per_head_dim = per_head_dim;
    this.vocab_size = vocab_size;
    this.max_prefill_length = max_prefill_length;
    this.kv_cache_length = kv_cache_length;
    // 由于采用固定长度的Cache,所以past_kv_size和kv_cache_length保持一致
    this.past_kv_size = Int64(kv_cache_length);
    this.use_fp16 = use_fp16;
    // 处理输入数据指针
    this.input_ids_size = Int64(max_prefill_length);
    this.input_ids_bytes = sizeOf<Int32>() * UIntNative(this.input_ids_size);
    this.attention_mask_size = Int64(max_prefill_length + kv_cache_length);
    this.attention_mask_bytes = sizeOf<Int32>() * UIntNative(this.attention_mask_size);
    this.position_ids_size = Int64(max_prefill_length);
    this.position_ids_bytes = sizeOf<Int32>() * UIntNative(this.position_ids_size);
    this.past_key_value_size = Int64(
      num_hidden_layers * 2 * num_key_value_heads * kv_cache_length * per_head_dim
    );
    this.past_key_value_bytes = sizeOf<Float32>() * UIntNative(this.past_key_value_size);
    // 处理输出数据指针
    this.logits_size = Int64(max_prefill_length * vocab_size);
    this.logits_bytes = sizeOf<Float32>() * UIntNative(this.logits_size);
    // 持久化输出logits数组
    this.logits_output = Array<Float32>(Int64(this.vocab_size), {_ => 0.0});
    this.new_kv_cache_size = Int64(
      num_hidden_layers * 2 * num_key_value_heads * 1 * per_head_dim
    );
    this.new_kv_cache_bytes = sizeOf<Float32>() * UIntNative(this.new_kv_cache_size);
  }

  public func malloc_buffer(model_buffer_length: Int64) {
    // 预分配输入与模型占用内存的空间
    unsafe {
      this.raw_input_ids = malloc(this.input_ids_bytes);
      this.p_input_ids = CPointer<Int32>(this.raw_input_ids);

      this.raw_attention_mask = malloc(this.attention_mask_bytes);
      this.p_attention_mask = CPointer<Int32>(this.raw_attention_mask);
      // 第一步，初始化attention_mask所有数值均为0
      memset(this.raw_attention_mask, 0, this.attention_mask_bytes);
      // 第二步，将this.past_kv_size~this.attention_mask_size长度的数值设置为1
      var tmp_p = this.p_attention_mask;
      for (ii in 0..this.attention_mask_size) {
        unsafe{
          if (ii >= this.past_kv_size) {
            tmp_p.write(1);
          }
          tmp_p = tmp_p + 1;
        }
      }
      this.raw_position_ids = malloc(this.position_ids_bytes);
      this.p_position_ids = CPointer<Int32>(this.raw_position_ids);

      this.raw_past_key_values = malloc(this.past_key_value_bytes);
      // 初始化past_key_values为0
      memset(this.raw_past_key_values, 0, this.past_key_value_bytes);
      this.p_past_key_values_float = CPointer<Float32>(this.raw_past_key_values);

      // 初始化一下输出相关的数据指针看看(实测不用初始化，等有输出了，直接copy指针就行)
      // this.raw_logits = malloc(this.logits_bytes);
      // this.p_logits = CPointer<Float32>(this.raw_logits);
      // this.raw_new_kv_cache = malloc(this.new_kv_cache_bytes);
      // this.p_new_kv_cache = CPointer<Float32>(this.raw_new_kv_cache);
      // 初始化模型buffer
      // 将模型长度传给模型指针
      this.model_buffer_size = UIntNative(model_buffer_length);
      this.raw_model_buffer = malloc(this.model_buffer_size);
      this.p_model_buffer = CPointer<UInt8>(this.raw_model_buffer)
    }
  }

  public func reset() {
    this.input_pos = 0;
    this.real_kv_size = 0;
    // reset input_buffer
    unsafe {
      // 第一步，初始化attention_mask所有数值均为0
      memset(this.raw_attention_mask, 0, this.attention_mask_bytes);
      // 第二步，将this.past_kv_size~this.attention_mask_size长度的数值设置为1
      var tmp_p = this.p_attention_mask;
      for (ii in 0..this.attention_mask_size) {
        unsafe{
          if (ii >= this.past_kv_size) {
            tmp_p.write(1);
          }
          tmp_p = tmp_p + 1;
        }
      }
      // 初始化past_key_values为0
      memset(this.raw_past_key_values, 0, this.past_key_value_bytes);
    }
  }

  public func load_model_buffer_iter(model_buffer: Array<UInt8>, buffer_length: Int64, p_temp_model: CPointer<UInt8>): CPointer<UInt8> {
    // println_log("=== INFO load model buffer === ");
    // 读取模型文件，可以传入buffer加偏移量
    // 每次读取一小段，然后返回偏移后的指针，方便下一次写入数据
    var temp_p = p_temp_model;
    unsafe{
      // temp_p = this.p_model_buffer[offset];
      for (i in 0..buffer_length) {
        temp_p.write(model_buffer[i]);
        temp_p = temp_p + 1;
      }
    };
    return temp_p;
  }

  public func build_model(enable_cpu_fp16!: Bool = false): Bool {
    // 编译模型文件
    // 先创建上下文
    var context: OH_AI_ContextHandle = oh_ai_context_create();
    if (context.isNull()) {
      eprintln_log("===== OH_AI__LITE_ERR: Create OH_AI_Lite context failed.===== ");
      return false;
    }
    // 创建CPU执行器
    var cpu_info: OH_AI_DeviceInfoHandle = oh_ai_device_info_create(OH_AI_DeviceTypeEnum.OH_AI_DEVICETYPE_CPU);
    if (cpu_info.isNull()) {
      oh_ai_context_destroy(context);
      eprintln_log("===== OH_AI__LITE_ERR: Create CPU Info failed.=====");
      return false;
    }
    if (enable_cpu_fp16) {
      println_log("=== cpu_info enable fp16 ===");
      oh_ai_device_info_set_enable_fp16(cpu_info, true)
    }
    oh_ai_context_add_device_info(context, cpu_info);
    println_log("=== create empty model ===");
    this.model = oh_ai_model_create();
    if (this.model.isNull()) {
      // 释放context
      oh_ai_context_destroy(context)
      eprintln_log("===== OH_AI__LITE_ERR: create model failed.=====");
      return false;
    }
    println_log("=== begin build model ===")
    let status: OH_AI_Status = oh_ai_model_build(
      model,
      raw_model_buffer,
      this.model_buffer_size,
      OH_AI_ModelTypeEnum.OH_AI_MODELTYPE_MINDIR,
      context
    );
    if (status != OH_AI_StatusEnum.OH_AI_STATUS_SUCCESS) {
      // 此时context已经到模型中，如果失败，则需要释放模型，context会随着模型一起释放
      oh_ai_model_destroy(this.model);
      eprintln_log("===== OH_AI__LITE_ERR: model failed, code = ${status}.===== \n");
      return false;
    }
    println_log("=== OH_AI__LITE_INFO: model build sucess ===");
    return true;
  }

  public func inference(input_ids: Array<UInt32>): Option<Array<Float32>> {
    let seq_len = input_ids.size;
    for (i in 0..seq_len) {
      let res = this.inference_one(input_ids[i..i+1]);
      if (!res) {
        return None;
      }
    }
    // 输出logits
    var temp_p: CPointer<Float32> = this.p_logits;
    for (j in 0..this.logits_size) {
      unsafe{
        this.logits_output[j] = temp_p.read();
        temp_p = temp_p + 1;
      }
    }
    return Some(this.logits_output);

  }

  public func preprocess(input_ids: Array<UInt32>) {
    // 对输入数据做预处理
    // param: input_ids: 单次推理的input_ids，目前只支持1个input_id
    // param temp_seq_len: 单次推理的input_ids长度，目前只支持1
    // 拷贝input_ids
    // println_log("===== OH_AI__LITE_INFO: preprocss ===== \n");
    // println_log("=== real kv size = ${this.real_kv_size}");
    var temp_p1: CPointer<Int32> = this.p_input_ids;
    for (xx in 0..this.input_ids_size) {
      unsafe{
        temp_p1.write(Int32(input_ids[xx]));
        temp_p1 = temp_p1 + 1;
      }
    }

    // 处理attention_mask(将this.real_kv_size ~ this.past_kv_size)长度的数值设置为0
    // 第一步，将所有attention_mask设置为0(已经在初始化的时候设置过了)
    // 第二步，将this.past_kv_size~this.attention_mask_size长度的数值设置为1（已经初始化的时候设置过了）
    // 第三步，将0 ~ this.real_kv_size+1长度的数值设置为1
    var temp_ap = this.p_attention_mask;
    for (_ in 0..=this.real_kv_size) {
      unsafe {
        temp_ap.write(1);
        temp_ap += 1;
      }
    }

    // 处理position_ids
    // 它的数值范围应该是this.input_pos到this.input_pos + temp_seq_len(temp_seq_len目前也只能是1)
    // 拷贝position_ids
    var temp_p2: CPointer<Int32> = this.p_position_ids;
    let position_id: Int32 = Int32(this.input_pos);
    for (_ in 0..this.position_ids_size) {
      unsafe{
        temp_p2.write(position_id);
        temp_p2 = temp_p2 + 1;
      }
    }
    // 处理past_key_cache，基本不用动它，固定的
  }

  public func postprocess(temp_seq_len!: Int64 = 1) {
    // 后处理，更新kv_cache
    // println_log("===== OH_AI__LITE_INFO: postprocess ===== \n");
    var seq_len = temp_seq_len;
    this.input_pos = this.real_kv_size + seq_len;
    if (seq_len + this.real_kv_size > Int64(this.kv_cache_length)) {
      seq_len = Int64(this.kv_cache_length) - this.real_kv_size;
    }
    if (seq_len < 0) {
      // 不更新kv_cache了
      return;
    }
    // 更新kv_cache
    // kv_cache shape: [batch, num_hidden_layers * 2 * num_key_value_heads,  kv_cache_length, per_head_dim]
    // new_kv_cache shape: [batch, num_hidden_layers * 2 * num_key_value_heads,  temp_seq_len, per_head_dim]
    // 需要写一个这样的逻辑：
    // kv_cache[:, :, self.real_kv_size: self.real_kv_size + seq_len, :] = new_kv_cache[:, :, 0: seq_len, :]
    var p_target: CPointer<Float32> = this.p_new_kv_cache;
    var p_src: CPointer<Float32> = this.p_past_key_values_float;
    // 先将p_src从[:,:, 0, 0]切到[:, :, real_kv_size, 0]
    for (_ in 0..this.real_kv_size) {
      for (_ in 0..this.per_head_dim) {
        unsafe {
          p_src = p_src + 1;
        }
      }
    }
    // 执行切片操作(batch=1)
    // kv_cache[:, :, self.real_kv_size: self.real_kv_size + seq_len, :] = new_kv_cache[:, :, 0: seq_len, :]
    let dim1 = this.num_hidden_layers * 2 * num_key_value_heads;
    // 遍历kv_cache，遇到0 < dim2 < seq_len,则执行一次操作
    for (_ in 0..dim1) {
      for (xx in 0..Int64(this.kv_cache_length)) {
        for (_ in 0..this.per_head_dim) {
          unsafe{
            if (xx >= 0 && xx < seq_len) {
              p_src.write(p_target.read())
              p_target = p_target + 1;
            }
            p_src = p_src + 1;
          }
        }
      }
    }
    // 更新real_kv_size
    this.real_kv_size += seq_len;
  }

  // func test_print_input() {
  //   // 临时测试函数，用于打印输入信息
  //   for (idx in 0..3) {
  //     let (temp_size, temp_point, temp_str) = match(idx) {
  //       case 0 => (this.input_ids_size, this.p_input_ids, "input_ids");
  //       case 1 => (this.attention_mask_size, this.p_attention_mask, "attention_mask");
  //       case 2 => (this.position_ids_size, this.p_position_ids, "position_ids");
  //       case index => throw Exception("unknow index ${index}");
  //     }
  //     println_log("${temp_str} size = ${temp_size}")
  //     print("${temp_str}: ");
  //     var temp_p1 = temp_point;
  //     for (_ in 0..temp_size) {
  //       let data = unsafe{
  //         let temp_data = temp_p1.read();
  //         temp_p1 = temp_p1 + 1;
  //         temp_data
  //       }
  //       print("${data},")
  //     }
  //     println_log("");
  //   }
  //   println_log("past_key_values size = ${this.past_key_value_size}")
  //   var temp_p2 = this.p_past_key_values_float;
  //   var data_sum: Float64 = 0.0;
  //   var data_max: Float64 = Float64.Min;
  //   print("past_key_value[:${Int64(this.per_head_dim) * 2}] = ")
  //   for (i in 0..this.past_key_value_size) {
  //     let data = Float64(unsafe{
  //       let temp_data = temp_p2.read();
  //       temp_p2 = temp_p2 + 1;
  //       temp_data
  //     });
  //     data_sum += data;
  //     if (data > data_max) {
  //       data_max = data;
  //     }
  //     if (i < Int64(this.per_head_dim) * 2) {
  //       print("${data}, ");
  //     }
  //   }
  //   println_log("");
  //   let data_mean = data_sum / Float64(this.past_key_value_size);
  //   println_log("past_key_value mean=${data_mean}, sum = ${data_sum}, max = ${data_max}");
  // }

  // func test_print_output() {
  //   // 临时测试函数，用于打印输出数值的信息
  //   // 打印logits
  //   println_log("logits size = ${this.logits_size}")
  //   var temp_p1 = this.p_logits;
  //   var data_sum: Float64 = 0.0;
  //   var data_max: Float64 = Float64.Min;
  //   println_log("logits[:${Int64(this.per_head_dim) * 2}] = ")
  //   for (i in 0..this.logits_size) {
  //     let data = Float64(unsafe{
  //       let temp_data = temp_p1.read();
  //       temp_p1 = temp_p1 + 1;
  //       temp_data
  //     });
  //     data_sum += data;
  //     if (data > data_max) {
  //       data_max = data;
  //     }
  //     if (i < Int64(this.per_head_dim) * 2) {
  //       print("${data},")
  //     }
  //   }
  //   println_log("");
  //   let data_mean = data_sum / Float64(this.logits_size);
  //   println_log("logits mean=${data_mean}, sum = ${data_sum}, max = ${data_max}");
  //   // 打印new_kv_cache
  //   println_log("new_kv_cache size = ${this.new_kv_cache_size}")
  //   print("new_kv_cache[:${Int64(this.per_head_dim) * 2}] = ")
  //   var temp_p2 = this.p_new_kv_cache;
  //   var data_sum2: Float64 = 0.0;
  //   var data_max2: Float64 = Float64.Min;
  //   for (i in 0..this.new_kv_cache_size) {
  //     let data = Float64(unsafe{
  //       let temp_data = temp_p2.read();
  //       temp_p2 = temp_p2 + 1;
  //       temp_data
  //     });
  //     data_sum2 += data;
  //     if (data > data_max2) {
  //       data_max2 = data;
  //     }
  //     if (i < Int64(this.per_head_dim) * 2) {
  //       print("${data},")
  //     }
  //   }
  //   println_log("");
  //   let data_mean2 = data_sum2 / Float64(this.new_kv_cache_size);
  //   println_log("new_kv_cache mean=${data_mean2}, sum = ${data_sum2}, max = ${data_max2}");
  // }

  public func inference_one(input_ids: Array<UInt32>): Bool {
    // 执行推理过程, 每次只推理max_prefill_length(目前默认是1)个id
    // param: input_ids: 单次推理的input_ids，目前只支持1个input_id
    // param temp_seq_len: 单次推理的input_ids长度，目前只支持1
    // 返回Logits
    // println_log("===== OH_AI__LITE_INFO: model inference ===== \n");
    if (this.model.isNull()) {
      eprintln_log("===== model is null, skip =====");
      return false;
    }
    let inputs: OH_AI_TensorHandleArray = oh_ai_model_get_inputs(model);
    if (inputs.handle_list.isNull()) {
      eprintln_log("===== OH_AI_ModelGetInputs handle failed, ret: ===== \n");
      oh_ai_model_destroy(this.model);
      return false;
    }
    if (inputs.handle_num != 4) {
      eprintln_log("input number must be 4");
      oh_ai_model_destroy(this.model);
      return false;
    }
    // 对输入数据做预处理
    this.preprocess(input_ids);
    // println_log("===== OH_AI__LITE_INFO: bind inputs ===== \n");
    // 验证并绑定输入
    var temp_p: CPointer<OH_AI_TensorHandle> = inputs.handle_list;
    for (i in 0..4) {
      let temp_input: OH_AI_TensorHandle = unsafe {
        let temp_data = temp_p.read();
        temp_p = temp_p + 1;
        temp_data
      };
      let (raw_input_bytes, raw_input_point) = match (i) {
        case 0 => (this.input_ids_bytes, this.raw_input_ids);
        case 1 => (this.attention_mask_bytes, this.raw_attention_mask);
        case 2 => (this.position_ids_bytes, this.raw_position_ids);
        case 3 => (this.past_key_value_bytes, this.raw_past_key_values);
        case index => throw Exception("invalid input index ${index}")
      }
      if (temp_input.isNull()) {
        eprintln_log("inputs[${i}] handle is null");
        oh_ai_model_destroy(this.model);
        return false;
      }
      // 验证数据字节长度
      let temp_input_num = oh_ai_tensor_get_data_size(temp_input);
      if (temp_input_num != Int64(raw_input_bytes)) {
        eprintln_log("index: ${i}; input bytes not equal, left = ${temp_input_num}, right = ${raw_input_bytes}");
        oh_ai_model_destroy(this.model);
        return false;
      }
      // 绑定输入信息
      oh_ai_tensor_set_data(temp_input, raw_input_point);
    }
    // 获取输出数据
    // println_log("===== OH_AI__LITE_INFO: create outputs ===== \n");
    var outputs: OH_AI_TensorHandleArray = oh_ai_model_get_outputs(model);
    if (outputs.handle_list.isNull()) {
      eprintln_log("===== OH_AI_ModelGetouts handle failed, ret: =====");
      oh_ai_model_destroy(this.model);
      return false;
    }
    if (outputs.handle_num != 2) {
      eprintln_log("===== output handle_num is not 2, will exit =====");
      oh_ai_model_destroy(this.model);
      return false;
    }
    // println_log("===== OH_AI__LITE_LOG: model outputs handle number = ${outputs.handle_num} ====");
    // 尝试绑定输出数据，和输入数据一样做处理
    // println_log("===== OH_AI__LITE_INFO: bind outputs ===== \n");
    // 先重制一下输出数据指针全部为0(已经是直接copy指针了，所以不用重制)
    // }
    // println_log("===== OH_AI__LITE_INFO: bind p_outputs ===== \n");
    unsafe{this.p_outputs.write(outputs)};
    // 执行模型推理
    let before_fun = CPointer<Unit>();
    let after_fun = CPointer<Unit>();
    // println_log("===== OH_AI__LITE_INFO: predict ===== \n");
    // 临时打印输入数据
    // this.test_print_input();
    let model_infer_result: OH_AI_Status = oh_ai_model_predict(
      this.model, inputs, this.p_outputs, before_fun, after_fun
    );
    if (model_infer_result != OH_AI_StatusEnum.OH_AI_STATUS_SUCCESS) {
      eprint("===== OH_AI_Model model infer failed, code: ${model_infer_result} =====");
      return false;
    }
    // 开始拷贝输出
    var temp_out_p: CPointer<OH_AI_TensorHandle> = outputs.handle_list;
    for (i in 0..2) {
      let temp_out: OH_AI_TensorHandle = unsafe {
        let temp_data = temp_out_p.read();
        temp_out_p = temp_out_p + 1;
        temp_data
      };
      if (temp_out.isNull()) {
        eprintln_log("output[${i}] handle is null");
        oh_ai_model_destroy(this.model);
        return false;
      }
      let raw_output_bytes = match (i) {
        case 0 => this.logits_bytes
        case 1 => this.new_kv_cache_bytes
        case index => throw Exception("invalid output index ${index}")
      }
      // 验证数据字节长度
      let temp_input_num = oh_ai_tensor_get_data_size(temp_out);
      if (temp_input_num != Int64(raw_output_bytes)) {
        eprintln_log("index: ${i}; output bytes not equal, left = ${temp_input_num}, right = ${raw_output_bytes}");
        oh_ai_model_destroy(this.model);
        return false;
      }
      // 拷贝输出指针（要等模型释放才会释放，所以不用担心指针悬停问题）
      if (i == 0) {
        this.raw_logits = oh_ai_tensor_get_data(temp_out);
        this.p_logits = unsafe{CPointer<Float32>(this.raw_logits)};
      } else {
        this.raw_new_kv_cache = oh_ai_tensor_get_data(temp_out);
        this.p_new_kv_cache = unsafe{CPointer<Float32>(this.raw_new_kv_cache)};
      }
    }
    // 后处理
    this.postprocess();
    // 临时打印输出数据
    // this.test_print_output();
    return true;
  }

  public func free() {
    unsafe {
      println_log("=== INFO free model buffer ====")
      // free model buffer
      free(CPointer<Unit>(this.p_model_buffer));
      // free model
      if (!this.model.isNull()) {
        println_log("=== INFO free model ====")
        oh_ai_model_destroy(this.model);
      }
      // free input, free model的时候会把它也free掉，所以这里不用free了
      // free(this.raw_input_ids);
      // free(this.raw_attention_mask);
      // free(this.raw_position_ids);
      // free(this.raw_past_key_values);
      // 释放绑定输出的指针
      println_log("=== INFO free p_outputs ====")
      unsafe{free(CPointer<Unit>(this.p_outputs))};
      
    }
  }
  
}