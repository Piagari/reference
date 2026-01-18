/**
 * Created on 2024/8/6
 */
package ohos_app_cangjie_entry.components.playground.swiper

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.components.playground.utils.*
import std.collection.ArrayList

@Component
public class DisplayModeBar {
  // 元素的排列模式
  @Link var displayMode: SwiperDisplayMode

  // 元素排列模式的字符串表示
  @State var content: String = "STRETCH"

  let options = ArrayList<String>(["STRETCH", "AUTO_LINEAR"])

  func handler(displayMode: String) {
    this.content = displayMode
    this.parse(displayMode)
  }

  func parse(displayMode: String) {
    match (displayMode) {
      case "STRETCH" => this.displayMode = SwiperDisplayMode.Stretch
      case "AUto_LINEAR" => this.displayMode = SwiperDisplayMode.AutoLinear
      case _ => this.displayMode = SwiperDisplayMode.Stretch
    }
  }

  func build() {
    SelectBar(
      title: "DisplayMode",
      content: content,
      options: options,
      onSelect: handler
    )
  }
}