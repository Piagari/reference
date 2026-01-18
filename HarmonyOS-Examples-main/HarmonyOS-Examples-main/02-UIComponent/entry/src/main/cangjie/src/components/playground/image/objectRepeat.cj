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
public class ObjectRepeatBar {
  // 图片的重复模式
  @Link var objectRepeat: ImageRepeat

  // 图片重复样式的文本表示
  @State var content: String = "NoRepeat"

  let options = ArrayList<String>(["NoRepeat", "X", "Y", "XY"])

  func handler(objectRepeat: String) {
    this.content = objectRepeat
    this.parse(objectRepeat)
  }

  func parse(objectRepeat: String) {
    match (objectRepeat) {
      case "NoRepeat" => this.objectRepeat = ImageRepeat.NoRepeat
      case "X" => this.objectRepeat = ImageRepeat.X
      case "Y" => this.objectRepeat = ImageRepeat.Y
      case "XY" => this.objectRepeat = ImageRepeat.XY
      case _ => this.objectRepeat = ImageRepeat.NoRepeat
    }
  }

  func build() {
    SelectBar(
      title: "ObjectRepeat",
      content: content,
      options: options,
      onSelect: handler
    )
  }
}