/**
 * Created on 2025/7/9
 */
package ohos_app_cangjie_entry.pages
import ohos.state_macro_manage.Entry
import ohos.state_macro_manage.Component
import ohos.state_macro_manage.State
import silkui.components.action_sheet.SilkActionSheet
import silkui.components.action_sheet.SilkActionSheetOptions
import silkui.components.action_sheet.SilkActionSheetAction
import ohos_app_cangjie_entry.components.Nav
import ohos_app_cangjie_entry.components.Title
import cj_res_entry.*
import ohos.state_macro_manage.r
import silkui.components.cell.SilkCellGroup
import silkui.components.cell.SilkCellGroupOptions
import silkui.components.cell.SilkCell
import ohos.state_macro_manage.Builder
import silkui.components.cell.SilkCellOptions
import silkui.components.toast.SilkToast

@Entry
@Component
public class ActionSheetPage {
    @State
    var show1: Bool = false
    @State
    var show2: Bool = false
    @State
    var show3: Bool = false
    @State
    var show4: Bool = false
    @State
    var show5: Bool = false
    @State
    var show6: Bool = false
    @Builder
    func fn1() {
        Column() {
            SilkCell(
            props: SilkCellOptions(
                title: "基础用法",
                isLink: true
                ),
                click: { _ => show1 = true }

        )
        SilkCell(
            props: SilkCellOptions(
                title: "展示图标",
                isLink: true
                ),
                click: { _ => show2 = true }

        )
        SilkCell(
            props: SilkCellOptions(
                title: "展示取消按钮",
                isLink: true
                ),
                click: { _ => show3 = true }

        )
        SilkCell(
            props: SilkCellOptions(
                title: "展示描述信息",
                isLink: true
                ),
                click: { _ => show4 = true }

        )
        }
    }
    @Builder
    func fn2() {
        Column() {
            SilkCell(
            props: SilkCellOptions(
                title: "选项状态",
                isLink: true
                ),
                click: { _ => show5 = true }

        )
        }
    }
    @Builder
    func fn3() {
        Column() {
            SilkCell(
            props: SilkCellOptions(
                title: "自定义面板",
                isLink: true
                ),
                click: { _ => show6 = true }

        )
        }
    }

    @Builder
    func content6 () {
        Text("内容")
    }

    var options1: SilkActionSheetOptions = SilkActionSheetOptions(
        actions: [
            SilkActionSheetAction(name: "选项一"),
            SilkActionSheetAction(name: "选项二"),
            SilkActionSheetAction(name: "选项三")
            ]
    )
    var options2: SilkActionSheetOptions = SilkActionSheetOptions(
        actions: [
            SilkActionSheetAction(name: "选项一", icon: "cart-o"),
            SilkActionSheetAction(name: "选项二", icon: "shop-o"),
            SilkActionSheetAction(name: "选项三", icon: "star-o")
            ]
    )
    var options3: SilkActionSheetOptions = SilkActionSheetOptions(
        cancelText: "取消",
        closeOnClickAction: true,
        actions: [
            SilkActionSheetAction(name: "选项一"),
            SilkActionSheetAction(name: "选项二"),
            SilkActionSheetAction(name: "选项三")
            ]
    )
    var options4: SilkActionSheetOptions = SilkActionSheetOptions(
        cancelText: "取消",
        closeOnClickAction: true,
        description: "这是一段描述信息",
        actions: [
            SilkActionSheetAction(name: "选项一"),
            SilkActionSheetAction(name: "选项二"),
            SilkActionSheetAction(name: "选项三", subname: "描述信息")
            ]
    )
    var options5: SilkActionSheetOptions = SilkActionSheetOptions(
         cancelText: "取消",
        closeOnClickAction: true,
        actions: [
            SilkActionSheetAction(name: "选项一", color: Color(0xffee0a24)),
            SilkActionSheetAction(name: "选项二", disabled: true),
            SilkActionSheetAction(name: "选项三", loading: true)
            ]
    )
    var options6: SilkActionSheetOptions = SilkActionSheetOptions(
        title: "标题"
    )
    func build () {
                Column() {
            Nav("ActionSheet")
            Scroll() {
                Column() {
                     Title("基础用法")
                    SilkCellGroup(props: SilkCellGroupOptions(inset: true), Childrens: this.fn1)
 Title("选项状态")
                    SilkCellGroup(props: SilkCellGroupOptions(inset: true), Childrens: this.fn2)
 Title("自定义面板")
                    SilkCellGroup(props: SilkCellGroupOptions(inset: true), Childrens: this.fn3)


                    SilkActionSheet(
                        show: show1,
                        props: options1,
                        select: { action, _ => SilkToast.toast(action.name); show1 = false}
                    )
                    SilkActionSheet(
                        show: show2,
                        props: options2,
                        select: { action, _ => SilkToast.toast(action.name); show2 = false}

                    )
                    SilkActionSheet(
                        show: show3,
                        props: options3,
                        cancel: { => SilkToast.toast("取消")}
                    )
                    SilkActionSheet(
                        show: show4,
                        props: options4
                    )
                    SilkActionSheet(
                        show: show5,
                        props: options5
                    )
                    SilkActionSheet(
                        show: show6,
                        props: options6,
                        content: {_ => content6(this)}
                    )
                    }
                .justifyContent(FlexAlign.Start)
            }
            .layoutWeight(1)
            .backgroundColor(@r(app.color.silkdocbackground))
            .align(Alignment.Top)
        }.width(100.percent).height(100.percent)

}
}