/**
 * Created on 2025/5/15
 *
 * Rate 评分组件示例页面
 */
package ohos_app_cangjie_entry.pages

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.state_macro_manage.*
import cj_res_entry.*
import ohos_app_cangjie_entry.components.{Nav, Title}
import silkui.components.rate.{SilkRate, SilkRateOptions}
import silkui.components.cell.{SilkCell, SilkCellOptions, SilkCellGroup, SilkCellGroupOptions}
import silkui.ResourceColor
import silkui.constants.SilkRateColorKey
import silkui.constants.updateRateColorConstant
import silkui.constants.getRateColorConstant
import ohos.prompt_action.PromptAction

@Entry
@Component
class RatePage {
    @State
    var score1: Float64 = 3.0

    @State
    var score2: Float64 = 3.0

    @State
    var score3: Float64 = 3.0

    @State
    var score4: Float64 = 2.5

    @State
    var score5: Float64 = 4.0

    @State
    var score6: Float64 = 3.0

    @State
    var score7: Float64 = 3.0

    @State
    var score8: Float64 = 3.0

    @State
    var score9: Float64 = 3.3

     @State
    var score10: Float64 = 2.0


    func build() {
        Column() {
            Nav("Rate")
            Scroll() {
                Column() {
                    Title("基础用法" + score1.toString())
                    Row() {
                        SilkRate(
                        value: score1,
                        props: SilkRateOptions()
                    )
                    }
                    .padding(left: 16.vp)
                    .width(100.percent)
                    .justifyContent(FlexAlign.Start)

                    Title("自定义图标")
                    Row() {
                    SilkRate(
                        value: score2,
                        props: SilkRateOptions(
                            icon: "like",
                            voidIcon: "like-o"
                        )
                    )
                        }
                    .padding(left: 16.vp)
                    .width(100.percent)
                    .justifyContent(FlexAlign.Start)

                    Title("自定义样式")
                        Row() {
                    SilkRate(
                        value: score3,
                        props: SilkRateOptions(
                            size: 25.vp,
                            color: Color(0xffffd21e),
                            voidIcon: "star",
                            voidColor: Color(0xffeeeeee)
                        )
                    )
                    }
                    .padding(left: 16.vp)
                    .width(100.percent)
                    .justifyContent(FlexAlign.Start)
                    Title("半星")
                    Row() {
                    SilkRate(
                        value: score4,
                        props: SilkRateOptions(
                            allowHalf: true
                        )
                    )
                    }
                    .padding(left: 16.vp)
                    .width(100.percent)
                    .justifyContent(FlexAlign.Start)
                    Title("自定义数量")
                    Row() {
                    SilkRate(
                        value: score5,
                        props: SilkRateOptions(
                            count: 6
                        )
                    )}
                    .padding(left: 16.vp)
                    .width(100.percent)
                    .justifyContent(FlexAlign.Start)

                    Title("可清空")
                    Row() {
                    SilkRate(
                        value: score6,
                        props: SilkRateOptions(
                            clearable: true
                        )
                    )}
                    .padding(left: 16.vp)
                    .width(100.percent)
                    .justifyContent(FlexAlign.Start)

                    Title("禁用状态")
                    Row() {
                    SilkRate(
                        value: score7,
                        props: SilkRateOptions(
                            disabled: true
                        )
                    )}
                    .padding(left: 16.vp)
                    .width(100.percent)
                    .justifyContent(FlexAlign.Start)

                    Title("只读状态")
                    Row() {
                    SilkRate(
                        value: score8,
                        props: SilkRateOptions(
                            readonly: true
                        )
                    )}
                    .padding(left: 16.vp)
                    .width(100.percent)
                    .justifyContent(FlexAlign.Start)

                    Title("只读状态小数显示")
                    Row() {
                    SilkRate(
                        value: score9,
                        props: SilkRateOptions(
                            readonly: true,
                            allowHalf: true
                        )
                    )}
                    .padding(left: 16.vp)
                    .width(100.percent)
                    .justifyContent(FlexAlign.Start)

                    Title("监听 change 事件")
                    Row() {
                    SilkRate(
                        value: score10,
                        props: SilkRateOptions(),
                        change: {v =>
                            score10 = v
                            // 在实际应用中可以使用 PromptAction.showToast 显示提示
                                PromptAction.showToast(
                                    message: "change: " + v.toString()
                                )
                        }
                    )}
                    .padding(left: 16.vp)
                    .width(100.percent)
                    .justifyContent(FlexAlign.Start)
                }
                .justifyContent(FlexAlign.Start)
            }
            .layoutWeight(1)
            .backgroundColor(@r(app.color.silkdocbackground))
            .align(Alignment.Top)
        }
        .width(100.percent)
        .height(100.percent)
    }
}
