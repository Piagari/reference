/**
 * Created on 2024/10/24
 */
package ohos_app_cangjie_entry.components

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import encoding.url.URL
import ohos_app_cangjie_entry.utils.*
import std.time.DateTime
import cj_res_entry.app

const SIZE = 38
const MARGIN = SIZE * 2 + 20

@Component
public class ReceiveContent {
    @Prop var message: String

    @Builder
    public func avatar() {
        Image(@r(app.media.robot)).width(SIZE).height(SIZE).borderRadius(SIZE / 2).backgroundColor(0xf0f0f0)
    }

    @Builder
    func time() {
        Row() {
            Text(DateTime.now().toString('yyyy-MM-dd HH:mm:ss')).fontSize(12)
        }
        .width(100.percent)
        .justifyContent(FlexAlign.Start)
        .margin(left: MARGIN)
    }

    @Builder
    func content() {
        Row() {
            Text(message)
        }
        .constraintSize(maxWidth: 85.percent)
        .padding(10)
        .backgroundColor(0xffffff)
        .borderRadius(10)
        .width(85.percent)
    }

    func build() {
        Column(3) {
            if (!message.isEmpty()) {
                time()
                Row() {
                    avatar()
                    content()
                }
                .justifyContent(FlexAlign.Start)
                .alignItems(VerticalAlign.Top)
                .width(100.percent)
            }
        }
        .width(100.percent)
        .padding(right: 60, left: 10)
    }
}