/**
 * Created on 2025/5/28
 */
package ohos_app_cangjie_entry.components

import ohos_app_cangjie_entry.interop.*
import ohos_app_cangjie_entry.utils.*
import ohos_app_cangjie_entry.components.entity.*

import std.collection.*
import cj_res_entry.app
import ohos.component.*
import ohos.state_macro_manage.Consume
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.hybrid_base.*
import ohos.base.*


// 文件选择器组件
@Component
protected class Picker {
    // 从父组件消费的状态变量
    @Consume var filesAreValid: Bool       // 文件是否有效标志
    @Consume var filePicked: Bool          // 是否已选择文件标志
    @Consume var attachments: GeneralDataSource<AttachmentInfo>  // 附件数据源
    @Consume var start: Bool               // 是否显示起始页标志

    @Builder
    public func Selector(image: CJResource, caption: CJResource, onClick!: () -> Unit = {=>}) {
        Column {
            Column {
                Image(image).width(25).height(25)
            }
            .width(110)
            .height(75)
            .backgroundColor(0xf0f0f0)
            .borderRadius(20)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .onClick { _ =>
                start = false
                onClick()
            }

            Text(caption)
            .fontColor(@r(app.color.text_color))
            .fontSize(12)
            .margin(top: 5)
        }.margin(top:5)
    }

    // 构建UI
    public func build() {
        Row {
            // 拍照OCR按钮
            Selector(@r(app.media.cam), @r(app.string.photo_ocr), onClick: { =>
                execFuncByName('takePhoto') { image, stage =>  handleOcrResult(image, stage, true) }
            })

            // 图片OCR按钮
            Selector(@r(app.media.pic), @r(app.string.image_ocr), onClick: { =>
                execFuncByName('selectImage') { image, stage => handleOcrResult(image, stage, true) }
            })

            // 文档OCR按钮
            Selector(@r(app.media.attachment), @r(app.string.document_label), onClick: { =>
                execFuncByName('selectFile') { doc, stage => handleOcrResult(doc, stage, false) }
            })
        }
        .width(100.percent)
        .borderWidth(1)
        .borderColor(0xf0f0f0)
        .padding(left: 20, right: 20, bottom: 5)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Bottom)
    }

    let fileNames: HashSet<String>  = HashSet<String>()
    // 处理OCR结果回调
    func handleOcrResult(fileInfo: OcrFileInfo, stage: Int8, isImage: Bool) {
        let ps = ProcessStage.fromInt8(stage)
        AppLog.info("[handleOcrResult] ${ps}, size: ${fileInfo.size}, ocrResult/reason: ${fileInfo.ocrResult}")

        if (let UPLOADING <- ps) {
            if(fileNames.contains(fileInfo.uri)) {
                showToast("重复文件: ${getFileName(fileInfo.uri)}")
                return
            }
            fileNames.put(fileInfo.uri)
            showToast("开始处理: ${getFileName(fileInfo.uri)}")
            let attachInfo = AttachmentInfo(fileInfo, if (isImage) { FileType.Image } else { FileType.Document }, attachments.totalCount())
            attachments.append(attachInfo)
            filePicked = true // 添加到附件列表后，更新状态
            filesAreValid = false // 初始时认为无效，直到解析完成
        } else {
            let idx = attachments.find() { i => attachments[i].uri == fileInfo.uri }
            if (idx == -1 || attachments[idx].uri != fileInfo.uri) { return }
            attachments[idx].stage = ps
            if (let FINISHED <- ps) {
                showToast("处理完成: ${getFileName(fileInfo.uri)}")
                attachments[idx].ocrResult = fileInfo.ocrResult
            }
            attachments.notifyOneChange(idx, changeType: UPDATE)
        }
    }
}