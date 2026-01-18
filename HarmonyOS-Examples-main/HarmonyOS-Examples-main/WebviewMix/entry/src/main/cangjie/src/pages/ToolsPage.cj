/**
 * Created on 2024/9/8
 */
package ohos_app_cangjie_entry.pages

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos_app_cangjie_entry.api.*
import ohos_app_cangjie_entry.bean.*
import ohos_app_cangjie_entry.utils.*
import ohos.state_macro_manage.*
import std.collection.*
import ohos.hilog.*
import std.collection.*
import encoding.json.*
import serialization.serialization.*

/**
* Tools工具
*/
@Component
public class ToolsPage {
    @State var datas: ArrayList<ToolItem> = ArrayList<ToolItem>()

    protected override func aboutToAppear() {
        var toolsResult = HttpRequest.getToolReq()
        if(toolsResult.errorCode == 0){
             this.datas = toolsResult.data.getOrThrow()
            //Hilog.debug(1, "test", "tools=${datas.size.toString()}")
        }
    }

    func build() {
        Column() {
            Grid() {
                if (this.datas.size > 0) {
                    ForEach(this.datas,itemGeneratorFunc: { toolItem: ToolItem, idx: Int64 =>
                                GridItem {ToolItemView(toolItem: toolItem)}.onClick{ evt =>
                                    Router.push(url: "WebPage",params:Utils.String2JsonObject(Utils.getWebURL(toolItem.name, toolItem.link)))
                                }
                        }
                    )
                }
            }.columnsTemplate("1fr 1fr")
        }
        .width(100.percent)
        .height(100.percent)
        .backgroundColor(0xF5F5F5)
        .padding(top: 5.px)
    }
}
