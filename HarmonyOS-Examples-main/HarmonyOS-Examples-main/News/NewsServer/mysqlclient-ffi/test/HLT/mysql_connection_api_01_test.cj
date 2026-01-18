// 3rd_party_lib:mysqlclient-ffi/build/mysqlclient
// 3rd_party_lib_ohos:mysqlclient-ffi/build/aarch64-linux-ohos/mysqlclient
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*

@Test
public class MysqlConnectionApiTest {
    @TestCase
    func mysqlConnectionApiTest001(): Unit {
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
        let ret: Int32 = mysqlConnectionApi.mysqlSelectDb("mysql")
        @Assert(0, ret)

        mysqlConnection.close()
    }

    @TestCase
    func mysqlConnectionApiTest002(): Unit {
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
        let ret: Int32 = mysqlConnectionApi.mysqlSelectDb("0")
        @Assert(true, ret != 0)

        mysqlConnection.close()
    }

    @TestCase
    func mysqlConnectionApiTest003(): Unit {
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
        let ret: Int32 = mysqlConnectionApi.mysqlSelectDb("")
        @Assert(true, ret != 0)

        mysqlConnection.close()
    }

    @TestCase
    func mysqlConnectionApiTest004(): Unit {
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
        let ret: Int32 = mysqlConnectionApi.mysqlSelectDb("/:65438&**%%")
        @Assert(true, ret != 0)

        mysqlConnection.close()
    }

    @TestCase
    func mysqlConnectionApiTest005(): Unit {
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
        let ret: Int32 = mysqlConnectionApi.mysqlSelectDb("你好")
        @Assert(true, ret != 0)

        mysqlConnection.close()
    }

    @TestCase
    func mysqlConnectionApiTest006(): Unit {
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
        let ret: Int32 = mysqlConnectionApi.mysqlSelectDb("你好123qwe%^&")
        @Assert(true, ret != 0)

        mysqlConnection.close()
    }

    @TestCase
    func mysqlConnectionApiTest007(): Unit {
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
        let ret: Int32 = mysqlConnectionApi.mysqlSelectDb("asvdcvxcasfdasdasdasdsa")
        @Assert(true, ret != 0)

        mysqlConnection.close()
    }

    @TestCase
    func mysqlConnectionApiTest008(): Unit {
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
        let ret: Int32 = mysqlConnectionApi.mysqlResetConnection()
        @Assert(true, ret == 0)

        mysqlConnection.close()
    }
}
