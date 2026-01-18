/**
 * Created on 2024/8/26
 */
package ohos_app_cangjie_entry.pages
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import cj_res_entry.*
import ohos.resource_manager.*
import ohos_app_cangjie_entry.components.badge.*
import ohos_app_cangjie_entry.global.*
import ohos_app_cangjie_entry.entity.*
import ohos_app_cangjie_entry.mock.*
import ohos.router.Router
import std.collection.ArrayList
import ohos_app_cangjie_entry.components.chat.*
import ohos_app_cangjie_entry.util.GeneralDataSource
import std.time.*
import std.io.*
import net.http.*
import net.tls.*
import encoding.json.*
import std.console.Console
import encoding.json.stream.*
import ohos.hilog.*

@Entry
@Component
public class ChatView {
  @State var index: Int64 = 0

  @State var resTexts: String = ''

  @State var msgIndex: Int64 = 100

  @State var message: String = ''

  var client: Client = ClientBuilder().build()

  var msgDataSource: GeneralDataSource<Message>= GeneralDataSource<Message>([])

  // 对方user
  @State var targetUser: User = user1

  // 当前的聊天对象
  @State var currentChat: Chat = chat1

  // 消息列表
  @State var msgList: ArrayList<Message> = ArrayList<Message>([])

  @State var messages: StringBuilder =  StringBuilder("""
    {"role": "system", "content": "你是我的全能助手，你的名字叫仓宝"}
  """)

  @State var answ: String = ""

  // 底部各个图标的大小
  let bottomIconSize = 30

  // 显示聊天内容的组件
  @Builder
  func generateChatLine(e: Message, index: Int64) {
    if (e.userId == LOCAL_USER.id) {
      ChatLine(src: LOCAL_USER.avatar, content: e.content, isSelf: true)
    }
    else {
      ChatLine(src: targetUser.avatar, content: e.content, isSelf: false)
    }
  }

  // 这会在渲染组件前执行
  protected override func aboutToAppear() {
    this.targetUser = TARGET_USER.get()
    this.currentChat = CURRENT_CHAT.get()
    this.msgList = ArrayList<Message>(this.currentChat.msgs)
    this.msgDataSource = GeneralDataSource<Message>(msgList)
    var role: String= ""
    for (msg in msgList) {
      if (msg.userId==1) {
        role = "user"
      } else {
        role = "system"
      }
      var rebuMsg = """
        , {"role": "${role}", "content": "${msg.content}"}
      """
      this.messages.append(rebuMsg)
    }
  }

  // 回退的按钮点击
  func onBackBtnClick() {
    Router.back()
  }

