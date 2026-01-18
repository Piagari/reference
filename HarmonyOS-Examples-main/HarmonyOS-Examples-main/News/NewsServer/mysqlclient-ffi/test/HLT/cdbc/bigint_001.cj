// 3rd_party_lib:mysqlclient-ffi/build/mysqlclient
// 3rd_party_lib_ohos:mysqlclient-ffi/build/aarch64-linux-ohos/mysqlclient
import std.database.sql.*
import std.io.*
import std.time.*
import std.regex.*
import std.math.*
import mysqlclient_ffi.*

@Test
public class bigint_001 {
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
        prepareStatement = conn.prepareStatement("create table test(data bigint NOT NULL, datanull bigint)")
        rowCount = prepareStatement.update()
        @Assert(0, rowCount.rowCount)
        prepareStatement.close()
    }

    @TestCase
    public func bigint_001(): Unit {
        prepareStatement = conn.prepareStatement("insert into test values(?,?)")
        var rowCount = prepareStatement.update([SqlBigInt(Int64.Max), SqlNullableBigInt(None)])
        @Assert(1, rowCount.rowCount)
        prepareStatement.close()
        prepareStatement = conn.prepareStatement("select * from test")
        var queryResult = prepareStatement.query()
        var arr: Array<SqlDbType> = [SqlBigInt(0), SqlNullableBigInt(0)]
        queryResult.next(arr)
        @Assert("SqlBigInt", queryResult.columnInfos[0].typeName)
        match (arr[0]) {
            case v: SqlBigInt => @Assert(Int64.Max, v.value)
            case _ => @Assert("abc", "123")
        }
        @Assert("SqlNullableBigInt", queryResult.columnInfos[1].typeName)
        match (arr[1]) {
            case v: SqlNullableBigInt => @Assert(None, v.value)
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
