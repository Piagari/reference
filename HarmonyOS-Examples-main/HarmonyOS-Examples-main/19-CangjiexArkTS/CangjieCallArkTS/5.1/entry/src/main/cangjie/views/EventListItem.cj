/**
 * Created on 2025/8/28
 */
package ohos_app_cangjie_entry.views

import std.time.*

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*

import ohos_app_cangjie_entry.services.EventInfo

@Component
class EventListItem {
    @Prop var item: EventInfo
    var onDelete: () -> Unit

    let timeFormat: String = "yyyy/MM/dd HH:mm"

    func build() {
        Row {
            Column {
                Text(item.title)
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                Text("${DateTime.fromUnixTimeStamp(Duration.millisecond * item.startTime).format(timeFormat)}")
                    .fontSize(12)
                    .margin(top: 4)
                    .fontColor(Color.GRAY)
            }
            .alignItems(HorizontalAlign.Start)

            Button("删除")
                .height(36)
                .borderRadius(8)
                .fontColor(Color.WHITE)
                .backgroundColor(0xec0000)
                .onClick { _ => onDelete() }
        }
        .height(48)
        .width(100.percent)
        .justifyContent(FlexAlign.SpaceBetween)
    }
}
