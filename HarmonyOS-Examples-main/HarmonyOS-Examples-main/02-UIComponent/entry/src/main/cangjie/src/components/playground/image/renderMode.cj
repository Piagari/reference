/**
 * Created on 2024/8/5
 */
package ohos_app_cangjie_entry.components.playground.image

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.components.playground.utils.*
import std.collection.ArrayList

@Component
public class RenderModeBar {
  // 图片渲染的模式
  @Link var renderMode: ImageRenderMode

  // 图片渲染模式的字符串表示
  @State var content: String = "Original"

  let options = ArrayList<String>(["Original", "Template"])

  func handler(renderMode: String) {
    this.content = renderMode
    this.parse(renderMode)
  }

  func parse(renderMode: String) {
    match (renderMode) {
      case "Original" => this.renderMode = ImageRenderMode.Original
      case "Template" => this.renderMode = ImageRenderMode.Template
      case _ => this.renderMode = ImageRenderMode.Original
    }
  }

  func build() {
    SelectBar(
      title: "RenderMode",
      content: content,
      options: options,
      onSelect: handler
    )
  }
}