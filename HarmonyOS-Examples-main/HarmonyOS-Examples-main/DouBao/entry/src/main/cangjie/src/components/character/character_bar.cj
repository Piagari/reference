package ohos_app_cangjie_entry.components.character

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.resource_manager.*
import cj_res_entry.app
import ohos_app_cangjie_entry.mock.*
import ohos_app_cangjie_entry.entity.*
import ohos_app_cangjie_entry.util.*
import ohos.router.Router
import ohos_app_cangjie_entry.global.*

class TabData {
  public TabData(let title: String) {}
}

@Component
public class TabBtn {
  // 图标下面的文本
  @Prop var title: String

  // 图标和文本的颜色,活跃是蓝色,不活跃是黑色
  @Prop var color: UInt32

  @Prop var bgcolor: UInt32

  @Prop var weight: FontWeight

  func build() {
    Column() {
      Text(title)
      .fontSize(15)
      .fontColor(color)
      .margin(right:10)
      .backgroundColor(bgcolor)
      .padding(8)
      .borderRadius(10)
      .borderColor(0xe5e5e5)
      .fontWeight(weight)
      .borderWidth(1)
    }
  }
}

@Component
public class watchBar {
  // 聊天项点击的回调
  func privateChatOnClick(target: (Chat, User)) {
    CURRENT_CHAT.set(target[0])
    TARGET_USER.set(target[1])
    Router.push(url: "ChatView")
  }

  let Nodata = Array<(Chat, User)>([])

  let privateChatDataSource = Array<(Chat, User)>([
    (chat11, user11), (chat12, user12), (chat12, user13),(chat12, user14),(chat12,user10),(chat12,user9)
  ])

  let privateChatDataSource2 = Array<(Chat, User)>([
    (chat11, user11), (chat12, user12), (chat12, user13),(chat12, user14),(chat12,user10),(chat12, user11), (chat12, user12), (chat12, user13),(chat12, user14)
  ])

  // 当前活跃的Tab的序号
  @State var activeInd: UInt32 = 0;

  let userList = [user2, user3, user4, user5, user6, user7, user8, user9, user10]

  // 点击Tab的响应函数
  func tabOnClick(index: UInt32) {
    this.activeInd = index;
  }

  let dataSource = Array<TabData>([
    TabData("推荐"),
    TabData("精选"),
    TabData("拍照问"),
    TabData("头像生成"),
    TabData("通话畅聊"),
    TabData("学习"),
    TabData("真人感"),
    TabData("古今对话"),
    TabData("品牌专区"),
    TabData("沉浸体验"),
    TabData("绘画"),
    TabData("游戏动漫"),
    TabData("角色"),
    TabData("影视小说"),
    TabData("工作"),
    TabData("创作"),
    TabData("生活"),
    TabData("情感"),
    TabData("趣味"),
    TabData("近期上新")
  ])

  func tabOnChange(index: UInt32) {
    if (activeInd != index) {
      this.activeInd = index
    }
  }

  @Builder
  func swiper(DataSource:Array<(Chat, User)>) {
    Column() {
      List(space:15) {
        ForEach(DataSource, itemGeneratorFunc: {elem: (Chat, User), index: Int64 =>
          ListItem() {
            watchListItem(
              src: elem[1].avatar,
              name: elem[1].username,
              msg: elem[0].msgs[0].content,
              time: elem[0].msgs[0].time,
              count: elem[0].count,
              about: elem[1].about,
              bindItem: elem,
              phone:0,
              author: elem[1].author,
              readnum: elem[1].readnum,
              introduce: elem[1].introduce,
              onClick: privateChatOnClick
            )
          }
        })
      }.padding(left: 0, right: 0, bottom: 0,top:0)
      .layoutWeight(1)
    }
    .width(100.percent)
    .height(100.percent)
  }

  func build() {
    Column() {
      Row() {
        List() {
          ForEach(dataSource, itemGeneratorFunc: { elem: TabData, ind: Int64 =>
            ListItem() {
              Row() {
                if (UInt32(ind) == activeInd) {
                  Text(elem.title)
                  .fontSize(15)
                  .fontColor(0x0165ff)
                  .margin(right:10)
                  .backgroundColor(0xd8e9fd)
                  .padding(8)
                  .borderRadius(10)
                  .borderColor(0xe5e5e5)
                  .fontWeight(FontWeight.Bold)
                  .borderWidth(1)
                  .onClick({ e: ClickEvent => tabOnClick(UInt32(ind)) })
                } else {
                  Text(elem.title)
                  .fontSize(15)
                  .fontColor(0x000000)
                  .margin(right:10)
                  .backgroundColor(0xffffff)
                  .padding(8)
                  .borderRadius(10)
                  .borderColor(0xe5e5e5)
                  .fontWeight(FontWeight.Normal)
                  .borderWidth(1)
                  .onClick({ e: ClickEvent => tabOnClick(UInt32(ind)) })
                }
              }
            }
          })
        }.scrollBar(BarState.Off)
        .width(100.percent)
        .listDirection(Axis.Horizontal)
      }.width(100.percent)
      .padding(left: 20, right: 20, top: 0,bottom:15)
      .alignItems(VerticalAlign.Top)
      .backdropBlur(5)

      Swiper() {
        Scroll() {
          Column() {
            Image(@r(app.media.gif)).width(90.percent).height(130).borderRadius(20).margin(bottom:20)
            swiper(privateChatDataSource)
          }.margin(bottom:150)
        }
        .width(100.percent)
        .layoutWeight(1)
        .scrollable(ScrollDirection.Vertical)
        .align(Alignment.TopStart)
        .scrollBar(BarState.Off)
        swiper(privateChatDataSource2)
        swiper(Nodata)
        swiper(Nodata)
        swiper(Nodata)
        swiper(Nodata)
        swiper(Nodata)
        swiper(Nodata)
        swiper(Nodata)
        swiper(Nodata)
        swiper(Nodata)
        swiper(Nodata)
        swiper(Nodata)
        swiper(Nodata)
        swiper(Nodata)
        swiper(Nodata)
        swiper(Nodata)
        swiper(Nodata)
        swiper(Nodata)
        swiper(Nodata)
      }.loop(false)
      .index(activeInd)
      .indicator(false)
      .onChange({
        index => tabOnChange(UInt32(index))
      })
      .margin(bottom:80)
      .layoutWeight(1)
    }.backgroundColor(0xffffff).layoutWeight(1)
    .expandSafeArea(
      types: [SafeAreaType.SYSTEM],
      edges: [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]
    )
  }
}