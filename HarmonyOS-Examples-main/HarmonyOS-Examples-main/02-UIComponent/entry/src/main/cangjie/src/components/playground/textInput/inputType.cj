/**
 * Created on 2024/8/5
 */
package ohos_app_cangjie_entry.components.playground.textInput

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.components.playground.utils.*
import std.collection.ArrayList

@Component
public class InputTypeBar {
  // 输入类型
  @Link var inputType: InputType

  // 输入类型的文本表示
  @State var content: String = "Normal"

  let options = ArrayList<String>(["Normal", "Number", "Email", "Password"])

  func handler(inputType: String) {
    this.content = inputType
    this.parse(inputType)
  }

  func parse(inputType: String) {
    match (inputType) {
      case "Normal" => this.inputType = InputType.Normal
      case "Number" => this.inputType = InputType.Number
      case "Email" => this.inputType = InputType.Email
      case "Password" => this.inputType = InputType.Password
      case _ => this.inputType = InputType.Normal
    }
  }

  func build() {
    SelectBar(
      title: "InputType",
      content: content,
      options: options,
      onSelect: handler
    )
  }
}