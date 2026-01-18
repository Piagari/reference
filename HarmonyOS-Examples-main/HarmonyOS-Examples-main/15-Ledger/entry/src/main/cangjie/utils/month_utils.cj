/**
 * Created on 2025/7/31
 */
package ohos_app_cangjie_entry.utils

import std.format.*
import std.collection.ArrayList
import std.time.*

public func formatMonthLabel(year: Int64, month: Int64): String {
    return "${year}年${month.format("02")}月"
}

public func daysInMonth(year: Int64, month: Int64): Int64 {
    return DateTime.of(year: year, month: month, dayOfMonth: 1, timeZone: TimeZone.Local).addMonths(1).addDays(-1).dayOfMonth
}

public func startWeekday(year: Int64, month: Int64): Int64 {
    return DateTime.of(year: year, month: month, dayOfMonth: 1, timeZone: TimeZone.Local).dayOfWeek.value() // 周日=0, 周一~六=1..6
}

public func endWeekday(year: Int64, month: Int64): Int64 {
    let dim = daysInMonth(year, month)
    return DateTime.of(year: year, month: month, dayOfMonth: dim, timeZone: TimeZone.Local).dayOfWeek.value()
}