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
public class CurveBar {
  // 动画曲线
  @Link var curve: Curve

  // 动画曲线的文本表示
  @State var content: String = "Linear"

  let options = ArrayList<String>([
    "Linear",
    "Ease",
    "EaseIn",
    "EaseOut",
    "EaseInOut",
    "FastOutSlowIn",
    "LinearOutSlowIn",
    "FastOutLinearIn",
    "ExtremeDeceleration",
    "Sharp",
    "Rhythm",
    "Smooth",
    "Friction"
  ])

  func handler(curve: String) {
    this.content = curve
    this.parse(curve)
  }

  func parse(curve: String) {
    match (curve) {
      case "Linear" => this.curve = Curve.Linear
      case "Ease" => this.curve = Curve.Ease
      case "EaseIn" => this.curve = Curve.EaseIn
      case "EaseOut" => this.curve = Curve.EaseInOut
      case "EaseInOut" => this.curve = Curve.EaseInOut
      case "FastOutSlowIn" => this.curve = Curve.FastOutSlowIn
      case "LinearOutSlowIn" => this.curve = Curve.LinearOutSlowIn
      case "FastOutLinearIn" => this.curve = Curve.FastOutLinearIn
      case "ExtremeDeceleration" => this.curve = Curve.ExtremeDeceleration
      case "Sharp" => this.curve = Curve.Sharp
      case "Rhythm" => this.curve = Curve.Rhythm
      case "Smooth" => this.curve = Curve.Smooth
      case "Friction" => this.curve = Curve.Friction
      case _ => this.curve = Curve.Linear
    }
  }

  func build() {
    SelectBar(
      title: "Curve",
      content: content,
      options: options,
      onSelect: handler
    )
  }
}