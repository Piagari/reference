// 3rd_party_lib:mysqlclient-ffi/build/mysqlclient
// 3rd_party_lib_ohos:mysqlclient-ffi/build/aarch64-linux-ohos/mysqlclient
import std.database.sql.*
import std.io.*
import std.time.*
import std.regex.*
import std.math.*
import mysqlclient_ffi.*

@Test
public class binary_001 {
    var conn: MysqlConnection
    var prepareStatement: MysqlStatement
    var rowCount: MysqlUpdateResult
    init() {
        var driver = MysqlDriver("mysql")
        var database = driver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )
        conn = database.connect()
        prepareStatement = conn.prepareStatement("drop table if exists test")
        rowCount = prepareStatement.update()
        @Assert(0, rowCount.rowCount)
        prepareStatement.close()
        prepareStatement = conn.prepareStatement("create table test(data BINARY(20) NOT NULL, datanull BINARY(20))")
        rowCount = prepareStatement.update()
        @Assert(0, rowCount.rowCount)
        prepareStatement.close()
    }

    @TestCase
    public func test001(): Unit {
        prepareStatement = conn.prepareStatement("insert into test values(?,?)")
        rowCount = prepareStatement.update([SqlBinary([0, 22]), SqlNullableBinary(None)])
        @Assert(1, rowCount.rowCount)
        prepareStatement.close()
        prepareStatement = conn.prepareStatement("select * from test")
        var queryResult = prepareStatement.query()
        var arr: Array<SqlDbType> = [SqlBinary([0, 11]), SqlNullableBinary(None)]
        queryResult.next(arr)

        // @Assert("SqlBinary", queryResult.columnInfos[0].typeName)
        match (arr[0]) {
            case v: SqlBinary => @Assert(true, v.value[..2]==[0, 22])
            case _ => @Assert("abc", "123")
        }

        // @Assert("SqlNullableBinary", queryResult.columnInfos[1].typeName)
        match (arr[1]) {
            case v: SqlNullableBinary => @Assert(None, v.value)
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
