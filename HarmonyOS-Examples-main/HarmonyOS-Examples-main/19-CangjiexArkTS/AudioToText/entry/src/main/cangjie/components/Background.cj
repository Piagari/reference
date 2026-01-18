/**
 * Created on 2025/5/30
 */
package ohos_app_cangjie_entry.components

import ohos.base.*
import ohos.component.*
import ohos.state_macro_manage.*
internal import ohos.state_manage.ObservedProperty
internal import ohos.state_manage.LocalStorage
internal import ohos.state_manage.SubscriberManager
internal import ohos.state_manage.ViewStackProcessor

@Component
public class Background {
    func build() {
        Column {
            Text("语音识别转文字")
            .fontSize(24)
            .margin(top: 100)

            Text("· 点击【开始录音】开始说话")
            .fontSize(16)
            .margin(top: 10)
        }.width(100.percent)
        .padding(top: 5, bottom: 100)
    }
}