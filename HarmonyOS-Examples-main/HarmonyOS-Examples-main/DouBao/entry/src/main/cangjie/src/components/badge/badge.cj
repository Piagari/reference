/**
 * Created on 2024/8/26
 */
package ohos_app_cangjie_entry.components.badge

import ohos.base.*
import ohos.component.*
import ohos.state_macro_manage.*
import ohos.state_manage.*

const BG_INFORM2: UInt32 = 0xff3a32
const BG_SECONDARY: UInt32 = 0x6c757d
const FONT_COLOR2: UInt32 = 0xffffff
const BG_INFORM: UInt32 = 0xdde4f7
const FONT_COLOR: UInt32 = 0x0b65e1

@Builder
public func Avatar(src!: CJResource, size!: Int64 = 50) {
  Image(src).width(size).height(size).borderRadius(size / 2)
}

@Builder
public func MBadge(text!: String) {
  if (text!=''){
    Text(text.toString()).fontSize(14).fontWeight(Bold)
    .fontColor(FONT_COLOR).height(25)
    .backgroundColor(BG_INFORM)
    .borderRadius(5)
    .padding(left: 7, right: 7)
    .margin(right: 10)
  }

}

@Builder
public func Count(count!: Int64) {
  Text(count.toString()).fontSize(15).height(22)
  .fontColor(FONT_COLOR2)
  .backgroundColor(BG_INFORM2)
  .borderRadius(50.percent)
  .padding(left: 6, right: 6)
  .margin(right: 2)
}

@Builder
public func CBadge(count!: Int64) {
  Text(count.toString()).fontSize(12)
  .fontColor(0x000000).height(20)
  .backgroundColor(Color(208,207,212))
  .borderRadius(50.percent)
  .padding(left: 6, right: 6)
  .margin(right: 2)
}

@Builder
public func TheOptions(src!: CJResource, text!: String) {
  Row() {
    Text(text).fontWeight(FontWeight.Medium).fontSize(17).width(270)
    Image(src).size(width: 25, height: 25)
  }.borderRadius(20)
  .borderColor(0x6d767e)
  .shadow(radius: 50, color:Color(0xececec))
  .padding(25)
  .margin(bottom:20)
  .width(90.percent)
}

@Builder
public func MyImage(src!: CJResource) {
  Image(src).width(40).height(40).margin(bottom:20)
}

@Builder
public func ToCreate() {
  Button() {
    Text("去创作")
  }
  .fontSize(16)
  .shape(ShapeType.Normal)
  .stateEffect(true)
  .width(80)
  .height(35)
  .backgroundColor(0xf5f5f5)
  .borderRadius(15)
}

@Builder
public func Text_author_looknum(text!: String) {
  Text(text)
  .fontSize(14)
  .textOverflow(TextOverflow.Ellipsis)
  .margin(right:3)
  .fontColor(0x949494)
}

@Builder
public func Text_name(text!: String) {
  Text(text)
  .fontSize(18)
  .textOverflow(TextOverflow.Ellipsis)
  .fontWeight(FontWeight.Medium)
  .margin(right:8)
}

@Builder
public func Text_introduce(text!: String) {
  Text(text)
  .fontSize(14)
  .lineHeight(20)
  .textOverflow(TextOverflow.Ellipsis)
  .maxLines(2)
  .layoutWeight(1)
}

@Builder
public func ImageIcon(src!: CJResource, bot!: Int64) {
  Image(src)
  .size(width: 20, height: 20)
  .margin(right: bot)
}

@Builder
public func Text_self(text!: String, bot!: Int64) {
  Text(text)
  .margin(bottom: bot)
  .fontColor(0x999999)
}
