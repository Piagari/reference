
import mysqlclient_ffi.*
import std.database.sql.*
import std.time.*


/*
 * 数据库控制类
 */
public class Database {


    // 数据库连接字符串
    let strConnection = "HOST=127.0.0.1;USER=root;PASSWD=654321;DB=news_manager;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0"
    
    // 数据库驱动
    let mysqlDriver: MysqlDriver

    // 数据源
    let datasource: MysqlDatasource

    // 数据库链接
    let connection: MysqlConnection

    // 单例模式
    // 无法从外部访问构造函数
    private init() {

        // 初始化数据库驱动
        mysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        datasource = mysqlDriver.open(
            strConnection,
            Array<(String, String)>()
        )
            
        // 返回一个可用的链接
        connection = datasource.connect()
    }


    // 单例对象
    private static let instance : Database = Database()
    // 获取单例对象
    static func getInstance() : Database {
        return instance
    }

}