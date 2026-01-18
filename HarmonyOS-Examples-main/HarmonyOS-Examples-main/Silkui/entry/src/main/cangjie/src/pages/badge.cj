/**
 * Created on 2025/5/5
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
import silkui.SilkUIPaddingOptions
import silkui.components.badge.SilkBadge
import silkui.components.badge.SilkBadgeOptions
import silkui.components.icon.SilkIcon
import silkui.components.badge.SilkBadgePosition

@Entry
@Component
class BadgePage {

    @Builder
    func Children () {
        Column(){}
        .width(40)
        .aspectRatio(1)
        .borderRadius(4)
        .backgroundColor(@r(app.color.gray_2))
    }

    @Builder
    func C1 () {
            SilkIcon(
            name: "success",
            fontSize: 10.vp,
            lineHeight: 16.vp,
            fontColor: Color.WHITE
        )
    }
    @Builder
    func C2 () {
        SilkIcon(
            name: "cross",
            fontSize: 10.vp,
            lineHeight: 16.vp,
            fontColor: @r(app.color.white)
        )
    }
    @Builder
    func C3 () {
        SilkIcon(
            name: "down",
            fontSize: 10.vp,
            lineHeight: 16.vp,
            fontColor: @r(app.color.white)
        )
    }

    protected override func aboutToAppear(){
    }
    func build() {
        Column() {
            Nav("Badge")
            Scroll() {
                Column() {
                    Title("基础用法")
                    Row(16) {
                        SilkBadge(
                            props: SilkBadgeOptions(
                                content: "5"
                            ),
                            Children: Children,
                            hasChildren: true,
                            hasContent: false
                            )
                        SilkBadge(
                            props: SilkBadgeOptions(
                                content: "10"
                            ),
                            Children: Children,
                            hasChildren: true,
                            hasContent: false
                            )
                        SilkBadge(
                            props: SilkBadgeOptions(
                                content: "Hot"
                            ),
                            Children: Children,
                            hasChildren: true,
                            hasContent: false
                            )
                        SilkBadge(
                            props: SilkBadgeOptions(
                                content: "5",
                                dot: true
                            ),
                            Children: Children,
                            hasChildren: true,
                            hasContent: false
                            )
                    }
                    .width(100.percent)
                    .padding(left: 16.vp, right: 16.vp)
                    .justifyContent(FlexAlign.Start)
                    Title("最大值")
                    Row(16) {
                        SilkBadge(
                            props: SilkBadgeOptions(
                                content: "10",
                                max: 9
                            ),
                            Children: Children,
                            hasChildren: true,
                            hasContent: false
                            )
                        SilkBadge(
                            props: SilkBadgeOptions(
                                content: "21",
                                max: 20
                            ),
                            Children: Children,
                            hasChildren: true,
                            hasContent: false
                            )
                        SilkBadge(
                            props: SilkBadgeOptions(
                                content: "100",
                                max: 99
                            ),
                            Children: Children,
                            hasChildren: true,
                            hasContent: false
                            )
                    }
                    .width(100.percent)
                    .padding(left: 16.vp, right: 16.vp)
                    .justifyContent(FlexAlign.Start)
                    Title("自定义颜色")
                    Row(16) {
                        SilkBadge(
                            props: SilkBadgeOptions(
                                content: "5",
                                backgroundColor: Color(0xff1989fa)
                            ),
                            Children: Children,
                            hasChildren: true,
                            hasContent: false
                            )
                        SilkBadge(
                            props: SilkBadgeOptions(
                                content: "10",
                                backgroundColor: Color(0xff1989fa)
                            ),
                            Children: Children,
                            hasChildren: true,
                            hasContent: false
                            )
                        SilkBadge(
                            props: SilkBadgeOptions(
                                dot: true,
                                backgroundColor: Color(0xff1989fa)
                            ),
                            Children: Children,
                            hasChildren: true,
                            hasContent: false
                            )
                    }
                    .width(100.percent)
                    .padding(left: 16.vp, right: 16.vp)
                    .justifyContent(FlexAlign.Start)
                    Title("自定义徽标内容")
                    Row(16) {
                        SilkBadge(
                            props: SilkBadgeOptions(
                            ),
                            Content: C1,
                            Children: Children,
                            hasChildren: true,
                            hasContent: true
                            )
                        SilkBadge(
                            props: SilkBadgeOptions(
                            ),
                            Content: C2,
                            Children: Children,
                            hasChildren: true,
                            hasContent: true
                            )
                        SilkBadge(
                            props: SilkBadgeOptions(
                            ),
                            Content: C3,
                            Children: Children,
                            hasChildren: true,
                            hasContent: true
                            )
                    }
                    .width(100.percent)
                    .padding(left: 16.vp, right: 16.vp)
                    .justifyContent(FlexAlign.Start)
                    Title("自定义徽标位置")
                    Row(16) {
                        SilkBadge(
                            props: SilkBadgeOptions(
                                content: "10",
                                position: SilkBadgePosition.TOP_LEFT
                            ),
                            Children: Children,
                            hasChildren: true,
                            hasContent: false
                            )
                       SilkBadge(
                            props: SilkBadgeOptions(
                                content: "10",
                                position: SilkBadgePosition.BOTTOM_LEFT
                            ),
                            Children: Children,
                            hasChildren: true,
                            hasContent: false
                            )
                        SilkBadge(
                            props: SilkBadgeOptions(
                                content: "10",
                                position: SilkBadgePosition.BOTTOM_RIGHT
                            ),
                            Children: Children,
                            hasChildren: true,
                            hasContent: false
                            )
                    }
                    .width(100.percent)
                    .padding(left: 16.vp, right: 16.vp)
                    .justifyContent(FlexAlign.Start)
                    Title("独立展示")
                    Row(16) {
                        SilkBadge(
                            props: SilkBadgeOptions(
                                content: "20",
                            ),
                            hasChildren: false,
                            hasContent: false
                            )
                        SilkBadge(
                            props: SilkBadgeOptions(
                                content: "100",
                                max: 99
                            ),
                            hasChildren: false,
                            hasContent: false
                            )
                    }
                    .width(100.percent)
                    .padding(left: 16.vp, right: 16.vp)
                    .justifyContent(FlexAlign.Start)
                    }
                .justifyContent(FlexAlign.Start)
            }
            .layoutWeight(1)
            .backgroundColor(@r(app.color.white))
            .align(Alignment.Top)
        }.width(100.percent).height(100.percent)
    }
}