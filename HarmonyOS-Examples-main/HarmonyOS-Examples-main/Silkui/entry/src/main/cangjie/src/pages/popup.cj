/**
 * Created on 2025/5/8
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
import silkui.components.popup.SilkPopup
import silkui.components.popup.SilkPopupOptions
import silkui.components.popup.SilkPopupPosition
import silkui.components.popup.SilkPopupClosePosition
import ohos.prompt_action.PromptAction

@Entry
@Component
class PopupPage {
    @State
    var pop1: Bool = false
    @State
    var pop2: Bool = false
    @State
    var pop3: Bool = false
    @State
    var pop4: Bool = false
    @State
    var pop5: Bool = false
    @State
    var pop6: Bool = false
    @State
    var pop7: Bool = false
    @State
    var pop8: Bool = false
    @State
    var pop9: Bool = false
    @State
    var pop10: Bool = false
    @State
    var pop11: Bool = false
    @State
    var pop12: Bool = false
    @Builder
    func fn () {
        Column(){
            Text("内容")
            .fontSize(16)
            .fontColor(@r(app.color.text_color))
        }
        .padding(64)
    }
    @Builder
    func fn2 () {
        Column(){

        }
        .width(100.percent)
        .height(30.percent)
    }
    @Builder
    func fn3 () {
        Column(){

        }
        .width(100.percent)
        .height(100.percent)
    }

    func build() {
        Column() {
            Nav("Popup")
            Scroll() {
                Column() {
                    Title("基础用法")
                    Column(){
                        SilkCell(
                            props: SilkCellOptions(
                                title: "展示弹出层",
                                isLink: true
                            ),
                            click: { _=>
                                    pop1 = true
                                }
                        )
                        SilkPopup(show: pop1, props: SilkPopupOptions(), Children: fn)
                    }
                    .padding(left: 16,right: 16)
                    .borderRadius(0)
                    .clip(true)
                    Title("弹出位置")
                    Column(){
                        Grid() {
                            GridItem() {
                                Column(8) {
                                    Image(@r(app.media.arrow_up))
                                    .width(28)
                                    .aspectRatio(1)
                                    Text("顶部弹出")
                                    .fontSize(12)
                                    .fontColor(@r(app.color.text_color))
                                }
                                .padding(top: 16, bottom: 16)
                            }
                            .backgroundColor(Color.WHITE)
                            .onClick({_=>pop2 = true})
                            GridItem() {
                                Column(8) {
                                    Image(@r(app.media.arrow_down))
                                    .width(28)
                                    .aspectRatio(1)
                                    Text("底部弹出")
                                    .fontSize(12)
                                    .fontColor(@r(app.color.text_color))
                                }
                                .padding(top: 16, bottom: 16)
                            }
                            .backgroundColor(Color.WHITE)
                            .onClick({_=>pop3 = true})
                            GridItem() {
                                Column(8) {
                                    Image(@r(app.media.arrow_left))
                                    .width(28)
                                    .aspectRatio(1)
                                    Text("左侧弹出")
                                    .fontSize(12)
                                    .fontColor(@r(app.color.text_color))
                                }
                                .padding(top: 16, bottom: 16)
                            }
                            .backgroundColor(Color.WHITE)
                            .onClick({_=>pop4 = true})
                            GridItem() {
                                Column(8) {
                                    Image(@r(app.media.arrow))
                                    .width(28)
                                    .aspectRatio(1)
                                    Text("右侧弹出")
                                    .fontSize(12)
                                    .fontColor(@r(app.color.text_color))
                                }
                                .padding(top: 16, bottom: 16)
                            }
                            .backgroundColor(Color.WHITE)
                            .onClick({_=>pop5 = true})
                        }
                        .columnsTemplate("1fr 1fr 1fr 1fr")
                        .rowsGap(1)
                        .borderRadius(8)
                        .clip(true)
                        SilkPopup(
                            show: pop2,
                            props: SilkPopupOptions(
                                position: SilkPopupPosition.TOP
                            ),
                            Children: fn2
                        )
                        SilkPopup(
                            show: pop3,
                            props: SilkPopupOptions(
                                position: SilkPopupPosition.BOTTOM
                            ),
                            Children: fn2
                        )
                        SilkPopup(
                            show: pop4,
                            props: SilkPopupOptions(
                                position: SilkPopupPosition.LEFT
                            ),
                            Children: fn3
                        )
                        SilkPopup(
                            show: pop5,
                            props: SilkPopupOptions(
                                position: SilkPopupPosition.RIGHT
                            ),
                            Children: fn3
                        )
                    }
                    .padding(left: 16,right: 16)
                    .borderRadius(0)
                    Title("关闭图标")
                    Column(){
                        SilkCell(
                            props: SilkCellOptions(
                                title: "关闭图标",
                                isLink: true
                            ),
                            click: { _=>
                                    pop6 = true
                                }
                        )
                        SilkCell(
                            props: SilkCellOptions(
                                title: "自定义图标",
                                isLink: true
                            ),
                            click: { _=>
                                    pop7 = true
                                }
                        )
                        SilkCell(
                            props: SilkCellOptions(
                                title: "图标位置",
                                isLink: true
                            ),
                            click: { _=>
                                    pop8 = true
                                }
                        )
                        SilkPopup(show: pop6, props: SilkPopupOptions(position: SilkPopupPosition.BOTTOM, showClose: true), Children: fn2)
                        SilkPopup(show: pop7, props: SilkPopupOptions(position: SilkPopupPosition.BOTTOM, showClose: true, closeIcon: @r(app.media.close)), Children: fn2)
                        SilkPopup(show: pop8, props: SilkPopupOptions(position: SilkPopupPosition.BOTTOM, showClose: true, closePosition: SilkPopupClosePosition.TOP_LEFT), Children: fn2)
                    }.padding(left: 16,right: 16)
                    .borderRadius(0)
                    .clip(true)
                    Title("圆角弹窗")
                    Column(){
                        SilkCell(
                            props: SilkCellOptions(
                                title: "圆角弹窗（居中）",
                                isLink: true
                            ),
                            click: { _=>
                                    pop9 = true
                                }
                        )
                        SilkCell(
                            props: SilkCellOptions(
                                title: "圆角弹窗（底部）",
                                isLink: true
                            ),
                            click: { _=>
                                    pop10 = true
                                }
                        )

                        SilkPopup(show: pop9, props: SilkPopupOptions(round: true, roundValue: 16.vp), Children: fn)
                        SilkPopup(show: pop10, props: SilkPopupOptions(position: SilkPopupPosition.BOTTOM,round: true, roundValue: 16.vp), Children: fn2)
                    }.padding(left: 16,right: 16)
                    Title("事件监听")
                    Column(){
                        SilkCell(
                            props: SilkCellOptions(
                                title: "监听点击事件",
                                isLink: true
                            ),
                            click: { _=>
                                    pop11 = true
                                }
                        )
                        SilkCell(
                            props: SilkCellOptions(
                                title: "监听显示事件",
                                isLink: true
                            ),
                            click: { _=>
                                    pop12 = true
                                }
                        )

                        SilkPopup(show: pop11, props: SilkPopupOptions(showClose: true, round: true), Children: fn, clickOverlay: { => clickClose()}, clickClose: { => clickCloseIcon()})
                        SilkPopup(show: pop12, props: SilkPopupOptions(position: SilkPopupPosition.BOTTOM, round: true, roundValue: 16.vp), Children: fn2,
                            open: { => PromptAction.showToast(message: "open")},
                            opened: { => PromptAction.showToast(message: "opened")},
                            close: { => PromptAction.showToast(message: "close")},
                            closed: { => PromptAction.showToast(message: "closed")}
                            )
                    }.padding(left: 16,right: 16)
                    .borderRadius(0)
                    .clip(true)
                }.justifyContent(FlexAlign.Start)
            }.layoutWeight(1).backgroundColor(@r(app.color.silkdocbackground)).align(Alignment.Top)
        }.width(100.percent).height(100.percent)
    }
     func clickClose () {
        PromptAction.showToast(message: "click_overlay")
  }
  func clickCloseIcon () {
        PromptAction.showToast(message: "click_icon")
  }
}
