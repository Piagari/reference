/**
 * Created on 2024/11/15
 */
package ohos_app_cangjie_entry.components

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*
import cj_res_entry.*

@Builder
public func Title (title: String) {
    Text(title)
    .padding(top: 20, left: 16, bottom: 16)
    .fontSize(14)
    .fontColor(@r(app.color.silkdoctextcolor4))
    .width(100.percent)
}