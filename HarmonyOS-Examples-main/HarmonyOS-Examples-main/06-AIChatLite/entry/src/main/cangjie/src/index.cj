package ohos_app_cangjie_entry

import ohos.base.*
import ohos.component.*
import ohos.state_macro_manage.*
import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.concurrency.launch
import cj_res_entry.*

import ohos_app_cangjie_entry.model.*
import ohos_app_cangjie_entry.utils.*
import ohos_app_cangjie_entry.components.ChatBlock
import std.time.*

extend Image {
    public func size() {
        this.size(width: 30, height: 30)
    }
}

@Entry
@Component
class EntryView {
    let now = { => DateTime.now().toString('yyyy-MM-dd HH:mm:ss') }
    @State var input: String = ''
    @State var talking: Message = Message('', You, now())
    let messages = GeneralDataSource<Message>([
        Message("你好，我是仓宝", You, now()),
        Message("很高兴认识你", Me, now())
    ])
    let llm = LLM(url: 'https://api.siliconflow.cn/v1/chat/completions',
        key: 'sk-ujrvulmnsdiolckgtjklhqbwbkfudgeglrkxxbzljagbtrnk',
        model: 'deepseek-ai/DeepSeek-V3.1-Terminus',
        memory: true)
    let scroller: Scroller = Scroller()

    func build() {
        Column() {
            Row() {
                Column() {
                    Text("仓宝")
                    Text("Mate 70 Pro").fontSize(10)
                }
            }.width(100.percent)
            .padding(left: 10, right: 10, bottom: 10)
            .justifyContent(FlexAlign.Center)
            .backgroundColor(0xffffff)
            .expandSafeArea(
                types: [SafeAreaType.SYSTEM],
                edges: [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]
            )

            Scroll(scroller) {
                Column(20) {
                    LazyForEach(messages, itemGeneratorFunc: { value: Message, _: Int64 =>
                         ChatBlock(message: value)
                    })
                    if (!talking.content.isEmpty()) {
                        ChatBlock(message: talking)
                    }
                }.padding(top: 20, bottom: 20)
            }.align(Alignment.TopStart)
            .layoutWeight(1)
            .backgroundColor(Color(238, 237, 242))

            Column(10) {
                Row() {
                    TextInput(text: input)
                    .fontColor(0x000000)
                    .backgroundColor(0xffffff)
                    .layoutWeight(1)
                    .borderRadius(6.fp)
                    .margin(right: 10)
                    .onChange { value =>
                        input = value
                    }

                    Button("发送").shape(ShapeType.Normal)
                    .height(40)
                    .width(60)
                    .fontSize(12)
                    .fontColor(0xffffff)
                    .borderRadius(6.fp)
                    .backgroundColor(Color(67, 151, 247))
                    .onClick {
                        if (input.isEmpty()) {
                            return
                        }
                        messages.append(Message(input, Me, now()))
                        let text = input
                        spawn {
                            llm.chats(text) { slice: String =>
                                launch {
                                    talking = Message(talking.content + slice, You, talking.time)
                                    scroller.scrollEdge(Edge.Bottom) // 页面随消息扩展向下滚动
                                }
                            }
                            launch {
                                messages.append(Message(talking.content, You, now()))
                                talking = Message('', You, now())
                            }
                        }
                        input = ''
                    }
                }

                Row() {
                    Image(@r(app.media.microphones)).size()
                    Image(@r(app.media.image)).size()
                    Image(@r(app.media.camera)).size()
                    Image(@r(app.media.red_gift)).size()
                    Image(@r(app.media.emotion_happy_line)).size()
                    Image(@r(app.media.chatview_add_icon))
                    .size(width: 26, height: 26)
                }.width(100.percent)
                .alignItems(VerticalAlign.Center)
                .justifyContent(FlexAlign.SpaceBetween)
            }.padding(left: 10, right: 10, top: 5)
            .expandSafeArea(
                types: [SafeAreaType.SYSTEM],
                edges: [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]
            )
        }.width(100.percent)
        .height(100.percent)
        .backgroundColor(Color(242, 241, 247))
        .expandSafeArea(
            types: [SafeAreaType.SYSTEM],
            edges: [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]
        )
    }
}
