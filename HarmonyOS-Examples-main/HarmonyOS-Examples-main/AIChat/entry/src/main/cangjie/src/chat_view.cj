package ohos_app_cangjie_entry

internal import ohos.base.BusinessException
internal import ohos.base.Color
internal import ohos.base.CJResource
internal import ohos.base.__GenerateResource__
internal import ohos.base.LengthProp
internal import ohos.base.Length
import ohos.concurrency.launch
internal import ohos.component.Alignment
internal import ohos.component.ClickEvent
internal import ohos.component.Column
internal import ohos.component.Row
internal import ohos.component.Button
internal import ohos.component.Flex
internal import ohos.component.FlexAlign
internal import ohos.component.FlexDirection
internal import ohos.component.FlexParams
internal import ohos.component.ForEach
internal import ohos.component.TextArea
internal import ohos.component.TextInput
internal import ohos.component.Text
internal import ohos.component.LazyForEach
internal import ohos.component.ItemAlign
internal import ohos.component.List
internal import ohos.component.ListItem
internal import ohos.component.BarPosition
internal import ohos.component.CustomView
internal import ohos.component.CJEntry
internal import ohos.component.FontWeight
internal import ohos.component.FakeComponent
internal import ohos.component.NestedScrollMode
internal import ohos.component.NestedScrollOptions
internal import ohos.component.loadNativeView
internal import ohos.component.LegalCallCheck
internal import ohos.component.If
internal import ohos.component.Image
internal import ohos.component.HorizontalAlign
internal import ohos.component.Scroll
internal import ohos.component.Scroller
internal import ohos.component.ScrollDirection
internal import ohos.component.Edge
internal import ohos.component.ShapeType
internal import ohos.component.SafeAreaEdge
internal import ohos.component.SafeAreaType
internal import ohos.component.SourceType
internal import ohos.component.StickyStyle
internal import ohos.component.TextAlign
internal import ohos.component.ViewBuilder
internal import ohos.component.VerticalAlign
internal import ohos.prompt_action.*
internal import ohos.state_manage.LocalStorage
internal import ohos.state_manage.ObservedArrayList
internal import ohos.state_manage.ObservedProperty
internal import ohos.state_manage.SubscriberManager
internal import ohos.state_manage.ViewStackProcessor
// custom import
import ohos_app_cangjie_entry.view.ChatLine

import ohos.state_macro_manage.Entry
import ohos.state_macro_manage.Component
import ohos.state_macro_manage.State
import ohos.state_macro_manage.r
import ohos.state_macro_manage.Builder
import ohos.net.http.*
import ohos.hilog.Hilog
import ohos.router.Router
import std.collection.HashMap
import std.collection.ArrayList
import encoding.json.stream.*
import std.io.ByteArrayStream
import std.time.Duration
import std.sync.sleep
import ohos.preferences.*
import encoding.json.JsonObject
import encoding.json.JsonValue
import encoding.json.JsonInt
import encoding.json.JsonString
import std.time.DateTime
import std.time.DateTimeFormat
import ohos.relational_store.getRdbStore
import ohos.relational_store.RdbStore
import ohos.relational_store.StoreConfig
import ohos.relational_store.SecurityLevel
import ohos.relational_store.ValueType as RelationValueType
import std.collection.Map
import ohos.i18n.getAppPreferredLanguage


// custom project
import ohos_app_cangjie_entry.components.Avatar
// import markdown.components.*


@Entry
@Component
class ChatView {
    // user input
    @State
    var prompt: String = ""
    var env_info: EnvInfo = EnvInfo()
    var max_tokens: Int64 = 2048
    var temperature: Float64 = 0.7
    var chat_timeout: Int64 = 120
    var top_p: Float64 = 1.0
    var stream: Bool = false
    // temp var
    var system_prompt: String = ""
    @State
    var temp_user_content: String = ""
    @State
    var temp_assistant_content: String = ""
    @State
    var blank_height: Length = 0.percent
    // total message
    @State
    var messages: MessageDataSource = MessageDataSource(ArrayList<Message>([
         Message(RoleType.System, this.system_prompt)
    ]))
    // var messages: ObservedArrayList<Message> = ObservedArrayList<Message>([
    //     Message(RoleType.System, this.system_prompt)
    // ])
    @State
    var message_size: Int64 = 1
    // hisotry
    var history: ArrayList<(String, String)> = ArrayList<(String, String)>([])
    let user_avatar: CJResource = @r(app.media.user_avatar)
    let bot_avatar: CJResource = @r(app.media.bot_avatar)

