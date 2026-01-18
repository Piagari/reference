/**
 * Created on 2025/4/25
 */
package ohos_app_cangjie_entry.pages

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.state_macro_manage.*
import cj_res_entry.*
import ohos_app_cangjie_entry.components.{Nav, Title}
import silkui.components.cell.*
import silkui.components.toast.*
import silkui.SilkUIPaddingOptions
import silkui.components.loading.SilkLoadingType
import std.sync.sleep
import std.time.*

@Entry
@Component
class Toast {
    @Builder
    func Fn1() {
        SilkCell(
            props: SilkCellOptions(title: "文字提示", isLink: true),
            click: {e => SilkToast.toast("提示内容")}
        )
        SilkCell(
            props: SilkCellOptions(title: "加载提示", isLink: true),
            click: {e => SilkToast.loading(@r(app.string.test_toast))}
        )
        SilkCell(
            props: SilkCellOptions(title: "成功提示", isLink: true),
            click: {e => SilkToast.success("成功文案")}
        )
        SilkCell(
            props: SilkCellOptions(title: "失败提示", isLink: true, border: false),
            click: {e => SilkToast.error("失败文案")}
        )
    }

    @Builder
    func Fn2() {
        SilkCell(
            props: SilkCellOptions(title: "自定义图标", isLink: true),
            click: {e => SilkToast.toast(SilkToastOptions(message: "自定义图标", icon: @r(app.media.like_o)))}
        )
        SilkCell(
            props: SilkCellOptions(title: "自定义图片", isLink: true),
            click: { e => SilkToast.toast(SilkToastOptions(message: "自定义图标", icon: "https://fastly.jsdelivr.net/npm/@vant/assets/logo.png"))}
            )
        SilkCell(
            props: SilkCellOptions(title: "自定义加载图标", isLink: true),
            click: {e => SilkToast.loading(SilkToastOptions(message: "加载中...", loadingType: SilkLoadingType.SPINNER))}
        )
    }
    @Builder
    func Fn3() {
        SilkCell(
            props: SilkCellOptions(title: "顶部展示", isLink: true),
            click: {e => SilkToast.toast(SilkToastOptions(message: "自定义图标", showPosition: SilkToastPosition.TOP))}
        )
        SilkCell(
            props: SilkCellOptions(title: "底部展示", isLink: true),
            click: {e => SilkToast.toast(SilkToastOptions(message: "自定义图标", showPosition: SilkToastPosition.BOTTOM))}
        )
    }
    @Builder
    func Fn4() {
        SilkCell(
            props: SilkCellOptions(title: "使用 Toast 组件", isLink: true),
            click: {e => show = true}
        )
    }
    @Builder
    func CusContentImage() {
        Image('https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg').width(200).height(100)
    }
    @Builder
    func Fn5() {
        SilkCell(
            props: SilkCellOptions(title: "动态更新提示", isLink: true),
            click: {
                e =>
                let toast = SilkToast.loading(
                    SilkToastOptions(
                        duration: 0,
                        forbidClick: true,
                        message: "倒计时 3 秒"
                    )
                );

                spawn {
                    =>
                    var second = 3;
                    while (second > 0) {
                        sleep(1 * Duration.second);
                        second--;
                        if (second > 0) {
                            toast.setMessage?("倒计时 ${second.toString()} 秒")
                        } else {
                            SilkToast.closeToast()
                        }
                    }
                }
            }
        )
    }

    @State
    var show: Bool = false

    func build() {
        Column() {
            Nav("Toast")
            Scroll() {
                Column() {
                    Title("基础用法")
                    SilkCellGroup(props: SilkCellGroupOptions(), Childrens: this.Fn1)
                    Title("自定义图标")
                    SilkCellGroup(props: SilkCellGroupOptions(), Childrens: this.Fn2)
                    Title("自定义位置")
                    SilkCellGroup(props: SilkCellGroupOptions(), Childrens: this.Fn3)
                    Title("动态更新提示")
                    SilkCellGroup(props: SilkCellGroupOptions(), Childrens: this.Fn5)
                    Title("使用 Toast 组件")
                    SilkCellGroup(props: SilkCellGroupOptions(), Childrens: this.Fn4)
                    SilkToastComponent(show: show, Content: CusContentImage,
                        style: SilkToastStyle(padding: SilkUIPaddingOptions(0.vp)), hasContent: true)
                }.justifyContent(FlexAlign.Start)
            }.layoutWeight(1).backgroundColor(@r(app.color.silkdocbackground)).align(Alignment.Top)
        }.width(100.percent).height(100.percent)
    }
}
