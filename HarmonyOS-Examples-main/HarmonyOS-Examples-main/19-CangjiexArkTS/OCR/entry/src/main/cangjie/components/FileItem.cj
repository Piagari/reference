/**
 * Created on 2025/5/28
 */
package ohos_app_cangjie_entry.components

import ohos_app_cangjie_entry.components.entity.*
import ohos_app_cangjie_entry.utils.*
import ohos_app_cangjie_entry.interop.*
import ohos.state_macro_manage.*
import ohos.base.*
import std.collection.*
import cj_res_entry.app

// 每一个附件信息所对应的附件栏中的项，用于调用后者的update函数来更新其中的状态变量。
protected let fileItemsMap = HashMap<AttachmentInfo, FileItem>()

const WIDTH: Int64 = 200
const HEIGHT: Int64 = 60

// 附件栏的每一个文件。
@Component
public class FileItem {
    var uri: String = ""
    var icon: CJResource
    var index: Int64
    var dynamicStyle: DynamicStyle

    @State var tips: String = getResourceString(@r(app.string.uploading))
    @Consume var filePicked: Bool
    @Consume var filesAreValid: Bool
    @Consume var attachments: GeneralDataSource<AttachmentInfo>

    protected func aboutToAppear(): Unit {
        AppLog.info("[Attachment] new FileItem: ${getFileName(uri)}, index=${index}")
        let info = attachments[index]
        //fileItemsMap.put(info, this)
    }

    protected func aboutToDisappear(): Unit {
        AppLog.info("[Attachment] delete FileItem: ${getFileName(uri)}, index=${index}")
    }

    func build() {
        Column(){
            // 文件信息区域
            Stack(Alignment.TopEnd) {
                Row {
                    Image(icon).width(30).height(30)
                    Column {
                        Text(getFileName(uri)).style(getResourceColor(@r(app.color.text_color)), 16, WIDTH - 50)
                        Text(tips).style(dynamicStyle.textColor(), 14, WIDTH - 50)
                    }
                    .justifyContent(FlexAlign.Start)
                }
                .borderRadius(10)
                .borderColor(@r(app.color.input_box_border))
                .borderWidth(1)
                .width(WIDTH - 6)
                .height(HEIGHT - 6)
                .margin(top: 6, right: 6)
                .justifyContent(FlexAlign.SpaceAround)
                // 删除按钮
                Image(dynamicStyle.closeButtonStyle())
                    .width(18)
                    .height(18)
                    .borderWidth(1)
                    .borderRadius(10)
                    .borderColor(dynamicStyle.closeBorderColor())
                    .backgroundColor(dynamicStyle.closeBackgroundColor())
                    .onClick { _ => onAttachmentsDeleted() }
            }
            .width(WIDTH)
            .height(HEIGHT)
        }
        .padding(top: 5, bottom:5)
        .justifyContent(FlexAlign.Start)
        .margin(left: MARGIN)
    }

    /**
     *   处理附件删除后的状态更新
     */
    func onAttachmentsDeleted() {
        let info = attachments[index]
        let uri = info.uri
        AppLog.info("[Attachment] remove file ${index}: ${uri}")
        // 从全局集合中移除
        fileItemsMap.remove(info)
        // 从数据源中删除
        attachments.delete(index)

        /**
        更新后续文件的索引
        这里是由于该组件保存的index无法被刷新，在删除非最后一个元素时，其后的组件中保存的index的值不对，
        所以在这里手动遍历刷新。
        虽然可以在GeneralDataSource::delete的方法中每次都调用notifyChange，但是这会导致在删除最后一个元素时，
        虽然UI上各组件还在原位置，但是实际位置在屏幕顶部，导致无法再点击删除。
        **/
        for (i in index..attachments.totalCount()) {
            if (let Some(v) <- fileItemsMap.get(attachments[i])) {
                AppLog.info("[Attachment] update index ${v.index} -> ${i}")
                v.index = i
            }
        }
        if (attachments.totalCount() == 0) {
            showToast("所有文件已清除")
            filePicked = false
            filesAreValid = false
        }
    }
}
