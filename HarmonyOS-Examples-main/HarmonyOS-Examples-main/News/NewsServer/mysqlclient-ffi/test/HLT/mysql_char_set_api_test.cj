// 3rd_party_lib:mysqlclient-ffi/build/mysqlclient
// 3rd_party_lib_ohos:mysqlclient-ffi/build/aarch64-linux-ohos/mysqlclient
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*

@Test
public class MysqlCharSetApiTest {
    @TestCase
    func mysqlCharSetApiTest001(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlCharSetApi: MysqlCharSetApi = MysqlCharSetApi(mysqlConnection)
        @Assert("utf8mb4", mysqlCharSetApi.mysqlCharacterSetName())

        var ret: Int32 = mysqlCharSetApi.mysqlSetCharacterSet("utf8")
        @Assert(true, ret == 0)
        @Assert("utf8mb3", mysqlCharSetApi.mysqlCharacterSetName())

        ret = mysqlCharSetApi.mysqlSetCharacterSet("ascii")
        @Assert(true, ret == 0)
        @Assert("ascii", mysqlCharSetApi.mysqlCharacterSetName())

        ret = mysqlCharSetApi.mysqlSetCharacterSet("gbk")
        @Assert(true, ret == 0)
        @Assert("gbk", mysqlCharSetApi.mysqlCharacterSetName())

        ret = mysqlCharSetApi.mysqlSetCharacterSet("utf8mb4")
        @Assert(true, ret == 0)
        @Assert("utf8mb4", mysqlCharSetApi.mysqlCharacterSetName())

        mysqlConnection.close()
    }

    @TestCase
    func mysqlCharSetApiTest002(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlCharSetApi: MysqlCharSetApi = MysqlCharSetApi(mysqlConnection)

        var ret: Int32 = mysqlCharSetApi.mysqlSetCharacterSet("1")
        @Assert(false, ret == 0)
        @Assert("utf8mb4", mysqlCharSetApi.mysqlCharacterSetName())

        ret = mysqlCharSetApi.mysqlSetCharacterSet("____")
        @Assert(false, ret == 0)
        @Assert("utf8mb4", mysqlCharSetApi.mysqlCharacterSetName())

        ret = mysqlCharSetApi.mysqlSetCharacterSet("acfasfdsfds")
        @Assert(false, ret == 0)
        @Assert("utf8mb4", mysqlCharSetApi.mysqlCharacterSetName())

        ret = mysqlCharSetApi.mysqlSetCharacterSet("fsa4290312>>")
        @Assert(false, ret == 0)
        @Assert("utf8mb4", mysqlCharSetApi.mysqlCharacterSetName())

        ret = mysqlCharSetApi.mysqlSetCharacterSet("123")
        @Assert(false, ret == 0)
        @Assert("utf8mb4", mysqlCharSetApi.mysqlCharacterSetName())

        ret = mysqlCharSetApi.mysqlSetCharacterSet(">><<<^*#@~!()")
        @Assert(false, ret == 0)
        @Assert("utf8mb4", mysqlCharSetApi.mysqlCharacterSetName())

        ret = mysqlCharSetApi.mysqlSetCharacterSet("")
        @Assert(false, ret == 0)
        @Assert("utf8mb4", mysqlCharSetApi.mysqlCharacterSetName())

        mysqlConnection.close()
    }
}
