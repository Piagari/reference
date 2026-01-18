/**
 * Created on 2025/8/26
 */
package ohos_app_cangjie_entry.calendar_manager

import ohos.ark_interop.*

import ohos_app_cangjie_arkts_interop.base.*

public class Attendee <: ArkTSClass & JSConvertible<Attendee> {
    public let name: ArkTSRequiredReadWriteProperty<String>
    public let email: ArkTSRequiredReadWriteProperty<String>
    public let role: ArkTSOptionalReadWriteProperty<AttendeeRole>

    public init(jsObj: JSObject) {
        super(jsObj)
        this.name = requiredProp("name")
        this.email = requiredProp("email")
        this.role = optionalProp("role")
    }

    public init(name: String, email: String, role!: ?AttendeeRole = None) {
        this(createJSObject(("name", name), ("email", email), ("role", role)))
    }

    public static func fromJSV(value: ?JSValue): ?Attendee {
        fromJSVHelper(value, "Attendee", { v: JSValue => v.isObject() }) { v: JSValue =>
            Attendee(v.asObject())
        }
    }
}