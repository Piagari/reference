/**
 * @file 新闻文件（包含新闻类、新闻管理类）
 */
package default


import std.collection.*
import mysqlclient_ffi.*
import std.database.sql.*
import std.console.*
import std.convert.*
import encoding.json.stream.*
import std.math.numeric.*


/**
 * 新闻 类  
 */
public class News <: ToString & JsonSerializable{
    var id : UInt32                     // 编号
    var cover : String                  // 封面
    var title : String                  // 标题
    var content : String                // 内容 
    var like_num : UInt32               // 点赞数
    var hot : String                    // 热度
    var publish_date : String           // 发布时间

    // 普通构造函数 
    public init (id : UInt32, cover : String, title : String, content : String, like_num : UInt32, hot : String, publish_date : String) { 
        // 初始化成员变量
        this.id = id
        this.cover = cover
        this.title = title
        this.content = content
        this.like_num = like_num
        this.hot = hot
        this.publish_date = publish_date
    }

    /**
     * 输出新闻信息
     */
    public func outputInfo() {
        "编号: ${id} 封面: ${cover} 标题: ${title} 内容: ${content} 点赞数: ${like_num}  热点：${hot} 发布时间: ${publish_date}"
    }
    
    /**
     * 输出新聞信息（转换为字符串）
     */
    public func toString() {
        outputInfo()
    }
    
    /**
     * 转换为Json格式
     */
    public func toJson(w: JsonWriter): Unit {
        w.startObject()
        w.writeName("id").writeValue(Int64(id)) 
        w.writeName("cover").writeValue(cover)
        w.writeName("title").writeValue(title)
        w.writeName("content").writeValue(content)
        w.writeName("like_num").writeValue(Int64(like_num)) 
        w.writeName("hot").writeValue(hot)
        w.writeName("publish_date").writeValue(publish_date)
        w.endObject()
    }
}

/**
 * 新闻 管理类
 */
public class NewsManager {

    /**
     * 数据库连接
     */
    private let connection : MysqlConnection

    // 单例模式
    // 无法从外部访问构造函数
    private init() {
        // 获取数据库连接
        connection = Database.getInstance().connection
    }
    // 单例对象
    private static let instance : NewsManager = NewsManager()
    // 获取单例对象
    static func getInstance() : NewsManager {
        return instance
    }


    /**
     * 输出全部新闻信息
     */
    func getAllNews(w : JsonWriter) : Unit{

        // 开始Json数组
        w.startArray()

        // 查询语句预执行语句
        var mysqlStatement: MysqlStatement = connection.prepareStatement("select * from a_journalism")

        // 执行查询语句
        var res: MysqlQueryResult = mysqlStatement.query()

        // 获取数据
        let arrDb : Array<SqlDbType> = [SqlInteger(0), SqlVarchar(""), SqlVarchar(""), SqlVarchar(""),SqlInteger(0), SqlVarchar(""), SqlVarchar("")]

        var isBool = res.next(arrDb)
        while (isBool) {
            try {
                let id = UInt32((arrDb[0] as SqlInteger).getOrThrow().value)
                let cover = (arrDb[1] as SqlVarchar).getOrThrow().value
                let title = (arrDb[2] as SqlVarchar).getOrThrow().value
                let content = (arrDb[3] as SqlVarchar).getOrThrow().value
                let like_num = UInt32((arrDb[4] as SqlInteger).getOrThrow().value)
                let hot = (arrDb[5] as SqlVarchar).getOrThrow().value
                let publish_date = (arrDb[6] as SqlVarchar).getOrThrow().value
                let news = News(id, cover, title, content, like_num, hot, publish_date)
                news.toJson(w)
            } catch (e : Exception) {
                println(e)
            }
            isBool = res.next(arrDb)
        }

        mysqlStatement.close()

        // 结束Json数组
        w.endArray()
    }

    /**
     * 将新闻信息插入到数据表中
     * @param news 新闻对象
     * @return 是否插入成功
     */
    func insertNews(news : News) : Bool {

        // 插入
        let statement = connection.prepareStatement("insert into  a_journalism(id,cover,title,content,like_num,hot,publish_date)  VALUES(?,?,?,?,?,?,?)")

        let arrDb : Array<SqlDbType> = [SqlInteger(Int32(news.id)), 
                                        SqlVarchar(news.cover), 
                                        SqlVarchar(news.title),
                                        SqlVarchar(news.content),
                                        SqlInteger(Int32(news.like_num)),
                                        SqlVarchar(news.hot),
                                        SqlVarchar(news.publish_date)]
        // 执行插入语句插入数据
        var mysqlUpdateResult: MysqlUpdateResult = statement.update(arrDb)
        if (mysqlUpdateResult.rowCount == 1) {
            println("数据库插入成功!增加一条新闻记录!")
            true
        } else {
            false
        }
    }

