/**
 * Created on 2025/1/17
 */
package ohos_app_cangjie_entry.pages
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import cj_res_entry.app
import ohos.resource_manager.*
import ohos_app_cangjie_entry.util.*
import ohos_app_cangjie_entry.entity.*
import ohos_app_cangjie_entry.mock.*
import ohos_app_cangjie_entry.components.badge.*
import ohos.router.Router
import ohos_app_cangjie_entry.global.*

@Component
public class Notice {
  func build() {
    Column() {
      Text("通知")
      .fontSize(18)
      .fontWeight(Bold)
      .margin(top:20)

      Image(@r(app.media.notice))
      .width(90.percent)
      .height(130)
      .margin(top:20)
      .borderRadius(20)

      Image(@r(app.media.m5))
      .width(40)
      .height(40)
      .margin(top:200)

      Text("暂未收到通知")
      .margin(top:20)
      .fontColor(0x999999)
    }.width(100.percent)
    .justifyContent(FlexAlign.Center)
  }
}