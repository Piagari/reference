/**
 * Created on 2024/8/26
 */
package ohos_app_cangjie_entry.chat
import encoding.json.*
import encoding.json.stream.*
import std.io.ByteArrayStream
import std.collection.HashMap
import std.collection.ArrayList
import CJson.jsonmacro.*
import CJson.*

public enum Role <: ToString {
    I | AI | System
    public func toString() {
        match (this) {
            case I => 'user'
            case AI => 'assistant'
            case System => 'system'
        }
    }
}

class CustRoleSerializer <: IJsonValueSerializable<Role> {
    public CustRoleSerializer(let value: Role) {}
    public static func fromJsonValue(json: JsonValue): Role {
        let temp_role = json.asString().getValue()
        var result_role = if (temp_role == 'system') {
            System
        } else if (temp_role == 'user') {
            I
        } else {
        	AI
        }
        return result_role
    }

    public func toJsonValue(): JsonValue {
        return JsonString(this.value.toString())
    }
}

@JsonSerializable
public struct Message {
    @JsonCust[CustRoleSerializer]
    public var role: Role
    public var content: String
    public var reason: String
    public init() {
        this.role = System
        this.content = ""
        this.reason = ""
    }
    public init(role: Role, content: String, reason: String) {
        this.role = role
        this.content = content
        this.reason = reason
    }
}

@JsonSerializable
public struct Chat{
    public var time: String
    public var messages: ArrayList<Message>
    public init() {
        this.time = ''
        this.messages = ArrayList<Message>()
    }
    public init(time: String, messages: ArrayList<Message>) {
        this.time = time
        this.messages = messages
    }
}