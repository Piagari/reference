package ohos_app_cangjie_entry.pages

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.router.*
import ohos_app_cangjie_entry.components.*
import ohos_app_cangjie_entry.components.playground.utils.*
import ohos_app_cangjie_entry.components.playground.tab.*
import ohos_app_cangjie_entry.utils.*
import std.collection.ArrayList
import ohos.resource_manager.*
import cj_res_entry.app

@Entry
@Component
class TabsView {
  // TabBar的位置
  @State var barPosition: BarPosition = BarPosition.Start

  // 是否垂直
  @State var vertical: Bool = false

  // 是否可以滑动
  @State var scrollable: Bool = true

  // TabBar的模式
  @State var barMode: BarMode = BarMode.Fixed

  // 宽度
  @State var barWidth: Int64 = 300

  // 高度
  @State var barHeight: Int64 = 50

  // 动画持续时间
  @State var animationDuration: Int64 = 400

  let dataList = ArrayList<(String, String)>([
    ("原生智能化",
      "内嵌AgentDSL的编程框架，自然语言&编程语言有机融合；多Agent协同，简化符号表达，模式自由组合，支持各类智能应用开发。"),
    ("天生全场景",
      "轻量化可缩放运行时，模块化分层设计，内存再小也能装得下；全场景领域扩展，元编程和eDSL技术，支持面向领域声明式开发。"),
    ("高性能",
      "终端场景首款全并发 GC ，应用线程更流畅，响应更快。轻量化线程，并发性能更好，开销更少。")
  ])

  func build() {
    Scroll() {
      Column(SECTION_EXTERNAL_SPACE) {
        PageTitle(content: "Tab")

        PageDescription(content: "Tab组件用于呈现多页切换的效果")

        Column(SECTION_INTERNAL_SPACE) {
          SectionTitle(content: "Playground")

          Tabs(barPosition) {
            ForEach(
              this.dataList,
              itemGeneratorFunc: {
                element: (String, String), index: Int64 =>
                  TabContent() {
                    Row() {
                      Text(element[1])
                    }.height(100)
                  }.tabBar(element[0])
              }
            )
          }.scrollable(scrollable)  // 设置可以通过左右滑动来切换
          .vertical(vertical)
          .barWidth(barWidth)
          .barHeight(barHeight)
          .width(100.percent)
          .padding(10)
          .barMode(barMode)  // 设置布局模式为可滑动
          .animationDuration(Int32(animationDuration))  // 滑动动画时长

          Scroll() {
            Column(BAR_OUTER_GRID_SIZE) {
              BarPositionBar(barPosition: barPosition)

              ToggleBar(
                value: vertical,
                title: "Vertical"
              )

              ToggleBar(
                value: scrollable,
                title: "Scrollable"
              )

              BarModeBar(barMode: barMode)

              SliderBar(
                value: barWidth,
                sliderParams: SliderParams(50.0, 400.0, 10.0),
                title: "BarWidth"
              )

              SliderBar(
                value: barHeight,
                sliderParams: SliderParams(50.0, 400.0, 10.0),
                title: "BarHeight"
              )

              SliderBar(
                value: animationDuration,
                sliderParams: SliderParams(0.0, 1500.0, 100.0),
                title: "AnimationDuration"
              )
            }
          }.playgound()
          .height(600)
        }.section()
      }.pageContainer()
    }
  }
}