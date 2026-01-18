// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*

main(): Int64 {
    let mysqlConnectionTest: MysqlConnectionTest = MysqlConnectionTest()

    mysqlConnectionTest.mysqlConnectionTest01()
    mysqlConnectionTest.mysqlConnectionTest02()

    return 0
}

@Test
public class MysqlConnectionTest {
    @TestCase
    public func mysqlConnectionTest01(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()
        mysqlConnection.getMetaData()
        mysqlConnection.setOption(MysqlSetOption.MYSQL_OPTION_MULTI_STATEMENTS_OFF)
        mysqlConnection.setOption(MysqlSetOption.MYSQL_OPTION_MULTI_STATEMENTS_ON)
        mysqlConnection.mysqlPing()
        @Assert(false, mysqlConnection.isClosed())

        mysqlConnection.close()
    }

    @TestCase
    public func mysqlConnectionTest02(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()
        try {
            mysqlConnection.prepareStatement("3111111111111111111")
            @Assert(0, 1)
        } catch (e: SqlException) {
            @Assert(true, e.message.contains("You have an error in your SQL syntax"))
        }

        mysqlConnection.close()
    }
}
