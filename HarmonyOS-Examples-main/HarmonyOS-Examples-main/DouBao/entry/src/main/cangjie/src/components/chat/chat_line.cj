/**
 * Created on 2024/8/26
 */
package ohos_app_cangjie_entry.components.chat

import ohos.base.*
import ohos.component.*
import ohos.state_macro_manage.*
import ohos.state_manage.*
import ohos_app_cangjie_entry.components.badge.*

@Component
public class ChatLine {
  @Prop var src: CJResource

  @Prop var content: String

  @Prop var isSelf: Bool

  func build() {
    if (isSelf) {
      Row() {
        Row() {
          Text(content)
          .fontColor(0xffffff)
          .fontSize(18)
          .lineHeight(30)
        }
        .padding(top:10,bottom:10,left:20,right:20)
        .backgroundColor(0x0265fe)
        .borderRadius(20)
        .constraintSize(maxWidth: 100.percent)
        .margin(right: 10)
      }.justifyContent(FlexAlign.End)
      .width(100.percent)
      .padding(left: 10)
      .margin(top: 10, bottom: 10)
    } else {
      Row() {
        Row() {
          Text(content)
          .fontSize(18)
          .lineHeight(30)
        }
        .padding(top:10,bottom:10,left:20,right:20)
        .backgroundColor(0xf5f5f5)
        .constraintSize(maxWidth: 100.percent)
        .borderRadius(20)
        .margin(left: 10)
      }.width(100.percent)
      .padding(right: 10)
      .margin(top: 10, bottom: 10, right: 10)
    }
  }
}
