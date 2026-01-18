/**
 * Created on 2025/8/4
 */
package ohos_app_cangjie_entry.ui.entity

import ohos_app_cangjie_entry.constant.*

import ohos_app_cangjie_entry.utils.*
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import std.collection.ArrayList
import std.time.*



// 专门用来管理时间相关的动态字段
@Observed
public class DynamicTime {
    @Publish
    public var year: Int64 = 1970
    @Publish
    public var month: Int64 = 1
    @Publish
    public var selectedDate: DateTime = DateTime.of(year: 1970, month: 1, dayOfMonth: 1, timeZone: TimeZone.Local)
    @Publish
    public var pickerDate: DateTime = DateTime.of(year: 1970, month: 1, dayOfMonth: 1, timeZone: TimeZone.Local)
    @Publish
    public var selectedMonthLabel: String = ""

    public func reset() {
        let now = DateTime.now()
        this.year = now.year
        this.month = now.monthValue
        this.selectedDate = DateTime.of(year: this.year, month: this.month, dayOfMonth: now.dayOfMonth, timeZone: TimeZone.Local)
        this.pickerDate = this.selectedDate
    }
    public func resetByPicker() {
        this.selectedDate = this.pickerDate
        this.year = this.selectedDate.year
        this.month = this.selectedDate.monthValue
    }

    public func timeStr() {
        "${this.year}-${this.month}"
    }

    public func update(sourceData: ArrayList<SourceData>) {
        this.selectedMonthLabel = formatMonthLabel(year, month)
        this.selectedDate = DateTime.of(year: year, month: month, dayOfMonth: getDefaultDay(), timeZone: TimeZone.Local)
        this.pickerDate = this.selectedDate
    }

    public func updateCellAndIdx(sourceData: ArrayList<SourceData>) {
        let head = startWeekday(year, month)
        let cells = ArrayList<BillCell>()
        if (head > 0) {
            let prevLast = DateTime.of(year: year, month: month, dayOfMonth: 1, timeZone: TimeZone.Local).addDays(-1).dayOfMonth
            for (i in 0..head) {
                cells.append(BillCell(prevLast - head + i + 1, true))
            }
        }
        for (d in 1..daysInMonth(year, month) + 1) {
            cells.append(BillCell(d, false))
        }
        for (src in sourceData) {
            if (src.payDate.year == year && src.payDate.monthValue == month) {
                let idx = src.payDate.dayOfMonth + head - 1
                if (idx >= 0 && idx < cells.size) {
                    cells[idx].addDetails(src)
                }
            }
        }
        for (d in 1..7 - endWeekday(year, month)) {
            cells.append(BillCell(d, true))
        }

        let selIdx = getDefaultDay() + startWeekday(year, month) - 1
        let selectedIdx = if (selIdx >= 0 && selIdx < cells.size) { selIdx } else { -1 }
        (cells, selectedIdx)
    }

    public func handleCellClick(cell: BillCell, idx: Int64) {
        if (cell.isSupplemental) {
            this.month += 11 // 1-12映射到0-11 相当于 -1 + 12，“+12”是为了方便取模
            if (idx <= 21) { this.month-- } else { this.month++ }
            this.month = this.month % 12 + 1
            if (this.month == 12) { this.year-- }
            if (this.month == 1) { this.year++ }
        }
        this.selectedDate = DateTime.of(year: this.year, month: this.month, dayOfMonth: cell.day, timeZone: TimeZone.Local)
    }


    private func getDefaultDay() {
        if (selectedDate.year == year && selectedDate.monthValue == month) {
            selectedDate.dayOfMonth
        } else {
            1
        }
    }
}