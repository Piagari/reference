/**
 * Created on 2024/9/9
 */
package ohos_app_cangjie_entry.component
internal import ohos.base.*
import ohos.component.*
internal import ohos.state_manage.*
internal import ohos_app_cangjie_entry.api.*
internal import ohos_app_cangjie_entry.bean.*
internal import ohos_app_cangjie_entry.utils.*
import ohos.state_macro_manage.*
internal import ohos.webview.*
internal import ohos.router.*
internal import std.collection.*
import ohos.resource_manager.*
import cj_res_entry.app //用于导入@r

@Component
public class TitleBar {

    @Link var title:String

    func build() {
        Flex(FlexParams(direction: FlexDirection.Row, alignItems:ItemAlign.Center)){
            Image(@r(app.media.ic_arrow_left))
            .width(@r(app.float.vp30))
            .height(@r(app.float.vp30))
            .onClick{ evt=> Router.back() }

            Text(Utils.formatHtml(this.title))
            //.width(20.percent)
            .height(50)
            //.backgroundColor(0xF5DEB3)
            .textAlign(TextAlign.Center)
            .textOverflow(TextOverflow.Ellipsis)
            .fontColor(Color.BLACK)
            .maxLines(1)
            .fontSize(20)
            .flexGrow(1)

            Text("")
             .width(@r(app.float.vp30))
             .height(@r(app.float.vp30))

        }
        .width(100.percent)
        .height(@r(app.float.vp60))
        .backgroundColor(0xF5F5F5)
    }

}