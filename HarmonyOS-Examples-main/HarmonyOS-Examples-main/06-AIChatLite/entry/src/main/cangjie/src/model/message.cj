/**
 * Created on 2024/10/24
 */
package ohos_app_cangjie_entry.model

import ohos.base.*
import ohos.state_macro_manage.r
import cj_res_entry.app

public enum Who {
    You | Me
    public prop icon: CJResource {
        get() {
            match(this) {
                case Me => @r(app.media.me)
                case You => @r(app.media.you)
            }
        }
    }
}

public class Message {
    public Message(
        public let content: String,
        public let who: Who,
        public let time: String
    ) {}
}