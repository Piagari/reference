/**
 * Created on 2024/9/2
 */
package ohos_app_cangjie_entry.Page

import cj_res_entry.app
import ohos_app_cangjie_entry.Component.*
import ohos_app_cangjie_entry.Model.*
internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.prompt_action.*
import ohos.router.*


@Component
public class Profile {
    var scroller: Scroller = Scroller();
    @Provide
    var opacityValue: Float64 = 0.0;
    private var yOffset: Float64 = 0.0;
    @StorageLink["isLogin"]
    var isLoginCheck: Bool = false;
    @State
    var isShow: Bool = false;
    @State
    var hide: CJResource = @r(app.media.ic_hide)
    @State
    var show: CJResource = @r(app.media.ic_show)
    @State
    var property: String = '99999'
//    TODO Tabs相关生命周期/跳转存在bug,后续待处理
//    protected override func aboutToAppear() {
//        AppLog.info('profile aboutToAppear finish')
//        if (this.isLoginCheck == false) {
//            this.jumpToLogin()
//        }
//    }

    func jumpToLogin() {
        Router.push(url: 'Login')
        AppLog.info('push finish')
    }

    func onScrollAction() {
        this.yOffset = this.scroller.currentOffset().yOffset
        if (this.yOffset > Float64(100)) {
            this.opacityValue = 1.0
        } else {
            this.opacityValue = this.yOffset / Float64(100)
        }
    }

    @Builder
    func profileBanner() {
        Column() {
            Row() {
                Image(@r(app.media.ic_person)).width(64).height(64).borderRadius(24)
                Text("您好，XX").fontSize(24).fontColor(Color.WHITE).margin(left: 24, bottom: 24)
            }.width(100.percent).height(64).margin(left: 64, top: 100)
            Blank()
            Row() {
                Image(@r(app.media.ic_vip)).width(16).height(16)
                Text("大众客户").fontSize(16)
                Blank()
                Text("查看尊享权益").fontSize(16)
                Image(@r(app.media.ic_public_arrow_right)).width(16).height(16)
            }.width(80.percent).height(36).backgroundColor(0xBDFFC7).borderRadius(12)
        }.width(100.percent).height(222).backgroundImage(src: "/resources/base/media/ic_app_background.png")
    }

    @Builder
    func profileEntrance() {
        Row() {
            ForEach(
                profileItems,
                itemGeneratorFunc: {
                    item: iconItem, index: Int64 => Column() {
                        Image(item.getImage()).width(40).height(40).margin(bottom: 4)
                        Text(item.getTitle()).fontSize(12).textAlign(TextAlign.Center).fontWeight(FontWeight.W400)
                    }
                }
            )
        }.width(90.percent).height(130).justifyContent(FlexAlign.SpaceEvenly).borderRadius(12).backgroundColor(
            Color.WHITE).margin(top: 12, bottom: 12)
    }

    @Builder
    func profileWealth() {
        Row() {
            Text("我的资产").width(100).fontSize(24).textAlign(TextAlign.Start).fontWeight(FontWeight.W600)
            Image(this.hide).width(24).height(24).onClick(
                {
                    event =>
                    this.isShow = !this.isShow
                    if (this.isShow == true) {
                        this.hide = this.show
                    } else {
                        this.hide = @r(app.media.ic_hide)
                    }
                }
            )
        }.padding(top: 12, left: 12, bottom: 12, right: 12).width(100.percent)

        Column() {
            Row() {
                Text("资产").fontSize(20).margin(left: 24)
                Image(@r(app.media.ic_public_arrow_right)).width(16).height(16)
                Blank()
                Text("昨日收益").fontSize(20)
                Image(@r(app.media.ic_public_arrow_right)).width(16).height(16).margin(right: 24)
            }.width(100.percent).margin(top: 24)
            Row() {
                if (this.isShow) {
                    Text("¥99999").fontSize(24).fontWeight(FontWeight.W600).margin(left: 24, top: 16)
                } else {
                    Text("*****").fontSize(24).fontWeight(FontWeight.W600).margin(left: 24, top: 16)
                }
                Blank()
                if (this.isShow) {
                    Text("暂无收益").fontSize(24).fontWeight(FontWeight.W600).margin(right: 24, top: 16)
                } else {
                    Text("*****").fontSize(24).fontWeight(FontWeight.W600).margin(right: 24, top: 16)
                }
            }.width(100.percent)
        }.width(90.percent).height(120).borderRadius(12).backgroundColor(Color.WHITE).margin(top: 12)
    }

    @Builder
    func profileIncome() {
        Row() {
            Text("本月收支").width(100).fontSize(24).textAlign(TextAlign.Start).fontWeight(FontWeight.W600)
        }.padding(top: 24, left: 12, bottom: 12, right: 12).width(100.percent)

        Column() {
            Row() {
                Text("收入").fontSize(20).margin(left: 24)
                Image(@r(app.media.ic_public_arrow_right)).width(16).height(16)
                Blank()
                Text("支出").fontSize(20)
                Image(@r(app.media.ic_public_arrow_right)).width(16).height(16).margin(right: 24)
            }.width(100.percent).margin(top: 24)
            Row() {
                if (this.isShow) {
                    Text("¥99999").fontSize(24).fontWeight(FontWeight.W600).margin(left: 24, top: 16)
                } else {
                    Text("*****").fontSize(24).fontWeight(FontWeight.W600).margin(left: 24, top: 16)
                }
                Blank()
                if (this.isShow) {
                    Text("¥0.00").fontSize(24).fontWeight(FontWeight.W600).margin(right: 24, top: 16)
                } else {
                    Text("*****").fontSize(24).fontWeight(FontWeight.W600).margin(right: 24, top: 16)
                }
            }.width(100.percent)
        }.width(90.percent).height(120).borderRadius(12).backgroundColor(Color.WHITE).margin(top: 12)
    }

    func build() {
        Stack(Alignment.Top) {
            Column() {
                Scroll(this.scroller) {
                    Column() {
                        this.profileBanner()
                        this.profileEntrance()
                        this.profileWealth()
                        this.profileIncome()
                        HomeLocation()
                    }.zIndex(1)
                }.onScroll({
                    offset => this.onScrollAction()
                })
                Column() {
                    HomeHeader()
                }.position(x: 0, y: 0).height(120.vp).zIndex(2)
            }
        }
    }
}
