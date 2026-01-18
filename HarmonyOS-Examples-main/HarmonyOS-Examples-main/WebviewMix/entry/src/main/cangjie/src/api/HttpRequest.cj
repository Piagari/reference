/**
 * Created on 2024/9/6
 */
package ohos_app_cangjie_entry.api
import ohos.net.http.*
import ohos.base.*
import std.collection.*
import ohos_app_cangjie_entry.bean.*
import ohos.hilog.*
import std.time.*
import std.sync.*
import ohos.state_manage.*


public interface  HttpRequest {

     //1-测试地址
      static func testReq():ResponseResult<HarmonyData>{
        return HttpService<HarmonyData>.getInstance().httpRequestGet(HttpConfig.testURL)
      }
     //2-首页List请求
      static func homeListReq(page:Int64):ResponseResult<SearchData>{
            return HttpService<SearchData>.getInstance().httpRequestPost("${HttpConfig.homeArticleListURL}/${page}/json", "k=鸿蒙")
      }
     //3-课程请求
      static func getChapterReq():ResponseResult<ArrayList<DataItem>>{
            return HttpService<ArrayList<DataItem>>.getInstance().httpRequestGet(HttpConfig.chatperURL)
      }
     //4-课程下的列表
       static func getSupterChapterReq(page:Int64,cid:Int64):ResponseResult<SearchData>{
            return HttpService<SearchData>.getInstance().httpRequestGet("${HttpConfig.superChatperURL}/${page}/json?cid=${cid}&page_size=40&order_type=1")
      }

      //5-工具请求
      static func getToolReq():ResponseResult<ArrayList<ToolItem>>{
        return HttpService<ArrayList<ToolItem>>.getInstance().httpRequestGet(HttpConfig.toolsURL)
      }
      //6-登录
       static func loginReq(username:String,password:String):ResponseResult<UserInfo>{
            return HttpService<UserInfo>.getInstance().httpRequestPost("${HttpConfig.loginURL}","username=${username}&password=${password}")
      }
      //7-注册
       static func registerReq(username:String,password:String,repassword:String):ResponseResult<UserInfo>{
            return HttpService<UserInfo>.getInstance().httpRequestPost("${HttpConfig.registerURL}","username=${username}&password=${password}&repassword=${repassword}")
      }
     //8-个人信息
      static func userInfoReq():ResponseResult<UserData>{
        return HttpService<UserData>.getInstance().httpRequestGet(HttpConfig.userInfoURL)
      }
      //9-退出
      static func logoutReq():ResponseResult<String>{
        return HttpService<String>.getInstance().httpRequestGet(HttpConfig.logoutURL)
      }
}

