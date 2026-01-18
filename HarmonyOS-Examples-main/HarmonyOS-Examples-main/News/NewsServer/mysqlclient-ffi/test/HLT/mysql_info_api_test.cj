// 3rd_party_lib:mysqlclient-ffi/build/mysqlclient
// 3rd_party_lib_ohos:mysqlclient-ffi/build/aarch64-linux-ohos/mysqlclient
import mysqlclient_ffi.*
import std.database.sql.*
import std.unittest.*
import std.unittest.testmacro.*

@Test
public class MysqlInfoApi01Test {
    @TestCase
    func mysqlInfoApiTest001(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()
        let mysqlInfoApi: MysqlInfoApi = MysqlInfoApi(mysqlConnection)
        let retErrno: UInt32 = mysqlInfoApi.mysqlErrno()
        @Assert(0, retErrno)
        let strError: String = mysqlInfoApi.mysqlError()
        @Assert("", strError)
        let strState: String = mysqlInfoApi.mysqlSqlstate()
        @Assert("00000", strState)
        let retCount: UInt32 = mysqlInfoApi.mysqlWarningCount()
        @Assert(0, retCount)
        let strInfo: String = mysqlInfoApi.mysqlInfo()
        @Assert("", strInfo)
        let retInfo: Int32 = mysqlInfoApi.mysqlDumpDebugInfo()
        @Assert(0, retInfo)

        mysqlConnection.close()
    }

    @TestCase
    func mysqlInfoApiTest002(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        // 删除t_test2名称数据表
        mysqlConnection.prepareStatement("drop table if exists t_test_float")

        let mysqlInfoApi: MysqlInfoApi = MysqlInfoApi(mysqlConnection)
        let retErrno: UInt32 = mysqlInfoApi.mysqlErrno()
        @Assert(0, retErrno)
        let strError: String = mysqlInfoApi.mysqlError()
        @Assert("", strError)
        let strState: String = mysqlInfoApi.mysqlSqlstate()
        @Assert("00000", strState)
        let retCount: UInt32 = mysqlInfoApi.mysqlWarningCount()
        @Assert(0, retCount)
        let strInfo: String = mysqlInfoApi.mysqlInfo()
        @Assert("", strInfo)
        let retInfo: Int32 = mysqlInfoApi.mysqlDumpDebugInfo()
        @Assert(0, retInfo)

        mysqlConnection.close()
    }

    @TestCase
    func mysqlInfoApiTest003(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()
        try {
            mysqlConnection.prepareStatement("drop")
        } catch (e: SqlException) {
            (e)
        }
        let mysqlInfoApi: MysqlInfoApi = MysqlInfoApi(mysqlConnection)
        let retErrno: UInt32 = mysqlInfoApi.mysqlErrno()
        @Assert(1064, retErrno)
        let strError: String = mysqlInfoApi.mysqlError()
        @Assert("You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '' at line 1", strError)
        let strState: String = mysqlInfoApi.mysqlSqlstate()
        @Assert("42000", strState)
        let retCount: UInt32 = mysqlInfoApi.mysqlWarningCount()
        @Assert(0, retCount)
        let strInfo: String = mysqlInfoApi.mysqlInfo()
        @Assert("", strInfo)
        let retInfo: Int32 = mysqlInfoApi.mysqlDumpDebugInfo()
        @Assert(0, retInfo)

        mysqlConnection.close()
    }

    @TestCase
    func mysqlInfoApiTest004(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        // 删除t_test2名称数据表
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_float")
        mysqlStatement1.update()

        let mysqlInfoApi: MysqlInfoApi = MysqlInfoApi(mysqlConnection)
        let retErrno: UInt32 = mysqlInfoApi.mysqlErrno()
        @Assert(0, retErrno)
        let strError: String = mysqlInfoApi.mysqlError()
        @Assert("", strError)
        let strState: String = mysqlInfoApi.mysqlSqlstate()
        @Assert("00000", strState)
        let retCount: UInt32 = mysqlInfoApi.mysqlWarningCount()
        @Assert(1, retCount)
        let strInfo: String = mysqlInfoApi.mysqlInfo()
        @Assert("", strInfo)
        let retInfo: Int32 = mysqlInfoApi.mysqlDumpDebugInfo()
        @Assert(0, retInfo)

        // 删除t_test2名称数据表
        var mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_float")
        mysqlStatement9.update()

        let retErrno2: UInt32 = mysqlInfoApi.mysqlErrno()
        @Assert(0, retErrno2)
        let strError2: String = mysqlInfoApi.mysqlError()
        @Assert("", strError2)
        let strState2: String = mysqlInfoApi.mysqlSqlstate()
        @Assert("00000", strState2)
        let retCount2: UInt32 = mysqlInfoApi.mysqlWarningCount()
        @Assert(1, retCount2)
        let strInfo2: String = mysqlInfoApi.mysqlInfo()
        @Assert("", strInfo2)
        let retInfo2: Int32 = mysqlInfoApi.mysqlDumpDebugInfo()
        @Assert(0, retInfo2)

        mysqlConnection.close()
    }
}
