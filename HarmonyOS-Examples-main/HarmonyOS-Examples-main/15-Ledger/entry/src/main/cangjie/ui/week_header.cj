/**
 * Created on 2025/7/31
 */
package ohos_app_cangjie_entry.ui

import ohos_app_cangjie_entry.constant.*

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import std.collection.*


@Component
public class WeekHeader {

    public func build() {
        Row {
            ForEach(
                Constants.WEEKS,
                itemGeneratorFunc: {
                    wk: String, _: Int64 => Text(wk).textAlign(TextAlign.Center).width(14.3.percent).fontSize(18).fontWeight(W600)
                }
            )
        }
        .height(30)
        .width(100.percent)
        .margin(16)
    }
}
