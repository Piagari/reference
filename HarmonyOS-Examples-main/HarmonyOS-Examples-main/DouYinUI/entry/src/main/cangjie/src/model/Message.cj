/**
 * Created on 2024/8/30
 */
package ohos_app_cangjie_entry.model

import ohos.base.CJResource
import ohos.state_macro_manage.*
import cj_res_entry.app
import std.collection.ArrayList

//message类
public open class Message {
    public Message(let message: String) {}

    public open func getMessage(): String {
        return this.message
    }
}
