/**
 * Created on 2024年12月10日
 */
package ohos_app_cangjie_entry
import ohos.state_macro_manage.Entry
import ohos.state_macro_manage.Component
import ohos.state_macro_manage.State
import ohos.state_macro_manage.r
import ohos.state_macro_manage.Builder
import ohos.hilog.Hilog
import ohos.router.Router
import std.time.DateTime
import std.time.DateTimeFormat
import ohos.concurrency.launch
import ohos.component.BorderStyle
import encoding.json.JsonObject
import std.collection.HashMap
import encoding.json.JsonValue
import encoding.json.JsonInt
import encoding.json.JsonString
import ohos.relational_store.*
import std.collection.Map
import ohos.i18n.getAppPreferredLanguage

@Entry
@Component
class MainView {
    @State
    var dialogs: ObservedArrayList<Dialog> = ObservedArrayList<Dialog>([
       // Dialog(id: 3, topic: "test3", datetime: "2024-12-15 22:00:00", message_count: 2, is_selected: true),
       // Dialog(id: 2, topic: "test2", datetime: "2024-12-13 22:00:00", message_count: 2, is_selected: false),
       // Dialog(id: 1, topic: "test1", datetime: "2024-12-12 22:00:00", message_count: 2, is_selected: false)
    ])
    @State
    var selected_index: Int64 = 0
    // === 下面三个参数用于接受从chat_view.cj路由返回的结果 ==
    // 返回的dialog_id
    @State
    var selected_dialog_id: Int64 = -1
    // 返回的dialog_topic
    @State
    var selected_dialog_topic: String = ""
    // 返回的message_count
    @State
    var selected_message_count: Int64 = 0

    // 用户偏好语言
    @State
    var language = ""

    func get_now_time(): String {
        return DateTime.now().toString(DateTimeFormat.of("yyyy-MM-dd HH:mm:ss"))
    }
    var rdb_store_option: Option<RdbStore> = None

