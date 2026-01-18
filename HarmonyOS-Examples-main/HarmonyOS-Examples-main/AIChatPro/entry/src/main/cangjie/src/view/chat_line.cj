/**
 * Created on 2024/8/26
 */
package ohos_app_cangjie_entry.view

import ohos.base.CJResource
import ohos.base.LengthProp
import ohos.base.Length
import ohos.component.Alignment
import ohos.component.CustomView
import ohos.component.Flex
import ohos.component.FlexAlign
import ohos.component.FlexDirection
import ohos.component.FlexParams
import ohos.component.LegalCallCheck
import ohos.component.ItemAlign
import ohos.component.Row
import ohos.component.Text
import ohos.component.ViewBuilder
import ohos.state_macro_manage.Component
import ohos.state_manage.LocalStorage
import ohos.state_manage.ObservedProperty
import ohos.state_manage.SubscriberManager
import ohos.state_manage.ViewStackProcessor
import ohos.state_macro_manage.Prop

// custom project
import ohos_app_cangjie_entry.components.Avatar

@Component
public class ChatLine {
    @Prop var src: CJResource

    @Prop var content: String

    @Prop var is_self: Bool

    func build() {
     Row() {
       Flex(
        FlexParams(
          direction: if (!is_self) {FlexDirection.Row} else {FlexDirection.RowReverse},
          justifyContent: FlexAlign.Start,
          alignItems: ItemAlign.Start,
          alignContent:  if (!is_self) {FlexAlign.Start} else {FlexAlign.End}
       )) {
         Avatar(src: src, size: 40)
         Row() {
           Text(content)
         }
         .padding(10)
         .backgroundColor(if (is_self) {0x89d961} else {0xffffff})
         .borderRadius(10)
         .constraintSize(maxWidth: 80.percent)
         .margin(right: 10, left: 10)
       }
     }.justifyContent(if (is_self) {FlexAlign.End} else {FlexAlign.Start})
     .width(100.percent)
     .padding(left: 10, right: 10)
     .margin(top: 10, bottom: 10)
    }
}
