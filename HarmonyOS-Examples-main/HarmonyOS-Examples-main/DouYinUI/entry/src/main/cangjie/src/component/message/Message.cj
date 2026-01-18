/**
 * Created on 2024/8/27
 */
package ohos_app_cangjie_entry.component.message

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*

@Component
public class Message{
    func build() {
        Column(){
            MessageTop()
            MessageBody()
        }
        .width(100.percent)
        .height(100.percent)
    }
}