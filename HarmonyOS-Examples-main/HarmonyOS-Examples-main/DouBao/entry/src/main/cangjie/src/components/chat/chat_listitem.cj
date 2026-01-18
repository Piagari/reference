/**
 * Created on 2024/8/26
 */
package ohos_app_cangjie_entry.components.chat

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.components.badge.*
import ohos_app_cangjie_entry.entity.*
import cj_res_entry.app

const COLOR_SECONDARY: UInt32 = 0x6c757d

@Builder
public func ChatListItem(
  src!: CJResource,
  name!: String,
  msg!: String,
  time!: String,
  count!: Int64,
  about!: String,
  phone!:Int64 = 0,
  bindItem!: (Chat, User),
  onClick!: ((Chat, User)) -> Unit
)
{
  Row() {
    Avatar(src: src, size: 60)

    Column() {
      Row() {
        Row() {
          Text(name)
          .fontSize(18)
          .textOverflow(TextOverflow.Ellipsis)
          .fontWeight(Bold)
          .margin(right:8)
          MBadge(text: about)
        }.layoutWeight(1)
      }.justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Bottom)
      .margin(bottom: 10)

      Row() {
        Text(msg)
        .fontSize(14)
        .fontColor(COLOR_SECONDARY)
        .textOverflow(TextOverflow.Ellipsis)
        .maxLines(1)
        .layoutWeight(1)
      }.justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
    }.layoutWeight(1)
    .margin(left: 18)

    if (phone == 1) {
      Image(@r(app.media.phone))
      .width(30)
      .height(30)
    } else {
      Count(count: count)
    }
  }.padding(top: 10, bottom: 10,left:20,right:20)
  .width(100.percent)
  .margin(top: 5)
  .onClick({ e:ClickEvent => onClick(bindItem)})
}

