package ohos_app_cangjie_entry.pages

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.router.*
import ohos_app_cangjie_entry.components.*
import ohos_app_cangjie_entry.components.playground.font.*
import ohos_app_cangjie_entry.components.playground.button.*
import ohos_app_cangjie_entry.utils.*
import ohos_app_cangjie_entry.components.playground.utils.*

@Entry
@Component
class ButtonView {
  // 字体大小
  @State var fontSize: Int64 = 16

  // 字体颜色
  @State var fontColor: UInt32 = 0xffffff

  // 字重
  @State var fontWeight: FontWeight = FontWeight.Normal

  // 字体样式
  @State var fontStyle: FontStyle = FontStyle.Normal

  // 按钮形状
  @State var shape: ShapeType = ShapeType.Normal

  // 是否开启按压效果
  @State var stateEffect: Bool = true

  // 宽度
  @State var width: Int64 = 140

  // 高度
  @State var height: Int64 = 60

  // 边框宽度
  @State var borderWidth: Int64 = 0

  // 边框的圆角
  @State var borderRadius: Int64 = 10

  // 边框的颜色
  @State var borderColor: UInt32 = 0xffffff

  // 背景颜色
  @State var backgroundColor: UInt32 = 0x3755be

  func build() {
    Scroll() {
      Column(SECTION_EXTERNAL_SPACE) {
        PageTitle(content: "Button")

        PageDescription(content: "Button组件用于呈现按钮")

        Column(SECTION_INTERNAL_SPACE) {
          SectionTitle(content: "Playground")

          Column() {
            Button() {
              Text("Join Cangjie")
              .fontSize(fontSize)
              .fontColor(fontColor)
              .fontWeight(fontWeight)
              .fontStyle(fontStyle)
            }
            .shape(shape)
            .stateEffect(stateEffect)
            .width(width)
            .height(height)
            .backgroundColor(backgroundColor)
            .borderRadius(borderRadius)
            .borderWidth(borderWidth)
            .borderColor(borderColor)
          }.codeCard().playgroundCard()

          Scroll() {
             Column(BAR_OUTER_GRID_SIZE) {
              SliderBar(
                value: fontSize,
                sliderParams: SliderParams(14.0, 60.0, 1.0),
                title: "FontSize"
              )

              ColorBand(
                color: fontColor,
                title: 'FontColor'
              )

              FontWeightBar(fontWeight: fontWeight)

              FontStyleBar(fontStyle: fontStyle)

              ShapeBar(shape: shape)

              SliderBar(
                value: width,
                sliderParams: SliderParams(50.0, 250.0, 10.0),
                title: "Width"
              )

              SliderBar(
                value: height,
                sliderParams: SliderParams(50.0, 250.0, 10.0),
                title: "Height"
              )

              SliderBar(
                value: borderRadius,
                sliderParams: SliderParams(0.0, 50.0, 1.0),
                title: 'BorderRadius'
              )

              SliderBar(
                value: borderWidth,
                sliderParams: SliderParams(0.0, 20.0, 1.0),
                title: "BorderWidth"
              )

              ColorBand(
                color: borderColor,
                title: "BorderColor"
              )


              ColorBand(
                color: backgroundColor,
                title: "BackgroundColor"
              )

              ToggleBar(
                value: stateEffect,
                title: "StateEffect"
              )
             }
          }.playgound()
          .height(600)
        }.section()
      }.pageContainer()
    }
  }
}