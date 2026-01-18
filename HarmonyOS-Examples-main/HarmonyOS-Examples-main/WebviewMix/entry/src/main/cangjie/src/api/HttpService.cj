/**
 * Created on 2024/9/9
 */
package ohos_app_cangjie_entry.api
import ohos.net.http.*
import ohos.base.*
import std.collection.*
import ohos_app_cangjie_entry.bean.*
import ohos_app_cangjie_entry.utils.*
import ohos.hilog.*
import std.time.*
import std.sync.*
import ohos.state_manage.*
import serialization.serialization.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import std.math.*
import encoding.json.*
import std.collection.*


public class HttpService<T> where T <: Serializable<T> {

    let p0 = PersistentStorage.persistProp("Cookie", "")
    @StorageLink["Cookie"] var cookie: String = ""

    var responseResult = ResponseResult<T>()
    //单例
    private HttpService() {}
    private static var instance: HttpService<T> = HttpService<T>()
    public static func getInstance(): HttpService<T> {
        return instance
    }
   func getHeaderMethod():HashMap<String, String>{
        if(Utils.isEmpty<String>(this.cookie)){
            Hilog.info(1, "test", "header===: Empty-cookieValue=${cookie}")
            return HashMap<String, String>([("content-type", "application/json")])
        } else {
            //var cookie:String = AppStorage.get<String>("Cookie").getOrThrow()
            Hilog.info(1, "test", "header===: Value-cookieValue=${cookie}")
            return  HashMap<String, String>([("content-type", "application/json"),("Cookie",cookie)])
        }
   }
    //get请求
    func httpRequestGet(url: String): ResponseResult<T> {

        let option = HttpRequestOptions(
            method: RequestMethod.GET, // 可选，默认为http.RequestMethod.GET
            expectDataType: HttpDataType.STRING, // 可选，指定返回数据的类型
            usingCache: true, // 可选，默认为true
            priority: 1, // 可选，默认为1
            // 开发者根据自身业务需要添加header字段
            header:getHeaderMethod(),
            //header: HashMap<String, String>([("content-type", "application/json"),("Cookie",cookie)]),
            //header: HashMap<String, String>([("content-type", "application/json")]),
            readTimeout: 60000, // 可选，默认为60000ms
            connectTimeout: 60000, // 可选，默认为60000ms
            usingProtocol: HttpProtocol.HTTP1_1, // 可选，协议类型默认值由系统自动指定
            usingProxy: UsingProxy.NOT_USE, //可选，默认不使用网络代理，自API 10开始支持该属性
        )
        return httpRequest(url, option)
    }
    //post请求
    public func httpRequestPost(url: String, params: String): ResponseResult<T> {
        let option = HttpRequestOptions(
            method: RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
            usingCache: true, // 可选，默认为true
            extraData: HttpData.STRING_DATA(params),
            expectDataType: HttpDataType.STRING, // 可选，指定返回数据的类型
            // 开发者根据自身业务需要添加header字段
            //header: HashMap<String, String>([("content-type", "application/json")]),
            readTimeout: 60000, // 可选，默认为60000ms
            connectTimeout: 60000, // 可选，默认为60000ms
            usingProxy: UsingProxy.NOT_USE, //可选，默认不使用网络代理，自API 10开始支持该属性
        )
        return httpRequest(url, option)
    }

    func httpRequest(url: String, option: HttpRequestOptions): ResponseResult<T> {
        let httpRequest = createHttp();
        // 用于订阅HTTP响应头，此接口会比request请求先返回。可以根据业务需要订阅此消息
        httpRequest.onHeadersReceive({header: HashMap<String, String> =>
            Hilog.info(1, "test", "resp===: header: ${header}")
        })
        try {
            // Hilog.info(0, "test", "resp===: 开始请求")
            httpRequest.request(url,{ err, resp =>
                    if (let Some(e) <- err) {
                        Hilog.info(1, "test", "exception: ${e.message}")
                        var jo = Utils.String2JsonObject(Utils.getResult(400, e.message, ""))
                        this.responseResult = Utils.JsonObject2ResponseResult<T>(jo)
                    }
                    if (let Some(r) <- resp) {

                        Hilog.info(1, "test", "resp===: data:${r.result}")
                        //Hilog.info(1, "test", "resp===: cookies:${r.cookies}")
                        //Hilog.info(1, "test", "resp===: setCookie:${r.setCookie}")
                        //Hilog.info(1, "test", "resp===: header:${r.header}")
                        //Hilog.info(1, "test", "resp===: hasCookie:${r.header.contains('set-cookie')}")

                        //if(r.responseCode==
                        //cookie保存
                        var hasCookie = r.header.contains('set-cookie')
                        if(url.contains("login")||url.contains("register")){
                            var cookieValue = r.setCookie.toString().replace("[", "").replace("]", "")
                            Hilog.info(1, "test", "resp===: setcookie: ${cookieValue}")
                            cookie = cookieValue
                            //Hilog.info(1, "test", "resp===: setcookie: ${r.header['set-cookie']},值为：${AppStorage.get<String>("Cookie").getOrThrow()}")
                        }
                        //数据类解析
                        var jo = Utils.String2JsonObject(r.result.toString())
                        this.responseResult = Utils.JsonObject2ResponseResult<T>(jo)
                    } else {
                        Hilog.info(1, "test", "response is none")
                        var jo = Utils.String2JsonObject(Utils.getResult(404, "response is none", ""))
                        this.responseResult = Utils.JsonObject2ResponseResult<T>(jo)
                    }
                    httpRequest.destroy()
                },
                options: option
            )
            sleep(Duration.second * 1)
            //Hilog.info(0, "test", "resp===: 结束请求")
            return responseResult
        } catch (exception: Exception) {
            var jo = Utils.String2JsonObject(Utils.getResult(500, "${exception.message}", "出错了"))
            this.responseResult = Utils.JsonObject2ResponseResult<T>(jo)
            return responseResult
        } finally {
        }
    }
}