    let scroller = Scroller()

    @State
    var dialog_id = 0
    @State
    var dialog_topic = ""
    @State
    var message_count = 0  // 消息数据量，包含system_prompt
    @State
    var max_id: Int64 = 0
    // 关系数据库连接信息
    var rdb_store_option: Option<RdbStore> = None
    // 用户偏好语言
    @State
    var language = ""


    func get_now_time(): String {
        return DateTime.now().toString(DateTimeFormat.of("yyyy-MM-dd HH:mm:ss"))
    }

    func query_max_id(): Int64 {
        // 获取数据库Message表里面的最大id
        let select_sql = '''
        SELECT max(id) as max_id FROM Message
        '''
        let bind_data: Array<RelationValueType> = Array<RelationValueType>([])
        try {
            let result_set = this.rdb_store_option.getOrThrow().querySql(select_sql, bindArgs: bind_data);
            if (result_set.goToNextRow()) {
               return result_set.getLong(result_set.getColumnIndex("max_id"))
            } else {
                return 0;
            }
        } catch (e: Exception){
            Hilog.error(0, "==DB Query==", "can't get max id in Message, error: ${e.toString()}");
            return 0;
        }
    }

    func insert_db_new_message(role: RoleType, content: String) {
        // 往数据库里面插入新数据
        try {
            let new_data = HashMap<String, RelationValueType>([
                ("id", RelationValueType.integer(this.max_id + 1)),
                ("fk_dialog_id", RelationValueType.integer(this.dialog_id)),
                ("role", RelationValueType.string(role_type_to_str(role).getOrThrow())),
                ("content", RelationValueType.string(content)),
                ("datetime", RelationValueType.string(this.get_now_time()))
            ])
            let result: Int64 = this.rdb_store_option.getOrThrow().insert("Message", new_data)
            this.rdb_store_option.getOrThrow().commit();
            // 顺便更新一下max_id和message_count
            this.max_id += 1
            this.message_count += 1
            Hilog.info(0, "==DB insert==", "insert new dialog ok, dialog id: ${result}, roleType: ${role_type_to_str(role)}, content: ${content}");
        } catch (e: Exception) {
            Hilog.error(0, "==DB insert==", "insert data to Message Table failed, error: ${e.toString()}")
        }
    }

    func clear_db_message() {
        try {
            let delete_sql = "DELETE FROM Message WHERE fk_dialog_id = ${this.dialog_id}"
            this.rdb_store_option.getOrThrow().executeSql(delete_sql)
            this.rdb_store_option.getOrThrow().commit();
            Hilog.info(0, "==DB delete==", "clear message, dialog id: ${this.dialog_id}");
        } catch (e: Exception) {
            Hilog.error(0, "==DB delete==", "clear message failed, error: ${e.toString()}")
        }
    }

    func get_message_count(fk_dialog_id: Int64): Int64 {
        // 获取数据库Message表里面的指定fk_dialog_id所拥有的消息数量
        let select_sql = "SELECT count(*) as message_count FROM Message WHERE fk_dialog_id = ${dialog_id}"
        let bind_data: Array<RelationValueType> = Array<RelationValueType>([])
        try {
            let result_set = this.rdb_store_option.getOrThrow().querySql(select_sql, bindArgs: bind_data);
            if (result_set.goToNextRow()) {
                let message_count = result_set.getLong(result_set.getColumnIndex("message_count"))
                Hilog.info(0, "==DB Query==", "message count in Message for dialog id ${dialog_id} count: ${message_count}")
                if (message_count >= 1) {
                    return message_count - 1
                } else {
                    return 0
                }
            } else {
                return 0;
            }
        } catch (e: Exception){
            Hilog.error(0, "==DB Query==", "can't get message count in Message, error: ${e.toString()}");
            return 0;
        }
    }

    func update_message_count(dialog_id: Int64, message_count: Int64) {
        // 更新数据库Dialog表里面的message_count字段
        let update_dialog_sql: String = "UPDATE Dialog SET message_count = ${message_count} WHERE id = ${dialog_id}"
        try {
            this.rdb_store_option.getOrThrow().executeSql(update_dialog_sql)
            this.rdb_store_option.getOrThrow().commit()
            Hilog.info(0, "==UPDATE DB==", "update dialog success!, changed id: ${dialog_id}, changed message_count: ${message_count}")
        } catch (e: Exception) {
            Hilog.error(0, "==UPDATE DB==", "update dialog message failed, error: ${e.toString()}")
        }
    }

