/**
 * Created on 2024/8/5
 */
package ohos_app_cangjie_entry.pages

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.router.*
import ohos_app_cangjie_entry.components.*
import ohos_app_cangjie_entry.components.playground.utils.*
import ohos_app_cangjie_entry.components.playground.image.*
import ohos_app_cangjie_entry.utils.*
import ohos.resource_manager.*
import cj_res_entry.app

@Entry
@Component
class ImageView {
  // 图片填充方式
  @State var objectFit: ImageFit = ImageFit.Cover

  // 图片的渲染方式
  @State var renderMode: ImageRenderMode = ImageRenderMode.Original

  // 容器的宽度
  @State var width: Int64 = 380

  // 容器的高度
  @State var height: Int64 = 130

  // 图片的重复方式
  @State var objectRepeat: ImageRepeat = ImageRepeat.NoRepeat

  func build() {
    Scroll() {
      Column(SECTION_EXTERNAL_SPACE) {
        PageTitle(content: "Image")

        PageDescription(content: "Image组件主要用于呈现图片")

        Column(SECTION_INTERNAL_SPACE) {
          SectionTitle(content: "Playground")

          Image(@r(app.media.hc_2024_cn))
          .objectFit(objectFit)
          .renderMode(renderMode)
          .objectRepeat(objectRepeat).width(width).height(height)

          Column(BAR_OUTER_GRID_SIZE) {
            SliderBar(
              value: width,
              sliderParams: SliderParams(100.0, 400.0, 10.0),
              title: "Width"
            )

            SliderBar(
              value: height,
              sliderParams: SliderParams(50.0, 400.0, 10.0),
              title: "Height"
            )

            ObjectFitBar(objectFit: objectFit)

            ObjectRepeatBar(objectRepeat: objectRepeat)

            RenderModeBar(renderMode: renderMode)
          }.padding(bottom: 50)
        }.section()
      }.pageContainer()
    }
  }
}
