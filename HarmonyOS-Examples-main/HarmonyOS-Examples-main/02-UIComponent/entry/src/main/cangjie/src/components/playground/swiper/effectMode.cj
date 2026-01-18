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
public class EffectModeBar {
  // 边缘滑动效果
  @Link var effectMode: EdgeEffect

  // 边缘滑动效果的文本表示
  @State var content: String = "Spring"

  let options = ArrayList<String>(["Spring", "Fade", "None"])

  func handler(effectMode: String) {
    this.content = effectMode
  }

  func parse(effectMode: String) {
    match (effectMode) {
      case "Spring" => this.effectMode = EdgeEffect.Spring
      case "Fade" => this.effectMode = EdgeEffect.Fade
      case "None" => this.effectMode = EdgeEffect.None
      case _ => this.effectMode = EdgeEffect.None
    }
  }

  func build() {
    SelectBar(
      title: "EffectMode",
      content: content,
      options: options,
      onSelect: handler
    )
  }
}