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
import ohos_app_cangjie_entry.components.playground.checkbox.*
import ohos_app_cangjie_entry.components.playground.utils.*

@Entry
@Component
class CheckboxView {
  // 选中状态
  @State var selected: Bool = false

  // 选中的颜色
  @State var selectedColor: UInt32 = COLOR_BLUE

  // 复选框的形状
  @State var shape: CheckBoxShape = CheckBoxShape.CIRCLE

  func build() {
    Scroll() {
      Column(SECTION_EXTERNAL_SPACE) {
        PageTitle(content: "Checkbox")

        PageDescription(content: "CheckBox呈现多选框")

        Column(SECTION_INTERNAL_SPACE) {
          SectionTitle(content: "Playground")

          Column() {
            Row() {
              Checkbox().select(selected)
                .selectedColor(selectedColor)
                .shape(shape)
                .onChange({
                  e: Bool => this.selected = e
                })

              Text("${selected}")
            }.alignItems(VerticalAlign.Center)
          }.codeCard().playgroundCard()


           Column(BAR_OUTER_GRID_SIZE) {
            ColorBand(
              color: selectedColor,
              title: 'SelectedColor'
            )

            CheckboxShapeBar(checkboxShape: shape)
           }.padding(bottom: 50)
        }.section()
      }.pageContainer()
    }
  }
}