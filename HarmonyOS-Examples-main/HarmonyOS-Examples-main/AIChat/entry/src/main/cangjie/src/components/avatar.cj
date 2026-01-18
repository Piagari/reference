/**
 * Created on 2024/8/26
 */
package ohos_app_cangjie_entry.components

import ohos.base.CJResource
import ohos.component.CustomView
import ohos.component.Image
import ohos.component.ViewBuilder
import ohos.state_macro_manage.Builder
import ohos.state_manage.LocalStorage
import ohos.state_manage.ObservedProperty
import ohos.state_manage.SubscriberManager
import ohos.state_manage.ViewStackProcessor

@Builder
public func Avatar(src!: CJResource, size!: Int64 = 50) {
    Image(src).width(size).height(size).borderRadius(5)
}