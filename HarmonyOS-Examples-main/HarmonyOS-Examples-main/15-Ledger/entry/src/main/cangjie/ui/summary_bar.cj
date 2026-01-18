/**
 * Created on 2025/7/31
 */
package ohos_app_cangjie_entry.ui

import ohos_app_cangjie_entry.constant.*
import ohos_app_cangjie_entry.ui.entity.*

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import std.format.*
import cj_res_entry.app


extend Text {
    func summaryBarStyle(isIncome: Bool) {
        this
        .fontSize(12)
        .fontWeight(FontWeight.W500)
        .margin(left: 4)
        .fontColor(if (isIncome) { @r(app.color.income) } else { @r(app.color.expense) })
    }
}

@Component
public class SummaryBar {
    @Prop
    var dynamicBill: DynamicBill

    public func build() {
        Row {
            Text(@r(app.string.CapitalFlow)).fontSize(22).fontWeight(W600)
            Row {
                Text(@r(app.string.income)).fontColor(Color.GRAY)
                Text(dynamicBill.selectedDayCell.income.format(".2")).summaryBarStyle(true)

                Text(@r(app.string.expenses)).fontColor(Color.GRAY).margin(left: 12)
                Text(dynamicBill.selectedDayCell.expense.format(".2")).summaryBarStyle(false)
            }
            .layoutWeight(1)
            .justifyContent(FlexAlign.End)
        }
        .height(40)
        .width(100.percent)
        .offset(x: -5, y: 0)
        .margin(top: 20)
    }
}
