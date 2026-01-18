/**
 * Created on 2025/8/4
 */
package ohos_app_cangjie_entry.ui

import ohos_app_cangjie_entry.constant.*
import ohos_app_cangjie_entry.ui.entity.*

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import cj_res_entry.app
import std.time.*


@Component
public class DatePickerComponent {
    @Prop
    var dynamicStyle: DynamicStyle
    @Prop
    var dynamicTime: DynamicTime

    var update: ()->Unit

    public func build() {
        if (dynamicStyle.showPicker) {
            Column {
                DatePicker(start: Constants.start, end: Constants.end, selected: dynamicTime.pickerDate)
                .onDateChange { result => dynamicTime.pickerDate = DateTime.of(
                        year: Int64(result.year),
                        month: Int64(result.month),
                        dayOfMonth: Int64(result.day),
                        timeZone: TimeZone.Local
                    )
                }
                .disappearTextStyle(color: Color.GRAY, weight: FontWeight.Bold)
                .textStyle(color: 0xff182431, weight: FontWeight.Normal)
                .selectedTextStyle(color: Color.BLACK, weight: FontWeight.W600)

                Row {
                    Button(@r(app.string.cancel))
                    .onClick{ _ => dynamicStyle.showPicker = false }
                    .layoutWeight(1)
                    .fontColor(Color.GRAY)
                    .backgroundColor(Color.WHITE)

                    Button(@r(app.string.confirm))
                    .onClick { _ =>
                        dynamicTime.resetByPicker()
                        this.update()
                        dynamicStyle.showPicker = false
                    }
                    .layoutWeight(1)
                    .fontColor(Color.BLUE)
                    .backgroundColor(Color.WHITE)
                }
                .height(40)
                .margin(top: 12)
            }
            .padding(16)
            .backgroundColor(Color.WHITE)
            .borderRadius(12)
            .width(80.percent)
            .align(Alignment.Center)
            .zIndex(2)
        }
    }
}