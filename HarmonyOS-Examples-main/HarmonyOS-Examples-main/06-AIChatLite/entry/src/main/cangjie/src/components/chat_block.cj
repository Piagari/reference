/**
 * Created on 2024/10/24
 */
package ohos_app_cangjie_entry.components

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.model.Who
import ohos_app_cangjie_entry.model.Message

const SIZE = 36
const MARGIN = SIZE * 2 + 20

@Component
public class ChatBlock {
    @Prop var message: Message

    @Builder
    public func Avatar() {
        Image(message.who.icon).width(SIZE).height(SIZE).borderRadius(SIZE / 2)
    }

    @Builder
    func MessageContent(bgColor: UInt32, fontColor: UInt32) {
        Row() {
            Text(message.content).fontColor(fontColor)
        }.constraintSize(maxWidth: 85.percent)
         .padding(10)
         .backgroundColor(bgColor)
         .borderRadius(10)
    }

    func build() {
        if (let Me <- message.who) {
            Column(3) {
                // 时间戳
                Row() {
                    Text(message.time).fontSize(12)
                }.width(100.percent)
                .justifyContent(FlexAlign.End)
                .margin(right: MARGIN)
                // 消息气泡
                Row() {
                    this.MessageContent(0x4c96ff, 0xffffff)
                    Row().width(10)
                    Avatar()
                }.justifyContent(FlexAlign.End)
                 .alignItems(VerticalAlign.Top)
                 .width(100.percent)
            }.width(100.percent)
            .padding(right: 10, left: 10)
        } else {
            Column(3) {
                Row() {
                    Text(message.time).fontSize(12)
                }.width(100.percent)
                .justifyContent(FlexAlign.Start)
                .margin(left: MARGIN)

                Row() {
                    Avatar()
                    Row().width(10)
                    this.MessageContent(0xffffff, 0x000000)
                }.justifyContent(FlexAlign.Start)
                 .alignItems(VerticalAlign.Top)
                 .width(100.percent)
            }.width(100.percent)
            .padding(right: 10, left: 10)
        }
    }
}