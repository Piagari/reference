package ohos_app_cangjie_entry
import encoding.json.stream.*
import std.collection.ArrayList
import std.io.ByteArrayStream

public enum SamplingMethod {
  Greedy | Top_p | Top_k
}

public struct ModelState {
  public var code: Int64
  public var is_end: Bool
  public var message: String = ""

  public init(
    code!: Int64 = 200,
    is_end!: Bool = false,
    message!: String = ""
  ) {
    this.code = code
    this.is_end = is_end
    this.message = message
  }
}

public struct FunctionCall <: JsonDeserializable<FunctionCall> & JsonSerializable {
  public let name: String
  public let arguments: String

  public init(name: String, arguments: String) {
    this.name = name
    this.arguments = arguments
  }

  public static func fromJson(r: JsonReader): FunctionCall {
    r.startObject()
    let name = JsonHelper.readField<String>(r, "name")
    let arguments = JsonHelper.readField<String>(r, "arguments")
    r.endObject()
    return FunctionCall(name, arguments)
  }

  public func toJson(w: JsonWriter) {
    w.startObject()
    w.writeName("name").writeValue<String>(this.name)
    w.writeName("arguments").writeValue<String>(this.arguments)
    w.endObject()
    w.flush()
  }
}

public enum RoleType {
  User | Assistant | System | Function | NULL
}

public func role_type_to_str(role: RoleType): Option<String> {
  return match(role) {
    case RoleType.User => Some("user")
    case RoleType.Assistant => Some("assistant")
    case RoleType.System => Some("system")
    case RoleType.Function => Some("function")
    case RoleType.NULL => None
  }
}

public func str_to_role_type(role_option_str: Option<String>): RoleType {
  return match(role_option_str) {
    case Some(role_option) =>
      match (role_option) {
        case "user" => RoleType.User
        case "assistant" => RoleType.Assistant
        case "system" => RoleType.System
        case "function" => RoleType.Function
        case x => throw Exception("unknown enum ${x} for RoleType")
      }
    case None => RoleType.NULL
  }
}

public struct Message <: JsonDeserializable<Message> & JsonSerializable {
  public let role: RoleType
  public var content: String
  public let function_call: Option<FunctionCall>

  public init(role: RoleType, content: String) {
    this.role = role
    this.content = content
    this.function_call = None
  }

  public init(role: RoleType, content: String, function_call: Option<FunctionCall>) {
    this.role = role
    this.content = content
    this.function_call = function_call
  }

  public static func fromJson(r: JsonReader): Message {
    r.startObject()
    let role_option_str = JsonHelper.readField<Option<String>>(r, "role")
    let content = JsonHelper.readField<String>(r, "content")
    let function_call = JsonHelper.readField<Option<FunctionCall>>(r, "function_call")
    r.endObject()
    let role_type = str_to_role_type(role_option_str)
    return Message(role_type, content, function_call)
  }
  public func toJson(w: JsonWriter) {
    w.startObject()
    w.writeName("role").writeValue<Option<String>>(role_type_to_str(this.role))
    w.writeName("content").writeValue<String>(this.content)
    if (this.function_call.isSome()) {
      w.writeName("function_call").writeValue<FunctionCall>(this.function_call.getOrThrow())
    }
    w.endObject()
    w.flush()
  }
}
// 辅助模块，用于JSON反序列化
public struct JsonUtility {
  // 从 JSON 中读取特定字段
  public static func readField<T>(r: JsonReader, fieldName: String): T where T <: JsonDeserializable<T> {
    while (r.peek() != EndObject) {
      let n = r.readName()
      if (n == fieldName) {
        return r.readValue<T>()
      }
    }
    throw Exception("Field not found: ${fieldName}")
  }
  // 从 JSON 中读取多个字段
  public static func readFields(r: JsonReader): (UInt32, String, Bool, Bool, Bool, Bool, Bool) {
    var id: UInt32 = 0
    var content: String = ""
    var single_word: Bool = false
    var lstrip: Bool = false
    var rstrip: Bool = false
    var normalized: Bool = false
    var special: Bool = false

    while (r.peek() != EndObject) {
      let n = r.readName()
      match (n) {
        case "id" => id = r.readValue<UInt32>()
        case "content" => content = r.readValue<String>()
        case "single_word" => single_word = r.readValue<Bool>()
        case "lstrip" => lstrip = r.readValue<Bool>()
        case "rstrip" => rstrip = r.readValue<Bool>()
        case "normalized" => normalized = r.readValue<Bool>()
        case "special" => special = r.readValue<Bool>()
        case _ => println("未知键: $(n)")
      }
    }
    return (id, content, single_word, lstrip, rstrip, normalized, special)
  }
}