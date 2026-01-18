/**
 * Created on 2025/1/7
 */
package ohos_app_cangjie_entry

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import std.collection.*
import ohos.router.*

@Entry
@Component
class NewsSearchView {
    @State var imageIp: String = "http://192.168.3.11:8000"
    // 传入参数：新闻关键字
    let newsKey : String = Router.getParams() ?? ""

    // 新闻信息
    @State var newsSearchLists : ObservedArrayList<News> = ObservedArrayList<News>()

    // 显示界面时更新新闻
    protected override func onPageShow() {
        NewsManager.getInstance().queryNews(newsKey) { res =>
            if (res) {
                newsSearchLists = ObservedArrayList<News>(NewsManager.getInstance().newsSearchLists)
            }
        }
    }

    func build() {
        Column() {
            Text("新闻搜索")
                .textAlign(TextAlign.Center)
                .fontSize(16)
                .fontColor(0xffffff)
                .backgroundColor(0xffbb86fc)
                .borderRadius(2)
                .margin(top:2,bottom:2)
                .width(98.percent)
                .height(40)

            List(space: 5, initialIndex: 0 ) {
                ForEach(this.newsSearchLists, itemGeneratorFunc:{item: News,index: Int64  =>
                    ListItem() {
                                    Row(2){
                                         Image(imageIp + "${item.propCover}")
                                            .objectFit(ImageFit.Fill)
                                            .width(35.percent)
                                            .height(90)
                                            .borderStyle(BorderStyle.Solid)
                                            .borderRadius(10)
                                         Column(2){
                                                Text(item.propTitle)
                                                    .width(100.percent)
                                                    .height(25)
                                                    .fontSize(14)
                                                    .maxLines(1)
                                                    .textOverflow(TextOverflow.Ellipsis)
                                                    .textAlign(TextAlign.Start)
                                                Text(item.propContent )
                                                    .width(100.percent)
                                                    .height(40)
                                                    .fontSize(12)
                                                    .fontColor(0x555555)
                                                    .maxLines(2)
                                                    .textOverflow(TextOverflow.Ellipsis)
                                                    .textAlign(TextAlign.Start)
                                                Row(2){
                                                    Text("${item.propPublishDate}" )
                                                        .width(60.percent)
                                                        .height(25)
                                                        .fontSize(10)
                                                        .fontColor(0xdddddd)
                                                        .textAlign(TextAlign.Start)
                                                    Text("🩷：${item.propLikeNum}" )
                                                        .width(30.percent)
                                                        .height(25)
                                                        .fontSize(10)
                                                        .fontColor(0xdddddd)
                                                        .textAlign(TextAlign.End)
                                                }
                                         }.width(64.percent).height(100)
                                    }.backgroundColor(0xffffff)
                                }
                        .onClick({  evt =>
                             Router.push(url: "NewsDetailView", params: "${newsSearchLists[index].propId}")
                         })
                })
           }.width(98.percent)
            .scrollBar(BarState.Off)

        }.width(100.percent)
        .height(96.percent)
        .margin(top: 2)
    }
}