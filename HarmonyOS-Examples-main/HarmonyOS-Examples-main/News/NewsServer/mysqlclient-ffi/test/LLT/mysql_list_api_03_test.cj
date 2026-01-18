// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*
import std.math.*

main(): Int64 {
    let mysqlListApi01Test: MysqlListApi03Test = MysqlListApi03Test()

    mysqlListApi01Test.mysqlListApiTest001()

    return 0
}

@Test
public class MysqlListApi03Test {
    @TestCase
    public func mysqlListApiTest001(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlListApi: MysqlListApi = MysqlListApi(mysqlConnection)
        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)
        let cp1: CPointer<Unit> = mysqlListApi.mysqlListTables()
        let retFields: UInt32 = mysqlRecordApi.mysqlNumFields(cp1)
        @Assert(true, retFields!=0)
        let retEof: Bool = mysqlRecordApi.mysqlEof(cp1)
        @Assert(true, retEof)
        let retRows: UInt64 = mysqlRecordApi.mysqlNumRows(cp1)
        @Assert(true, retRows!=0)
        unsafe {
            for (i in 0..retRows) {
                var cpCString: CPointer<CString> = mysqlRecordApi.mysqlFetchRow(cp1)
                for (j in 0..retFields) {
                    var cString: CString = cpCString.read(Int64(j))
                    println(cString.toString())
                    if (i == 3) {
                        @Assert("mysql", cString.toString())
                    }
                }
            }
        }
        mysqlRecordApi.mysqlFreeResult(cp1)

        mysqlConnection.close()
    }
}