    func update_dialog_topic() {
        // 更新数据库Dialog表里面的dialog字段
        let update_dialog_sql: String = '''
            UPDATE Dialog SET topic = "${this.dialog_topic}" WHERE id = ${this.dialog_id}
        '''
        try {
            this.rdb_store_option.getOrThrow().executeSql(update_dialog_sql)
            this.rdb_store_option.getOrThrow().commit()
            Hilog.info(0, "==UPDATE DB==", "update dialoa success!, changed id: ${dialog_id}, changed dialog: ${this.dialog_topic}")
        } catch (e: Exception) {
            Hilog.error(0, "==UPDATE DB==", "update dialog message failed, sql: ${update_dialog_sql}, error: ${e.toString()}")
        }
    }

    protected func onPageShow() {
        // 先获取用户偏好语言
        this.language = getAppPreferredLanguage()
        Hilog.info(0, "==Language==", "chat view language is ${this.language}")
        // model generator config
        var model: String = ""
        var api_key: String = ""
        var base_url: String = ""
        var system_prompt: String = ""
        let params: JsonObject = Router.getParamsObject()
        let dialog_id_option: Option<JsonValue> = params.get("dialog_id")
        let dialog_topic_option = params.get("dialog_topic")
        let message_count_option = params.get("message_count")
        match (dialog_id_option) {
            case Some(temp_value) =>
                try {
                    let temp_int = temp_value.asInt()
                    this.dialog_id = temp_int.getValue()
                } catch (_) {
                    Hilog.error(0, "==JSON ERROR==", "can't tranfer json value to int")
                }
            case _ => ()
        }
        match (dialog_topic_option) {
           case Some(temp_value) =>
                try {
                    let temp_str = temp_value.asString()
                    this.dialog_topic = temp_str.getValue()
                } catch (_) {
                    Hilog.error(0, "==JSON ERROR==", "can't tranfer json value to string")
                }
            case _ => ()
        }
        match (message_count_option) {
           case Some(temp_value) =>
                try {
                    let temp_str = temp_value.asInt()
                    let temp_message_count: Int64 = temp_str.getValue()
                    if (temp_message_count > 0) {
                        // 需要加上system_prompt这一条数据
                        this.message_count = temp_message_count + 1
                    }
                } catch (_) {
                    Hilog.error(0, "==JSON ERROR==", "can't tranfer json value to string")
                }
            case _ => ()
        }
        Hilog.info(0, "==DIALOG INFO==", "dialog_id: ${this.dialog_id}, dialog_topic: ${this.dialog_topic}")
        var my_preference = Preferences.getPreferences(getContext(), "save")
        // model
        if (my_preference.has("model")) {
            match(my_preference.get("model", ValueType.string(""))) {
                case ValueType.string(temp_str) => model = temp_str
                case _ => ()
            }
        }
        // api_key
        if (my_preference.has("api_key")) {
            match(my_preference.get("api_key", ValueType.string(""))) {
            case ValueType.string(temp_str) => api_key = temp_str
            case _ => ()
            }
        }
        // base_url
        if (my_preference.has("base_url")) {
            match(my_preference.get("base_url", ValueType.string(""))) {
                case ValueType.string(temp_str) => base_url = temp_str
                case _ => ()
            }
        }
        // system_prompt
        if (my_preference.has("system_prompt")) {
            match(my_preference.get("system_prompt", ValueType.string(""))) {
                case ValueType.string(temp_str) => this.system_prompt = temp_str
                case _ => ()
            }
        }
        // chat timeout
        if (my_preference.has("chat_timeout")) {
            match(my_preference.get("chat_timeout", ValueType.integer(120))) {
                case ValueType.integer(temp_int) => this.chat_timeout = temp_int
                case _ => ()
	  		}
        }
        this.env_info = EnvInfo(model, api_key, base_url, system_prompt)
        // max_tokens
        if (my_preference.has("max_tokens")) {
            match(my_preference.get("max_tokens", ValueType.integer(0))) {
                case ValueType.integer(temp_int) => this.max_tokens = temp_int
                case _ => ()
            }
        }
        // temperature
        if (my_preference.has("temperature")) {
            match(my_preference.get("temperature", ValueType.double(0.0))) {
                case ValueType.double(temp_float) => this.temperature = temp_float
                case _ => ()
            }
        }
        // top_p
        if (my_preference.has("top_p")) {
            match(my_preference.get("top_p", ValueType.double(0.0))) {
                case ValueType.double(temp_float) => this.top_p = temp_float
                case _ => ()
            }
        }
        // stream
        if (my_preference.has("stream")) {
            match(my_preference.get("stream", ValueType.bool(false))) {
                case ValueType.bool(temp_bool) => this.stream = temp_bool
                case _ => ()
            }
        }
        // 连接关系数据库
        if (this.rdb_store_option.isNone()) {
            this.rdb_store_option = Some(getRdbStore(getContext(), StoreConfig("ai_chat.db", SecurityLevel.S1)));
        }
        // 更新最大id
        this.max_id = this.query_max_id();
        Hilog.info(0, "==On Page Show==", "max id is ${this.max_id}, message_count: ${this.message_count}")
        // 从数据库查询历史数据填充messages和history
        if (this.history.size == 0 && this.messages.totalCount() <= 1) {
            try {
                let message_select_sql: String = "SELECT id, role, content, datetime FROM Message WHERE fk_dialog_id = ${this.dialog_id}"
                launch {
                    let bind_data: Array<RelationValueType> = Array<RelationValueType>([])
                    let result_set = this.rdb_store_option.getOrThrow().querySql(message_select_sql, bindArgs: bind_data)
                    // 将查询结果给this.messages,方便数据展示
                    while (result_set.goToNextRow()) {
                        let temp_role_str = result_set.getString(result_set.getColumnIndex("role"))
                        if (temp_role_str == "system") {
                            continue
                        }
                        let temp_role: RoleType = str_to_role_type(Some(temp_role_str));
                        let temp_content = result_set.getString(result_set.getColumnIndex("content"))
                        // Todo 后面再将对话时间加上UI上面，目前暂时用不到
                        let temp_datetime = result_set.getString(result_set.getColumnIndex("datetime"))
                        launch {
                            this.messages.addData(Message(temp_role, temp_content))
                            this.scroller.scrollEdge(Edge.Bottom)
                        }
                    }
                    // 顺便也更新一下history
                    for (i in 1..this.messages.totalCount():2) {
                        launch {
                            this.history.append((this.messages.getData(i).content, this.messages.getData(i + 1).content))
                        }
                    }
                }
            } catch (e: Exception) {
                Hilog.error(0, "==DB query==", "failed select data from Message Table, error: ${e.toString()}")
            }
        }
        // 如果是新对话，插入一条system_prompt
        if (this.message_count == 0) {
            this.insert_db_new_message(RoleType.System, this.system_prompt)
        }
    }



