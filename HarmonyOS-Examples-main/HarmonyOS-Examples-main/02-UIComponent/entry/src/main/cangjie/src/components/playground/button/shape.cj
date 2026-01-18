/**
 * Created on 2024/8/2
 */
package ohos_app_cangjie_entry.components.playground.button

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.components.playground.utils.*
import std.collection.ArrayList

@Component
public class ShapeBar {
  // 按钮形状
  @Link var shape: ShapeType

  // 按钮形状的文本表示
  @State var content: String = "Normal"

  // 按钮类型的可选项
  let options = ArrayList<(String)>(["Normal", "Capsule", "CircleType"])

  // 按钮形状的响应回调
  func handler(shape: String) {
    this.content = shape
    this.parse(shape)
  }

  func parse(shape: String) {
    match (shape) {
      case "Normal" => this.shape = ShapeType.Normal
      case "Capsule" => this.shape = ShapeType.Capsule
      case "CircleType" => this.shape = ShapeType.CircleType
      case _ => this.shape = ShapeType.Normal
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