    protected func onPageShow() {
        // 先获取用户偏好语言
        this.language = getAppPreferredLanguage()
        Hilog.info(0, "==Language==", "main view language is ${this.language}")
        // 如果没有dialogs，尝试初始化数据
        if (this.dialogs.size == 0) {
            try {
                // 连接关系数据库
                this.rdb_store_option = Some(getRdbStore(getContext(), StoreConfig("ai_chat.db", SecurityLevel.S1)));
                let rdb_store = this.rdb_store_option.getOrThrow();
                // 临时加入，删表
                // rdb_store.executeSql("DROP TABLE Dialog");
                // rdb_store.commit();
                // 创建Dialog表
                let dialog_create_sql: String = '''
                    CREATE TABLE IF NOT EXISTS Dialog (
                        id INTEGER PRIMARY KEY,
                        topic TEXT NOT NULL,
                        datetime TEXT NOT NULL,
                        message_count INTEGER NOT NULL,
                        is_selected INTEGER NOT NULL
                    );
                '''
                // 创建Chat的表(fk_dialog_id是一个外键，连接Dialog表的主键）
                let chat_create_sql: String = '''
                    CREATE TABLE IF NOT EXISTS Message (
                        id INTEGER PRIMARY KEY,
                        fk_dialog_id INTEGER NOT NULL,
                        role TEXT NOT NULL,
                        content TEXT NOT NULL,
                        datetime TEXT NOT NULL
                    );
                '''
                launch {
                    rdb_store.executeSql(dialog_create_sql)
                    rdb_store.executeSql(chat_create_sql)
                    rdb_store.commit()
                }
                Hilog.info(0, "===DB init==", "db init success.")
                // 查询Dialog数据
                let dialog_select_sql: String = '''
                    SELECT id, topic, datetime, message_count, is_selected FROM Dialog ORDER BY id DESC;
                '''
                let bind_data: Array<ValueType> = Array<ValueType>([])
                // 执行数据查询
                launch {
                    let result_set = rdb_store.querySql(dialog_select_sql, bindArgs: bind_data)
                    // 将查询结果给this.dialogs,方便数据展示
                    var i: Int64 = 0;
                    while (result_set.goToNextRow()) {
                        let temp_id = result_set.getLong(result_set.getColumnIndex("id"))
                        let temp_topic = result_set.getString(result_set.getColumnIndex("topic"))
                        let temp_datetime = result_set.getString(result_set.getColumnIndex("datetime"))
                        let temp_message_count = result_set.getLong(result_set.getColumnIndex("message_count"))
                        let temp_is_selected = result_set.getLong(result_set.getColumnIndex("is_selected"))
                        if (temp_is_selected > 0) {
                            this.selected_index = i
                        }
                        launch {
                            this.dialogs.append(
                                Dialog(
                                    id: temp_id,
                                    topic: temp_topic,
                                    datetime: temp_datetime,
                                    message_count: temp_message_count,
                                    is_selected: temp_is_selected > 0
                                )
                            )
                        }
                        i += 1
                    }
                }
                Hilog.info(0, "===DB init==", "dialogs init success.")
            } catch (e: Exception) {
               Hilog.error(0, "===DB init==", "db init failed, error: ${e.toString()}")
            }
        } else {
            let dialog_id = this.dialogs[this.selected_index].id
            // if (message_count > 0) {
            //     this.dialogs[this.selected_index].message_count = message_count
            // }
        }
        // === 尝试从Router读取数据 ===
        let params: JsonObject = Router.getParamsObject()
        let dialog_id_option: Option<JsonValue> = params.get("dialog_id")
        let dialog_topic_option = params.get("dialog_topic")
        let message_count_option = params.get("message_count")
        match (dialog_id_option) {
            case Some(temp_value) =>
                try {
                    let temp_int = temp_value.asInt()
                    this.selected_dialog_id = temp_int.getValue()
                } catch (_) {
                    Hilog.error(0, "==JSON ERROR==", "can't tranfer json value to int")
                }
            case _ => ()
        }
        match (dialog_topic_option) {
           case Some(temp_value) =>
                try {
                    let temp_str = temp_value.asString()
                    this.selected_dialog_topic = temp_str.getValue()
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
                    this.selected_message_count = temp_message_count
                } catch (_) {
                    Hilog.error(0, "==JSON ERROR==", "can't tranfer json value to string")
                }
            case _ => ()
        }
        // 当存在旧数据，以及存在Router传参时
        if (this.dialogs.size > 0 && this.selected_dialog_id >= 0) {
            Hilog.info(0, "==DIALOG INFO==", "dialog_id: ${this.selected_dialog_id}, dialog_topic: ${this.selected_dialog_topic}, message_count: ${this.selected_message_count}")
            // 判断当前选中行的id是不是传参进的目标id，如果是，则进行数据更新
            if (this.dialogs[this.selected_index].id == this.selected_dialog_id) {
                if (this.dialogs[this.selected_index].message_count != this.selected_message_count) {
                    this.dialogs[this.selected_index].message_count = this.selected_message_count
                }

                if (this.dialogs[this.selected_index].topic != this.selected_dialog_topic) {
                    this.dialogs[this.selected_index].topic = this.selected_dialog_topic
                }
            }
        }
    }

    func update_db_dialog_seleted(target_id!: Int64, target_value!: Int64) {
        // 更新数据库对应id的选中状态
        let update_dialog_sql: String = "UPDATE Dialog SET is_selected = ${target_value} WHERE id = ${target_id}"
        try {
            this.rdb_store_option.getOrThrow().executeSql(update_dialog_sql)
            this.rdb_store_option.getOrThrow().commit()
            Hilog.info(0, "==UPDATE DB==", "update dialog success!, changed id: ${target_id}, change selected value: ${target_value}")
        } catch (e: Exception) {
            Hilog.error(0, "==UPDATE DB==", "update dialog failed, error: ${e.toString()}")
        }
    }

