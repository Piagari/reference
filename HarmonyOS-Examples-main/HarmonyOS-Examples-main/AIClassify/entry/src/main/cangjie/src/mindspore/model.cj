package ohos_app_cangjie_entry.mindspore


let OH_AI_MAX_SHAPE_NUM: Int64 = 32;


@C
public struct OH_AI_TensorHandleArray {
  public var handle_num: UIntNative = 0;
  public var handle_list: CPointer<OH_AI_TensorHandle> = CPointer<OH_AI_TensorHandle>();
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_o_h___a_i___tensor_handle_array-V5
// 概述：张量数组结构体，用于存储张量数组指针和张量数组长度。
// 成员：handle_num	张量数组长度。
// 成员：handle_list	指向张量数组的指针。

@C
public struct OH_AI_ShapeInfo {
  public var shape_num: UIntNative = 0;
  // 下面两种表示方式
  public var shape: CPointer<Int64> = CPointer<Int64>();
  // public var shape: VArray<Int64, $32> = VArray<Int64, $32>(item: 0);
}

// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_o_h___a_i___shape_info-V5
// 概述：维度信息，最大的维度为OH_AI_MAX_SHAPE_NUM。
// 成员：shape_num	维度数组长度。
// 成员：shape [OH_AI_MAX_SHAPE_NUM]	维度数组。

@C
public struct OH_AI_CallBackParam {
  public var node_name: CString = unsafe { LibC.mallocCString("")} ;
  public var node_type: CString = unsafe { LibC.mallocCString("")} ;
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_o_h___a_i___call_back_param-V5
// 概述：回调函数中传入的算子信息。
// 成员：node_name	算子名称。
// 成员：node_type	算子类型。


public type OH_AI_ModelHandle = CPointer<Unit>;
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_modelhandle
// typedef void* OH_AI_ModelHandle
// 概述：指向模型对象的指针。

public type OH_AI_TrainCfgHandle = CPointer<Unit>;
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_traincfghandle
// typedef void* OH_AI_TrainCfgHandle
// 概述：指向训练配置对象的指针。

// public type OH_AI_KernelCallBack = (inputs: OH_AI_TensorHandleArray , outputs: OH_AI_TensorHandleArray , kernel_Info: OH_AI_CallBackParam)-> Bool;
public type OH_AI_KernelCallBack = CPointer<Unit>;
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_kernelcallback
// 概述：回调函数指针。
// 该函数指针是用于设置OH_AI_ModelPredict函数参数中的两个回调函数。 
// 该指针指向的函数需要包含三个参数，其中inputs和outputs对应了算子的输入和输出张量，kernel_Info表示当前算子的信息。 
// 可以通过回调函数监控算子执行的情况，例如统计算子的执行时间，校验算子的正确性等等。
// typedef bool(* OH_AI_KernelCallBack) (const OH_AI_TensorHandleArray inputs, const OH_AI_TensorHandleArray outputs, const OH_AI_CallBackParam kernel_Info)

foreign func OH_AI_ModelCreate(): OH_AI_ModelHandle;
public func oh_ai_model_create(): OH_AI_ModelHandle {
  unsafe {OH_AI_ModelCreate()}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_modelcreate
// OH_AI_API OH_AI_ModelHandle OH_AI_ModelCreate ()
// 功能：创建一个模型对象。
// 返回：模型对象指针。


foreign func OH_AI_ModelDestroy(p_model: CPointer<OH_AI_ModelHandle>): Unit;
public func oh_ai_model_destroy(model: OH_AI_ModelHandle) {
  unsafe {
    // 创建一个p_context指针指向context,用于context释放
    var p_unit_model: CPointer<Unit> = malloc(sizeOf<OH_AI_ModelHandle>());
    var p_model: CPointer<OH_AI_ModelHandle> = CPointer<OH_AI_ContextHandle>(p_unit_model);
    p_model.write(model); // 相当于：*p_model = model;
    OH_AI_ModelDestroy(p_model);
    // 执行完上面的不确定下面还有没有，保险起见判断一下再决定是否释放
    if (!p_unit_model.isNull()) {
      free(CPointer<Unit>(p_unit_model));
    }
  }
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_modeldestroy
// OH_AI_API void OH_AI_ModelDestroy (OH_AI_ModelHandle * model)
// 功能：释放一个模型对象。
// 参数：model	模型对象指针。


foreign func OH_AI_ModelBuild(
    model: OH_AI_ModelHandle,
    model_data: CPointer<Unit>,
    data_size: UIntNative,
    model_type: OH_AI_ModelType,
    model_context: OH_AI_ContextHandle
): OH_AI_Status;
public func oh_ai_model_build(
    model: OH_AI_ModelHandle,
    model_data: CPointer<Unit>,
    data_size: UIntNative,
    model_type: OH_AI_ModelType,
    model_context: OH_AI_ContextHandle
): OH_AI_Status {
  unsafe{OH_AI_ModelBuild(model, model_data, data_size, model_type, model_context)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_modelbuild
// OH_AI_API OH_AI_Status OH_AI_ModelBuild (OH_AI_ModelHandle model, const void * model_data, size_t data_size, OH_AI_ModelType model_type, const OH_AI_ContextHandle model_context )
// 功能：从内存缓冲区加载并编译MindSpore模型。
// 注意，同一个OH_AI_ContextHandle对象仅能传递给OH_AI_ModelBuild或者OH_AI_ModelBuildFromFile一次， 如果多次调用该函数需要创建多个不同的OH_AI_ContextHandle。
// 参数：model	模型对象指针。
// 参数：model_data	内存中已经加载的模型数据地址。
// 参数：data_size	模型数据的长度。
// 参数：model_type	模型文件类型，具体见OH_AI_ModelType。
// 参数：model_context	模型运行时的上下文环境，具体见 OH_AI_ContextHandle。
// 返回：枚举类型的状态码OH_AI_Status，若返回OH_AI_Status::OH_AI_STATUS_SUCCESS则证明创建成功。


foreign func OH_AI_ModelBuildFromFile(
    model: OH_AI_ModelHandle,
    model_path: CString,
    model_type: OH_AI_ModelType,
    model_context: OH_AI_ContextHandle
): OH_AI_Status;
public func oh_ai_model_build_from_file(
    model: OH_AI_ModelHandle,
    model_path: CString,
    model_type: OH_AI_ModelType,
    model_context: OH_AI_ContextHandle
): OH_AI_Status {
  unsafe {OH_AI_ModelBuildFromFile(model, model_path, model_type, model_context)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_modelbuildfromfile
// OH_AI_API OH_AI_Status OH_AI_ModelBuildFromFile (OH_AI_ModelHandle model, const char * model_path, OH_AI_ModelType model_type, const OH_AI_ContextHandle model_context )
// 功能：通过模型文件加载并编译MindSpore模型。
// 注意，同一个OH_AI_ContextHandle对象仅能传递给OH_AI_ModelBuild或者OH_AI_ModelBuildFromFile一次， 如果多次调用该函数需要创建多个不同的OH_AI_ContextHandle。
// 返回：枚举类型的状态码OH_AI_Status，若返回OH_AI_Status::OH_AI_STATUS_SUCCESS则证明创建成功。

foreign func OH_AI_ModelResize(
    model: OH_AI_ModelHandle,
    inputs: OH_AI_TensorHandleArray,
    shape_infos: CPointer<OH_AI_ShapeInfo>,
    shape_info_num: UIntNative
): OH_AI_Status;
public func oh_ai_model_resize(
    model: OH_AI_ModelHandle,
    inputs: OH_AI_TensorHandleArray,
    shape_infos: CPointer<OH_AI_ShapeInfo>,
    shape_info_num: UIntNative
): OH_AI_Status {
  unsafe{OH_AI_ModelResize(model, inputs, shape_infos, shape_info_num)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_modelresize
// OH_AI_API OH_AI_Status OH_AI_ModelResize (OH_AI_ModelHandle model, const OH_AI_TensorHandleArray inputs, OH_AI_ShapeInfo * shape_infos, size_t shape_info_num )
// 功能：调整已编译模型的输入形状。
// 参数1：model	模型对象指针。
// 参数2：inputs	模型输入对应的张量数组结构体。
// 参数3：shape_infos	输入形状信息数组，按模型输入顺序排列的由形状信息组成的数组，模型会按顺序依次调整张量形状。
// 参数4：shape_info_num	形状信息数组的长度。
// 返回：枚举类型的状态码OH_AI_Status，若返回OH_AI_Status::OH_AI_STATUS_SUCCESS则证明创建成功。


foreign func OH_AI_ModelPredict(
  model: OH_AI_ModelHandle,
  inputs: OH_AI_TensorHandleArray,
  outputs: CPointer<OH_AI_TensorHandleArray>,
  before: OH_AI_KernelCallBack,
  after: OH_AI_KernelCallBack
): OH_AI_Status;
public func oh_ai_model_predict(
  model: OH_AI_ModelHandle,
  inputs: OH_AI_TensorHandleArray,
  outputs: CPointer<OH_AI_TensorHandleArray>,
  before: OH_AI_KernelCallBack,
  after: OH_AI_KernelCallBack
): OH_AI_Status {
  unsafe{OH_AI_ModelPredict(model, inputs, outputs, before, after)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_modelpredict
// OH_AI_API OH_AI_Status OH_AI_ModelPredict (OH_AI_ModelHandle model, const OH_AI_TensorHandleArray inputs, OH_AI_TensorHandleArray * outputs, const OH_AI_KernelCallBack before, const OH_AI_KernelCallBack after )
// 功能：执行模型推理。
// 参数1：model	模型对象指针。
// 参数2：inputs	模型输入对应的张量数组结构体。
// 参数3：outputs	模型输出对应的张量数组结构体的指针。
// 参数4：before	模型推理前执行的回调函数。
// 参数5：after	模型推理后执行的回调函数。
// 返回：枚举类型的状态码OH_AI_Status，若返回OH_AI_Status::OH_AI_STATUS_SUCCESS则证明创建成功。

foreign func OH_AI_ModelGetInputs (model: OH_AI_ModelHandle): OH_AI_TensorHandleArray
public func oh_ai_model_get_inputs(model: OH_AI_ModelHandle): OH_AI_TensorHandleArray {
  unsafe{OH_AI_ModelGetInputs(model)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_modelgetinputs
// OH_AI_API OH_AI_TensorHandleArray OH_AI_ModelGetInputs (const OH_AI_ModelHandle model)
// 功能：获取模型的输入张量数组结构体。
// 参数：model	模型对象指针。
// 返回：模型输入对应的张量数组结构体。


foreign func OH_AI_ModelGetOutputs (model: OH_AI_ModelHandle): OH_AI_TensorHandleArray
public func oh_ai_model_get_outputs(model: OH_AI_ModelHandle): OH_AI_TensorHandleArray {
  unsafe{OH_AI_ModelGetOutputs(model)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_modelgetoutputs
// OH_AI_API OH_AI_TensorHandleArray OH_AI_ModelGetOutputs (const OH_AI_ModelHandle model)
// 功能：获取模型的输出张量数组结构体。
// 参数：model	模型对象指针。
// 返回：模型输出对应的张量数组结构体。

foreign func OH_AI_ModelGetInputByTensorName (model: OH_AI_ModelHandle , tensor_name: CString): OH_AI_TensorHandle;
public func oh_ai_model_get_input_by_tensor_name (model: OH_AI_ModelHandle , tensor_name: CString): OH_AI_TensorHandle {
  unsafe {OH_AI_ModelGetInputByTensorName(model, tensor_name)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_modelgetinputbytensorname
// OH_AI_API OH_AI_TensorHandle OH_AI_ModelGetInputByTensorName (const OH_AI_ModelHandle model, const char * tensor_name )
// 功能：通过张量名获取模型的输入张量。
// 参数：model	模型对象指针。
// 参数：tensor_name	张量名称。
// 返回：tensor_name所对应的输入张量的张量指针，如果输入中没有该张量则返回空。

foreign func OH_AI_ModelGetOutputByTensorName(model: OH_AI_ModelHandle, tensor_name: CString):OH_AI_TensorHandle;
public func oh_ai_model_get_output_by_tensor_name(model: OH_AI_ModelHandle, tensor_name: CString): OH_AI_TensorHandle {
  unsafe {OH_AI_ModelGetOutputByTensorName(model, tensor_name)}
}
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/_mind_spore-V5#oh_ai_modelgetoutputbytensorname
// OH_AI_API OH_AI_TensorHandle OH_AI_ModelGetOutputByTensorName (const OH_AI_ModelHandle model, const char * tensor_name )
// 通过张量名获取模型的输出张量。
// 参数：model	模型对象指针。
// 参数：tensor_name	张量名称。
// 返回：tensor_name所对应的输入张量的张量指针，如果输出中没有该张量则返回空。
