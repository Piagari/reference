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
import silkui.components.dialog.ShowSilkDialog
import silkui.components.dialog.SilkDialogOptions
import silkui.components.dialog.ShowSilkConfirmDialog
import silkui.components.dialog.SilkDialogTheme
import silkui.SilkUILinearGradientOptions
import std.sync.sleep
import std.time.*
import silkui.components.dialog.SilkDialog

@Entry
@Component
class DialogPage {

    protected override func aboutToAppear(){
    }

    @Builder
    func fn1 () {
        SilkCell(
            props: SilkCellOptions(title: "提示弹窗", isLink: true),
            click: { _ => ShowSilkDialog(SilkDialogOptions(
                            title: "标题",
                        message: "代码是写出来给人看的，附带能在机器上运行。"
            ))}
        )
        SilkCell(
            props: SilkCellOptions(title: "提示弹窗（无标题）", isLink: true),
            click: { _ => ShowSilkDialog(SilkDialogOptions(
                        message: "生命远不止连轴转和忙到极限，人类的体验远比这辽阔、丰富得多。"
            ))}
        )
        SilkCell(
            props: SilkCellOptions(title: "确认弹窗", isLink: true),
            click: { _ => ShowSilkConfirmDialog(SilkDialogOptions(
                            title: "标题",
                        message: "如果解决方法是丑陋的，那就肯定还有更好的解决方法，只是还没有发现而已。"
            ))}
        )
    }
    @Builder
    func fn2 () {
        SilkCell(
            props: SilkCellOptions(title: "提示弹窗", isLink: true),
            click: { _ => ShowSilkDialog(SilkDialogOptions(
                            title: "标题",
                        message: "代码是写出来给人看的，附带能在机器上运行。",
                        theme: SilkDialogTheme.ROUND_BUTTON,
                        linearGradient: SilkUILinearGradientOptions(
                                    angle: 90.0,
                                    colors: [(Color(255, 96, 52, alpha: 1.0), 0.0), (Color(238, 10, 36, alpha: 1.0), 1.0)]
                                )
            ))}
        )
        SilkCell(
            props: SilkCellOptions(title: "提示弹窗（无标题）", isLink: true),
            click: { _ => ShowSilkDialog(SilkDialogOptions(
                        message: "生命远不止连轴转和忙到极限，人类的体验远比这辽阔、丰富得多。",
                        theme: SilkDialogTheme.ROUND_BUTTON,
                        linearGradient: SilkUILinearGradientOptions(
                                    angle: 90.0,
                                    colors: [(Color(255, 96, 52, alpha: 1.0), 0.0), (Color(238, 10, 36, alpha: 1.0), 1.0)]
                                )
            ))}
        )
    }
     @Builder
    func fn3 () {
        SilkCell(
            props: SilkCellOptions(title: "异步关闭", isLink: true),
            click: { _ => ShowSilkConfirmDialog(SilkDialogOptions(
                            title: "标题",
                        message: "如果解决方法是丑陋的，那就肯定还有更好的解决方法，只是还没有发现而已。",
                        beforeClose: { action =>
                            spawn {
                                =>
                                    sleep(3 * Duration.second);
                                    action == "confirm"
                            }
                            }
            ))}
        )
    }
    @State
    var showDialog = false;
 @Builder
    func fn4 () {
        SilkCell(
            props: SilkCellOptions(title: "使用SilkDialog组件", isLink: true),
            click: { _ => showDialog = true}
        )
    }
    @Builder
    func F4Body () {
        Image("https://fastly.jsdelivr.net/npm/@vant/assets/apple-3.jpeg")
        .width(100.percent)
        .padding(left: 20.vp, right: 20.vp, top: 25.vp)
    }
    func build() {
        Column() {
            Nav("Dialog")
            Scroll() {
                Column() {
                    Title("基础用法")
                    SilkCellGroup(props: SilkCellGroupOptions(inset: true), Childrens: this.fn1)
                    Title("圆角按钮样式")
                    SilkCellGroup(props: SilkCellGroupOptions(inset: true), Childrens: this.fn2)
                    Title("异步关闭")
                    SilkCellGroup(props: SilkCellGroupOptions(inset: true), Childrens: this.fn3)
                    Title("使用SilkDialog组件")
                    SilkCellGroup(props: SilkCellGroupOptions(inset: true), Childrens: this.fn4)
                    SilkDialog(
                        show: showDialog,
                        hasBody: true,
                        Body: F4Body,
                        props: SilkDialogOptions(
                            title: "标题",
                            showCancel: true
                        )
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