    func db_clear_message(fk_dialog_id: Int64) {
        // 在Message表，清空指定的dialog_id的历史对话信息
        try {
            let delete_sql = "DELETE FROM Message WHERE fk_dialog_id = ${fk_dialog_id}"
            this.rdb_store_option.getOrThrow().executeSql(delete_sql)
            this.rdb_store_option.getOrThrow().commit();
            Hilog.info(0, "==DB delete==", "clear Message where fk_dialog_id = ${fk_dialog_id}");
        } catch (e: Exception) {
            Hilog.error(0, "==DB delete==", "clear Message where fk_dialog_id = ${fk_dialog_id} failed, error: ${e.toString()}")
        }
    }

    func db_delete_dialog(dialog_id: Int64) {
        // 在dialog表，删除对应id行数据
        let dialog_delete_sql: String = "DELETE FROM Dialog WHERE id = ${dialog_id}"
        try {
            this.rdb_store_option.getOrThrow().executeSql(dialog_delete_sql);
            this.rdb_store_option.getOrThrow().commit();
            Hilog.info(0, "==DB delete data==", "delete Dialog data success, changed id = ${dialog_id}")
        } catch (e: Exception){
            Hilog.error(0, "==DB delete data==", "delete Dialog data failed, error = ${e.toString()}")
        }
    }


