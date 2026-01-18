/**
 * Created on 2024/8/29
 */
package ohos_app_cangjie_entry.component.home.exp

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*

@Component
public class Exp{
    func build() {
        Column(){
            Text("经验页")
            .fontSize(50.vp)
        }
        .width(100.percent)
        .height(100.percent)
    }
}