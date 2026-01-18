/**
 * Created on 2024/10/24
 */
package ohos_app_cangjie_entry.components

import ohos.base.*
import ohos.component.*
import ohos.state_macro_manage.*
import ohos.state_manage.*
import cj_res_entry.*

@Component
public class MessageLine {
    @Prop var content: String
    @Prop var reason: String
    @Prop var self: Bool
    @State var show: Bool = true

    func icon(show: Bool) : CJResource {
        return if (show) { @r(app.media.on) } else { @r(app.media.down) }
    }

    func build() {
        if (self) {
            Column(3) {
                Row {
                    Row {
                        Text(content).fontColor(0x000000).fontSize(16).lineHeight(26)
                    }
                    .constraintSize(maxWidth: 90.percent)
                    .padding(top: 7, bottom: 7, right: 16, left: 16)
                    .backgroundColor(0xebf3fe)
                    .borderRadius(20)
                }
                .justifyContent(FlexAlign.End)
                .alignItems(VerticalAlign.Top)
                .width(100.percent)
            }
            .width(100.percent)
            .padding(right: 5, left: 5)
        } else {
            Column(3) {
                Row {
                    Row {
                        ChatAvatar(src: @r(app.media.system), size: 36)
                    }.margin(top: 5)
                    Row {
                        if (content == '' && reason == '') {
                            Row {
                                Image(@r(app.media.loading)).width(25).height(25)
                            }.padding(top: 7,bottom: 7,right: 16,left: 16)
                            .backgroundColor(0xffffff)
                        }
                        Column {
                            if (reason != '') {
                                Column {
                                    Row {
                                        Text('已深度思考').fontWeight(Bold).fontColor(0x777777).fontSize(14).lineHeight(20).margin(right: 10)
                                        Image(icon(show)).width(20).height(20)
                                    }
                                    .padding(top: 7,bottom: 7,right: 16,left: 16)
                                    .width(90.percent)
                                    .justifyContent(FlexAlign.Start)
                                    .onClick { _ =>
                                        if (show) {
                                            show = false
                                        } else {
                                            show = true
                                        }
                                    }
                                    if (show) {
                                        Row {
                                            Row().width(10)
                                            Row {
                                                Text(reason).fontColor(0x777777).fontSize(14).lineHeight(20)
                                            }
                                            .padding(top: 7,bottom: 0,right: 16,left: 10)
                                            .borderStyle(BorderStyle.Solid)
                                            .borderWidth(EdgeWidths(left: 2.vp))
                                            .borderColor(0xe5e5e5)
                                        }.width(90.percent)
                                    }
                                }
                            }
                            if (content != '') {
                                Row {
                                    Text(content).fontColor(0x000000).fontSize(16).lineHeight(26)
                                }
                                .width(90.percent)
                                .padding(top: 7,bottom: 7,right: 16,left: 16)
                                .backgroundColor(0xffffff)
                            }
                        }

                    }
                }
                .justifyContent(FlexAlign.Start)
                .alignItems(VerticalAlign.Top)
                .width(100.percent)
            }
            .width(100.percent)
            .padding(right: 5, left: 5)
        }
    }
}