/**
 * Created on 2025/8/26
 */
package ohos_app_cangjie_entry.calendar_manager

import ohos.ark_interop.*

import ohos_app_cangjie_arkts_interop.base.*

public class CalendarAccount <: ArkTSClass & JSConvertible<CalendarAccount> {
    public let name: ArkTSRequiredReadOnlyProperty<String>
    public let `type`: ArkTSRequiredReadWriteProperty<CalendarType>
    public let displayName: ArkTSOptionalReadWriteProperty<String>

    public init(jsObj: JSObject) {
        super(jsObj)
        this.name = requiredReadOnlyProp("name")
        this.`type` = requiredProp("type")
        this.displayName = optionalProp("displayName")
    }

    public init(name: String, `type`: CalendarType, displayName!: ?String = None) {
        this(createJSObject(("name", name), ("type", `type`), ("displayName", displayName)))
    }

    public static func fromJSV(value: ?JSValue): ?CalendarAccount {
        fromJSVHelper(value, "CalendarAccount", { v: JSValue => v.isObject() }) { v: JSValue =>
            CalendarAccount(v.asObject())
        }
    }
}