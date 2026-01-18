/**
 * Created on 2024/9/13
 */
package ohos_app_cangjie_entry.pages
internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos_app_cangjie_entry.api.*
import ohos_app_cangjie_entry.bean.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.utils.*
import ohos_app_cangjie_entry.component.*
import ohos_app_cangjie_entry.utils
import std.collection.*
import ohos.hilog.*
import std.collection.*
import encoding.json.*
import ohos.emitter.*
import serialization.serialization.*

//登录注册页面

@Entry
@Component
public class LoginRegisterPage{

    @State var username:String = ""
    @State var password:String = ""
    @State var repassword: String = ""
    @State var isRegister: Bool = false
    @State var isShowProgress: Bool = false
    private var timeOutId: Int64 = -1

    func loginAndRegister(){
        if(this.isRegister){
            this.register()
        }else{
            this.login()
        }
    }
    func login(){
        this.isShowProgress = true
        if(Utils.isEmpty<String>(username)||Utils.isEmpty<String>(password)){
            //提示：输入不能为空
            this.isShowProgress = false
        }else{
            var loginResult:ResponseResult<UserInfo> = HttpRequest.loginReq(username, password)
            Hilog.debug(1, "test", "loginResult=${loginResult.errorCode}")
            //Emitter.on("eventId", f)
            if(loginResult.errorCode == 0){
                //保存cookie，并跳转
                //Hilog.debug(1, "test", "跳转")
                //Router.push(url: "MePage")
                 Router.back()
            }else { //出错了

            }
            this.isShowProgress = false
        }
    }
    func register(){

        if(Utils.isEmpty<String>(username)||Utils.isEmpty<String>(password)||Utils.isEmpty<String>(repassword)){
            //为空提示
        }else{
             this.isShowProgress = true
             var registerResult:ResponseResult<UserInfo> = HttpRequest.registerReq(username, password,repassword)
             Hilog.debug(1, "test", "registerResult=${registerResult.errorMsg}")
             if(registerResult.errorCode == 0){ //成功
                //保存cookie，跳转
                Router.push(url: "MePage")
                //Router.back()
                this.isShowProgress = false
             }else { //失败
                Hilog.debug(1, "test", "失败原因：${registerResult.errorMsg}")
             }
             this.isShowProgress = false
        }
    }

   //---------------------------UI分割线----------------------------------------------------------
    func build(){

        Column(){
            //1-导航栏
            TitleBar(title:"登录与注册页面")

            //2-用户名、密码、确认密码
            Column(){
                    //2.1-用户名输入
                   TextInput(placeholder: "账号", text: this.username)
                   .maxLength(16)
                   .inputStyle()
                   .margin(top: 80)
                   .onChange{value=>this.username = value }
                   
                   Line().lineStyle()
                   
                   //2.2-密码
                   TextInput(placeholder: "密码", text: this.password)
                   .maxLength(16)
                   .setType(InputType.Password)
                   .inputStyle()
                   .onChange{value => this.password = value}
                   
                   Line().lineStyle()
                   
                   //2.3-注册密码(注册时显示)
                   if(this.isRegister) {
                       TextInput(placeholder: "确认密码", text: this.repassword)
                       .maxLength(16)
                       .setType(InputType.Password)
                       .inputStyle()
                       .onChange{value => this.repassword = value}
                   
                        Line().lineStyle()
                   
                   }
            }.padding(right: 12, left: 12)

            Stack(){
                //5-登录/注册按钮
                Button(Utils.getNamebyVariable(this.isRegister, "注册", "登录"))
                .shape(ShapeType.Capsule)
                .width(90.percent)
                .height(40)
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .backgroundColor(0x1E90FF)
                .margin(top: 87, bottom: 12)
                .onClick{evt => this.loginAndRegister() }

                //7-loading加载
                if(this.isShowProgress){
                    LoadingProgress()
                    .color(0x708090)
                    .width(60)
                    .height(60)
                }

            }

            //6-切换登录/注册文本
            Text(Utils.getNamebyVariable(this.isRegister, "已有账号，去登录", "没有账号，去注册"))
            .fontColor(0x1E90FF)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .onClick{evt =>
                this.isRegister = !this.isRegister
                this.username = ""
                this.password = ""
                this.repassword = ""

                }
        }
        .backgroundColor(0xFFFAFA)
        .height(100.percent)
        .width(100.percent)
        .padding(bottom:24)
    }
}

//1-扩展TextInput
extend TextInput {

    public func inputStyle() {
        this
        .placeholderColor(0x808080)
        .height(45)
        .fontSize(18)
        .backgroundColor(0xFFFAFA)
        .width(100.percent)
        .padding(left:0)
        .margin(top:12)
    }
}

//2-扩展Text
extend Text{

    func blueTextStyle(){
        this
        .fontColor(0x1E90FF)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)

    }
}
//3-扩展Line
extend Line {

    func lineStyle(){
        this.width(100.percent)
        .height(1)
        .backgroundColor(0x808080)
    }

}