    @Builder
    func generate_chatLine(msg: Message, index: Int64) {
        if (index == 0) {
            // todo system prompt process
        } else if (index % 2 == 1) {
            ChatLine(src: user_avatar, content: msg.content, is_self: true)
        } else {
            ChatLine(src: bot_avatar, content: msg.content, is_self: false)
        }
    }

    public func sumarize_topic() {
        // 对会话主题做总结，基于前2条/4条对话数据
        if (this.history.size >= 1 && this.history.size<=2)  {
            try {
                let summarize_prompt = if (this.language == "zh-Hans" || this.language == "zh-Hant") {
                   "使用四到五个字直接返回这句话的简要主题，不要解释、不要标点、不要语气词、不要多余文本，不要加粗，如果没有主题，请直接返回“闲聊”"
                } else {
                    "Please generate a four to five word title summarizing our conversation without any lead-in, punctuation, quotation marks, periods, symbols, bold text, or additional text. Remove enclosing quotation marks."
                }
                Hilog.info(0, "===AIChat===", "summarize prompt is ${summarize_prompt}")
                Hilog.info(0, "===AIChat===", "history is ${this.history.size}")
                let response: Option<String> = chat(
                    summarize_prompt,
                    this.env_info,
                    this.history,
                    this.max_tokens,
                    this.temperature,
                    this.top_p,
                    timeout: this.chat_timeout
                )
                match (response) {
                    case Some(res: String) =>
                        // update topic
                        launch {
                            if (res.size > 0) {
                                this.dialog_topic = res
                                // 顺手更新一下数据库的信息
                                this.update_dialog_topic()
                            }
                        }
                        Hilog.info(0, "===AIChat===", "change dialog topic to ${res}")
                    case None =>
                        Hilog.error(0, "AIChat", "can't get Response")
                        PromptAction.showToast(message: "Do summarize get error! call api failed, can't get Response \n 会话总结出现错误！调用接口失败，未收到任何返回。")
                }
            } catch (e: Exception) {
                  Hilog.error(0, "AIChat", "Network error")
                  PromptAction.showToast(message: "Error! Network error \n 错误！网络异常。")
            }
        }
    }

