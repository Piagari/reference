package ohos_app_cangjie_entry.mindspore

// 模块总文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/types_8h-V5


// 模型文件的类型。
public type OH_AI_ModelType = Int64;
public struct OH_AI_ModelTypeEnum {
  public static let OH_AI_MODELTYPE_MINDIR: Int64 = 0;
  public static let OH_AI_MODELTYPE_INVALID: Int64 = 0xFFFFFFFF;
}

// 设备类型信息，包含了目前支持的设备类型。
public type OH_AI_DeviceType = Int64;
public struct OH_AI_DeviceTypeEnum {
  public static let OH_AI_DEVICETYPE_CPU: Int64 = 0;
  public static let OH_AI_DEVICETYPE_GPU : Int64 = 1;
  public static let OH_AI_DEVICETYPE_KIRIN_NPU: Int64 = 2;
  public static let OH_AI_DEVICETYPE_NNRT:Int64 = 60;
  public static let OH_AI_DEVICETYPE_INVALID: Int64 = 100;
}

// NNRT管理的硬件设备类型。
public type OH_AI_NNRTDeviceType = Int64;
public struct OH_AI_NNRTDeviceTypeEnum {
  public static let OH_AI_NNRTDEVICE_OTHERS: Int64 = 0;
  public static let OH_AI_NNRTDEVICE_CPU: Int64 = 1;
  public static let OH_AI_NNRTDEVICE_GPU: Int64 = 2;
  public static let OH_AI_NNRTDEVICE_ACCELERATOR: Int64 = 3;
}

// NNRT硬件的工作性能模式。
public type OH_AI_PerformanceMode = Int64;
public struct OH_AI_PerformanceModeEnum {
  public static let OH_AI_PERFORMANCE_NONE: Int64 = 0;
  public static let OH_AI_PERFORMANCE_LOW: Int64 = 1;
  public static let OH_AI_PERFORMANCE_MEDIUM: Int64 = 2;
  public static let OH_AI_PERFORMANCE_HIGH: Int64 = 3;
  public static let OH_AI_PERFORMANCE_EXTREME: Int64 = 4;
}

// NNRT推理任务优先级。
public type OH_AI_Priority = Int64;
public struct OH_AI_PriorityEnum {
  public static let OH_AI_PRIORITY_NONE: Int64 = 0;
  public static let OH_AI_PRIORITY_LOW: Int64 = 1;
  public static let OH_AI_PRIORITY_MEDIUM: Int64 = 2;
  public static let OH_AI_PRIORITY_HIGH: Int64 = 3;
}

// 训练优化等级。
public type OH_AI_OptimizationLevel = Int64;
public struct OH_AI_OptimizationLevelEnum {
  public static let OH_AI_KO0: Int64 = 0;
  public static let OH_AI_KO2: Int64 = 2;
  public static let OH_AI_KO3: Int64 = 3;
  public static let OH_AI_KAUTO: Int64 = 4;
  public static let OH_AI_KOPTIMIZATIONTYPE = 0xFFFFFFFF;
}

// 量化类型信息
public type OH_AI_QuantizationType = Int64;
public struct OH_AI_QuantizationTypeEnum {
  public static let OH_AI_NO_QUANT: Int64 = 0;
  public static let OH_AI_WEIGHT_QUANT: Int64 = 1;
  public static let OH_AI_FULL_QUANT: Int64 = 2;
  public static let OH_AI_UNKNOWN_QUANT_TYPE: Int64 = 0xFFFFFFFF;
}
