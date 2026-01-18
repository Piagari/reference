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
public class BarModeBar {
  // 页签宽度分布方式
  @Link var barMode: BarMode

  // 页签宽度分布方式的字符串表示
  @State var content: String = "Fixed"

  let options = ArrayList<String>(["Fixed", "Scrollable"])

  func handler(barMode: String){
    this.content = barMode
    this.parse(barMode)
  }

  func parse(barMode: String) {
    match (barMode) {
      case "Fixed" => this.barMode = BarMode.Fixed
      case "Scrollable" => this.barMode = BarMode.Scrollable
      case _ => this.barMode = BarMode.Fixed
    }
  }

  func build() {
    SelectBar(
      title: "BarMode",
      content: content,
      options: options,
      onSelect: handler
    )
  }
}