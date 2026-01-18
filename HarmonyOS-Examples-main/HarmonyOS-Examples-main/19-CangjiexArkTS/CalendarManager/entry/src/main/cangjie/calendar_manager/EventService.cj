/**
 * Created on 2025/8/26
 */
package ohos_app_cangjie_entry.calendar_manager

import ohos.ark_interop.*

import ohos_app_cangjie_arkts_interop.base.*

public class EventService <: ArkTSClass & JSConvertible<EventService> {
    public let `type`: ArkTSRequiredReadWriteProperty<ServiceType>
    public let uri: ArkTSRequiredReadWriteProperty<String>
    public let description: ArkTSOptionalReadWriteProperty<String>

    public init(jsObj: JSObject) {
        super(jsObj)
        this.`type` = requiredProp("type")
        this.uri = requiredProp("uri")
        this.description = optionalProp("description")
    }

    public init(`type`: ServiceType, uri: String, description!: ?String = None) {
        this(createJSObject(("type", `type`), ("uri", uri), ("description", description)))
    }

    public static func fromJSV(value: ?JSValue): ?EventService {
        fromJSVHelper(value, "EventService", { v: JSValue => v.isObject() }) { v: JSValue =>
            EventService(v.asObject())
        }
    }
}