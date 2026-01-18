package ohos_app_cangjie_entry.component
internal import ohos.base.*
import ohos.component.*
internal import ohos.state_manage.*
internal import ohos_app_cangjie_entry.api.*
internal import ohos_app_cangjie_entry.bean.*
import ohos.state_macro_manage.*
internal import ohos.webview.*
internal import ohos.router.*
internal import std.collection.*
import ohos.resource_manager.*
import cj_res_entry.app //用于导入@r
import ohos.hilog.*
import ohos.emitter.*

import ohos_app_cangjie_entry.utils.*

/**
 * @desc：我的-头部信息
 */

@Component
public class MineHead {
    @State var userData: UserData = UserData()
    @State var isLogin: Bool = false
    @State var rank: String = '';
    @State var collectIds: String = '';
    @State var level: String = '';
    @State var coinCount: String = '';
    @State var username: String = '';

    protected override func aboutToAppear() {
        Hilog.debug(1, "test", "MineHead-aboutToAppear")
        var userResult = HttpRequest.userInfoReq()
        Hilog.debug(1, "test", "用户信息：errorCode=${userResult.errorCode},errorMsg=${userResult.errorMsg}")
        if(userResult.errorCode == 0){
            userData = userResult.data.getOrThrow()
            username = userData.userInfo.getOrThrow().username
            coinCount = userData.userInfo.getOrThrow().coinCount.toString()
            level = userData.coinInfo.getOrThrow().level.toString()
            collectIds = userData.userInfo.getOrThrow().collectIds.getOrThrow().size.toString()
            rank = userData.coinInfo.getOrThrow().rank
        }
    }
    protected override func onPageShow() {
        Hilog.debug(1, "test", "MineHead-onPageShow")
    }
//    protected override func onBackPress() {
//        return false
//    }
    // 在Home页面中
    func jumpLoginClick() {
        Router.push(url: "LoginRegisterPage")
    }

    func jumpPath(path: String) {
    }

    @Builder
    func InfoItem(title: String, content: String) {
        Column() {
            Text(title).fontSize(18).fontWeight(FontWeight.Bold)
            Text(Utils.getNamebyString(content, "——")).margin(top: 3)
        }
        .flexGrow(1)
        .alignItems(HorizontalAlign.Center)
    }

    func build() {
        Column() {
            //1-设置
            Flex(FlexParams(alignItems: ItemAlign.Center)) {
                Text('')
                .width(30)
                .height(30)

                Text('我的')
                .textAlign(TextAlign.Center)
                .fontColor(Color.WHITE)
                .maxLines(1)
                .fontSize(20)
                .flexGrow(1)

                 Image(@r(app.media.ic_setting))
                    .width(30)
                    .height(30)
            }
            .width(100.percent)
            .height(60)
            .padding(10)
            .backgroundColor(Color.BLUE)

            //2-底部
            Column() {
                //1-头像行-信息
                Flex(FlexParams(alignItems: ItemAlign.Center)) {
                    Image(@r(app.media.ic_user))
                    .margin(left: 20)
                    .width(60)
                    .height(60)

                    Text(Utils.getNamebyString(username, "欢迎登陆"))
                    .textAlign(TextAlign.Start)
                    .maxLines(1)
                    .fontSize(18)
                    .margin(left: 10, right: 10)
                    .flexGrow(1)

                    Image(@r(app.media.ic_arrow_right))
                    .width(30)
                    .height(30)
                }
                .width(100.percent)
                .onClick {evt => this.jumpLoginClick() }

                if (!Utils.isEmpty<String>(username)) {
                    Flex(FlexParams(justifyContent: FlexAlign.SpaceBetween)) {
                        this.InfoItem('排名', this.userData.coinInfo.rank)
                        this.InfoItem('收藏', "${this.userData.userInfo.getOrThrow().collectIds.getOrThrow().size}")
                        this.InfoItem('等级', "${this.userData.coinInfo.getOrThrow().level}")
                        this.InfoItem('积分', "${this.userData.coinInfo.getOrThrow().coinCount}")
                    }.margin(top: 40)
                } else {
                    Flex(FlexParams(justifyContent: FlexAlign.SpaceBetween)) {
                        this.InfoItem('排名', '——')
                        this.InfoItem('收藏', '——')
                        this.InfoItem('等级', '——')
                        this.InfoItem('积分', '——')
                    }.margin(top: 40)
                }
            }.width(100.percent)
            .padding(left: 10,right: 10,top: 30,bottom: 20)
        }
    }
}
