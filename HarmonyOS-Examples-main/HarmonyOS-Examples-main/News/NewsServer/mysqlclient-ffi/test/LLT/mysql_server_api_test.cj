// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*
import std.math.*

main(): Int64 {
    let mysqlServerApiTest: MysqlServerApiTest = MysqlServerApiTest()

    mysqlServerApiTest.mysqlServerApiTest001()

    return 0
}

@Test
public class MysqlServerApiTest {
    @TestCase
    func mysqlServerApiTest001(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlServerApi: MysqlServerApi = MysqlServerApi(mysqlConnection)

        var cpCtringArgv: CPointer<CString> = CPointer<CString>()
        var cpCtringGroups: CPointer<CString> = CPointer<CString>()

        var ret: Int32 = mysqlServerApi.mysqlServerInit(10, cpCtringArgv, cpCtringGroups)
        @Assert(0, ret)

        mysqlServerApi.mysqlServerEnd()

        ret = mysqlServerApi.mysqlRefresh(0)
        // windosw 2013 Lost connection to MySQL server during query，没有重新加载权限
        // linux 默认有重新加载权限
        println(ret)

        ret = mysqlServerApi.mysqlKill(0)
        @Assert(1, ret)

        mysqlConnection.close()
    }

    /*
     * 无法自动化
     */
    @Skip
    @TestCase
    func mysqlServerApiTest002(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlServerApi: MysqlServerApi = MysqlServerApi(mysqlConnection)

        mysqlServerApi.mysqlShutdown(MysqlShutdownLevel.SHUTDOWN_DEFAULT)

        mysqlConnection.close()
    }
}
