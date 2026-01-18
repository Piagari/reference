/**
 * Created on 2025/4/28
 */
package ohos_app_cangjie_entry.pages

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.state_macro_manage.*
import cj_res_entry.*
import ohos_app_cangjie_entry.components.{Nav, Title}
import silkui.components.button.SilkButton
import silkui.components.button.SilkButtonOptions
import silkui.components.button.SilkButtonType
import silkui.components.loading.SilkLoadingType
import silkui.components.button.SilkButtonSize
import silkui.SilkUILinearGradientOptions
import silkui.components.button.SilkButtonLoading
import silkui.components.button.SilkButtonDisabled

@Entry
@Component
class ButtonPage {
    @State
    var disabled: Bool = true
    @State
    var loading: Bool = false

    func build() {
        Column() {
            Nav("Button")
            Scroll() {
                Column() {
                    Title("按钮类型")
                    Row(16) {
                        SilkButton(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.PRIMARY,
                                text: "主要按钮"
                            )
                        )
                        SilkButton(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.SUCCESS,
                                text: "成功按钮"
                            )
                        )
                        SilkButton(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.DEFAULT,
                                text: "默认按钮"
                            )
                        )
                    }.width(100.percent).padding(top: 5, left: 20, right: 20).justifyContent(FlexAlign.Start)
                    Row(15) {
                        SilkButton(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.DANGER,
                                text: "危险按钮"
                            )
                        )
                        SilkButton(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.WARNING,
                                text: "警告按钮"
                            )
                        )
                    }.width(100.percent).padding(top: 5, left: 20, right: 20).justifyContent(FlexAlign.Start)
                    Title("朴素按钮")
                    Row(16) {
                        SilkButton(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.PRIMARY,
                                text: "朴素按钮",
                                plain: true
                            )
                        )
                        SilkButton(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.SUCCESS,
                                text: "朴素按钮",
                                plain: true
                            )
                        )
                    }.width(100.percent).padding(top: 5, left: 20, right: 20).justifyContent(FlexAlign.Start)
                    Title("细边框")
                    Row(16) {
                        SilkButton(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.PRIMARY,
                                text: "细边框按钮",
                                plain: true,
                                hairLine: true
                            )
                        )
                        SilkButton(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.SUCCESS,
                                text: "细边框按钮",
                                plain: true,
                                hairLine: true
                            )
                        )
                    }.width(100.percent).padding(top: 5, left: 20, right: 20, bottom: 5).justifyContent(FlexAlign.Start)
                    Title("禁用状态")
                    Row(16) {
                        SilkButtonDisabled(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.PRIMARY,
                                text: "禁用状态按钮"
                            ),
                            disabled: disabled
                        )
                        SilkButtonDisabled(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.SUCCESS,
                                text: "禁用状态按钮"
                            ),
                            disabled: disabled
                        )
                    }.width(100.percent).padding(top: 5, left: 20, right: 20).justifyContent(FlexAlign.Start)
                    Title("加载状态")
                    Row(16) {
                        SilkButtonLoading(
                            props: SilkButtonOptions(buttonType: SilkButtonType.PRIMARY),
                            loading: true
                        )
                        SilkButtonLoading(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.PRIMARY,
                                loadingType: SilkLoadingType.SPINNER
                            ),
                            loading: true
                        )
                        SilkButtonLoading(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.SUCCESS,
                                loadingText: "加载中..."
                            ),
                            loading: true
                        )
                    }.width(100.percent).padding(top: 5, left: 20, right: 20).justifyContent(FlexAlign.Start)
                    Title("按钮形状")
                    Row(16) {
                        SilkButton(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.PRIMARY,
                                text: "方形按钮",
                                square: true
                            )
                        )
                        SilkButton(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.SUCCESS,
                                text: "圆形按钮",
                                round: true
                            )
                        )
                    }.width(100.percent).padding(top: 5, left: 20, right: 20).justifyContent(FlexAlign.Start)
                    Title("图标按钮")
                    Row(16) {
                        SilkButton(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.PRIMARY,
                                icon: "plus",
                            )
                        )
                        SilkButton(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.PRIMARY,
                                icon: @r(app.media.startIcon),
                                text: "按钮",
                            )
                        )
                        SilkButton(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.PRIMARY,
                                plain: true,
                                icon: "https://fastly.jsdelivr.net/npm/@vant/assets/user-active.png",
                                text: "按钮",
                            )
                        )
                    }.width(100.percent).padding(top: 5, left: 20, right: 20).justifyContent(FlexAlign.Start)
                    Title("按钮尺寸")
                    Row(16) {
                        SilkButton(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.PRIMARY,
                                text: "大号按钮",
                                size: SilkButtonSize.LARGE
                            )
                        )
                    }.width(100.percent).padding(top: 5, left: 20, right: 20).justifyContent(FlexAlign.Start)
                    Row(16) {
                        SilkButton(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.PRIMARY,
                                text: "普通按钮",
                                size: SilkButtonSize.NORMAL
                            )
                        )
                        SilkButton(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.PRIMARY,
                                text: "小型按钮",
                                size: SilkButtonSize.SMALL
                            )
                        )
                        SilkButton(
                            props: SilkButtonOptions(
                                buttonType: SilkButtonType.PRIMARY,
                                text: "迷你按钮",
                                size: SilkButtonSize.MINI
                            )
                        )
                    }.width(100.percent).padding(top: 5, left: 20, right: 20).justifyContent(FlexAlign.Start)
                    Title("自定义颜色")
                    Row(16) {
                        SilkButton(
                            props: SilkButtonOptions(text: "单色按钮",color: Color(114, 50, 221, alpha: 1.0)),
                        )
                        SilkButton(
                            props: SilkButtonOptions(
                                text: "单色按钮",
                                plain: true,
//                            color: Color(114, 50, 221, alpha: 1.0)
                                color: @r(app.color.test_button)
                            ),
                        )
                        SilkButton(
                            props: SilkButtonOptions(
                                text: "渐变色按钮",
                                linearGradient: SilkUILinearGradientOptions(
                                    angle: 90.0,
                                    colors: [(Color(255, 96, 52, alpha: 1.0), 0.0), (Color(238, 10, 36, alpha: 1.0), 1.0)]
                                )
                            ),
                        )
                    }.width(100.percent).padding(top: 5, left: 20, right: 20).justifyContent(FlexAlign.Start)
                }.justifyContent(FlexAlign.Start)
            }.layoutWeight(1).backgroundColor(@r(app.color.silkdocbackground)).align(Alignment.Top)
        }.width(100.percent).height(100.percent)
    }
}
