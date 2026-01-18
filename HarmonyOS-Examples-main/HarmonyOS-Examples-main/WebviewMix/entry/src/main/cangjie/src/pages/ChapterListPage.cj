/**
 * Created on 2024/9/12
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
* 课程详情列表
*/
@Entry
@Component
public class ChapterListPage {

 @State var datas: ArrayList<ArticleItem> = ArrayList<ArticleItem>()
    @State var dataItem:DataItem = DataItem()

    protected override func aboutToAppear() {
         var jsonObj = Router.getParamsObject()
         //Hilog.debug(1, "test", "点击了${jsonObj.toString()}")
         dataItem =  Utils.JsonObject2Bean<DataItem>(jsonObj)
         var toolsResult = HttpRequest.getSupterChapterReq(0, dataItem.id)
         this.datas = toolsResult.data.getOrThrow().datas.getOrThrow()
         for(i in 0..datas.size){
            datas[i].envelopePic = dataItem.cover //添加封面图
         }
    }

    func build() {
        Column() {
            List( space: 0, initialIndex: 0 ) {
                ListItem(){
                    TitleBar(title: this.dataItem.desc)
                }
             if(this.datas.size>0){
                        ForEach(this.datas, itemGeneratorFunc: { articleItem:ArticleItem,index:Int64 =>
                                ListItem(){
                                    ChapterListItemView(articleItem:articleItem)
                                    //ArticleItemView(articleItem:articleItem)
                                }.onClick{ evt =>
                                    Router.push(url: "WebPage",params:Utils.String2JsonObject(Utils.getWebURL(articleItem.title, articleItem.link)))
                                }
                            })
                    }
            }
            .listDirection(Axis.Vertical) // 排列方向
            .scrollBar(BarState.Off)
            .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
            .width(100.percent)
        }
        .width(100.percent)
        .height(100.percent)
        .backgroundColor(0xFFFFFF)
        .padding(top: 5.px)
    }
}