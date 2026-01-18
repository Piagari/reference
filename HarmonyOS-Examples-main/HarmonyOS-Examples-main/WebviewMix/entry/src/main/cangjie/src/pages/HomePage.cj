/**
 * Created on 2024/9/8
 */
package ohos_app_cangjie_entry.pages

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos_app_cangjie_entry.api.*
import ohos_app_cangjie_entry.bean.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.utils.*
import std.collection.*
import ohos.hilog.*
import std.collection.*
import encoding.json.*
import std.time.*
import std.sync.*
import serialization.serialization.*

/**
* Home首页
*/
@Component
public class HomePage {

    @State var isRefreshing: Bool = false //控制刷新
    @State var isLoading:Bool = true //控制加载loading
    var bannerCtr: SwiperController = SwiperController()
    @State var datas:ArrayList<ArticleItem> = ArrayList<ArticleItem>()

     protected override func aboutToAppear() {
        var searchResult =  HttpRequest.homeListReq(0)
        if(searchResult.errorCode == 0){
            this.datas = searchResult.data.getOrThrow().datas.getOrThrow()
             //Hilog.debug(1, "test", searchBean.data.getOrThrow().size.toString())
        }
        this.isLoading = false
    }
    protected override func onPageShow() {

    }

    @Builder
    func bannerUI(){
        Swiper(bannerCtr) {
            ForEach(MockService.bannerList, itemGeneratorFunc: { banner:Banner,index:Int64=>
                        Image(banner.imagePath).height(26.percent).width(100.percent).onClick{ evt=>
                            Hilog.debug(1, "click", "点击了${banner.url}")
                            //var str:String = "{\"title\": \"${banner.title}\",\"url\":\"${banner.url}\"}"
                             //Hilog.debug(1, "url", "点击了${str1}")
                             Router.push(url: "WebPage",params:Utils.String2JsonObject(Utils.getWebURL(banner.title, banner.url)))
                        }
                    })
            }.autoPlay(true).vertical(false).width(100.percent).curve(Curve.LinearOutSlowIn)
        .onChange({ index =>})

    }
    //下拉刷新数据
    func freshData(){
        if(isRefreshing == true){
            Timer.once(Duration.second*1){ =>  //倒计时1S后，切换刷新状态
                    aboutToAppear() //调用api
                    isRefreshing = false
                  }
        }
    }

    @Builder
    func loadingUI() {
        Column() {
            LoadingProgress()
            .color(Color.BLUE)
            .width(60.percent)
            .height(60.percent)
        }
        .width(100.percent)
        .height(100.percent)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
    }

    func build() {
       Refresh(RefreshParams(refreshing: @Binder(this.isRefreshing))) {
         Stack(Alignment.TopStart) {
            Column() {
                List(space: 0, initialIndex: 0) {
                    //第一个Item-Banner
                    ListItem() {
                        bannerUI()
                    }
                    //第二个Item-ListArticle
                    if (this.datas.size > 0) {
                        ForEach(this.datas,itemGeneratorFunc: { articleItem: ArticleItem, index: Int64 =>
                                        ListItem() { ArticleItemView(articleItem: articleItem) }.onClick { evt =>
                                            Router.push(url: "WebPage",
                                            params: Utils.String2JsonObject(
                                            Utils.getWebURL(articleItem.title, articleItem.link)))
                                        }
                                    })
                    }
                }.listDirection(Axis.Vertical) // 排列方向
                    .scrollBar(BarState.Off)
                    .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
                    .width(100.percent)
                }
                .width(100.percent)
                .height(100.percent)
                .backgroundColor(0xF5F5F5)
                .padding(top: 5.px)

            //2-Loading
            if (this.isLoading) {
                    loadingUI()
                }
            }
        }
        .onStateChange{refreshStatus: RefreshStatus =>

        }
        .onRefreshing{ =>
            freshData()
        }
    }
}