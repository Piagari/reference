package ohos_app_cangjie_entry

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.Page.*
import ohos.router.*

let storage = AppStorage.setOrCreate("isLogin", false)

@Entry
@Component
class MyView {
    @State
    var currentIndex: Int32 = 0;
    var controller: TabsController = TabsController()
    @StorageLink["isLogin"]
    var isLoginCheck: Bool = false

    protected override func aboutToAppear() {
        AppLog.info("index aboutToAppear")
    }

    func build() {
        Tabs(BarPosition.End, this.controller) {
            TabContent {
                Home()
            }.tabBar(icon: "/resources/base/media/ic_home_normal.png", text: "首页")
            TabContent {
                Text("信用卡")
            }.tabBar(icon: "/resources/base/media/ic_creditcard_normal.svg", text: "信用卡")
            TabContent {
                Text("财富")
            }.tabBar(icon: "/resources/base/media/ic_wealth_normal.svg", text: "财富")
            TabContent {
                Text("生活")
            }.tabBar(icon: "/resources/base/media/ic_life_normal.png", text: "生活")
            TabContent {
                Profile()
            }.tabBar(icon: "/resources/base/media/ic_mine_normal.png", text: "我的")
        }.vertical(false).scrollable(true).barMode(BarMode.Fixed).barHeight(70).animationDuration(400).backgroundColor(
            0xF1F3F5).onChange(
            {
                index: Int32 =>
                this.currentIndex = index
                if (this.isLoginCheck == false && this.currentIndex == 4) {
                    Router.push(url: 'Login')
                }
            }
        )
    }
}
