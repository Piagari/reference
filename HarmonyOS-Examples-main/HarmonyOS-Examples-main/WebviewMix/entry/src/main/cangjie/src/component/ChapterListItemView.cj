/**
 * Created on 2024/9/12
 */
package ohos_app_cangjie_entry.component
internal import ohos.base.*
import ohos.component.*
internal import ohos.state_manage.*
internal import ohos_app_cangjie_entry.api.*
internal import ohos_app_cangjie_entry.bean.*
import ohos.state_macro_manage.*
internal import ohos.webview.*
internal import ohos.router.*
internal import std.collection.*
import ohos.resource_manager.*
import cj_res_entry.app //用于导入@r
import ohos.hilog.*
import ohos_app_cangjie_entry.utils.*

/**课程ItemView */

@Component
public class ChapterListItemView {
    @Prop var articleItem: ArticleItem

    func build() {
        Row() {
            //1-左侧图片
            Image(articleItem.envelopePic)
            .width(120)
            .height(150)

            //2-右侧
            Column() {
                //1-name
                Text(articleItem.chapterName)
                .fontSize(18)
                .fontColor(0x9098DB)

                //2-author
                Text("${articleItem.author}")
                .fontSize(12)
                .fontColor(Color.BLACK)
                .margin(top: 10, right: 0, bottom: 0,left: 0)

                //3-desc
                Text(articleItem.title)
                .fontSize(12)
                .fontColor(Color.BLACK)
                .maxLines(2)
                .textOverflow(TextOverflow.Ellipsis)
                .margin(top: 10)
            }
            //.flexGrow(1)
            .width(65.percent)
            .alignItems(HorizontalAlign.Start)
            .margin(left: 10,right:10)
        }
        .padding(5)
        .width(100.percent)
        .borderWidth(0.5)
        .borderColor(Color.GRAY)
        .alignItems(VerticalAlign.Top)
        .backgroundColor(0xF5F5F5)
    }
}
