// 3rd_party_lib:mysqlclient-ffi/build/mysqlclient
// 3rd_party_lib_ohos:mysqlclient-ffi/build/aarch64-linux-ohos/mysqlclient
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*

@Test
public class MysqlConnectionApiTest {
    @TestCase
    func mysqlConnectionApiTest009(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlConnectionApi: MysqlConnectionApi = MysqlConnectionApi(mysqlConnection)
        var isBool: Bool = mysqlConnectionApi.mysqlChangeUser("root", "123456", "mysql")
        @Assert(true, isBool)

        isBool = mysqlConnectionApi.mysqlChangeUser("tttttt", "00000000000000000", "mysql")
        @Assert(true, isBool)

        mysqlConnection.close()
    }
}
