/**
 * Created on 2025/7/31
 */
package ohos_app_cangjie_entry.ui

import ohos_app_cangjie_entry.ui.entity.*

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import std.time.*
import cj_res_entry.app


@Component
public class MonthPickerRow {

    @Prop
    var dynamicTime: DynamicTime
    @Prop
    var dynamicStyle: DynamicStyle
    @Prop
    var dynamicBill: DynamicBill

    public func build() {
        Row {
            Text(dynamicTime.selectedMonthLabel).fontSize(18).fontWeight(W500).layoutWeight(1)
            Image(@r(app.media.arrow_bottom)).size(width: 18, height: 18)
        }
        .align(Alignment.Center)
        .offset(x: 10, y: 0)
        .height(32)
        .width(35.percent)
        .onClick { _ =>
            dynamicTime.pickerDate = dynamicTime.selectedDate
            dynamicStyle.showPicker = !dynamicStyle.showPicker
         }
    }
}
