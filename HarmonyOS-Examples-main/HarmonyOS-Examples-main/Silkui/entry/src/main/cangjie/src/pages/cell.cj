/**
 * Created on 2024/11/15
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

@Entry
@Component
class CellPage {
    @State
    var title: String = "标题"
    @State
    var flag: Bool = false

    protected override func aboutToAppear(){
    }
    @Builder
    func CustomTitle () {
        Row(4) {
            Text("单元格")
            .fontSize(@r(app.float.font_size_md))
            .fontColor(@r(app.color.text_color))
            Text("标签")
            .fontSize(@r(app.float.font_size_sm))
            .fontColor(@r(app.color.white))
            .padding(right: 4.0, left: 4.0)
            .borderRadius(@r(app.float.radius_sm))
            .backgroundColor(@r(app.color.primary_color))
        }
    }
    @Builder
    func CustomValue () {
        Image(@r(app.media.search))
            .height(16)
         .fillColor(@r(app.color.text_color))
    }

    @Builder
    func fn1() {
        SilkCell(
            props: SilkCellOptions(title: "单元格", value: "内容")
        )
        SilkCell(
            props: SilkCellOptions(title: "单元格", value: "内容", label: "描述信息")
        )
    }
    @Builder
    func fn2() {
        SilkCell(
            props: SilkCellOptions(title: "单元格", value: "内容", size: SilkCellSize.Large),
        )
        SilkCell(
            props: SilkCellOptions(title: "单元格", value: "内容", label: "描述信息", size: SilkCellSize.Large)
        )
    }
    @Builder
    func fn3() {
        SilkCell(
            props: SilkCellOptions(title: "单元格", value: "内容", icon: @r(app.media.location_o)),
        )
    }
    @Builder
    func fn4() {
        SilkCell(
            props: SilkCellOptions(title: "单元格", isLink: true),
        )
        SilkCell(
            props: SilkCellOptions(title: "单元格", value: "内容", isLink: true)
        )
        SilkCell(
            props: SilkCellOptions(title: "单元格", value: "内容", isLink: true, arrowDirection: SilkCellArrowDirection.DOWN)
        )
    }
    @Builder
    func fn5() {
        SilkCell(
            props: SilkCellOptions(title: "单元格", value: "内容"),
        )
    }
    @Builder
    func fn6() {
        SilkCell(
            props: SilkCellOptions(title: "单元格", value: "内容"),
        )
    }
     @Builder
    func fn7() {
        SilkCell(
            hasTitle: true,
            Title: this.CustomTitle,
            props: SilkCellOptions(value: "内容", isLink: true),
        )
        SilkCell(
            hasRightIcon: true,
            RightIcon: this.CustomValue,
            props: SilkCellOptions(title: "单元格", icon: @r(app.media.shop_o)),
        )
    }
    @Builder
    func fn8() {
        SilkCell(
            props: SilkCellOptions(title: "单元格", value: "内容", center: true, label: "描述信息"),
        )
    }
    func build() {
        Column() {
            Nav("Cell")
            Scroll() {
                Column() {
                    Title("基础用法")
                    SilkCellGroup(props: SilkCellGroupOptions(), Childrens: this.fn1)
                    Title("卡片风格")
                    SilkCellGroup(props: SilkCellGroupOptions(inset: true), Childrens: this.fn1)
                    Title("单元格大小")
                    SilkCellGroup(props: SilkCellGroupOptions(), Childrens: this.fn2)
                    Title("展示图标")
                    SilkCellGroup(props: SilkCellGroupOptions(), Childrens: this.fn3)
                    Title("展示箭头")
                    SilkCellGroup(props: SilkCellGroupOptions(), Childrens: this.fn4)
                    Title("分组标题")
                    SilkCellGroup(props: SilkCellGroupOptions(title: @r(app.string.cell_group_name1)), Childrens: this.fn5)
                    SilkCellGroup(props: SilkCellGroupOptions(title: "分组2"), Childrens: this.fn5)
                    Title("使用插槽")
                    SilkCellGroup(props: SilkCellGroupOptions(), Childrens: this.fn7)
                    Title("垂直居中")
                    SilkCellGroup(props: SilkCellGroupOptions(), Childrens: this.fn8)
                }
                .justifyContent(FlexAlign.Start)
            }
            .layoutWeight(1)
            .backgroundColor(@r(app.color.silkdocbackground))
            .align(Alignment.Top)
        }.width(100.percent).height(100.percent)
    }
}
