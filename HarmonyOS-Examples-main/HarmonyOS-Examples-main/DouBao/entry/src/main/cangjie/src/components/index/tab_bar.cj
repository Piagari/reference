/**
 * Created on 2024/8/26
 */
package ohos_app_cangjie_entry.components.index

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.resource_manager.*
import cj_res_entry.app
import ohos_app_cangjie_entry.components.badge.*
@CustomDialog
class MyDialog {
  var controller: Option<CustomDialogController> = Option.None

  func build() {
    Column() {
      Button().onClick { evt =>
        controller?.close()
      }.width(50).height(5)
      .backgroundColor(0xffffff)
      .backgroundImage(src:@r(app.media.heng))
      .backgroundImageSize(width:50,height:5)
      .margin(bottom:30)

      TheOptions(src: @r(app.media.c1), text: "创建 AI 智能体")

      TheOptions(src: @r(app.media.c2), text: "AI 生图")

      TheOptions(src: @r(app.media.c3), text: "AI 写真")

      TheOptions(src: @r(app.media.c4), text: "音乐生成")
    }.height(440).width(100.percent).backgroundColor(0xffffff)
    .borderRadius(20)
    .shadow(radius: 10, color:Color(0xececec))
    .justifyContent(FlexAlign.Center)
  }
}

class TabData {
  public TabData(let src: CJResource,let src2: CJResource, let title: String) {}
}


@Component
public class TabBtn{
  var dialogController: CustomDialogController = CustomDialogController(CustomDialogControllerOptions(builder: MyDialog(), alignment:DialogAlignment.Bottom,customStyle:true, backgroundColor: Color.WHITE,maskColor:Color(0x11000000)))

  // 图标资源
  @Prop var src: CJResource

  // 图标下面的文本
  @Prop var title: String

  func build() {
    if (title == '创作'){
      Column() {
        Image(src)
        .size(width: 25, height: 25)
        .fillColor(0x000000)
        .margin(bottom:5)
        Text(title).fontSize(10).fontColor(0x000000)
      }
      .onClick({ e: ClickEvent =>  dialogController.`open`()})
    }
    else{
      Column() {
        Image(src)
        .size(width: 25, height: 25)
        .fillColor(0x000000)
        .margin(bottom:5)
        Text(title).fontSize(10).fontColor(0x000000)
      }
    }

  }
}

@Component
public class TabBar {
  // 当前活跃的Tab的序号
  @Link var activeInd: Int64

  // 点击Tab的响应函数
  func tabOnClick(index: Int64) {
    this.activeInd = index;
  }

  let dataSource = Array<TabData>([
    TabData(@r(app.media.message), @r(app.media.message2), "对话"),
    TabData(@r(app.media.select), @r(app.media.select2), "发现"),
    TabData(@r(app.media.aivideo), @r(app.media.aivideo), "创作"),
    TabData(@r(app.media.collect), @r(app.media.collect2), "通知"),
    TabData(@r(app.media.i), @r(app.media.i2), "我的")
  ])

  func build() {
    Row() {
      ForEach(dataSource, itemGeneratorFunc: { elem: TabData, index: Int64 =>
        Column() {
          if (index == activeInd) {
            TabBtn(src: elem.src2, title: elem.title)
          } else {
            TabBtn(src: elem.src, title: elem.title)
          }
        }.onClick({ e: ClickEvent => tabOnClick(index) })
      })
    }.width(100.percent).padding(left: 20, right: 20, top: 10)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Top)
    .backdropBlur(5)
  }
}