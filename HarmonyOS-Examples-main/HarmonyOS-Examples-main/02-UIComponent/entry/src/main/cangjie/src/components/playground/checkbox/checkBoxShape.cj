/**
 * Created on 2024/8/5
 */
package ohos_app_cangjie_entry.components.playground.checkbox

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.components.playground.utils.*
import std.collection.ArrayList

@Component
public class CheckboxShapeBar {
  // 复选框形状
  @Link var checkboxShape: CheckBoxShape

  // 复选框形状的文本表示
  @State var content: String = "Circle"

  let options = ArrayList<String>(["CIRCLE", "ROUNDED_SQUARE"])

  func handler(checkboxShape: String) {
    this.content = checkboxShape
    this.parse(checkboxShape)
  }

  func parse(checkboxShape: String) {
    match (checkboxShape) {
      case "CIRCLE" => this.checkboxShape = CheckBoxShape.CIRCLE
      case "ROUNDED_SQUARE" => this.checkboxShape = CheckBoxShape.ROUNDED_SQUARE
      case _ => this.checkboxShape = CheckBoxShape.CIRCLE
    }
  }

  func build() {
    SelectBar(
      title: "Shape",
      content: content,
      options: options,
      onSelect: handler
    )
  }
}