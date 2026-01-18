// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*

main(): Int64 {
    let mysqlStatementTest: MysqlStatementTest = MysqlStatementTest()

    mysqlStatementTest.mysqlStatementTest01()

    return 0
}

@Test
public class MysqlStatementTest {
    @TestCase
    public func mysqlStatementTest01(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
        @Assert("mysql", mysqlDriver.name)
        @Assert(true, mysqlDriver.version.size > 0)

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        // 删除t_test2名称数据表
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_time")
        mysqlStatement1.update()
        mysqlStatement1.parameterColumnInfos
        mysqlStatement1.setOption("111", "1111")
        mysqlStatement1.setOption(MysqlStmtAttrType.STMT_ATTR_UPDATE_MAX_LENGTH, true)
        mysqlStatement1.setOption(MysqlStmtAttrType.STMT_ATTR_UPDATE_MAX_LENGTH, false)
        mysqlStatement1.setOption(MysqlStmtAttrType.STMT_ATTR_CURSOR_TYPE, UInt64(1))
        @Assert(false, mysqlStatement1.isClosed())

        // 释放预执行语句内存
        mysqlStatement1.close()

        // 关闭链接
        mysqlConnection.close()
    }
}
