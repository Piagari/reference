/**
 * Created on 2025/8/5
 */
package ohos_app_cangjie_entry.ui

import ohos_app_cangjie_entry.ui.entity.*
import ohos_app_cangjie_entry.constant.*

import ohos.base.*
import ohos.component.*
import ohos.state_macro_manage.*
import ohos.state_manage.*
import std.format.*
import cj_res_entry.app

extend Text {
    func moneyStyle(cell: BillCell, isIncome: Bool) {
        this
        .height(14)
        .fontSize(12)
        .fontWeight(FontWeight.W500)
        .textAlign(TextAlign.Center)
        .fontColor(if (isIncome) { @r(app.color.income) } else { @r(app.color.expense) })
        .visibility(if (isIncome && cell.income != 0.0 || !isIncome && cell.expense != 0.0) { Visibility.Visible } else { Visibility.Hidden })
    }
}

@Component
public class CalendarGrid {
    @Prop
    var dynamicTime: DynamicTime
    @Prop
    var dynamicStyle: DynamicStyle
    @Prop
    var dynamicBill: DynamicBill

    var update: () -> Unit

    func build() {
        Grid {
            ForEach(dynamicStyle.flowCells, itemGeneratorFunc: { cell: BillCell, idx: Int64 => GridItem {
                        Column {
                            Text(cell.day.toString())
                            .width(32)
                            .height(32)
                            .textAlign(TextAlign.Center)
                            .fontWeight(FontWeight.W700)
                            .fontSize(18)
                            .fontColor(dynamicStyle.getFontColor(cell, idx))
                            .backgroundColor(dynamicStyle.getBackgroundColor(cell, idx))
                            .borderRadius(100)

                            Text(cell.expense.format(".2")).moneyStyle(cell, false)
                            Text(cell.income.format(".2")).moneyStyle(cell, true)
                            Divider()
                            .strokeWidth(0.6)
                            .width(100.percent)
                            .color(Color.BLACK)


                        }.onClick{ _ => handleCellClick(cell, idx) }
                    }
                },
                keyGeneratorFunc: {c: BillCell, i: Int64 => "${dynamicTime.timeStr()}-${c.day}-${i}"}
            )
        }
        .columnsTemplate(Constants.columnsTemplateStr)
        .rowsTemplate(dynamicStyle.getRowsTemplateStr())
        .height(dynamicStyle.getHeight())
        .offset(x: 0, y: 3)
        .width(100.percent)
        .rowsGap(30)
    }

    private func handleCellClick(cell: BillCell, idx: Int64) {
        dynamicTime.handleCellClick(cell, idx)
        dynamicBill.handleCellClick(cell, idx)
        dynamicStyle.handleCellClick(cell, idx)
        if (cell.isSupplemental) {
            update()
        }
    }
}