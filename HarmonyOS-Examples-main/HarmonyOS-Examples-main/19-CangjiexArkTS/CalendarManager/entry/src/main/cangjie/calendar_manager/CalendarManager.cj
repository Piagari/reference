/**
 * Created on 2025/8/25
 */
package ohos_app_cangjie_entry.calendar_manager

import ohos.base.*
import ohos.ark_interop.*
import ohos.ability.AbilityContext

import ohos_app_cangjie_arkts_interop.base.*

public class CalendarManager <: ArkTSClass & JSConvertible<CalendarManager> {
    public let getCalendar: ArkTSAsyncMethod<Calendar>
    public let createCalendar: ArkTSAsyncMethod<Calendar>

    public init(jsObj: JSObject) {
        super(jsObj)
        this.getCalendar = asyncMethod("getCalendar")
        this.createCalendar = asyncMethod("createCalendar")
    }

    public static func fromJSV(value: ?JSValue): ?CalendarManager {
        fromJSVHelper(value, "CalendarManager", { v: JSValue => v.isObject() }) { v: JSValue =>
            CalendarManager(v.asObject())
        }
    }
}