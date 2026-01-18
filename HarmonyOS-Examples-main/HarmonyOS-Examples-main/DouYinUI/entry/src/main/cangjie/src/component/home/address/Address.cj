/**
 * Created on 2024/8/29
 */
package ohos_app_cangjie_entry.component.home.address


internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*

@Component
public class Address{
    func build() {
        Column(){
            Text("地址页")
            .fontSize(50.vp)
        }
        .width(100.percent)
        .height(100.percent)
    }
}