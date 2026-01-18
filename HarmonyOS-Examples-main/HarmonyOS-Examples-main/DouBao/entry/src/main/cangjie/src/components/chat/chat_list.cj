/**
 * Created on 2024/8/26
 */
package ohos_app_cangjie_entry.components.chat

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import cj_res_entry.app
import ohos.resource_manager.*
import ohos_app_cangjie_entry.util.*
import ohos_app_cangjie_entry.entity.*
import ohos_app_cangjie_entry.mock.*
import ohos.router.Router
import ohos_app_cangjie_entry.global.*

@Component
public class ChatList {
  // 聊天项点击的回调
  func privateChatOnClick(target: (Chat, User)) {
    CURRENT_CHAT.set(target[0])
    TARGET_USER.set(target[1])
    Router.push(url: "ChatView")
  }

  let tabsController: TabsController = TabsController()

  let privateChatDataSource = Array<(Chat, User)>([
    (chat1, user2), (chat2, user3), (chat3, user4),
    (chat4, user5), (chat5, user6), (chat6, user7),
    (chat7, user8), (chat8, user9), (chat9, user10)
  ])

  func build() {
    Column() {
      List() {
        ForEach(privateChatDataSource, itemGeneratorFunc: {elem: (Chat, User), index: Int64 =>
          if (index != 0) {
            ListItem() {
              ChatListItem(
                src: elem[1].avatar,
                name: elem[1].username,
                msg: elem[0].msgs[0].content,
                time: elem[0].msgs[0].time,
                count: elem[0].count,
                about: elem[1].about,
                bindItem: elem,
                phone:0,
                onClick: privateChatOnClick
              )
            }.backgroundColor(0xffffff)
          }
          else {
            ListItem() {
              ChatListItem(
                src: elem[1].avatar,
                name: elem[1].username,
                msg: elem[0].msgs[0].content,
                time: elem[0].msgs[0].time,
                count: elem[0].count,
                about: elem[1].about,
                bindItem: elem,
                phone:1,
                onClick: privateChatOnClick
              )
            }.backgroundColor(0xf5f5f5)
          }
        })
      }.padding(left: 0, right: 0, bottom: 0)
      .divider(strokeWidth: 5.px, color: Color(0xF5F5F5), startMargin: 250.px, endMargin: 20.px) // 每行之间的分界线

    }.width(100.percent)
    .height(100.percent)
  }
}