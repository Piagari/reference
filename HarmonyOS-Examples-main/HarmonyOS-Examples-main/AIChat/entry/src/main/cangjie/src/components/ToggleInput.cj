/**
 * Created on 2024/9/3
 */
package ohos_app_cangjie_entry.components

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.utils.*

const OUTER_HEIGHT = 30
const OUTER_WIDTH = 60
const OUTER_PADDING = 2
const INNER_WIDTH = (OUTER_WIDTH - OUTER_PADDING * 2) / 2
const INNER_HEIGHT = (OUTER_HEIGHT - OUTER_PADDING * 2)
const MOVE = INNER_WIDTH
const INITIAL_BACKGROUND_COLOR: UInt32 = 0xeeeeee
const ACTIVE_BACKGROUND_COLOR: UInt32 = 0x161315
const INNER_BLOCK_BACKGROUND_COLOR: UInt32 = 0xffffff


@Component
public class ToggleInput {
    // 标签名
    @Prop var label: CJResource
    // 开启与否
    @Link var value: Bool
    // 移动距离
    @State var offSetX: Int64 = 0

    @State var outerBackgroundColor: UInt32 = INITIAL_BACKGROUND_COLOR

    // 处理开关变化
    func onClick(e: ClickEvent) {
        this.value = !this.value
        if (this.value) {
            this.offSetX = MOVE
            this.outerBackgroundColor = ACTIVE_BACKGROUND_COLOR
        } else {
            this.offSetX = 0
            this.outerBackgroundColor = INITIAL_BACKGROUND_COLOR
        }
    }

    protected func aboutToAppear() {
        if(this.value) {
            this.offSetX = MOVE
            this.outerBackgroundColor = ACTIVE_BACKGROUND_COLOR
        }
    }

    func build() {
        Row() {
            Text(label).fontSize(20).fontWeight(FontWeight.W300)

            Row(10) {
                Text("Off")

                Row(){
                    Row() {}.animationStart(animation)
                    .width(INNER_WIDTH).height(INNER_HEIGHT)
                    .backgroundColor(INNER_BLOCK_BACKGROUND_COLOR)
                    .borderRadius(6.fp)
                    .offset(x: offSetX, y: 0)
                    .animationEnd()
                }.animationStart(animation)
                .width(OUTER_WIDTH)
                .height(OUTER_HEIGHT)
                .padding(OUTER_PADDING)
                .backgroundColor(outerBackgroundColor)
                .borderRadius(8.fp)
                .onClick(onClick)
                .animationEnd()

                Text("On")
            }.alignItems(VerticalAlign.Center)
        }.width(100.percent)
        .margin(bottom: 20)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
    }
}