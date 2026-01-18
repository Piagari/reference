/**
 * Created on 2024/8/26
 */
package ohos_app_cangjie_entry.components.character

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.components.badge.*
import ohos_app_cangjie_entry.entity.*
import cj_res_entry.app

const COLOR_SECONDARY: UInt32 = 0x6c757d

@Builder
public func watchListItem(
  src!: CJResource,
  name!: String,
  msg!: String,
  time!: String,
  count!: Int64,
  about!: String,
  phone!:Int64 = 0,
  bindItem!: (Chat, User),
  author!: String,
  readnum!: String,
  introduce!: String,
  onClick!: ((Chat, User)) -> Unit
) {
  Column() {
    Row() {
      Avatar(src: src, size: 60)
      Column() {
        Row() {
          Row() {
            Text_name(text: name)
          }.layoutWeight(1)
        }.justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Bottom)
        .margin(bottom: 3)

        Row() {
          Text_introduce(text: introduce)
        }.justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)

      }.layoutWeight(1)
      .margin(left: 18)

      Image(@r(app.media.add3))
      .width(30)
      .height(30)
      .margin(left:10)
    }
    .padding(top: 0, bottom: 0,left:10,right:10)
    .width(100.percent)
    .margin(top: 0).onClick({ e:ClickEvent => onClick(bindItem)})

    Row() {
      Row() {
        Text() {
          ImageSpan(@r(app.media.chat2))
          .width(20)
          .height(20)
          .objectFit(ImageFit.Contain)
        }.margin(right:3)
        Text_author_looknum(text: readnum)
        Text_author_looknum(text: ' · ')
        Text_author_looknum(text: '@'+author)
      }.layoutWeight(1)
    }.justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Bottom)
    .margin(top:5,left:90)
  }
  .width(100.percent)
  .padding(left: 8, right: 8)
}

