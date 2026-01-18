/**
 * Created on 2024/9/3
 */
package ohos_app_cangjie_entry.components

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*

@Component
public class FormInput {
    // 标签名
    @Prop var label: CJResource
    // 输入类型
    @Prop var inputType: InputType
    // 是否多行,如果是则直接显示一个TextArea
    @Prop var multi: Bool
    // 输入的内容,采用Link双向绑定
    @Link var value: String
    // 输入内容变化的响应函数
    func onChange(newValue: String) : Unit {
        this.value = newValue
    }

    func build() {
        Column(10) {
            Row() {
                Text(label).fontSize(20).fontWeight(FontWeight.W300)
            }.width(100.percent)
            .justifyContent(FlexAlign.Start)

            if (multi) {
                TextArea(text: value)
                .padding(10)
                .backgroundColor(0xffffff)
                .borderRadius(10)
                .borderWidth(2)
                .borderColor(0xe8e8e8)
                .onChange(onChange)
            } else {
                TextInput(text: value).setType(inputType)
                .padding(10)
                .backgroundColor(0xffffff)
                .borderRadius(10)
                .borderWidth(2)
                .borderColor(0xe8e8e8)
                .onChange(onChange)
            }
        }.width(100.percent)
        .margin(bottom: 20)
    }
}