// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*
import std.math.*

main(): Int64 {
    let mysqlSslApiTest: MysqlSslApiTest = MysqlSslApiTest()

    mysqlSslApiTest.mysqlSslApiTest001()

    return 0
}

@Test
public class MysqlSslApiTest {
    @TestCase
    func mysqlSslApiTest001(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlSslApi: MysqlSslApi = MysqlSslApi(mysqlConnection)

        var isBool: Bool = mysqlSslApi.mysqlSslSet("", "", "", "", "")
        @Assert(false, isBool)

        var strCipher: String = mysqlSslApi.mysqlGetSslCipher()
        // windosw TLS_AES_256_GCM_SHA384
        // linux 空字符串
        println(strCipher)

        isBool = mysqlSslApi.mysqlGetSslSessionReused()
        @Assert(false, isBool)

        mysqlSslApi.mysqlGetSslSessionData(0, CPointer<UInt32>())

        isBool = mysqlSslApi.mysqlFreeSslSessionData(CPointer<Unit>())
        @Assert(true, isBool)

        mysqlConnection.close()
    }
}