  func build() {
    Column() {
      Row() {
        Image(@r(app.media.prev)).fillColor(0x000000)
        .size(width: 30, height: 30)
        .onClick({e: ClickEvent => this.onBackBtnClick()})
        .margin(right: 20)

        Avatar(src: targetUser.avatar, size: 40)

        Column(2) {
          Text(targetUser.username)
          .fontSize(16)
          .maxLines(1)
          .textOverflow(TextOverflow.Ellipsis)
          Row() {
            Text('@'+targetUser.author)
            .fontSize(14)
            .maxLines(1)
            .textOverflow(TextOverflow.Ellipsis)
          }
        }.layoutWeight(1)
        .margin(left: 10)
        .alignItems(HorizontalAlign.Start)
        ImageIcon(src: @r(app.media.phone2), bot: 20)
        ImageIcon(src: @r(app.media.sound), bot: 20)
        ImageIcon(src: @r(app.media.slh), bot: 10)
      }.padding(left: 10, right: 10, bottom: 10)
      .backgroundColor(0xffffff)
      .expandSafeArea(
        types: [SafeAreaType.SYSTEM],
        edges: [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]
      )

      Column() {
        Avatar(src: targetUser.avatar, size: 150)
      }.width(100.percent)
      .justifyContent(FlexAlign.Center)
      .padding(bottom:15)

      Scroll() {
        Column() {
          LazyForEach(msgDataSource, itemGeneratorFunc: { e: Message, index: Int64 =>
            generateChatLine(e, index)
          })
        }.width(100.percent)
        .padding(left: 10, right: 10)
        .alignItems(HorizontalAlign.Start)
      }
      .align(Alignment.TopStart)
      .layoutWeight(1)
      .backgroundColor(0xffffff)

      Column(10) {
        Row() {
          TextInput(text: message,placeholder: '发信息...')
          .fontColor(0x000000)
          .placeholderColor(0x999999)
          .backgroundColor(0xffffff)
          .layoutWeight(1)
          .borderRadius(6.fp)
          .margin(right: 10)
          .onChange { value =>
            message = value
          }

          Button()
          .shape(ShapeType.Normal)
          .height(30)
          .width(30)
          .borderRadius(30)
          .backgroundImage(src:@r(app.media.on))
          .backgroundImageSize(width: 30,height: 30)
          .backgroundColor(0xffffff)
          .onClick {
            if (message.isEmpty()) {
              return
            }
            let time = DateTime.now().toString('yyyy-MM-dd HH:mm:ss')
            msgDataSource.append(Message(this.msgIndex, 1, time,message))
            this.msgIndex = this.msgIndex + 1
            var question = """
              , {"role": "user", "content": "${message}"}
            """
            this.messages.append(question)
            spawn {
              var response = client.chat(messages.toString())
              var tempText2 = ""
              var resText = StringBuilder("")
              while(tempText2 != "[DONE]") {
                let buffer = Array<Byte>(10240, item: 0)
                var length = response.body.read(buffer)
                let rawText = String.fromUtf8(buffer[..length])
                for (tempText in rawText.split("\n")) {
                  tempText2 = if (tempText.startsWith("data: ")) {
                    tempText["data: ".size..]
                  } else {
                    tempText
                  }
                  if (tempText2.size == 0) {
                    continue
                  }
                  if (tempText2 == "[DONE]") {
                    break
                  }
//                  Hilog.info(0, "hilog_test", "******Info: ${tempText}******")
//                  Hilog.info(0, "hilog_test", "******Info2: ${resText}******")
                  resText.append(parseContent(tempText2.toString()).toString())
                  this.resTexts = resText.toString()
                  let time = DateTime.now().toString('yyyy-MM-dd HH:mm:ss')
                  spawn(Main) {
                    if(this.index==0){
                      this.msgIndex = this.msgIndex + 1
                      var answer = Message(this.msgIndex,targetUser.id,time,"")
                      msgDataSource.append(answer)
                      this.index = this.index + 1
                    }
                    else{
                      msgDataSource.set(msgDataSource.totalCount() -1,Message(this.msgIndex, targetUser.id, time,this.resTexts))
                    }
                  }
                }
              }
              this.answ = """
                , {"role": "system", "content": "${this.resTexts}"}
              """
            }
            this.messages.append(this.answ)
//            for (x in messages.toString().split("\n")) {
//                Hilog.info(0, "hilog_test", "******Info3: ${x}******")
//            }
            this.index = 0
            message = ''
          }
        }.shadow(radius: 20, color:Color(0x999999))
        .borderRadius(20)
        .padding(10)
      }.padding(left: 10, right: 10, top: 5)
      .expandSafeArea(
        types: [SafeAreaType.SYSTEM],
        edges: [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]
      )
      .onAppear {
        var config = TlsClientConfig()
        config.verifyMode = TrustAll
        client = ClientBuilder().tlsConfig(config).readTimeout(Duration.Max).build()
      }
      }.width(100.percent)
      .height(100.percent)
      .backgroundColor(0xffffff)
      .expandSafeArea(
        types: [SafeAreaType.SYSTEM],
        edges: [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]
      )
  }
}