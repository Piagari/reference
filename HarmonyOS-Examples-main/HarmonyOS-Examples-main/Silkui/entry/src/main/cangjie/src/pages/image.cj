/**
 * Created on 2025/5/9
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
import silkui.components.image.*
import silkui.components.loading.SilkLoading
import ohos.prompt_action.PromptAction

@Entry
@Component
class ImagePage {
    // 图片链接
    let catImage: String = "https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg"
    // 错误图片链接（用于演示加载失败）
    let errorImage: String = "https://fastly.jsdelivr.net/npm/@vant/assets/cat-error.jpeg"

    @Builder
    func loa1() {
        Column() {
            SilkLoading(size: 24.vp)
        }
            .width(100.percent)
            .height(100.percent)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .backgroundColor(Color(0xf7, 0xf8, 0xfa, alpha: 1.0))
    }

    @Builder
    func err1() {
        Column() {
            Text("加载失败").fontSize(14.vp).fontColor(Color(0x96, 0x97, 0x99, alpha: 1.0))
        }
            .width(100.percent)
            .height(100.percent)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .backgroundColor(Color(0xf7, 0xf8, 0xfa, alpha: 1.0))
    }

    func build() {
        Column() {
            Nav("Image")
            Scroll() {
                Column() {
                    Title("基础用法")
                    Row() {
                        SilkImage(
                            src: catImage,
                            props: SilkImageOptions(
                                width: 100.vp,
                                height: 100.vp
                            )
                        )
                    }
                        .justifyContent(FlexAlign.Start)
                        .padding(16)
                        .backgroundColor(Color.WHITE)
                        .width(100.percent)
                        .borderRadius(8)

                    Title("填充模式")
                    Row(10) {
                        Column() {
                            SilkImage(
                                src: catImage,
                                props: SilkImageOptions(
                                    width: 100.vp,
                                    height: 100.vp,
                                    fit: SilkImageFit.CONTAIN
                                )
                            )
                            Text("CONTAIN").fontSize(14).fontColor(@r(app.color.text_color)).margin(bottom: 5)
                        }
                        Column() {
                            SilkImage(
                                src: catImage,
                                props: SilkImageOptions(
                                    width: 100.vp,
                                    height: 100.vp,
                                    fit: SilkImageFit.COVER
                                )
                            )
                            Text("COVER").fontSize(14).fontColor(@r(app.color.text_color)).margin(bottom: 5)
                        }
                        Column() {
                            SilkImage(
                                src: catImage,
                                props: SilkImageOptions(
                                    width: 100.vp,
                                    height: 100.vp,
                                    fit: SilkImageFit.FILL
                                )
                            )
                            Text("FILL").fontSize(14).fontColor(@r(app.color.text_color)).margin(bottom: 5)
                        }
                    }
                        .justifyContent(FlexAlign.Start)
                        .padding(16)
                        .backgroundColor(Color.WHITE)
                        .width(100.percent)
                        .borderRadius(8)
                    Row(10) {
                        Column() {
                            SilkImage(
                                src: catImage,
                                props: SilkImageOptions(
                                    width: 100.vp,
                                    height: 100.vp,
                                    fit: SilkImageFit.NONE
                                )
                            )
                            Text("NONE").fontSize(14).fontColor(@r(app.color.text_color)).margin(bottom: 5)
                        }
                        Column() {
                            SilkImage(
                                src: catImage,
                                props: SilkImageOptions(
                                    width: 100.vp,
                                    height: 100.vp,
                                    fit: SilkImageFit.SCALE_DOWN
                                )
                            )
                            Text("SCALE_DOWN").fontSize(14).fontColor(@r(app.color.text_color)).margin(bottom: 5)
                        }
                    }
                        .justifyContent(FlexAlign.Start)
                        .padding(16)
                        .backgroundColor(Color.WHITE)
                        .width(100.percent)
                        .borderRadius(8)

                    //                    Title("图片位置")
                    //                    Column() {
                    //                        PositionImages()
                    //                    }.padding(16).backgroundColor(Color.WHITE).width(100.percent).borderRadius(8)
                    //
                    Title("圆形图片")
                    Row(10) {
                        Column() {
                            SilkImage(
                                src: catImage,
                                props: SilkImageOptions(
                                    width: 100.vp,
                                    height: 100.vp,
                                    fit: SilkImageFit.CONTAIN,
                                    round: true
                                )
                            )
                            Text("CONTAIN").fontSize(14).fontColor(@r(app.color.text_color)).margin(bottom: 5)
                        }
                        Column() {
                            SilkImage(
                                src: catImage,
                                props: SilkImageOptions(
                                    width: 100.vp,
                                    height: 100.vp,
                                    fit: SilkImageFit.COVER,
                                    round: true
                                )
                            )
                            Text("COVER").fontSize(14).fontColor(@r(app.color.text_color)).margin(bottom: 5)
                        }
                        Column() {
                            SilkImage(
                                src: catImage,
                                props: SilkImageOptions(
                                    width: 100.vp,
                                    height: 100.vp,
                                    fit: SilkImageFit.FILL,
                                    round: true
                                )
                            )
                            Text("FILL").fontSize(14).fontColor(@r(app.color.text_color)).margin(bottom: 5)
                        }
                    }
                        .justifyContent(FlexAlign.Start)
                        .padding(16)
                        .backgroundColor(Color.WHITE)
                        .width(100.percent)
                        .borderRadius(8)
                    Row(10) {
                        Column() {
                            SilkImage(
                                src: catImage,
                                props: SilkImageOptions(
                                    width: 100.vp,
                                    height: 100.vp,
                                    fit: SilkImageFit.NONE,
                                    round: true
                                )
                            )
                            Text("NONE").fontSize(14).fontColor(@r(app.color.text_color)).margin(bottom: 5)
                        }
                        Column() {
                            SilkImage(
                                src: catImage,
                                props: SilkImageOptions(
                                    width: 100.vp,
                                    height: 100.vp,
                                    fit: SilkImageFit.SCALE_DOWN,
                                    round: true
                                )
                            )
                            Text("SCALE_DOWN").fontSize(14).fontColor(@r(app.color.text_color)).margin(bottom: 5)
                        }
                    }
                        .justifyContent(FlexAlign.Start)
                        .padding(16)
                        .backgroundColor(Color.WHITE)
                        .width(100.percent)
                        .borderRadius(8)

                    Title("加载中提示")
                    Row(10) {
                        Column() {
                            SilkImage(
                                src: catImage,
                                props: SilkImageOptions(
                                    width: 100.vp,
                                    height: 100.vp
                                ),
                                Loading: loa1
                            )
                            Text("默认提示").fontSize(14).fontColor(@r(app.color.text_color)).margin(bottom: 5)
                        }
                        Column() {
                            SilkImage(
                                src: catImage,
                                props: SilkImageOptions(
                                    width: 100.vp,
                                    height: 100.vp
                                ),
                                Loading: loa1,
                                hasLoading: true
                            )
                            Text("自定义提示").fontSize(14).fontColor(@r(app.color.text_color)).margin(bottom: 5)
                        }
                    }
                        .justifyContent(FlexAlign.Start)
                        .padding(16)
                        .backgroundColor(Color.WHITE)
                        .width(100.percent)
                        .borderRadius(8)

                    Title("加载失败提示")
                    Row(10) {
                        Column() {
                            SilkImage(
                                src: errorImage,
                                props: SilkImageOptions(
                                    width: 100.vp,
                                    height: 100.vp
                                )
                            )
                            Text("默认提示").fontSize(14).fontColor(@r(app.color.text_color)).margin(bottom: 5)
                        }
                        Column() {
                            SilkImage(
                                src: errorImage,
                                props: SilkImageOptions(
                                    width: 100.vp,
                                    height: 100.vp
                                ),
                                Error: err1,
                                hasError: true
                            )
                            Text("自定义提示").fontSize(14).fontColor(@r(app.color.text_color))
                        }
                    }
                        .justifyContent(FlexAlign.Start)
                        .padding(16)
                        .backgroundColor(Color.WHITE)
                        .width(100.percent)
                        .borderRadius(8)

                    Title("事件监听")
                    Row() {
                        SilkImage(
                            src: catImage,
                            props: SilkImageOptions(
                                width: 100.vp,
                                height: 100.vp
                            ),
                            click: {_ => PromptAction.showToast(message: "点击图片")},
                            load: {=> PromptAction.showToast(message: "图片加载完成")},
                            error: {=> PromptAction.showToast(message: "图片加载失败")}
                        )
                    }
                        .justifyContent(FlexAlign.Start)
                        .padding(16)
                        .backgroundColor(Color.WHITE)
                        .width(100.percent)
                        .borderRadius(8)
                }.justifyContent(FlexAlign.Start).padding(left: 16, right: 16)
            }.layoutWeight(1).backgroundColor(@r(app.color.silkdocbackground)).align(Alignment.Top)
        }.width(100.percent).height(100.percent)
    }
}
