package ohos_app_cangjie_entry

import ohos_app_cangjie_entry.components.entity.*
import ohos_app_cangjie_entry.components.*
import ohos_app_cangjie_entry.utils.*

import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.hybrid_base.*
import ohos_app_cangjie_entry.interop.*

@HybridComponentEntry
@Component
class Index {

    // 附件数据源
    @Provide
    var attachments: GeneralDataSource<AttachmentInfo> = GeneralDataSource<AttachmentInfo>()

    // 是否显示起始引导页
    @Provide
    var start: Bool = true

    // 是否有文件被选中 - 监听变化
    @Provide @Watch[onAttachmentsChanged]
    var filePicked: Bool = false

    // 所有文件是否有效 - 监听变化
    @Provide @Watch[onAttachmentsChanged]
    var filesAreValid: Bool = false

    // 当附件状态变化时触发的回调
    func onAttachmentsChanged() {
        // 可以在这里添加附件变化时的额外逻辑
        // 例如：更新UI状态、验证文件有效性等
    }

    func build() {
        Column() {
            if (start) {
                StartPage() // 显示起始引导页组件
            } else {
                ChatContainer() // 显示文件操作区域
            }
            //底部选择器组件（拍照/图库/文件）
            Picker()
        }
        .height(680)
        .width(400)

    }
}
