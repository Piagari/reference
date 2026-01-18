/**
 * Created on 2025/7/29
 */
package ohos_app_cangjie_entry.components.entity

import cj_res_entry.app
import ohos_app_cangjie_entry.interop.*
import ohos_app_cangjie_entry.utils.*
import ohos.state_macro_manage.*
import ohos.base.*

public class DynamicStyle {

    public DynamicStyle(var valid: Bool) {}

    public func textColor() {
        if (valid) {
            Color(0x777777)
        } else {
            showToast("文件处理失败 ！")
            Color.RED
        }
    }

    public func closeBorderColor() {
        if (valid) {
            getResourceColor(@r(app.color.input_box_border))
        } else {
            Color.RED
        }
    }

    public func closeButtonStyle() {
        if (valid) {
            @r(app.media.close)
        } else {
            @r(app.media.close_white)
        }
    }

    public func closeBackgroundColor() {
        if (valid) {
            getResourceColor(@r(app.color.item_background))
        } else {
            Color.RED
        }
    }
}