    public func chat_callback()                             {
        // 非流式对话的回调函数
        spawn {
            if (this.prompt.size > 0)  {
                try {
                    // add user message
                    let temp_prompt: String = this.prompt
                    launch {
                        this.temp_user_content = this.prompt
                        this.prompt = ""
                    }
                    // Hilog.error(0, "response", "prompt: ${temp_prompt}")
                    // Hilog.error(0, "response", "url: ${env_info.base_url}")
                    this.messages.addData(Message(RoleType.User, "${this.temp_user_content}"))
                    // 滑到底部
                    this.scroller.scrollEdge(Edge.Bottom)
                    let response: Option<String> = chat(
                        temp_prompt,
                        this.env_info,
                        this.history,
                        this.max_tokens,
                        this.temperature,
                        this.top_p,
                        timeout: this.chat_timeout
                    )
                    // Hilog.error(0, "response", "response: ${response}")
                    match (response) {
                        case Some(res: String) =>
                            // Hilog.error(0, "res", "res: ${res}")
                            // update message and history
                            launch {
                                this.messages.addData(Message(RoleType.Assistant, res))
                                // 滑到底部
                                this.scroller.scrollEdge(Edge.Bottom)
                                this.history.append(("${this.temp_user_content}", res))
                                // 顺便更新数据库
                                this.insert_db_new_message(RoleType.User, this.temp_user_content)
                                this.insert_db_new_message(RoleType.Assistant, res)
                                this.update_message_count(this.dialog_id, this.messages.totalCount() - 1)
                                this.temp_user_content = ""
                                // 顺便更新标题
                                this.sumarize_topic()
                            }
                        case None =>
                            Hilog.error(0, "AIChat", "can't get Response")
                            PromptAction.showToast(message: "Error! call api failed, can't get Response \n 错误！调用接口失败，未收到任何返回。")
                    }
                } catch (e: Exception) {
                      Hilog.error(0, "AIChat", "Network error")
                      this.messages.addData(Message(RoleType.Assistant, ""))
                      // 滑到底部
                      this.scroller.scrollEdge(Edge.Bottom)
                      PromptAction.showToast(message: "Error! Network error \n 错误！网络异常。")
                }
                launch {
                  this.temp_user_content = ""
                }
            }
        }
    }

