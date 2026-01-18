package ohos_app_cangjie_entry.pages

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.router.*
import ohos_app_cangjie_entry.components.*
import ohos_app_cangjie_entry.components.playground.utils.*
import ohos_app_cangjie_entry.components.playground.swiper.*
import ohos_app_cangjie_entry.utils.*
import std.collection.ArrayList
import ohos.resource_manager.*
import cj_res_entry.app

@Entry
@Component
class SwiperView {
  // 自动播放
  @State var autoPlay: Bool = false

  // 自动播放时播放的时间间隔
  @State var interval: Int64 = 3000

  // 是否启用导航点指示器
  @State var indicator: Bool = true

  // 是否开启循环
  @State var loop: Bool = true

  // 子组件切换的动画时长
  @State var duration: Int64 = 400

  // 是否纵向滑动
  @State var vertical: Bool = false

  // 主轴方向上元素排列的模式
  @State var displayMode: SwiperDisplayMode = SwiperDisplayMode.Stretch

  // 是否禁用组件滑动切换功能
  @State var disableSwipe: Bool = false

  // 设置Swiper的动画曲线
  @State var curve: Curve = Curve.Linear

  // 边缘滑动效果
  @State var effectMode: EdgeEffect = EdgeEffect.Spring

  let dataList = ArrayList<CJResource>([
    @r(app.media.hc_2024_cn),
    @r(app.media.hw_cloud_flexus_pc),
    @r(app.media.white_headed_langur_cn)
  ])


  func build() {
    Scroll() {
      Column(SECTION_EXTERNAL_SPACE) {
        PageTitle(content: "Swiper")

        PageDescription(content: "Swiper用于呈现轮播效果")

        Column(SECTION_INTERNAL_SPACE) {
          SectionTitle(content: "Playground")

          Swiper(){
            ForEach(
              this.dataList,
              itemGeneratorFunc: {
                element: CJResource, index: Int64 =>
                  Image(element)
                  .width(100.percent)
                  .height(150)
                  .objectFit(ImageFit.Cover)
              }
            )
          }.autoPlay(autoPlay)
          .interval(UInt32(interval))
          .indicator(indicator)
          .loop(loop)
          .duration(UInt32(duration))
          .vertical(vertical)
          .displayMode(displayMode)
          .disableSwipe(disableSwipe)
          .curve(curve)
          .effectMode(effectMode)

          Scroll() {
            Column(BAR_OUTER_GRID_SIZE) {
              ToggleBar(
                value: autoPlay,
                title: "AutoPlay"
              )

              SliderBar(
                value: interval,
                sliderParams: SliderParams(0.0, 8000.0, 1000.0),
                title: "Interval"
              )

              ToggleBar(
                value: indicator,
                title: "Indicator"
              )

              ToggleBar(
                value: loop,
                title: "Loop"
              )

              SliderBar(
                value: duration,
                sliderParams: SliderParams(0.0, 1500.0, 100.0),
                title: "Duration"
              )

              ToggleBar(
                value: vertical,
                title: "Vertical"
              )

              DisplayModeBar(displayMode: displayMode)

              ToggleBar(
                value: disableSwipe,
                title: "DisableSwipe"
              )

              CurveBar(curve: curve)

              EffectModeBar(effectMode: effectMode)
            }
          }.playgound()
          .height(600)
        }.section()
      }.pageContainer()
    }
  }
}

