package ohos_app_cangjie_entry

import ohos.base.*
import ohos.component.*
import ohos.concurrency.launch
import ohos.hilog.*
import ohos.resource_manager.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import cj_res_entry.*
import ohos_app_cangjie_entry.components.*
import ohos_app_cangjie_entry.chat.*
import ohos_app_cangjie_entry.data.*
import ohos_app_cangjie_entry.util.*
import ohos_app_cangjie_entry.pages.*
import ohos.router.Router

import std.collection.*
import std.fs.*
import std.sync.*
import std.time.*

enum ChatState {
    New | History | Modified
}

enum IOState {
    Empty | Input | Output

    func icon(): CJResource {
        match (this) {
            case Empty => @r(app.media.send_disable)
            case Input => @r(app.media.send_enable)
            case Output => @r(app.media.stop)
        }
    }
}

// 这个组合状态可描述整个对话过程，控制对应 UI 变化
type State = (ChatState, IOState)

extend Button {
    func style(src: CJResource) {
        this.shape(ShapeType.Normal)
            .height(30)
            .width(30)
            .borderRadius(30)
            .backgroundImage(src: src)
            .backgroundImageSize(width: 30, height: 30)
            .backgroundColor(0xffffff)
    }
}

@Entry
@Component
class EntryView {
    @State
    var input: String = ''
    @State
    var output: String = ''
    @State
    var reasons: String = ''
    @State
    var caption: String = '新对话'
    @State
    var state: State = (New, Empty)
    @State
    var expand: Bool = false
    @State
    var currentChat: GeneralDataSource<Message> = GeneralDataSource<Message>()
    // Todo: 当前聊天记录存储在本地 JSON 文件中，最终实现需要对接账户系统
    let filePath = Path("/data/storage/el2/base/haps/entry/files/dataset.json")
    @State
    var chatHistory: GeneralDataSource<Chat> = GeneralDataSource<Chat>(readHistory(filePath))
    // Todo: 实现附件选择和展示功能
    @State
    var filePicked: Bool = false
    @State
    var attachments: GeneralDataSource<(String, FileType)> = GeneralDataSource<(String, FileType)>()

    // 示例使用 SiliconFlow 提供的服务接口
    var robot: LLM = LLM(url: 'https://api.siliconflow.cn/v1/chat/completions',
        // 如果示例自带的密钥失效，请自行注册，https://cloud.siliconflow.cn/account/ak
        key: 'sk-tlezmsoonctmlgidrftejaexidbigllhtoauiltcfkvopofk',
        model: 'deepseek-ai/DeepSeek-V3',
        context: true)
    var taskThread: Option<Future<Unit>> = None
    let swiper: SwiperController = SwiperController()
    let scroller: Scroller = Scroller()

    func loadChat(index: Int64) {
        currentChat.set(chatHistory[index].messages)
        chatHistory[index].messages |> map { item =>
            (item.role, item.content)
        } |> collectArray |> robot.preset
    }

    func appendMessage() {
        if (!reasons.isEmpty() || !output.isEmpty()) {
            currentChat.append(Message(AI, output, reasons))
            output = ''
            reasons = ''
        }
    }

    func appendHistory() {
        match (state) {
            case (Modified, _) =>
                let time = DateTime.now().toString('yyyy/MM/dd')
                let newChat = Chat(time, ArrayList(currentChat.get()))
                chatHistory.append(newChat)
                // Todo: 当前聊天记录存储在本地 JSON 文件中，最终实现需要对接账户系统
                writeHistory(newChat, filePath)
            case _ => ()
        }
    }

    func stopChat() {
        if (let Some(future) <- taskThread) {
            future.cancel()
            future.get()
            taskThread = None
        }
        appendMessage()
    }

    func updateIOState() {
        state = (state[0], if (input.isEmpty()) { Empty } else { Input })
    }

    func resetChat(state: State) {
        stopChat()
        appendHistory()
        currentChat.clear()
        robot.reset()
        input = ''
        this.state = state
    }

    // 发送/终止按钮的行为
    func execute() {
        match (state) {
            // 输入状态 -> 发送请求 -> 输出状态
            case (chatState, Input) =>
                if (let New <- chatState) {
                    caption = input // 新建对话状态 -> 更新标题 -> 对话中状态
                }
                state = (Modified, Output)
            // 输出状态 -> 终止对话 -> 状态重置
            case (_, Output) =>
                stopChat()
                updateIOState()
                return
            // 无输入无输出状态 -> Nothing
            case _ => return
        }
        currentChat.append(Message(I, input, ''))
        input = ''
        // 新建线程发送请求，在流式传输中接收大模型输出
        taskThread = spawn {
            robot.chat(currentChat[-1].content) { slice: String, reason: Bool =>
                if (Thread.currentThread.hasPendingCancellation) {
                    return false
                }
                launch { // 在主线程中将文本更新到显示组件上
                    if (reason) { // reason 标识当前片段是否为思维链内容
                        reasons += slice
                    } else {
                        output += slice
                    }
                    scroller.scrollEdge(Edge.Bottom)
                }
                return true
            }
            // 如果去掉这个条件，则聊天被 resetChat 打断时
            // 下面的协程任务将滞后于 appendHistory 执行，当前消息将丢失
            if (Thread.currentThread.hasPendingCancellation) {
                return
            }
            // 流式传输完成 -> 将完整消息添加到当前对话
            launch {
                appendMessage()
                updateIOState()
            }
        }
    }

