package ohos_app_cangjie_entry

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.hilog.*
import ohos_app_cangjie_entry.common.Constants
import ohos_app_cangjie_entry.component.home.Home
import ohos_app_cangjie_entry.component.friend.Friend
import ohos_app_cangjie_entry.component.message.Message
import ohos_app_cangjie_entry.component.my.My
import ohos_app_cangjie_entry.component.commonComponent.BottomTab

@Entry
@Component
class MyView {
    //记录用户点击
    @State
    var currentIndex: Int64 = 0

    // 文档的 aboutToAppear()
    protected override func aboutToAppear() {
        //获取网络图片
        //let httpRes: HttpUtil = HttpUtil()
        //httpRes.getHttpRequest("https://val.qq.com/game-data.html?pageType=1&&heroId=1")
    }

    func build() {
        Stack(Alignment.Bottom) {
            if (this.currentIndex == 0) {
                Home()
            } else if (this.currentIndex == 1) {
                Friend()
            } else if (this.currentIndex == 3) {
                Message()
            } else if (this.currentIndex == 4) {
                My()
            }
            Row() {
                BottomTab(currentIndex: currentIndex)
            }.height(50.vp).width(Constants.FULL_SIZE).justifyContent(FlexAlign.Center)
        }.width(Constants.FULL_SIZE).height(Constants.FULL_SIZE)
    }
}