    public func stream_chat_callback() {
        // 流式对话的回调函数
        spawn {
            if (this.prompt.size > 0)  {
                // add user message
                let temp_prompt = this.prompt
                launch {
                    this.temp_user_content = this.prompt
                    this.messages.addData(Message(RoleType.User, "${this.temp_user_content}"))
                    // empty response
                    this.messages.addData(Message(RoleType.Assistant, ""))
                    // 滑到底部
                    this.scroller.scrollEdge(Edge.Bottom)
                    this.prompt = ""
                }
                let (request, client) = build_http_client(
                    temp_prompt,
                    this.env_info,
                    this.history,
                    this.max_tokens,
                    this.temperature,
                    this.top_p,
                    stream: true,
                    timeout: this.chat_timeout
                )
                var temp_text2 = ""
                try {
                    // call api
                    let response = client.send(request)
                    // read result
                    let buffer = Array<Byte>(10240, item: 0)
                    var finish_reason: Option<String> = None
                    var length = 0
                    var total_length = 0
                    while(finish_reason.isNone() && temp_text2 != "[DONE]") {
                        length = response.body.read(buffer)
                        total_length += length
                        let raw_text = String.fromUtf8(buffer[..length])
                        // Hilog.info(0, "raw_text", "=== length: ${length} / ${total_length} raw text: ${raw_text} ===")
                        for (temp_text in raw_text.split("\n")) {
                            temp_text2 =  if (temp_text.startsWith("data: ")) {
                                temp_text["data: ".size..]
                            } else {
                                temp_text
                            }
                            // Hilog.info(0, "temp_text", "=== temp text: ${temp_text} ===")
                            if (temp_text2.size == 0) {
                                continue
                            }
                            if (temp_text2 == "[DONE]") {
                                break
                            }
                            // Hilog.error(0, "stream", "temp_text: ${temp_text2}")
                            var input_stream = ByteArrayStream()
                            input_stream.write(temp_text2.toArray())
                            // convert text to ChatResponse object
                            let json_reader = JsonReader(input_stream)
                            let res_object = ChatResponse.fromJson(json_reader)
                            let choices: ArrayList<Choice> = res_object.choices
                            if (choices.size > 0) {
                                finish_reason = choices[0].finish_reason
                                // Hilog.error(0, "stream", "finish reason: ${finish_reason}")
                                if (finish_reason.isNone()) {
                                    let delta = choices[0].delta.getOrThrow()
                                    let message_count = this.messages.totalCount()
                                    // message to add delta content
                                    launch{
                                        this.temp_assistant_content += delta.content
                                        // update stream response
                                        this.messages.replaceData(message_count -  1, Message(RoleType.Assistant, "${this.temp_assistant_content}"))
                                        // 滑到底部
                                        this.scroller.scrollEdge(Edge.Bottom)
                                    }
                                }
                            }
                        }
                    }
                    // update messages and history
                    launch {
                        this.history.append(("${this.temp_user_content}", "${this.temp_assistant_content}"))
                        // 顺便更新数据库
                        this.insert_db_new_message(RoleType.User, this.temp_user_content)
                        this.insert_db_new_message(RoleType.Assistant, this.temp_assistant_content)
                        this.update_message_count(this.dialog_id, this.messages.totalCount() - 1)
                        this.temp_user_content = ""
                        this.temp_assistant_content = ""
                        // 顺便更新标题
                        this.sumarize_topic()
                    }
                } catch (e: Exception) {
                    Hilog.error(0, "error", "ERROR: ${e.message}, reviced text: ${temp_text2}")
                    // 中途中断，不做警告
                    if (this.temp_assistant_content.size == 0) {
                        launch {
                            PromptAction.showToast(message: "Error! ${e.message}")
                        }
                    }
                    if (this.temp_assistant_content.size > 0) {
                        // update messages and history
                        launch {
                            // this.messages.addData(Message(RoleType.User, "${this.temp_user_content}"))
                            // this.messages.addData(Message(RoleType.Assistant, "${this.temp_assistant_content}"))
                            this.history.append(("${this.temp_user_content}", "${this.temp_assistant_content}"))
                            // 顺便更新数据库
                            this.insert_db_new_message(RoleType.User, this.temp_user_content)
                            this.insert_db_new_message(RoleType.Assistant, this.temp_assistant_content)
                            this.update_message_count(this.dialog_id, this.messages.totalCount() - 1)
                            this.temp_user_content = ""
                            this.temp_assistant_content = ""
                            // 顺便更新标题
                            this.sumarize_topic()
                        }
                    }
                }
                client.close()
                launch {
                    this.temp_user_content = ""
                    this.temp_assistant_content = ""
                }
            }
        }
    }