    func build() {
        Swiper(swiper) {
            // 侧边栏，历史记录列表 + 账户页面入口
            Column {
                ChatList(chatData: chatHistory, onSelect: { index =>
                    // 从历史记录加载对话
                    resetChat((History, Empty))
                    loadChat(index)
                    caption = currentChat[0].content
                    swiper.showNext()
                })
                UserAvatarLine(src: @r(app.media.user), text: '仓颉')
            }.width(72.percent).height(100.percent).backgroundColor(0xffffff)

            // 聊天主页面
            Column {
                // 标题栏
                Row {
                    // 侧边栏切换按钮
                    Image(@r(app.media.history))
                        .fillColor(0x000000)
                        .size(width: 30, height: 30)
                        .onClick { _ => swiper.showPrevious() }
                    // 对话标题
                    Row {
                        Text(caption)
                            .fontSize(17)
                            .fontWeight(Bold)
                            .maxLines(1)
                            .textOverflow(TextOverflow.Ellipsis)
                    }.width(75.percent).justifyContent(FlexAlign.Center)
                    // 右上角新建对话按钮
                    Image(@r(app.media.new)).fillColor(0x000000).size(width: 30, height: 30)
                    .onClick { _ =>
                        resetChat((New, Empty))
                        caption = '新对话'
                    }
                }.width(100.percent)
                .padding(left: 5, right: 5, bottom: 15, top: 5)
                .justifyContent(FlexAlign.SpaceBetween)
                .backgroundColor(0xffffff)
                .expandSafeArea(
                    types: [SafeAreaType.SYSTEM],
                    edges: [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]
                )

                // 新聊天页面中间的 Slogan
                if (let (New, _) <- state) {
                    Slogan()
                }

                // 对话消息呈现
                Scroll(scroller) {
                    Column(20) {
                        LazyForEach(currentChat, itemGeneratorFunc: { item: Message, _: Int64 =>
                            if (let AI <- item.role) {
                                MessageLine(content: item.content, reason: item.reason, self: false)
                            } else {
                                MessageLine(content: item.content, reason: item.reason, self: true)
                            }
                        })
                        // 流式输出框使用独立组件控制，可避免整体刷新产生的屏闪问题
                        if (let (Modified, Output) <- state) {
                            MessageLine(content: output, reason: reasons, self: false)
                        }
                    }.padding(top: 0, bottom: 20)
                }
                .align(Alignment.TopStart)
                .layoutWeight(1)
                .backgroundColor(0xffffff)
                .onClick { _ => swiper.showNext() }

                // 底部输入区
                Column(10) {
                    // 1.被选择的附件
                    // Todo: 用户选择图片或文件的功能还未实现，但附件浮动在输入框上的 UI 已实现
                    FileLine(dataList: attachments, choiceState: filePicked)
                    // 2.输入框
                    Row {
                        TextInput(text: input, placeholder: '给 DeepSeek 发送消息')
                        .height(50)
                        .fontColor(0x717171)
                        .backgroundColor(0xf5f5f5)
                        .layoutWeight(1)
                        .borderRadius(50)
                        .margin(bottom: 10)
                        .onChange { value =>
                            input = value
                            match (state[1]) {
                                case Output => () // 输出状态 -> 控制按钮处于终止状态
                                case _ => updateIOState() // 其他状态 -> 更新发送按钮可用状态
                            }
                        }
                    }
                    // 3.控制栏
                    Row {
                        Row {
                            Switch(caption: '深度思考 (R1)',
                                onImage: @r(app.media.deepthink_on),
                                offImage: @r(app.media.deepthink_off),
                                onChange: { on: Bool =>
                                    robot.changeModel(if (on) {
                                        'deepseek-ai/DeepSeek-R1'
                                    } else {
                                        'deepseek-ai/DeepSeek-V3'
                                    })
                            })
                            Row().width(5)
                            // Todo: 实现联网搜索，并增加对应图标
                            Switch(caption: '联网搜索',
                                onImage: @r(app.media.net),
                                offImage: @r(app.media.net))
                        }.width(70.percent)
                        .justifyContent(FlexAlign.Start)

                        Row {
                            // 展开&折叠附件选择栏
                            Button()
                                .style(if (expand) { @r(app.media.close) } else { @r(app.media.add) })
                                .onClick { expand = !expand }
                            Row().width(5)
                            // 发送消息&终止对话
                            Button()
                                .style(state[1].icon())
                                .onClick { execute() }
                        }.width(30.percent)
                        .justifyContent(FlexAlign.End)
                    }
                    // 4.附件选择栏，拍照/图片/文件
                    if (expand) {
                        Row {
                            Selector(@r(app.media.cam), "拍照识文字")
                            Selector(@r(app.media.pic), "图片识文字", onClick: { =>
                                // Todo: 打开相册选择图片，对接相关服务转文字，作为提问的背景信息
                            })
                            Selector(@r(app.media.attachment), "文件", onClick: { =>
                                // Todo: 打开文件管理器选择文件，对接相关服务转文字，作为提问的背景信息
                            })
                        }
                        .width(100.percent)
                        .padding(left: 5, right: 5, top: 12)
                        .justifyContent(FlexAlign.SpaceBetween)
                    }
                }
                .width(100.percent)
                .justifyContent(FlexAlign.SpaceBetween)
                .alignItems(HorizontalAlign.Start)
            }.padding(left: 10, right: 10, top: 5)
        }
        .width(100.percent)
        .height(100.percent)
        .backgroundColor(0xffffff)
        .expandSafeArea(
            types: [SafeAreaType.SYSTEM],
            edges: [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]
        )
        .index(1)
        .displayMode(SwiperDisplayMode.AutoLinear)
        .loop(false)
        .indicator(false)
    }
}
