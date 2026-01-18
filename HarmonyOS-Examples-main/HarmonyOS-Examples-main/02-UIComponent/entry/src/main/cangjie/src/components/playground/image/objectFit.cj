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
public class ObjectFitBar {
  // 图片的填充样式
  @Link var objectFit: ImageFit

  // 图片填充样式的文本表示
  @State var content: String = "Cover"

  let options = ArrayList<String>(["Cover", "Contain", "Fill", "None", "ScaleDown"])

  func handler(objectFit: String) {
    this.content = objectFit
    this.parse(objectFit)
  }

  func parse(objectFit: String) {
    match (objectFit) {
      case "Cover" => this.objectFit = ImageFit.Cover
      case "Contain" => this.objectFit = ImageFit.Contain
      case "Fill" => this.objectFit = ImageFit.Fill
      case "None" => this.objectFit = ImageFit.None
      case "ScaleDown" => this.objectFit = ImageFit.ScaleDown
      case _ => this.objectFit = ImageFit.Cover
    }
  }

  func build() {
    SelectBar(
      title: "ImageFit",
      content: content,
      options: options,
      onSelect: handler
    )
  }

}