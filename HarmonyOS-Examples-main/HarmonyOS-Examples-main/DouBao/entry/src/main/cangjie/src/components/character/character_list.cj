/**
 * Created on 2024/8/26
 */
package ohos_app_cangjie_entry.components.character

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import cj_res_entry.app
import ohos.resource_manager.*
import ohos_app_cangjie_entry.util.*
import ohos_app_cangjie_entry.entity.*
import ohos_app_cangjie_entry.mock.*
import ohos.router.Router
import ohos_app_cangjie_entry.global.*

@Builder
func MoreItem(content: String) {
  Row() {
    Text(content)
    .fontSize(16)

    Image(@r(app.media.right_arrow))
    .size(width: 20, height: 20)
  }.justifyContent(FlexAlign.SpaceBetween)
  .alignItems(VerticalAlign.Center)
  .width(100.percent)
}

@Component
public class FriendList {
  let search1 = SearchController()

  @State var submitValue: String = ""

  @State var changeValue: String = ""

  @State var activeInd2: Int64 = 0

  func build() {
    Column() {
      Row() {
        Search(value: "", placeholder: "搜索智能体", controller: search1)
        .width(350)
        .height(45)
        .backgroundColor(0xf5f5f5)
        .placeholderColor(0x989898)
        .borderRadius(15)
        .onSubmit({value =>
          submitValue = value
        })
        .onChange({value =>
          changeValue = value
        })
        .id("searchComponent")
      }.width(100.percent)
      .justifyContent(FlexAlign.Center)
      .padding(top: 6, bottom: 6,left:6,right:6)
      .borderRadius(6)

      Column() {
        Scroll() {
          watchBar()
        }
      }.width(100.percent)
    }.width(100.percent)
    .height(100.percent)
  }
}