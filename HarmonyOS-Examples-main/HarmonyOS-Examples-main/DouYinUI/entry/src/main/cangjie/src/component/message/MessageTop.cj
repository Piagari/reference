/**
 * Created on 2024/8/29
 */
package ohos_app_cangjie_entry.component.message

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*
import cj_res_entry.app
import ohos_app_cangjie_entry.common.Constants

@Component
public class MessageTop {
    func build() {
        Row {
            Image(@r(app.media.ic_add)).width(24.vp).height(24.vp).fillColor(@r(app.color.light_black)).margin(
                bottom: 2)
            Row() {
                Text(@r(app.string.message)).fontSize(18.vp).fontColor(Color.BLACK)
            }.layoutWeight(1) //当前组件自适应占满剩余空间
            .justifyContent(FlexAlign.Center)

            Image(@r(app.media.ic_search_filled)).width(24.vp).height(24.vp).fillColor(@r(app.color.light_black)).margin(
                bottom: 2)
        }.height(50.vp).width(Constants.FULL_SIZE).alignItems(VerticalAlign.Center).justifyContent(
            FlexAlign.SpaceAround).padding(left:10,right:10)
    }
}
