/**
 * Created on 2025/8/25
 */
package ohos_app_cangjie_entry.calendar_manager

import ohos.ark_interop.*

import ohos_app_cangjie_arkts_interop.base.*

public let calendarManagerModule = CalendarManagerModule()

public class CalendarManagerModule <: ArkTSModule {
    public let getCalendarManager: ArkTSSyncMethod<CalendarManager>

    public init() {
        super(
            "calendarManager",
            ["ohos.permission.READ_CALENDAR", "ohos.permission.WRITE_CALENDAR"]
        )

        this.getCalendarManager = ArkTSSyncMethod<CalendarManager>(this.jsModule, this.ctx, "getCalendarManager")

        ArkTSBridge.registerModule(this)
    }
}
