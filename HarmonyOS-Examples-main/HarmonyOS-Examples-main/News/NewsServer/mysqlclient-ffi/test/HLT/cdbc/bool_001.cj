// 3rd_party_lib:mysqlclient-ffi/build/mysqlclient
// 3rd_party_lib_ohos:mysqlclient-ffi/build/aarch64-linux-ohos/mysqlclient
import std.database.sql.*
import std.io.*
import std.time.*
import std.regex.*
import std.math.*
import mysqlclient_ffi.*

@Test
public class OdbcTest {
    init() {}
    @TestCase
    public func test001(): Unit {
        var driver = MysqlDriver("mysql")
        var database = driver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )
        var conn = database.connect()
        var prepareStatement = conn.prepareStatement("drop table if exists test")
        var rowCount = prepareStatement.update()
        @Assert(0, rowCount.rowCount)
        prepareStatement.close()
        prepareStatement = conn.prepareStatement("create table test(data bool NOT NULL, datanull bool)")
        rowCount = prepareStatement.update()
        @Assert(0, rowCount.rowCount)
        prepareStatement.close()
        prepareStatement = conn.prepareStatement("insert into test values(?,?)")
        rowCount = prepareStatement.update([SqlBool(false), SqlNullableBool(None)])
        @Assert(1, rowCount.rowCount)
        prepareStatement.close()
        prepareStatement = conn.prepareStatement("select * from test")
        var queryResult = prepareStatement.query()
        var arr: Array<SqlDbType> = [SqlBool(true), SqlNullableBool(None)]
        queryResult.next(arr)

        // @Assert("SqlBool", queryResult.columnInfos[0].typeName)
        match (arr[0]) {
            case v: SqlBool => @Assert(false, v.value)
            case _ => @Assert("abc", "123")
        }

        // @Assert("SqlNullableBool", queryResult.columnInfos[1].typeName)
        match (arr[1]) {
            case v: SqlNullableBool => @Assert(None, v.value)
            case _ => @Assert("abc", "123")
        }
        prepareStatement.close()

        // 删除test名称数据表
        let mysqlStatement9: MysqlStatement = conn.prepareStatement("drop table if exists test")
        mysqlStatement9.update()
        mysqlStatement9.close()
        conn.close()
    }
}