    /*
     * 查询新闻信息
     * @param newsId 新闻id
     * @return 查询结果，?News对象
     */
    func queryNews(newsId : UInt32) : ?News {

        var news : ?News = None
                
        var arrDb: Array<SqlDbType> = [SqlInteger(Int32(newsId))]

        // 查询语句预执行语句
        var mysqlStatement: MysqlStatement = connection.prepareStatement("select * from a_journalism where id = ?")

        // 执行查询语句
        var res: MysqlQueryResult = mysqlStatement.query(arrDb)

        // 获取数据
        arrDb = [SqlInteger(0), SqlVarchar(""), SqlVarchar(""), SqlVarchar(""),SqlInteger(0), SqlVarchar(""), SqlVarchar("")]

        if (res.next(arrDb)) {
            try {
                let id = UInt32((arrDb[0] as SqlInteger).getOrThrow().value)
                let cover = (arrDb[1] as SqlVarchar).getOrThrow().value
                let title = (arrDb[2] as SqlVarchar).getOrThrow().value
                let content = (arrDb[3] as SqlVarchar).getOrThrow().value
                let like_num = UInt32((arrDb[4] as SqlInteger).getOrThrow().value)
                let hot = (arrDb[5] as SqlVarchar).getOrThrow().value
                let publish_date = (arrDb[6] as SqlVarchar).getOrThrow().value
                news = News(id, cover, title, content, like_num, hot, publish_date)                
            } catch (e : Exception) {
                println(e)
            }
        }
        mysqlStatement.close()
        return news

    }

    /*
     * 查询新闻信息
     */
    func queryNews(w : JsonWriter, newsKey : String) : Unit {        
        // 开始Json数组
        w.startArray()

        // 查询语句预执行语句
        var mysqlStatement: MysqlStatement = connection.prepareStatement("select * from a_journalism where title like '%${newsKey}%'")

        // 执行查询语句
        var res: MysqlQueryResult = mysqlStatement.query()

        // 获取数据
        let arrDb : Array<SqlDbType> = [SqlInteger(0), SqlVarchar(""), SqlVarchar(""), SqlVarchar(""),SqlInteger(0), SqlVarchar(""), SqlVarchar("")]

        var isBool = res.next(arrDb)
        while (isBool) {
            try {
                let id = UInt32((arrDb[0] as SqlInteger).getOrThrow().value)
                let cover = (arrDb[1] as SqlVarchar).getOrThrow().value
                let title = (arrDb[2] as SqlVarchar).getOrThrow().value
                let content = (arrDb[3] as SqlVarchar).getOrThrow().value
                let like_num = UInt32((arrDb[4] as SqlInteger).getOrThrow().value)
                let hot = (arrDb[5] as SqlVarchar).getOrThrow().value
                let publish_date = (arrDb[6] as SqlVarchar).getOrThrow().value
                let news = News(id, cover, title, content, like_num, hot, publish_date)
                news.toJson(w)
            } catch (e : Exception) {
                println(e)
            }
            isBool = res.next(arrDb)
        }

        mysqlStatement.close()

        // 结束Json数组
        w.endArray()        
    }
    

    /**
     * 删除新闻信息
     * @param newsId 新闻id 
     * @return 是否删除成功
     */
    func deleteNews(newsId : UInt32) : Bool {

        // 删除语句预执行语句
        let statement = connection.prepareStatement("delete from a_journalism where id = ?")

        var arrDb: Array<SqlDbType> = [SqlInteger(Int32(newsId))]

        // 执行删除语句
        var res = statement.update(arrDb)

        return if (res.rowCount == 1) {
            statement.close()
            true
        } else {
            statement.close()
            false
        }
    }


    /*
     * 修改新闻信息，更新数据库
     * @param news 新闻对象
     * @return 是否修改成功
     */
    func updateNews(news : News) : Bool { 

        // 更新语句预执行语句
        let statement = connection.prepareStatement("update a_journalism set cover = ?, title = ?, content = ?, like_num = ?, hot = ?, publish_date = ?  where id = ?")

        let arrDb : Array<SqlDbType> = [SqlVarchar(news.cover),
                                        SqlVarchar(news.title),
                                        SqlVarchar(news.content),
                                        SqlInteger(Int32(news.like_num)),
                                        SqlVarchar(news.hot),
                                        SqlVarchar(news.publish_date),
                                        SqlInteger(Int32(news.id))]

        // 执行更新语句
        let res = statement.update(arrDb)
        if (res.rowCount == 1) {
            statement.close()
            true
        } else {
            statement.close()
            false
        }
    }

}