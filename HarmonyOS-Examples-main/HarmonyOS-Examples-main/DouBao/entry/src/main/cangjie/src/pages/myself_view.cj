/**
 * Created on 2025/1/17
 */
package ohos_app_cangjie_entry.pages
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
import ohos_app_cangjie_entry.components.badge.*

@Component
public class Myself {
  @State
  var currentIndex: Int64 = 0

  public let my_tablist:Array<String> = ["作品","私密","智能体","收藏"]

  @Builder
  func contentItem(label: String, index: Int64) {
    Text(label)
    .fontSize(18)
    .fontColor(this.changeTextColorByIndex(index))
    .fontWeight(this.changeTextWeightByIndex(index))
  }

  func tabOnChange(index: UInt32) {
    if (currentIndex != Int64(index)) {
      this.currentIndex = Int64(index)
    }
  }

  //根据用户的点击index更改contentItem中的字体的颜色
  func changeTextColorByIndex(index: Int64): CJResource {
    match (this.currentIndex == index) {
      case true => @r(app.color.light_black)
      case _ => @r(app.color.message_text_color)
    }
  }

  func changeTextWeightByIndex(index: Int64): FontWeight {
    match (this.currentIndex == index) {
      case true => FontWeight.Bold
      case _ => FontWeight.Normal
    }
  }

  //根据用户点击index控制item的底部边框显隐
  func changeItemBorderColorByIndex(index: Int64): Color {
    match (this.currentIndex == index) {
      case true => Color.BLACK
      case _ => Color.TRANSPARENT
    }
  }
  func build() {
    Column() {
      Row() {
        Image(@r(app.media.set))
        .width(25)
        .height(25)
      }.width(100.percent)
      .justifyContent(FlexAlign.End)
      .padding(top:10,bottom:10,right:10)

      Row() {
        Avatar(src: @r(app.media.me), size: 170)
      }.width(100.percent)
      .justifyContent(FlexAlign.Center)

      Text("Admin")
      .fontSize(26)
      .fontWeight(Bold)
      .margin(top:15,bottom:5)

      Text("豆包号:pc66336")
      .fontColor(0x999999)

      Button() {
        Text("编辑个人资料")
      }
      .fontSize(22)
      .shape(ShapeType.Normal)
      .stateEffect(true)
      .width(170)
      .height(40)
      .backgroundColor(0xf5f5f5)
      .borderRadius(10)
      .margin(top:15,bottom:15)

      List() {
        ForEach(
          my_tablist,
          itemGeneratorFunc: {
            item: String, index: Int64 => ListItem() {
              this.contentItem(item, index)
            }.width(25.percent)
            .borderWidth(EdgeWidths(bottom: 2.vp)).borderColor(
              this.changeItemBorderColorByIndex(index))
            .onClick({evt=>
              this.currentIndex = index
              })
            .padding(bottom:15)
          }
        )
      }
      .width(100.percent)
      .height(35)
      .listDirection(Axis.Horizontal)
      .borderWidth(EdgeWidths(bottom: 1.vp))
      .borderColor(0xf3f3f3)
      .padding(left:10,right:10)

      Swiper() {
        Column() {
          MyImage(src: @r(app.media.m1))
          Text_self(text: "你发布的图片、音乐将展示在这里", bot: 20)
          ToCreate()
        }.width(100.percent)
        .height(40.percent)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)

        Column() {
          MyImage(src: @r(app.media.m2))
          Text_self(text: "你创作的图片、音乐将存放在这里", bot: 5)
          Text_self(text: "内容仅你可见", bot: 20)
          ToCreate()
        }.width(100.percent)
        .height(40.percent)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)

         Column() {
          MyImage(src: @r(app.media.m3))
          Text_self(text: "点击创建第一个 AI 智能体", bot: 20)
          Row() {}
          .width(80)
          .height(35)
        }.width(100.percent)
        .height(40.percent)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)

         Column() {
          MyImage(src: @r(app.media.m4))
          Text_self(text: "长按对话中的消息添加收藏", bot: 20)
          Row() {}
          .width(80)
          .height(35)
        }.width(100.percent)
        .height(40.percent)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }.loop(false)
      .index(UInt32(currentIndex))
      .indicator(false)
      .onChange({
        index => tabOnChange(UInt32(index))
      })
    }
  }
}