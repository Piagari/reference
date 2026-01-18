/**
 * Created on 2025/4/26
 */
package ohos_app_cangjie_entry.pages

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.state_macro_manage.*
import cj_res_entry.*
import ohos_app_cangjie_entry.components.{Nav, Title}
import silkui.components.loading.*

@Entry
@Component
class LoadingPage {
    func build() {
        Column() {
            Nav("Loading")
            Scroll() {
                Column() {
                    Title("基础用法")
                    Row(20) {
                        SilkLoading()
                        SilkLoading(loadingType: SilkLoadingType.SPINNER)
                    }.width(100.percent).padding(top: 5, left: 20).justifyContent(FlexAlign.Start)
                    Title("特定的颜色")
                    Row(20) {
                        SilkLoading(color: @r(app.color.primary_color))
                        SilkLoading(loadingType: SilkLoadingType.SPINNER, color: @r(app.color.primary_color))
                    }.width(100.percent).padding(top: 5, left: 20).justifyContent(FlexAlign.Start)
                    Title("大小")
                    Row(20) {
                        SilkLoading(size: 24.vp)
                        SilkLoading(loadingType: SilkLoadingType.SPINNER, size: 24.vp)
                    }.width(100.percent).padding(top: 5, left: 20).justifyContent(FlexAlign.Start)
                    Title("加载文案")
                    Row(20) {
                        SilkLoading(size: 24.vp, text: "加载中...")
                    }.width(100.percent).padding(top: 5, left: 20).justifyContent(FlexAlign.Start)
                    Title("垂直")
                    Row(20) {
                        SilkLoading(size: 24.vp, text: "加载中...", vertical: true)
                    }.width(100.percent).padding(top: 5, left: 20).justifyContent(FlexAlign.Start)
                    Title("自定义文本颜色")
                    Row(20) {
                        SilkLoading(color: @r(app.color.base_color), text: "加载中...", vertical: true)
                        SilkLoading(text: "加载中...", vertical: true, textColor: @r(app.color.base_color))
                    }.width(100.percent).padding(top: 5, left: 20).justifyContent(FlexAlign.Start)
                    Title("自定义图标")
                    Row(20) {
                        SilkLoading(size: 24.vp, text: "加载中...", vertical: true, icon: @r(app.media.star_o))
                    }.width(100.percent).padding(top: 5, left: 20).justifyContent(FlexAlign.Start)
                }.justifyContent(FlexAlign.Start)
            }.layoutWeight(1).backgroundColor(@r(app.color.silkdocbackground)).align(Alignment.Top)
        }.width(100.percent).height(100.percent)
    }
}
