/**
 * Created on 2024/8/6
 */
package ohos_app_cangjie_entry.components.playground.badge

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.components.playground.utils.*
import std.collection.ArrayList

@Component
public class BadgePositionBar {
  // 气泡的位置
  @Link var position: BadgePosition

  // 气泡位置的文本表示
  @State var content: String = "Right"

  let options = ArrayList<String>(["RightTop", "Right", "Left"])

  func handler(position: String) {
    this.content = position
    this.parse(position)
  }

  func parse(position: String) {
    match (position) {
      case "RightTop" => this.position = BadgePosition.RightTop
      case "Right" => this.position = BadgePosition.Right
      case "Left" => this.position = BadgePosition.Left
      case _ => this.position = BadgePosition.Right
    }
  }

  func build() {
    SelectBar(
      title: "Position",
      content: content,
      options: options,
      onSelect: handler
    )
  }
}