package ohos_app_cangjie_entry.pages

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.router.*
import ohos_app_cangjie_entry.components.*
import ohos_app_cangjie_entry.components.playground.font.*
import ohos_app_cangjie_entry.components.playground.slider.*
import ohos_app_cangjie_entry.utils.*
import ohos_app_cangjie_entry.components.playground.utils.*

@Entry
@Component
public class SliderView {
  // 滑块的值
  @State var value: Float64 = 0.0

  // 滑块颜色
  @State var blockColor: UInt32 = COLOR_BLACK

  // 轨道颜色
  @State var trackColor: UInt32 = COLOR_LIGHT

  // 滑块划过的轨道的颜色
  @State var selectedColor: UInt32 = COLOR_BLACK

  // 样式
  @State var style: SliderStyle = SliderStyle.OutSet

  // 显示步长
  @State var showSteps: Bool = false

  // 显示气泡
  @State var showTips: Bool = false

  // 方向
  @State var direction: Axis = Axis.Horizontal

  // 是否反向
  @State var reverse: Bool = false

  // 滑轨粗细
  @State var trackThickness: Int64 = 5

  func build() {
    Scroll() {
      Column(SECTION_EXTERNAL_SPACE) {
        PageTitle(content: "Slider")

        PageDescription(content: "Slider组件用于呈现滑块，实现范围内的取值")

        Column(SECTION_INTERNAL_SPACE) {
          SectionTitle(content: "Playground")

          Column() {
            Slider(
              value: 0.0,
              min: 0.0,
              max: 200.0,
              step: 5.0,
              style: style,
              direction: direction,
              reverse: reverse
            ).blockColor(blockColor)
            .trackColor(trackColor)
            .selectedColor(selectedColor)
            .showSteps(showSteps)
            .showTips(showTips)
            .trackThickness(trackThickness)
            .onChange({
              val: Float64, mode: SliderChangeMode => this.value = val
            }).margin(top: 40)

            Text("${value}")
          }.codeCard().playgroundCard()

          Scroll() {
            Column() {
              ColorBand(
                color: blockColor,
                title: "BlockColor"
              )

              ColorBand(
                color: trackColor,
                title: "TrackColor"
              )

              ColorBand(
                color: selectedColor,
                title: "SelectedColor"
              )

              SliderStyleBar(style: style)

              ToggleBar(
                value: showSteps,
                title: "ShowSteps"
              )

              ToggleBar(
                value: showTips,
                title: "ShowTips"
              )

              DirectionBar(direction: direction)

              ToggleBar(
                value: reverse,
                title: "Reverse"
              )

              SliderBar(
                value: trackThickness,
                sliderParams: SliderParams(0.0, 20.0, 1.0),
                title: "TrackThickness"
              )
            }
          }.playgound()
          .height(600)
        }.section()
      }.pageContainer()
    }
  }
}