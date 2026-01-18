// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*

main(): Int64 {
    let mysqlQueryResultTest: MysqlQueryResultTest = MysqlQueryResultTest()

    mysqlQueryResultTest.mysqlQueryResultTest01()

    return 0
}

@Test
public class MysqlQueryResultTest {
    @TestCase
    public func mysqlQueryResultTest01(): Unit {
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
        mysqlStatement1.close()

        // 创建t_test2名称数据表
        var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test_time(id bigint not null, timeValue1 time not null, timeValue2 time)")
        mysqlStatement2.update()
        mysqlStatement2.close()

        // 查询语句预执行语句
        var mysqlStatement4: MysqlStatement = mysqlConnection.prepareStatement("select * from t_test_time where id = 1")

        @Assert(0, mysqlStatement4.parameterCount)
        var mysqlQueryResult: MysqlQueryResult = mysqlStatement4.query()
        mysqlQueryResult.columnInfos
        let mysqlColumnInfos: Array<MysqlColumnInfo> = mysqlQueryResult.mysqlColumnInfos

        @Assert("id", mysqlColumnInfos[0].name)
        @Assert("SqlBigInt", mysqlColumnInfos[0].typeName)
        @Assert(0, mysqlColumnInfos[0].displaySize)
        @Assert(20, mysqlColumnInfos[0].length)
        @Assert(0, mysqlColumnInfos[0].scale)
        @Assert(true, mysqlColumnInfos[0].nullable)

        @Assert("timeValue1", mysqlColumnInfos[1].name)
        @Assert("SqlTime", mysqlColumnInfos[1].typeName)
        @Assert(0, mysqlColumnInfos[1].displaySize)
        @Assert(10, mysqlColumnInfos[1].length)
        @Assert(0, mysqlColumnInfos[1].scale)
        @Assert(true, mysqlColumnInfos[1].nullable)

        @Assert("timeValue2", mysqlColumnInfos[2].name)
        @Assert("SqlNullableTime", mysqlColumnInfos[2].typeName)
        @Assert(0, mysqlColumnInfos[2].displaySize)
        @Assert(10, mysqlColumnInfos[2].length)
        @Assert(0, mysqlColumnInfos[2].scale)
        @Assert(false, mysqlColumnInfos[2].nullable)

        mysqlQueryResult.close()
        @Assert(true, mysqlStatement1.isClosed())
        mysqlStatement4.close()

        // 删除t_test2名称数据表
        var mysqlStatement6: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_time")
        mysqlStatement6.update()
        mysqlStatement6.close()

        // 关闭链接
        mysqlConnection.close()
    }
}
