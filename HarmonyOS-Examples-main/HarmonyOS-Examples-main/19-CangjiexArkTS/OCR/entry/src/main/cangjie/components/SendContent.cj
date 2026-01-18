/**
 * Created on 2025/7/28
 */
package ohos_app_cangjie_entry.components

import ohos_app_cangjie_entry.utils.*
import ohos_app_cangjie_entry.components.entity.*

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import std.time.DateTime
import cj_res_entry.app

@Component
public class SendContent {

    @Prop var index: Int64

    @Prop var attachmentInfo: AttachmentInfo

    @Builder
    public func avatar() {
        Image(@r(app.media.me)).width(SIZE).height(SIZE).borderRadius(SIZE / 2).backgroundColor(0xf0f0f0)
    }

    @Builder
    func time() {
        Row() {
            Text(DateTime.now().toString('yyyy-MM-dd HH:mm:ss')).fontSize(12)
        }
        .width(100.percent)
        .justifyContent(FlexAlign.End)
        .margin(right: MARGIN)
    }

    @Builder
    func content() {
        if( attachmentInfo.kind.isImage() && attachmentInfo.uri != "") {
            Image(attachmentInfo.uri).width(100).height(100).borderWidth(1).objectFit(ImageFit.Cover)
        } else {
            Image(@r(app.media.file)).width(100).height(100)
        }
    }

    @Builder
    func fileItem() {
        FileItem(
            uri: attachmentInfo.uri,
            icon: attachmentInfo.kind.icon(),
            index: index,
            tips: getFileItemTips(attachmentInfo),
            dynamicStyle: DynamicStyle(attachmentInfo.isValid())
        )
    }

    // 获取文件项的提示文本
    func getFileItemTips(info: AttachmentInfo) {
        match (info.stage) {
            case PENDING => getResourceString(@r(app.string.pending))
            case PARSING => getResourceString(@r(app.string.parsing))
            case FINISHED =>
                if (info.ocrResult.isEmpty()) {
                    getResourceString(@r(app.string.no_text))
                } else {
                    "${getFileExt(info.uri)} ${getSizeStr(info.size)}"
                }
            case FAILED => getResourceString(@r(app.string.parse_failed))
            case _ => getResourceString(@r(app.string.uploading))
        }
    }

    func build() {
        Column(3) {
            time()
            Row() {
                content()
                avatar()
            }
            .justifyContent(FlexAlign.End)
            .alignItems(VerticalAlign.Top)
            .width(100.percent)
            fileItem()
        }
        .width(100.percent)
        .padding(right: 5, left: 10)
    }
}