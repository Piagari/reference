/**
 * Created on 2025/8/28
 */
package ohos_app_cangjie_entry.views

import ohos.base.*
import ohos.component.*

extend Column {
    // 卡片容器样式
    func sectionCard() {
        this.width(100.percent)
            .padding(20)
            .borderRadius(15)
            .margin(bottom: 15)
            .backgroundColor(Color.WHITE)
            .alignItems(HorizontalAlign.Start)
    }
}

extend Text {
    // 标题样式
    func sectionTitle() {
        this.fontSize(20)
            .fontWeight(FontWeight.Medium)
            .margin(bottom: 5)
    }
}

extend TextInput {
    // 文本输入框样式
    func inputFieldStyle() {
        this.fontSize(16)
            .backgroundColor(0xF1F3F5)
            .borderRadius(10)
            .padding(10)
            .margin(bottom: 10)
            .height(50)
    }
}

extend Button {
    // 操作按钮样式
    func actionButton() {
        this.width(100.percent)
            .height(50)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .borderRadius(12)
    }
}

extend Divider {
    // 标准分割线样式
    func standardDivider() {
        this.strokeWidth(1)
            .color(0xEFEFEF)
            .margin(top: 10, bottom: 10)
    }
}

extend ListItem {
    // 列表项样式
    func listItemStyle() {
        this.padding(10)
            .borderRadius(8)
            .backgroundColor(0xFAFAFA)
    }
}
