package ohos_app_cangjie_entry

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.components.badge.*
import ohos_app_cangjie_entry.components.index.*
import ohos.resource_manager.*
import cj_res_entry.app
import ohos_app_cangjie_entry.components.index.*
import ohos_app_cangjie_entry.util.*
import ohos_app_cangjie_entry.components.chat.ChatList
import ohos_app_cangjie_entry.components.character.FriendList
import ohos_app_cangjie_entry.pages.Myself
import ohos_app_cangjie_entry.pages.Notice
@Entry
@Component
class IndexView {
  // 当前选中的tab的Index
  @State var activeInd: Int64 = 0

  func build() {
    Column() {
      if (activeInd ==0) {
        Row() {
          Row() {
            Row() {}.width(75)
            Text("对话").fontSize(20).fontWeight(Bold)
            Row() {
              Image(@r(app.media.select))
              .size(width: 25, height: 25)
              .margin(right:25)

              Image(@r(app.media.add))
              .size(width: 25, height: 25)
            }
          }.justifyContent(FlexAlign.SpaceBetween)
          .layoutWeight(1)
          .alignItems(VerticalAlign.Center)
        }.padding(20)
        .width(100.percent)
        .alignItems(VerticalAlign.Center)
      }
      Scroll() {
        if (activeInd == 0) {
          ChatList()
        } else if (activeInd == 1) {
          FriendList()
        } else if (activeInd == 3) {
          Notice()
        } else if (activeInd == 4) {
          Myself()
        }
      }.width(100.percent)
      .layoutWeight(1)
      .scrollable(ScrollDirection.Vertical)
      .align(Alignment.TopStart)
      Row() {
        TabBar(activeInd: activeInd)
      }
    }.height(100.percent)
    .width(100.percent)
    .backgroundColor(0xffffff)
    .expandSafeArea(
      types: [SafeAreaType.SYSTEM],
      edges: [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]
    )
  }
}