    func build() {
        Column {
            // text
            Text("AI Chat").fontSize(24).width(76.percent).textAlign(TextAlign.Center).align(Alignment.Center)
            // history dialog
            Column {
                List() {
                    ForEach(
                        this.dialogs,
                        {
                            dialog: Dialog, index: Int64 =>
                                ListItem() {
                                Column {
                                    Text(dialog.topic)
                                    .margin(left: 5)
                                    .fontSize(22)
                                    .width(100.percent)
                                    .padding(top: 10)
                                    Row {
                                        Text(if (this.language == "zh-Hans") {"${dialog.message_count}条数据"} else {"${dialog.message_count} messages"})
                                        .fontSize(14)
                                        .fontColor(Color(200, 200, 200))
                                        .width(50.percent)
                                        Text(dialog.datetime)
                                        .fontSize(14)
                                        .fontColor(Color(200, 200, 200))
                                        .width(50.percent)
                                    }.margin(left: 5).padding(top: 5)
                                }.height(80)
                                .width(90.percent)
                                .backgroundColor(Color(255, 255, 255))
                                .border(width: 1.percent, color: if (dialog.is_selected) {Color(64, 133, 137)} else {Color(255, 255, 255)}, radius: 2.percent, style: BorderStyle.Solid)
                                .padding(left: 5.percent, right: 5.percent)
                                .margin(left: 5.percent, right: 5.percent)
                                // ListItem
                                }.margin(top: 12)
                                .onClick({
                                    e: ClickEvent =>
                                        launch {
                                            // 取消旧数据选中
                                            this.dialogs[this.selected_index].is_selected = false
                                            let old_id: Int64 = this.dialogs[this.selected_index].id
                                            this.update_db_dialog_seleted(target_id: old_id, target_value: 0)
                                            // 选中新表格
                                            this.selected_index = index
                                            this.dialogs[index].is_selected = true
                                            let new_id: Int64 = this.dialogs[index].id
                                            this.update_db_dialog_seleted(target_id: new_id, target_value: 1)
                                            // 准备页面跳转
                                            let params = JsonObject(HashMap<String, JsonValue>([
                                                ("dialog_id", JsonInt(this.dialogs[index].id)),
                                                ("dialog_topic", JsonString(this.dialogs[index].topic)),
                                                ("message_count", JsonInt(this.dialogs[index].message_count))
                                            ]))
                                            Router.push(url: "ChatView", params: params)
                                        }

                                })
                        }
                    )
                }
            }.height(88.percent)
            Row {
                // setting button
                Row {
                    Button {
                        Image(@r(app.media.ic_public_settings))
                        .width(32)
                        .height(32)
                        .margin(left: 4, right: 4, top: 4, bottom: 4)
                        .align(Alignment.Center)
                    }
                    .backgroundColor(Color(255, 255, 255))
                    .borderColor(Color(242, 241, 247))
                    .shape(ShapeType.CircleType)
                    .onClick({=> Router.push(url: "Settings")})
                }.width(10.percent).margin(left: 5.percent)
                // delete dialog button
                Row {
                    Button {
                        Image(@r(app.media.ic_contacts_delete))
                        .width(32)
                        .height(32)
                        .margin(left: 4, right: 4, top: 4, bottom: 4)
                        .align(Alignment.Center)
                    }
                    .backgroundColor(Color(255, 255, 255))
                    .borderColor(Color(242, 241, 247))
                    .shape(ShapeType.CircleType)
                    .height(100.percent)
                    .onClick({
                        =>
                            Hilog.info(0, "=== Delete Button===", "selected_index = ${this.selected_index}")
                            launch {
                                let old_index = this.selected_index
                                if (this.dialogs.size > 0) {
                                    // 操作数据库，删除该数据
                                    let old_id = this.dialogs[this.selected_index].id;
                                    // 先清空关联表的数据
                                    this.db_clear_message(old_id);
                                    // 再删除对应行
                                    this.db_delete_dialog(old_id);
                                    if (this.dialogs.size > 1)  {
                                        // 判断选中是不是最后一个数据
                                        if (this.dialogs.size - 1 == this.selected_index) {
                                            // 如果是最后一条数据，直接删数据就行，选中行往上走一行
                                            let temp: Dialog = this.dialogs.remove(old_index)
                                            this.selected_index -= 1
                                            this.dialogs[this.selected_index].is_selected = true
                                        } else {
                                            // Todo: 删除选中,删除后，貌似UI会将最后面的清掉
                                            // 临时解决办法：将数值依次从下一个传递到当前数值，然后删除掉最后一个，就可以实现这个功能
                                            // 将将要被删除的数据行的后续行均往前移一格
                                            for (i in this.selected_index..(this.dialogs.size - 1)) {
                                                this.dialogs[i].id = this.dialogs[i + 1].id
                                                this.dialogs[i].topic = this.dialogs[i + 1].topic
                                                this.dialogs[i].datetime = this.dialogs[i + 1].datetime
                                                this.dialogs[i].message_count = this.dialogs[i + 1].message_count
                                            }
                                            // 删除最后一条多余数据
                                            this.dialogs.remove(this.dialogs.size - 1)
                                            // 下面这个方法不行，对于复合数据类型，数据和UI会错位
                                            // this.dialogs.remove(this.selected_index);
                                        }
                                        // 将目标数据对应的数据库中的行，更新其is_selecetd数值为选中
                                        let new_id: Int64 = this.dialogs[this.selected_index].id
                                        // 同时需要更新数据库中的这个id对应行，是否选中的数值值
                                        this.update_db_dialog_seleted(target_id: new_id, target_value: 1);
                                    } else {
                                        // 只有一条数据，直接删就行
                                        let temp: Dialog = this.dialogs.remove(old_index)
                                    }
                                }
                            }
                   })
                }.width(10.percent).margin(left: 5.percent)
                // empty
                Row {

                }.width(40.percent)
                // new chat button
                Row {
                    Button(@r(app.string.new_chat))
                    .backgroundColor(Color(255, 255, 255))
                    .borderColor(Color(242, 241, 247))
                    .fontColor(Color(0, 0, 0))
                    .onClick({
                        =>
                            // 最上面的数据对应最大的id
                            let dialogs_size = this.dialogs.size
                            launch {
                                if (dialogs_size > 0) {
                                    let max_id: Int64 = this.dialogs[0].id
                                    // 取消旧数据选中
                                    this.dialogs[this.selected_index].is_selected = false
                                    let old_id: Int64 = this.dialogs[this.selected_index].id
                                    // 同时需要更新数据库中的这个id对应行，是否选中的数值值
                                    this.update_db_dialog_seleted(target_id: old_id, target_value: 0);
                                    // 添加新数据并选中
                                    // 新加的数据，默认放到最前面
                                    // 需要将所有数据往后面移动一位，否则数据不会刷新
                                    // 第一步：先添加一个新的空数据
                                    this.dialogs.append(
                                        Dialog(
                                            id: -1,
                                            topic: "",
                                            datetime: this.get_now_time(),
                                            message_count: 0,
                                            is_selected: false,
                                        )
                                    )
                                    // 第二步：将数据往后面移动
                                    for (i in dialogs_size..0:-1) {
                                        this.dialogs[i].id = this.dialogs[i - 1].id
                                        this.dialogs[i].topic = this.dialogs[i - 1].topic
                                        this.dialogs[i].datetime = this.dialogs[i - 1].datetime
                                        this.dialogs[i].message_count = this.dialogs[i - 1].message_count
                                    }
                                    // 第三步：将最上面一个数值设置为新的
                                    this.dialogs[0].id = max_id + 1
                                    this.dialogs[0].topic = if (this.language == "zh-Hans") {"新的聊天"} else {"New Chat"}
                                    this.dialogs[0].datetime = this.get_now_time()
                                    this.dialogs[0].message_count = 0
                                    this.dialogs[0].is_selected = true;
                                    this.selected_index = 0
                                } else {
                                    // 如果是空数据，直接添加就行了, 初始id设置为1
                                    this.dialogs.append(
                                        Dialog(
                                            id: 1,
                                            topic: if (this.language == "zh-Hans") {"新的聊天"} else {"New Chat"},
                                            datetime: this.get_now_time(),
                                            message_count: 0,
                                            is_selected: true,
                                        )
                                    )
                                    this.selected_index = 0
                                }

                                // 第四步：将新数据入sqlite数据库
                                let new_data = HashMap<String, ValueType>([
                                    ("id", ValueType.integer(this.dialogs[0].id)),
                                    ("topic", ValueType.string(this.dialogs[0].topic)),
                                    ("datetime", ValueType.string(this.dialogs[0].datetime)),
                                    ("message_count", ValueType.integer(this.dialogs[0].message_count)),
                                    ("is_selected", ValueType.integer(if (this.dialogs[0].is_selected) {1} else {0}))
                                ])
                                try {
                                    let result: Int64 = this.rdb_store_option.getOrThrow().insert("Dialog", new_data)
                                    this.rdb_store_option.getOrThrow().commit();
                                    Hilog.info(0, "==DB insert==", "insert new dialog ok, dialog id: ${result}");
                                } catch (e: Exception) {
                                    Hilog.error(0, "==DB insert==", "insert new dialog failed, error: ${e.toString()}")
                                }
                                // 准备页面跳转
                                let params = JsonObject(HashMap<String, JsonValue>([
                                    ("dialog_id", JsonInt(this.dialogs[0].id)),
                                    ("dialog_topic", JsonString(this.dialogs[0].topic)),
                                    ("message_count", JsonInt(0))
                                ]))
                                Router.push(url: "ChatView", params: params)
                            }

                        })
                }.width(25.percent).margin(right: 5.percent)
            }.margin(bottom: 10)
            .height(12.percent)
        }.backgroundColor(Color(231, 248, 255))
        .width(100.percent)
        .height(100.percent)
        .expandSafeArea(
            types: [SafeAreaType.SYSTEM, SafeAreaType.KEYBOARD],
            edges: [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]
        )
    }
}