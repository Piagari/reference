/**
 * Created on 2025/8/26
 */
package ohos_app_cangjie_entry.calendar_manager

import ohos.ark_interop.*

import ohos_app_cangjie_arkts_interop.base.*

public class CalendarConfig <: ArkTSClass & JSConvertible<CalendarConfig> {
    public let enableReminder: ArkTSOptionalReadWriteProperty<Bool>
    public let color: ArkTSOptionalReadWriteProperty<String>

    public init(jsObj: JSObject) {
        super(jsObj)
        this.enableReminder = optionalProp("enableReminder")
        this.color = optionalProp("color")
    }

    public init(enableReminder!: ?Bool = None, color!: ?String = None) {
        this(createJSObject(("enableReminder", enableReminder), ("color", color)))
    }

    public static func fromJSV(value: ?JSValue): ?CalendarConfig {
        fromJSVHelper(value, "CalendarConfig", { v: JSValue => v.isObject() }) { v: JSValue =>
            CalendarConfig(v.asObject())
        }
    }
}