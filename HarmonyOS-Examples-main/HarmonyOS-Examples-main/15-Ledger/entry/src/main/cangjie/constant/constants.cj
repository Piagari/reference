/**
 * Created on 2025/7/31
 */
package ohos_app_cangjie_entry.constant

import std.time.*
import std.collection.*

public class Constants {
    public static let WEEKS: Array<String> = ["日", "一", "二", "三", "四", "五", "六"]

    public static let start = DateTime.of(year: 2000, month: 1, dayOfMonth: 1, timeZone: TimeZone.Local)

    public static let end = DateTime.of(year: 2100, month: 12, dayOfMonth: 31, timeZone: TimeZone.Local)

    public static let COLOR_DARK_GRAY: UInt32 = 0xCECECE

    public static let COLOR_DARK_BLUE: UInt32 = 0x62A4D8

    public static let columnsTemplateStr = "1fr 1fr 1fr 1fr 1fr 1fr 1fr"
}