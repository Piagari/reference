/**
 * Created on 2024/8/26
 */
package ohos_app_cangjie_entry.components

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import cj_res_entry.app
import ohos.resource_manager.*
import ohos_app_cangjie_entry.util.*
import ohos_app_cangjie_entry.chat.*
import std.collection.ArrayList

@Component
public class ChatList {
    @Prop var chatData: GeneralDataSource<Chat>
    @State var index: Int64 = -1
    var onSelect: (index: Int64) -> Unit
    var curDate: String = ""

    @Builder
    public func ChatListItem(id: Int64, chat: Chat, drawDate: Bool) {
        Row() {
            Column() {
                if (drawDate) {
                    Row() {
                        Row() {
                            Text(chat.time)
                            .fontSize(16)
                            .textOverflow(TextOverflow.Ellipsis)
                            .fontWeight(FontWeight.Medium)
                            .fontColor(0xa3a3a3)
                            .maxLines(1)
                            .margin(left: 15)
                        }
                        .layoutWeight(1)
                    }
                    .justifyContent(FlexAlign.Center)
                    .alignItems(VerticalAlign.Bottom)
                    .margin(bottom: 5)
                }

                Row() {
                    Text(chat.messages[0].content)
                    .fontSize(17)
                    .fontColor(if (index == id) { 0x3e81d3u32 } else { 0x000000u32 })
                    .textOverflow(TextOverflow.Ellipsis)
                    .maxLines(1)
                    .layoutWeight(1)
                    .fontWeight(if (index == id) { FontWeight.Bold } else { FontWeight.Normal })
                }
                .justifyContent(FlexAlign.Center)
                .alignItems(VerticalAlign.Center)
                .width(100.percent)
                .backgroundColor(if (index == id) { 0xe3f1feu32 } else { 0xffffffu32 })
                .borderRadius(10)
                .padding(top: 15, bottom: 15, left: 15, right: 15)
            }
            .layoutWeight(1)
        }
        .padding(top: 2, bottom: 2, left: 5, right: 5)
        .width(100.percent)
        .margin(top: 5)
        .onClick { _ =>
            index = id
            onSelect(id)
        }
    }

    func drawDate(date: String) {
        if (curDate != date) {
            curDate = date
            return true
        }
        return false
    }

    func build() {
        Column {
            List {
                LazyForEach(chatData, itemGeneratorFunc: { chat: Chat, id: Int64 =>
                    ListItem {
                        ChatListItem(id, chat, drawDate(chat.time))
                    }
                    .backgroundColor(0xffffff)
                })
            }
            .padding(left: 0, right: 0, bottom: 0)
        }
        .width(100.percent)
        .height(90.percent)
    }
}