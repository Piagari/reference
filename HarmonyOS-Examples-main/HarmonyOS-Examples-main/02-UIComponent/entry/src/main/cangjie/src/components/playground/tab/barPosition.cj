/**
 * Created on 2024/8/6
 */
package ohos_app_cangjie_entry.components.playground.tab

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.components.playground.utils.*
import std.collection.ArrayList

@Component
public class BarPositionBar {
  // 页签位置
  @Link var barPosition: BarPosition

  @State var content: String = "Start"

  let options = ArrayList<String>(["Start", "End"])

  func handler(barPosition: String) {
    this.content = barPosition
    this.parse(barPosition)
  }

  func parse(barPosition: String) {
    match (barPosition) {
      case "Start" => this.barPosition = BarPosition.Start
      case "End" => this.barPosition = BarPosition.End
      case _ => this.barPosition = BarPosition.Start
    }
  }

  func build() {
    SelectBar(
      title: "BarPosition",
      content: content,
      options: options,
      onSelect: handler
    )
  }
}