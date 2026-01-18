/**
 * Created on 2024/9/10
 */
package ohos_app_cangjie_entry.utils
import std.regex.* //正则
import std.collection.*
import ohos_app_cangjie_entry.bean.*
import serialization.serialization.*
import std.math.*
import encoding.json.*
import std.collection.*

public class Utils {
    //单例
    private Utils(){}
    private static var instance:Utils = Utils()
    public static func  getInstance():Utils{
        return instance
    }

    //1-判断是否为空
    public static func isEmpty<T>(data: T) where T<:Serializable<T> {
        if (data is String) {
            return (data as String).getOrThrow().isEmpty()
        } else if (data is Array<T>) {
            return (data as Array<T>).getOrThrow().isEmpty()
        } else if (data is ArrayList<T>) {
            return (data as ArrayList<T>).getOrThrow().isEmpty()
        } else if(data is Serializable<T>){
            return data.serialize().toJson().toString().isEmpty() //待验证
        } else {
            return false
        }
    }

    //2-获取Article用户名
    public static func getArticleUser(articleItem:ArticleItem):String{

        if(isEmpty<String>(articleItem.author)){
            return articleItem.shareUser
        }
        if(isEmpty<String>(articleItem.shareUser)){
            return articleItem.author
        }
        return "--"
    }
    //3-如果name为空，取值other
    public static func getNamebyString(name:String,other:String):String{

        if (!isEmpty<String>(name)){
            return name
        }
        return other
    }
    //4-用于取代三元运算符，如果isTrue为真去值first，否则取值second
    public static func getNamebyVariable(isTrue:Bool,first:String,second:String):String{

        if (isTrue){
            return first
        }
        return second
    }

    //4-序列化：String->JsonObject
    public static func String2JsonObject(str:String):JsonObject{

        var jsobj:JsonObject = JsonObject();
        try {
        	    var jsv:JsonValue = JsonValue.fromStr(str);
                jsobj = (jsv as JsonObject).getOrThrow();
          }catch (exception:Exception) {
        	println(exception.toString())
        }
        return jsobj
    }
    //5-序列化：JsonObject->Bean
    public static func JsonObject2Bean<T>(jo:JsonObject) :T where T <:Serializable<T> {
        var t:T
        var jve =JsonValue.fromStr(jo.toString())
        var dml = DataModel.fromJson(jve)
        t =  T.deserialize(dml)
        return t

    }
    //6-序列化：数据类Bean——>JsonObject
    public static func Bean2JsonObject<T>(t:T):JsonObject where T<:Serializable<T>{
        let jsv:JsonValue = t.serialize().toJson()
        let jsb:JsonObject = (jsv as JsonObject).getOrThrow();
        return jsb;
    }

    //7-序列化：JsonObject->ResponseResult
    public static func JsonObject2ResponseResult<T>(jo:JsonObject) :ResponseResult<T> where T <:Serializable<T> {
        var responseResult:ResponseResult<T>
        var jve =JsonValue.fromStr(jo.toString())
        var dml = DataModel.fromJson(jve)
        responseResult =  ResponseResult<T>.deserialize(dml)
        return responseResult;
    }

    //8-拼接跳转URl
    public static func getWebURL(title:String,url:String){
         var str:String = "{\"title\": \"${title}\",\"url\":\"${url}\"}"
         return str
    }
    //9-数据返回结果
    public static func getResult(errorCode:Int64,errorMsg:String,data:String){
         var str:String = "{\"errorCode\": \"${errorCode}\",\"errorMsg\":\"${errorMsg}\",\"data\":\"${data}\"}"
         return str
    }

    //10-格式化字符串
    public static func formatHtml(html:String){
        var data:String = ""
        if (!isEmpty<String>(html)){
            var regSymbol = Regex("&.*;")
            var regHtml = Regex("</?[^>]+>")  //html标签正则
            let r =  regHtml.matcher(html)
            data= r.replaceAll("")
        }
        return data
    }
}
