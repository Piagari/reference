package ohos_app_cangjie_entry

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
internal import ohos_app_cangjie_entry.models.ChatModel
internal import ohos_app_cangjie_entry.utils.HiLog
internal import ohos_app_cangjie_entry.utils.Socket4CJ
import ohos.state_macro_manage.*

@Entry
@Component
class MyView {
    @State
    var chatModelArr: ObservedArrayList<ChatModel> = ObservedArrayList<ChatModel>([])
    @State
    var msg: String = ''
    private let client: Socket4CJ = Socket4CJ()

    func reveive(): Unit {
        spawn { // 创建线程，用于接收Sever发来的消息
            while (true) {
                var len: Int64
                var message: String
                (message, len) = this.client.receiveMsg()
                if (len == 0) { // 判断buffer长度是否为0，若为true，则Sever端关闭，需要跳出循环
                    break
                } else { // 否则接收消息
                    let chatModel: ChatModel = ChatModel("server", message, 1)
                    this.chatModelArr.append(chatModel)
                }
            }
        }
    }

    protected override func aboutToAppear() { // 生命周期函数，页面第一次打开（组件未渲染前）执行
        this.client.connectServer()
        this.reveive() // 创建线程
    }

    protected override func aboutToDisappear() { // 生命周期函数，页面被销毁执行
        this.client.closeClient()
    }

    @Builder
    func compChat(chatModel: ChatModel) { // 消息UI组合，分为接收和发送两种情况
        Row(5.vp) {
            if (1 == chatModel.getSendOrReceive()) {
                Image(@r(app.media.receive_img)).objectFit(ImageFit.Cover).width(40.vp).height(40.vp).borderRadius(
                    10.vp)
                Row() {
                    Text(chatModel.getMsg()).backgroundColor(@r(app.color.background_receive)).padding(10.vp).
                        borderRadius(15.vp).fontSize(18.vp)
                }.width(70.percent).justifyContent(FlexAlign.Start)
                Blank()
            } else {
                Blank()
                Row() {
                    Text(chatModel.getMsg()).backgroundColor(@r(app.color.background_send)).padding(10.vp).borderRadius(
                        10.vp).fontSize(18.vp)
                }.width(70.percent).justifyContent(FlexAlign.End)
                Image(@r(app.media.send_img)).objectFit(ImageFit.Cover).width(40.vp).height(40.vp).borderRadius(10.vp)
            }
        }.width(100.percent).padding(10.vp).alignItems(VerticalAlign.Top)
    }

    func build() {
        Column() {
            Row {
                Text('Socket Demo').fontSize(20.fp).fontWeight(FontWeight.Bold)
            }.width(100.percent).height(5.percent).justifyContent(FlexAlign.Center).expandSafeArea()
            List() {
                ForEach(
                    this.chatModelArr,
                    {
                        item: ChatModel, _: Int64 => ListItem() {
                            this.compChat(item)
                        }
                    }
                )
            }.width(100.percent).height(87.percent).scrollBar(BarState.Off).backgroundColor(
                @r(app.color.background_gay_01)).edgeEffect(EdgeEffect.Spring)
            Row() {
                TextInput(text: this.msg).borderRadius(10.vp).width(75.percent).onChange(
                    {
                    value: String => this.msg = value
                })
                Button("发送").width(20.percent).shape(ShapeType.Normal).backgroundColor(@r(app.color.background_btu)).
                    borderRadius(10.vp).fontSize(16.fp).onClick(
                    {
                    => if ('' != this.msg) {
                        let chat: ChatModel = ChatModel('client', this.msg, 0)
                        this.chatModelArr.append(chat)
                        this.client.sendMsg(msg)
                        this.msg = ''
                    }
                })
            }.height(8.percent).width(100.percent).justifyContent(FlexAlign.SpaceEvenly).expandSafeArea().alignItems(
                VerticalAlign.Center)
        }.height(100.percent).width(100.percent).backgroundColor(@r(app.color.background_gay_02)).expandSafeArea()
    }
}
