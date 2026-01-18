/**
 * Created on 2024/8/6
 */
package ohos_app_cangjie_entry.components.playground.slider

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.components.playground.utils.*
import std.collection.ArrayList

@Component
public class DirectionBar {
  // 滑轨的方向
  @Link var direction: Axis

  // 滑轨方向的文本表示
  @State var content: String = "Horizontal"

  let options = ArrayList<String>(["Horizontal", "Vertical"])

  func handler(direction: String) {
    this.content = direction
    this.parse(direction)
  }

  func parse(direction: String) {
    match (direction) {
      case "Horizontal" => this.direction = Axis.Horizontal
      case "Vertical" => this.direction = Axis.Vertical
      case _ => this.direction = Axis.Horizontal
    }
  }

  func build() {
    SelectBar(
      title: "Direction",
      content: content,
      options: options,
      onSelect: handler
    )
  }
}