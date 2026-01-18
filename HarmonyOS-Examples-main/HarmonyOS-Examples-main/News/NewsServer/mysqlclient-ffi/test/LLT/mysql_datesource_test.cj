// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*

main(): Int64 {
    let mysqlDatasourceTest: MysqlDatasourceTest = MysqlDatasourceTest()

    mysqlDatasourceTest.mysqlDatasourceTest01()
    mysqlDatasourceTest.mysqlDatasourceTest02()
    mysqlDatasourceTest.mysqlDatasourceTest03()

    return 0
}

@Test
public class MysqlDatasourceTest {
    @TestCase
    public func mysqlDatasourceTest01(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )
        mysqlDatasource.setOption("1111", "222222")
        mysqlDatasource.setOption("333", "4444")
        mysqlDatasource.close()
        @Assert(false, mysqlDatasource.isClosed())
    }

    @TestCase
    public func mysqlDatasourceTest02(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        mysqlDatasource.setOption(MysqlOption.MYSQL_OPT_CONNECT_TIMEOUT, UInt32(100000))
        mysqlDatasource.setOption(MysqlOption.MYSQL_OPT_GET_SERVER_PUBLIC_KEY, true)
        mysqlDatasource.setOption(MysqlOption.MYSQL_OPT_GET_SERVER_PUBLIC_KEY, false)
        mysqlDatasource.setOption(MysqlOption.MYSQL_OPT_MAX_ALLOWED_PACKET, UInt64(100000000000000000))
        mysqlDatasource.setOption(MysqlOption.MYSQL_OPT_CONNECT_ATTR_DELETE, "time")
        mysqlDatasource.close()
        @Assert(false, mysqlDatasource.isClosed())
    }

    @TestCase
    public func mysqlDatasourceTest03(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=wwww;PASSWD=1122222;DB=sssssss;PORT=1;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )
        try {
            mysqlDatasource.connect()
            @Assert(0, 1)
        } catch (e: SqlException) {
            @Assert(true, e.message.contains("Connect Failed!"))
        }
    }
}
