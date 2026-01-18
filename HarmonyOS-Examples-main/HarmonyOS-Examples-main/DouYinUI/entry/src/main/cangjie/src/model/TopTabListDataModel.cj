/**
 * Created on 2024/8/22
 */
package ohos_app_cangjie_entry.model
internal import ohos.base.*

//顶部Top栏列表类
public class TopTabListData {
    var label: String
    var selColor: CJResource
    var norColor: CJResource

    public TopTabListData(label: String, selColor: CJResource, norColor: CJResource) {
        this.label = label
        this.selColor = selColor
        this.norColor = norColor
    }

    public func getLabel() {
        return this.label
    }

    public func getSelColor() {
        return this.selColor
    }

    public func getNorColor() {
        return this.norColor
    }
}
