/**
 * Created on 2024/9/9
 */
package ohos_app_cangjie_entry.pages
internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
internal import ohos_app_cangjie_entry.api.*
internal import ohos_app_cangjie_entry.bean.*
internal import ohos_app_cangjie_entry.component.*
internal import ohos_app_cangjie_entry.utils.*
import ohos.state_macro_manage.*
internal import ohos.webview.*
internal import ohos.router.*
internal import std.collection.*
import ohos.hilog.*
/**
* 根据传递url显示网页内容
*/

@Entry
@Component
public class WebPage{

    @State var isLoading:Bool = true
    //@State var title:String = ""
    //var url: String = "网页标题"
    let webController = WebviewController()
    @State var webBean:WebBean = WebBean()

    protected override func aboutToAppear() {
        //this.url= Router.getParams().getOrThrow();
        var jsonObj = Router.getParamsObject()
         //Hilog.debug(1, "jsonObj", "点击了${jsonObj.toString()}")
         webBean =  Utils.JsonObject2Bean<WebBean>(jsonObj)
         //Hilog.debug(1, "webBean", "点击了${webBean.toString()}")
    }
    func build(){
        Stack(){
            //1-Web
            Column(){
                TitleBar(title: this.webBean.title)
                Web(src: webBean.url, controller: webController)
                    .onPageBegin({evt =>
                        AppLog.info("page begin url: ${evt.url}")
                    })
                    .onPageEnd({evt =>
                        AppLog.info("page end url: ${evt.url}")
                        this.isLoading = false
                    })
                }.width(100.percent)
                .height(100.percent)
                //.backgroundColor(0xDCDCDC)

            //2-Loading
            if(this.isLoading){
                LoadingProgress()
                .color(Color.BLUE)
                .width(80.percent)
                .height(80.percent)
             }
        }
    }
}