    func build() {
        Column {
            // title
            Column() {
                Row {
                   // back button
                    Button {
                        Image(@r(app.media.ic_public_back))
                        .width(32)
                        .height(32)
                        .margin(left: 4, right: 4)
                        .align(Alignment.Center)
                    }
                    .shape(ShapeType.CircleType)
                    .width(12.percent)
                    .backgroundColor(Color(242, 241, 247))
                    .padding(right: 10)
                    .margin(right: 10)
                    .onClick({
                        =>
                        let params = JsonObject(HashMap<String, JsonValue>([
                            ("dialog_id", JsonInt(this.dialog_id)),
                            ("dialog_topic", JsonString(this.dialog_topic)),
                            ("message_count", JsonInt(this.message_count - 1)) // messsage count不包含system_prompt
                        ]))
                        Hilog.info(0, "==Click back==", "message_count: ${this.message_count}")
                        // 将参数返回给主页面
                        Router.back(url: "MainView", params: params)
                    })
                    // text
                    Text(this.dialog_topic)
                    .fontSize(24)
                    .width(76.percent)
                    .textAlign(TextAlign.Center)
                    .align(Alignment.Center)
                    // clear button
                    Button {
                        Image(@r(app.media.ic_public_clean))
                        .width(32)
                        .height(32)
                        .margin(left: 4, right: 4)
                        .align(Alignment.Center)
                    }
                    .shape(ShapeType.CircleType)
                    .width(12.percent)
                    .backgroundColor(Color(242, 241, 247))
                    .padding(right: 10)
                    .margin(right: 10)
                    .onClick({=>
                         launch {
                             this.history.clear()
                             this.messages.clear()
                             this.messages.addData(Message(RoleType.System, this.system_prompt))
                             // 顺便清空数据库
                             this.clear_db_message();
                             // 同步插入一条新数据
                             this.insert_db_new_message(RoleType.System, this.system_prompt)
                             // 更新数据库统计
                             this.update_message_count(this.dialog_id, 0)
                             this.message_count = 1
                         }
                     })
                }.width(100.percent).padding(10) // Row
            }.expandSafeArea(
                types: [SafeAreaType.SYSTEM, SafeAreaType.KEYBOARD],
                edges: [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]
            )
            // chat
            Column(5) {
                List(scroller: this.scroller) {
                    LazyForEach(
                        this.messages,
                        itemGeneratorFunc: {
                            msg: Message, index: Int64 =>
                            ListItem() {
                                this.generate_chatLine(msg, index)
                            }
                        }
                    )
                }
                .nestedScroll(NestedScrollOptions(NestedScrollMode.SELF_ONLY, NestedScrollMode.SELF_ONLY))
                .onAreaChange({_, _ => this.scroller.scrollEdge(Edge.Bottom)})
            }
            .align(Alignment.TopStart)
            .layoutWeight(1)
            .backgroundColor(Color(238, 237, 242))
            // input
	  	  	Column(10) {
	  	  		Row() {
                    TextArea(text: this.prompt)
                    .fontColor(0x000000)
                    .backgroundColor(0xffffff)
                    .layoutWeight(1)
                    .borderRadius(6.fp)
                    .margin(right: 10)
                    .constraintSize(minHeight: 40.vp)
                    .onChange({change_str: String => this.prompt = change_str})
                    .onClick({event: ClickEvent =>
                         match (event.source) {
                             case SourceType.TouchScreen => launch{this.blank_height = 36.percent}
                             case _ => ()
                         }
                     })
                     .onEditChange({is_edit: Bool => if (!is_edit) {
                             this.blank_height = 0.percent
                         }
                     })
                    Button(@r(app.string.send))
                    .shape(ShapeType.Normal)
	  	  			.height(40)
	  	  			.width(60)
	  	  			.fontSize(12)
	  	  			.fontColor(0xffffff)
	  	  			.borderRadius(6.fp)
	  	  			.backgroundColor(Color(67, 151, 247))
                    .onClick({
                        =>
                        if (env_info.model.size == 0) {
                           PromptAction.showToast(message: "Attention! The model to be called is not configured \n 警告！未配置要调用的模型")
                        } else if (env_info.base_url.size == 0) {
                           PromptAction.showToast(message: "Attention! The API KEY is not configured \n 警告！未配置模型调用链接")
                        } else if (env_info.api_key.size == 0) {
                           PromptAction.showToast(message: "Attention! The base url is not configured \n 警告！未配置密钥")
                        } else if (this.system_prompt.size == 0) {
                           PromptAction.showToast(message: "Attention! The system prompt is not configured \n 警告！未配置系统提示词")
                        } else {
                           if (this.stream) {
                               this.stream_chat_callback()
                           } else {
                               this.chat_callback()
                           }
                       }
                    }) // button
                 }.padding(left: 2, right: 2) // row
	  	  	 } // column(10)
              .padding(left: 10, right: 10, top: 5)
              .expandSafeArea(
                  types: [SafeAreaType.SYSTEM],
                  edges: [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]
              )
             Column {

             }.height(this.blank_height)
         } // Column
         .width(100.percent)
         .height(100.percent)
         .backgroundColor(Color(242, 241, 247))
         .expandSafeArea(
             types: [SafeAreaType.SYSTEM, SafeAreaType.KEYBOARD],
             edges: [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]
         )
    } // build
}
