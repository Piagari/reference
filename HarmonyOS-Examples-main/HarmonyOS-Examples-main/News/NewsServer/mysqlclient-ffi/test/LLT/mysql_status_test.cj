// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*

let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
let arr: Array<(String, String)> = Array<(String, String)>()
let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
    "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
    arr
)
let con: MysqlConnection = mysqlDatasource.connect()

main(): Int64 {
    let conStatusTest: ConStatusTest = ConStatusTest()

    conStatusTest.ConStatusTest01()
    conStatusTest.ConStatusTest02()

    // conStatusTest.ConStatusTest03() //会关闭服务器
    // conStatusTest.ConStatusTest04() //会关闭服务器
    return 0
}

@Test
public class ConStatusTest {
    @TestCase
    public func ConStatusTest01(): Unit {
        let connstatus = con.state //正常已连接
        let res = match (connstatus) {
            case ConnectionState.Connected => 0
            case _ => 1
        }
        @Assert(res, 0)
    }

    @TestCase
    public func ConStatusTest02(): Unit {
        let connstatus = con.isClosed() //正常未关闭
        let res = match (connstatus) {
            case false => 0
            case _ => 1
        }
        @Assert(res, 0)
    }

    @TestCase
    public func ConStatusTest03(): Unit {
        let server = MysqlServerApi(con)
        server.mysqlShutdown(MysqlShutdownLevel.SHUTDOWN_DEFAULT) //关闭服务器，返回broken，已断开连接
        let connstatus = con.state
        let res = match (connstatus) {
            case ConnectionState.Broken => 0
            case _ => 1
        }
        @Assert(res, 0)
    }

    @TestCase
    public func ConStatusTest04(): Unit {
        let server = MysqlServerApi(con)
        server.mysqlShutdown(MysqlShutdownLevel.SHUTDOWN_DEFAULT) //关闭服务器
        let connstatus = con.isClosed() //已关闭
        let res = match (connstatus) {
            case true => 0
            case _ => 1
        }
        @Assert(res, 0)
    }
}
