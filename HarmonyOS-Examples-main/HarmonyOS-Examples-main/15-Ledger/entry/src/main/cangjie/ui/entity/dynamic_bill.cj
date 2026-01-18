/**
 * Created on 2025/8/5
 */
package ohos_app_cangjie_entry.ui.entity

import ohos_app_cangjie_entry.constant.*

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import std.collection.*

@Observed
public class DynamicBill {
    @Publish
    public var selectedDayCell: BillCell = BillCell(1, false)
    @Publish
    public var selectedDetails: ArrayList<BillDetail> = ArrayList<BillDetail>()
    @Publish
    public var selectedIncome: Float64 = 0.0
    @Publish
    public var selectedExpense: Float64 = 0.0

    public var dynamicStyle: ?DynamicStyle = None

    public func handleCellClick(cell: BillCell, idx: Int64) {
        if (cell.isSupplemental) { return }
        this.selectedDayCell = cell
        this.selectedDetails = ArrayList<BillDetail>()
        for (d in cell.flowDetails) {
            this.selectedDetails.append(d)
        }
        this.selectedIncome = cell.income
        this.selectedExpense = cell.expense
    }

    public func update(sourceData: ArrayList<SourceData>) {
        let style = dynamicStyle.getOrThrow()
        var selCell: BillCell = BillCell(1, false)
        if (style.selectedIdx >= 0) {
            selCell = style.flowCells[style.selectedIdx]
            for (d in selCell.flowDetails) {
                selectedDetails.append(d)
            }
            selectedIncome = selCell.income
            selectedExpense = selCell.expense
        }
        selectedDayCell = selCell
    }
}