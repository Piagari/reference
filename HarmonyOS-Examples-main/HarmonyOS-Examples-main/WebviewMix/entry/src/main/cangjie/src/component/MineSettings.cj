/**
 * Created on 2024/9/12
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

/**我的-设置列表 */
@Component
public class MineSettings {

    @Builder
     func SettingItem(src: CJResource,title: String) {
        Row() {
            Image(src).width(30).height(30)
            Text(title).fontSize(18).fontWeight(FontWeight.Bold).flexGrow(1).textAlign(TextAlign.Start).margin(left:10)
            Image(@r(app.media.ic_arrow_right)).width(30).height(30)
        }
        .height(80)
        .width(100.percent)
        .padding(top: 0, right: 10, bottom: 0, left: 10)
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
    }

    func build(){
        List(){
            ListItem(){
                SettingItem(@r(app.media.ic_todo),"TODO") //todo
            }
            ListItem(){
                SettingItem(@r(app.media.ic_model),"模式") //模式
            }
            ListItem(){
                SettingItem(@r(app.media.ic_about),"关于我们") //系统设置
            }
        }.divider(strokeWidth: 2.px, color: Color.GRAY, startMargin: 20.px, endMargin: 20.px) // 每行之间的分界线
    }

}