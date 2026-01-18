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
public class SliderStyleBar {
  // 滑块的样式
  @Link var style: SliderStyle

  // 滑块样式的文本表示
  @State var content: String = "OutSet"

  let options = ArrayList<String>(["OutSet", "InSet"])

  func handler(style: String) {
    this.content = style
    this.parse(style)
  }

  func parse(style: String) {
    match (style) {
      case "OutSet" => this.style = SliderStyle.OutSet
      case "InSet" => this.style = SliderStyle.InSet
      case _ => this.style = SliderStyle.OutSet
    }
  }

  func build() {
    SelectBar(
      title: "SliderStyle",
      content: content,
      options: options,
      onSelect: handler
    )
  }
}