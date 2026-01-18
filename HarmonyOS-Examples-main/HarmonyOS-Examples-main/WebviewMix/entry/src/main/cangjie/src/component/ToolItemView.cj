/**
 * Created on 2024/9/11
 */
package ohos_app_cangjie_entry.component
internal import ohos.base.*
import ohos.component.*
internal import ohos.state_manage.*
internal import ohos_app_cangjie_entry.api.*
internal import ohos_app_cangjie_entry.bean.*
import ohos.state_macro_manage.*
internal import ohos.webview.*
internal import ohos.router.*
internal import std.collection.*
import ohos.resource_manager.*
import cj_res_entry.app //用于导入@r
import ohos.hilog.*
import ohos_app_cangjie_entry.utils.*

/**工具ItemView */

@Component
public class ToolItemView {

     @Prop var toolItem:ToolItem

    func build() {

        Column(){
            //1-name
            Text(toolItem.name)
            .fontSize(18)
            .fontColor(0x9098DB)

            //2-desc
            Text(toolItem.desc)
            .fontSize(12)
            .fontColor(Color.BLACK)
            .margin(top: 3, right: 0, bottom: 0, left: 0)

        }
        .width(100.percent)
        .height(80)
        .padding(top: 2, right: 5, bottom: 2, left: 5)
        .borderWidth(0.5)
        .borderColor(Color.GRAY)
        .justifyContent(FlexAlign.SpaceEvenly)
        .backgroundColor(0xF5F5F5)

    }

}