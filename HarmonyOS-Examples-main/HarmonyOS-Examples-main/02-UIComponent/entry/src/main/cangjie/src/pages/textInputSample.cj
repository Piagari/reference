package ohos_app_cangjie_entry.pages

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.router.*
import ohos_app_cangjie_entry.components.*
import ohos_app_cangjie_entry.components.playground.font.*
import ohos_app_cangjie_entry.components.playground.textInput.*
import ohos_app_cangjie_entry.components.playground.utils.*
import ohos_app_cangjie_entry.utils.*

@Entry
@Component
class TextInputView {
  // 字体颜色
  @State var fontColor: UInt32 = COLOR_BLACK

  // 字体大小
  @State var fontSize: Int64 = 16

  // 文本对齐方式
  @State var textAlign: TextAlign = TextAlign.Start

  // 最大行数
  @State var maxLength: Int64 = 20

  // 输入模式
  @State var inputType: InputType = InputType.Normal

  // 边框圆角
  @State var borderRadius: Int64 = 0

  // 背景颜色
  @State var backgroundColor: UInt32 = COLOR_WHITE

  func build() {
    Scroll() {
      Column(SECTION_EXTERNAL_SPACE) {
        PageTitle(content: "TextInput")

        PageDescription(content: "TextInput组件用于获取用户输入")

        Column(SECTION_INTERNAL_SPACE) {
          SectionTitle(content: "Playground")

          Column() {
            TextInput(placeholder: "placeholder")
            .fontSize(fontSize)
            .fontColor(fontColor)
            .textAlign(textAlign)
            .maxLength(UInt32(maxLength))
            .setType(inputType)
            .backgroundColor(backgroundColor)
            .borderRadius(borderRadius)
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

              TextAlignBar(textAlign: textAlign)

              SliderBar(
                value: maxLength,
                sliderParams: SliderParams(15.0, 30.0, 1.0),
                title: "MaxLength"
              )

              InputTypeBar(inputType: inputType)


              SliderBar(
                value: borderRadius,
                sliderParams: SliderParams(0.0, 20.0, 1.0),
                title: "BorderRadius"
              )

              ColorBand(
                color: backgroundColor,
                title: "BackgroundColor"
              )
            }
          }.playgound()
          .height(500)
        }.section()
      }.pageContainer()
    }
  }
}