/**
 * Created on 2024/8/27
 */
package ohos_app_cangjie_entry.component.my

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*
import cj_res_entry.app

@Component
public class My {
    func build() {
        Stack() {
            MyBody()
            MyTop()
        }
        .width(100.percent)
        .height(100.percent)
        .alignment(Alignment.Top)
    }
}
