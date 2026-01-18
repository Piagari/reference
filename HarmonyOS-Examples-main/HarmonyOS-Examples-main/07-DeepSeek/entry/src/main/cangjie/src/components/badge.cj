/**
 * Created on 2025/1/29
 */
package ohos_app_cangjie_entry.components

import ohos.base.*
import ohos.component.*
import ohos.state_macro_manage.*
import ohos.state_manage.*
import ohos.router.Router
import cj_res_entry.*

@Builder
public func ChatAvatar(src!: CJResource, size!: Int64 = 50) {
    Image(src).width(size).height(size).borderRadius(size / 2)
}

@Builder
public func Slogan() {
    Column {
        Image(@r(app.media.logo))
            .width(80).height(60).margin(top: 20).borderRadius(20)
        Text("嗨！我是 DeepSeek")
            .fontSize(20)
            .fontWeight(Bold)
            .margin(top: 20)

        Text("我可以帮你搜索、答疑、写作，请把你的任务交给我吧~")
            .margin(top: 15).fontColor(0x999999).width(300).textAlign(TextAlign.Center)
    }.width(100.percent).height(60.percent).justifyContent(FlexAlign.Center)
}

@Component
public class Switch {
    var caption: String = ''
    var onImage: CJResource
    var offImage: CJResource
    var onChange: (Bool) -> Unit = { _ => }
    @State
    var state: Bool = false

    func build() {
        Text {
            ImageSpan(if (state) { onImage } else { offImage })
                .width(18)
                .height(18)
                .objectFit(ImageFit.Contain)
                .verticalAlign(ImageSpanAlignment.CENTER)
                .margin(right:5)
            Span(caption)
                .fontColor(if (state) { Color(0x3f82ee) } else { Color(0x717171) })
                .backgroundColor(if (state) { Color(0xe7f0fe) } else { Color(0xf5f5f5) })
                .layoutWeight(1)
                .borderRadius(50)
                .fontSize(14)
        }.backgroundColor(if (state) { Color(0xe7f0fe) } else { Color(0xf5f5f5) })
        .borderRadius(50)
        .padding(top: 7, bottom: 7, left: 10, right: 10)
        .onClick { _ =>
            state = !state
            onChange(state)
        }
    }
}

@Builder
public func Selector(image: CJResource, caption: String, onClick!: () -> Unit = {=>}) {
    Column {
        Column {
           Image(image).width(25).height(25)
        }
        .width(110)
        .height(75)
        .backgroundColor(0xf5f5f5)
        .borderRadius(20)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .onClick { _ => onClick() }

        Text(caption)
        .fontColor(0x717171)
        .fontSize(14)
        .margin(top: 5)
    }
}

@Builder
public func UserAvatarLine(src!: CJResource, text!: String) {
    Row {
        ChatAvatar(src: src, size: 40)
        Text(text)
        .height(50)
        .fontColor(0x000000)
        .backgroundColor(0xffffff)
        .layoutWeight(1)
        .margin(left: 10)
    }
    .backgroundColor(0xffffff)
    .padding(top: 10, bottom: 10, left: 15)
    .borderStyle(BorderStyle.Solid)
    .borderWidth(EdgeWidths(top: 1.vp, bottom: 1.vp))
    .borderColor(0xf2f2f2)
    .onClick { _ =>
        Router.push(url: "userView")
    }
}
