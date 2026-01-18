/**
 * Created on 2024/8/29
 */
package ohos_app_cangjie_entry.component.message

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import cj_res_entry.app
import ohos_app_cangjie_entry.model.{FriendList, FriendModel}

@Component
public class MessageBody {
    func build() {
        Column() {
            //好友状态列表
            List(space: 15) {
                ListItem() {
                    otherInfoColumn(@r(app.media.ic_other_img), "黑马喽")
                }
                ListItem() {
                    otherInfoColumn(@r(app.media.ic_other_img), "黑马喽")
                }
                ForEach(
                    FriendList,
                    itemGeneratorFunc: {
                        item: FriendModel, index: Int64 => ListItem() {
                            friendInfoColumn(item)
                        }
                    }
                )
            }.width(95.percent).height(100).listDirection(Axis.Horizontal).scrollBar(BarState.Off)
            //消息列表
            List(space: 15) {
                ListItem() {
                    otherMessagerItem(@r(app.media.ic_follow_mefollow_me), "新关注我的", "没有新通知",
                        @r(app.color.message_new_follow_color))
                }
                ListItem() {
                    otherMessagerItem(@r(app.media.ic_interactive_message), "互动消息", "马喽 在评论中提到了你",
                        @r(app.color.message_interactive_message_color))
                }
                ForEach(
                    FriendList,
                    itemGeneratorFunc: {
                        item: FriendModel, index: Int64 => ListItem() {
                            messageInfoItem(item)
                        }
                    }
                )
            }.width(95.percent).height(73.percent).listDirection(Axis.Vertical).scrollBar(BarState.Off)
        }.width(100.percent).height(100.percent)
    }

    //好友信息
    @Builder
    func friendInfoColumn(item: FriendModel) {
        Column(5) {
            friendStatusInfoItem(item, 50, 50, 59, 59)
            Text(item.getName()).fontSize(14.vp).fontWeight(FontWeight.Medium)
        }
    }

    //好友状态信息组件
    @Builder
    func friendStatusInfoItem(item: FriendModel, imgWidth: Int64, imgHeight: Int64, stackWidth: Int64,
        stackHeight: Int64) {
        Stack() {
            Row() {
                Image(item.getImg()).width(imgWidth).height(imgHeight).borderRadius(50)
            }.width(100.percent).height(100.percent).justifyContent(FlexAlign.Center).alignItems(VerticalAlign.Center)
            if (item.getStatus() == "在线") {
                Row() {
                    Image(@r(app.media.ic_status)).width(18).height(18).objectFit(ImageFit.Fill)
                }.borderRadius(50).padding(2).backgroundColor(Color.WHITE)
            }
        }.width(stackWidth).height(stackHeight).alignment(Alignment.BottomEnd)
    }

    //其他信息组件
    @Builder
    func otherInfoColumn(image: CJResource, lable: String) {
        Column(5) {
            Row() {
                Image(image).width(50).height(50).borderRadius(50)
            }.borderWidth(2).borderColor(Color.BLUE).borderRadius(50).padding(2)
            Text(lable).fontSize(14.vp).fontWeight(FontWeight.Medium)
        }
    }

    //其他消息组件
    @Builder
    func otherMessagerItem(img: CJResource, lable: String, message: String, imgBackgroundColor: CJResource) {
        Row(8) {
            Row() {
                Image(img).width(45).height(45).borderRadius(50).backgroundColor(imgBackgroundColor)
            }.width(55).height(55).justifyContent(FlexAlign.Center)
            Column(5) {
                Text(lable).fontSize(18).fontWeight(FontWeight.Bold)
                Text(message).fontSize(14).fontColor(@r(app.color.message_text_color))
            }.alignItems(HorizontalAlign.Start)
            Blank()
            Image(@r(app.media.ic_arrow_right)).width(24).height(24).fillColor(@r(app.color.dark_gray_color))
        }.width(100.percent)
    }

    //消息信息自定义组件
    @Builder
    func messageInfoItem(item: FriendModel) {
        Row(8) {
            friendStatusInfoItem(item, 45, 45, 55, 55)
            Column(5) {
                Text(item.getName()).fontSize(18).fontWeight(FontWeight.Bold)
                Text(selectStatusOrMessage(item)).fontSize(14).fontColor(@r(app.color.message_text_color))
            }.alignItems(HorizontalAlign.Start)
        }.width(100.percent)
    }

    //根据好友的在线状态，选择显示在线或消息
    func selectStatusOrMessage(item: FriendModel): String {
        match (item.getStatus()) {
            case "在线" => item.getStatus()
            case _ => item.getMessage()
        }
    }
}
