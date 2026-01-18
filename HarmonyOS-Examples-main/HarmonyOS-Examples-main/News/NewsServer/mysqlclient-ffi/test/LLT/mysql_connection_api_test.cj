// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*
import std.math.*

main(): Int64 {
    let mysqlConnectionApiTest: MysqlConnectionApiTest = MysqlConnectionApiTest()

    mysqlConnectionApiTest.mysqlConnectionApiTest001()
    mysqlConnectionApiTest.mysqlConnectionApiTest002()
    mysqlConnectionApiTest.mysqlConnectionApiTest003()
    mysqlConnectionApiTest.mysqlConnectionApiTest004()
    mysqlConnectionApiTest.mysqlConnectionApiTest005()

    mysqlConnectionApiTest.mysqlConnectionApiTest006()
    mysqlConnectionApiTest.mysqlConnectionApiTest007()
    mysqlConnectionApiTest.mysqlConnectionApiTest008()

    return 0
}

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

    @Skip
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
