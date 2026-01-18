/**
 * Created on 2024/9/10
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

@Component
public class ArticleItemView {

    @Prop var articleItem:ArticleItem
    @State var hasTag:Bool = false
    @State var tag:String = ""
    @State var author:String = ""
//    @State var title:String = ""
//    @State var desc:String = ""
    @State var hasSuperChapterName: Bool = false;
    @State var superChapterName: String = '';
    @State var hasChapterName: Bool = false;
    @State var chapterName: String = '';

    protected override func aboutToAppear() {
        //Hilog.debug(1, "test", "ArticleItemView=${articleItem.author}")
        let item = this.articleItem
        this.hasTag = Utils.isEmpty<Array<TagItem>>(item.tags.getOrThrow())
        //var aa = item.tags.getOrThrow()[0].name
        this.author = Utils.getArticleUser(articleItem)
        this.hasSuperChapterName = !Utils.isEmpty<String>(item.superChapterName)
        this.superChapterName = Utils.getNamebyString(item.superChapterName,"")
        this.hasChapterName = !Utils.isEmpty<String>(item.chapterName)
        this.chapterName = Utils.getNamebyString(item.chapterName,"")

    }

    func build() {
        Column() {
        //第一行
            Row() {
                    //Text(this.articleItem.tags.getOrThrow()[0].name)
                Text(Utils.getNamebyString(this.tag, "鸿蒙"))
                    .width(40)
                    .height(20)
                    .fontSize(12)
                    .textAlign(TextAlign.Center)
                    .fontColor(Color.RED)
                    .borderRadius(3)
                    .borderWidth(1)
                    .borderColor(Color.RED)
                    .fontColor(Color.RED)
                    //.backgroundColor(Color.RED)
                    .padding(left: 5, right: 5, top: 2, bottom: 2)

                 Row() {
                     Image(@r(app.media.ic_me))
                     .width(18)
                     .height(18)

                     Text(this.author)
                     .fontSize(12)
                     .margin(left: 5) //2-author
                     .fontColor(Color.BLACK)

                    }.margin(left: 5, right: 5)

                Row() {
                    Image(@r(app.media.ic_clock))
                    .width(18)
                    .height(18)

                    Text(this.articleItem.niceDate) //3-time
                    .fontSize(12)
                    .margin(left: 5) //2-author
                    .fontColor(Color.BLACK)
                }
            }.width(100.percent).justifyContent(FlexAlign.SpaceBetween)
            //第2行
            Flex(FlexParams(direction: FlexDirection.Row)) {
                Column() {
                    Text(Utils.formatHtml(this.articleItem.title))
                    //.width(Constants.FULL_PERCENT)
                    .maxLines(2)
                    .fontSize(20)
                    .textOverflow(TextOverflow.Ellipsis)
                    .fontColor(Color.BLACK)
                    .align(Alignment.TopStart)

                Text(this.articleItem.desc)
                    //.width(Constants.FULL_PERCENT)
                    .maxLines(2)
                    .textOverflow(TextOverflow.Ellipsis)
                    .fontColor(Color.GRAY)
                    .align(Alignment.TopStart)
                }.flexGrow(1).alignItems(HorizontalAlign.Start)
            }
            //.height(80)
            .margin(top: 10)
            //第三行
             //第3行
            Row() {
                if (this.hasSuperChapterName) {
                    Text("${this.chapterName}/${this.superChapterName}")
                    .fontSize(15)
                    .margin(left: 5) //2-author
                    .fontColor(0x858585)
                }

                Text("")
                .flexGrow(1)

                Image(@r(app.media.ic_heart))
                    .width(18)
                    .height(18)
            }
            .width(100.percent)
            .justifyContent(FlexAlign.Start)
            .margin(top: 5 )
        }
        .width(100.percent)
        .height(140)
        .padding(top: 5, right: 10, bottom: 5, left: 10)
        .borderWidth(1)
        .borderColor(Color.GRAY)
        .justifyContent(FlexAlign.SpaceEvenly)
        .backgroundColor(0xF5F5F5)
    }

}