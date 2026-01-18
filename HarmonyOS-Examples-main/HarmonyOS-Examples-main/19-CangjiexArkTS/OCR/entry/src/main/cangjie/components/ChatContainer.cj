/**
 * Created on 2025/2/12
 */
package ohos_app_cangjie_entry.components

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
internal import ohos.pasteboard.*
internal import std.collection.*
import cj_res_entry.app
import cj_res_entry.sys

import ohos_app_cangjie_entry.components.entity.*
import ohos_app_cangjie_entry.utils.*
import ohos_app_cangjie_entry.interop.*
import ohos.state_manage.*
import ohos.state_macro_manage.*

extend Text {
    func style(fcolor: Color, fsize: Int64, width: Int64) {
        this.fontColor(fcolor)
        .fontSize(fsize)
        .width(width)
        .maxLines(1)
        .textOverflow(TextOverflow.Ellipsis)
    }
}
/**
 * FileLine组件
 * 展示用户选择的附件列表和OCR提取的文本内容
*/
@Component
public class ChatContainer {
    @Provide var fileLineHeight: Int64 = 0 // 附件栏的高度，有文件时非0，没文件时为0
    @Consume var filePicked: Bool          // 聊天页面中定义的状态变量，根据它来控制附件栏高度
    @Consume var attachments: GeneralDataSource<AttachmentInfo>

    let scroller: Scroller = Scroller()

    @Builder
    func topButton() {
        Image(@r(app.media.top))
        .fillColor(0xffffff)
        .size(width:20,height:20)
        .onClick({ e:ClickEvent => scroller.scrollEdge(Edge.Top) })
    }

    @Builder
    func content() {
        Scroll(scroller) {
            Column(20) {
                LazyForEach(attachments, itemGeneratorFunc: { attachmentInfo: AttachmentInfo, index: Int64 =>
                    Column {
                        SendContent(index: index, attachmentInfo: attachmentInfo)
                        Column().height(10)
                        ReceiveContent(message: attachmentInfo.ocrResult)
                        topButton()
                    }.padding(top: 5,right: 8,bottom: 5)
                }, keyGeneratorFunc: { attachmentInfo: AttachmentInfo, index: Int64 =>
                    attachmentInfo.index = index
                    attachmentInfo.hashCode().toString()
                 })
            }
         }
        .align(Alignment.TopStart)
        .layoutWeight(1)
        .backgroundColor(0xe0ffff)
    }

    func build() {
        Column {
            content()
        }
        .height(100.percent)
        .width(100.percent)
    }
}
