/**
 * Created on 2024/9/9
 */
package ohos_app_cangjie_entry.api
public class HttpConfig {

    //1-baseURL
    public static var baseURL = 'https://www.wanandroid.com/'
    public static var testURL = baseURL+'harmony/index/json'

    //2-首页
    public static var homeArticleListURL = "https://www.wanandroid.com/article/query"

    //3-课程
    public static var chatperURL = "https://www.wanandroid.com/chapter/547/sublist/json"

    //4-课程列表
    public static var superChatperURL = "https://wanandroid.com/article/list"

    //5-工具
    public static var toolsURL = "https://wanandroid.com/tools/list/json"

    //6-登录 方法：POST 参数：username，password，注意保存cookie，需要cook时携带
     public static var loginURL = "https://www.wanandroid.com/user/login"

    //7-注册方法 方法：POST  参数：username,password,repassword
    public static var registerURL = "https://www.wanandroid.com/user/register"

    //8-个人信息
    public static var userInfoURL = "https://wanandroid.com//user/lg/userinfo/json"

    //9-退出 方法：GET
    public static var logoutURL = "https://www.wanandroid.com/user/logout/json"
	
}