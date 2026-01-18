/**
 * Created on 2024/9/3
 */
package ohos_app_cangjie_entry.components

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import std.format.*

@Component
public class IntSliderInput {
    // 标签名
    @Prop var label: CJResource
    // 当前的值
    @Link var value: Int64
    // 最小值
    @Prop var min: Int64
    // 最大值
    @Prop var max: Int64
    // 步长
    @Prop var step: Int64
    // 是否显示步长
    @Prop var showSteps: Bool

    // 滑动变化后
    func onChange(value: Float64, mode: SliderChangeMode) {
        this.value = Int64(value)
    }

    func build() {
        Column(10) {
            Row() {
                Text(label).fontSize(20).fontWeight(FontWeight.W300)

                Text("${value}")
            }.width(100.percent)
            .justifyContent(FlexAlign.SpaceBetween)

            Slider(
                value: Float64(value),
                min: Float64(min),
                max: Float64(max),
                step: Float64(step),
                style: SliderStyle.OutSet
            ).blockColor(0x161315)
            .trackColor(0x9b80a6)
            .selectedColor(0x161315)
            .showSteps(showSteps)
            .showTips(false)
            .width(100.percent)
            .onChange(onChange)
        }.width(100.percent)
        .margin(bottom: 20)
    }
}

@Component
public class FloatSliderInput {
    // 标签名
    @Prop var label: CJResource
    // 当前的值
    @Link var value: Float64
    // 最小值
    @Prop var min: Float64
    // 最大值
    @Prop var max: Float64
    // 步长
    @Prop var step: Float64
    // 是否显示步长
    @Prop var showSteps: Bool

    // 滑动变化后
    func onChange(value: Float64, mode: SliderChangeMode) {
        this.value = value
    }

    func build() {
        Column(10) {
            Row() {
                Text(label).fontSize(20).fontWeight(FontWeight.W300)

                Text("${value.format(".2")}")
            }.width(100.percent)
            .justifyContent(FlexAlign.SpaceBetween)

            Slider(
                value: value,
                min: min,
                max: max,
                step: step,
                style: SliderStyle.OutSet
            ).blockColor(0x161315)
            .trackColor(0x9b80a6)
            .selectedColor(0x161315)
            .showSteps(showSteps)
            .showTips(false)
            .width(100.percent)
            .onChange(onChange)
        }.width(100.percent)
        .margin(bottom: 20)
    }
}