package ohos_app_cangjie_entry.mindspore

let INT32_MAX: Int64 = 2147483647;
public type OH_AI_DataType = Int64;
public struct OH_AI_DataTypeEnum {
  public static let OH_AI_DATATYPE_UNKNOWN: Int64 = 0;
  public static let OH_AI_DATATYPE_OBJECTTYPE_STRING: Int64 = 12;
  public static let OH_AI_DATATYPE_OBJECTTYPE_LIST: Int64 = 13;
  public static let OH_AI_DATATYPE_OBJECTTYPE_TUPLE: Int64 = 14;
  public static let OH_AI_DATATYPE_OBJECTTYPE_TENSOR: Int64 = 17;
  public static let OH_AI_DATATYPE_NUMBERTYPE_BEGIN: Int64 = 29;
  public static let OH_AI_DATATYPE_NUMBERTYPE_BOOL: Int64 = 30;
  public static let OH_AI_DATATYPE_NUMBERTYPE_INT8: Int64 = 32;
  public static let OH_AI_DATATYPE_NUMBERTYPE_INT16: Int64 = 33;
  public static let OH_AI_DATATYPE_NUMBERTYPE_INT32: Int64 = 34;
  public static let OH_AI_DATATYPE_NUMBERTYPE_INT64: Int64 = 35;
  public static let OH_AI_DATATYPE_NUMBERTYPE_UINT8: Int64 = 37;
  public static let OH_AI_DATATYPE_NUMBERTYPE_UINT16: Int64 = 38;
  public static let OH_AI_DATATYPE_NUMBERTYPE_UINT32: Int64 = 39;
  public static let OH_AI_DATATYPE_NUMBERTYPE_UINT64: Int64 = 40;
  public static let OH_AI_DATATYPE_NUMBERTYPE_FLOAT16: Int64 = 42;
  public static let OH_AI_DATATYPE_NUMBERTYPE_FLOAT32: Int64 = 43;
  public static let OH_AI_DATATYPE_NUMBERTYPE_FLOAT64: Int64 = 44;
  public static let OH_AI_DATATYPE_NUMBERTYPE_END: Int64 = 46;
  public static let OH_AI_DataTypeInvalid: Int64 = INT32_MAX;
}