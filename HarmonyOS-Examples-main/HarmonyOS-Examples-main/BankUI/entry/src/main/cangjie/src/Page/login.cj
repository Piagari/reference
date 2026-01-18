/**
 * Created on 2024/9/2
 */
package ohos_app_cangjie_entry.Page

import cj_res_entry.app
import ohos_app_cangjie_entry.Component.*
internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.prompt_action.*
import ohos.router.*
import std.time.*
import std.sync.*

@Entry
@Component
public class Login {
    @State
    var account: String = '';
    @State
    var password: String = '';
    @State
    var isShowProgress: Bool = false;
    @StorageLink["isLogin"]
    var isLoginCheck: Bool = false;
    //    private var timeOutId: Int64 = -1;

    func login() {
        if (this.account == '' || this.password == '') {
            PromptAction.showToast(message: "输入不能为空")
        } else {
            this.isLoginCheck = true
            Router.push(url: "MyView")
//            TODO TimerRouter跳转存在bug,后续待处理
//            Timer.once(1000 * Duration.millisecond){ =>
//                    this.isShowProgress = false
//                    this.isLoginCheck = true
//                    Router.push(url: "MyView")
//                    }
    }
        }

//    protected override func aboutToDisappear(){
//        sleep(4000 * Duration.millisecond)
//    }

    func backClickLoginCheck() {
        if (this.isLoginCheck) {
            Router.back();
        } else {
            Router.push(url: "MyView")
        }
    }

    @Builder
    func imageButton(src: CJResource) {
        Button {
            Image(src)
        }.height(48).width(48).backgroundColor(0xF1F3F5)
    }

    func build() {
        Column() {
            Row() {
                Image(@r(app.media.ic_public_arrow_left)).width(20).height(20).margin(left: 10).onClick(
                    {
                    event => this.backClickLoginCheck()
                })
            }.width(100.percent).margin(top: 10, bottom: 100)
            Text("您好,").fontSize(24).fontWeight(FontWeight.Medium).margin(bottom: 10, left: 10).width(100.percent)
            Text("欢迎来到仓颉银行").fontSize(24).fontWeight(FontWeight.Medium).margin(bottom: 10, left: 10).width(
                100.percent)
            TextInput(placeholder: '手机号(内地)').maxLength(16).placeholderColor(0x787F87).setType(InputType.Number).
                height(45).width(100.percent).margin(top: 12).onChange({value: String => this.account = value})
            Line().width(100.percent).height(1).backgroundColor(0x33182431)
            TextInput(placeholder: '密码').maxLength(12).placeholderColor(0x787F87).setType(InputType.Password).height(
                45).width(100.percent).margin(top: 12).onChange({value: String => this.password = value})
            Line().width(100.percent).height(1).backgroundColor(0x33182431)
            Row() {
                Text("短信验证码登录").fontSize(14).fontColor(0x007DFF).fontWeight(FontWeight.Medium)
                Text("忘记密码").fontSize(14).fontColor(0x007DFF).fontWeight(FontWeight.Medium)
            }.justifyContent(FlexAlign.SpaceBetween).width(100.percent).margin(top: 8)
            Button("登录").shape(ShapeType.Capsule).width(100.percent).height(40).fontSize(16).fontWeight(
                FontWeight.Medium).backgroundColor(Color.RED).margin(top: 87, bottom: 30).onClick(
                {
                event => this.login()
            })
            Text("注册账号").fontSize(16).fontColor(0x007DFF).fontWeight(FontWeight.Medium)
            if (this.isShowProgress) {
                LoadingProgress().width(30).height(30).margin(top: 30)
            }
            Blank()
            Text("其他方式登录").fontColor(0x838D97).fontSize(12).fontWeight(FontWeight.Medium).margin(top: 50,
                bottom: 12)
            Row(44) {
                this.imageButton(@r(app.media.login_method1))
                this.imageButton(@r(app.media.login_method2))
                this.imageButton(@r(app.media.login_method3))
            }
        }.backgroundColor(0xF1F3F5).width(100.percent).height(100.percent).padding(left: 12, right: 12, bottom: 24)
    }
}
