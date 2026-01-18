// 3rd_party_lib:mysqlclient-ffi/build/mysqlclient
// 3rd_party_lib_ohos:mysqlclient-ffi/build/aarch64-linux-ohos/mysqlclient
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*
import std.math.*

@C
foreign func system(str: CString): CString

// @When[os == "windows"]
// var str1 = "net start mysql"

// @When[os == "windows"]
// var str2 = "net start mysql"

// @When[os != "windows"]
// var str1 = "service mysql start"

// @When[os != "windows"]
// var str2 = "docker restart some-mysql"

@Test
public class MysqlServerApiTest {
    @TestCase
    func mysqlServerApiTest002(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlServerApi: MysqlServerApi = MysqlServerApi(mysqlConnection)

        // mysqlServerApi.mysqlShutdown(MysqlShutdownLevel.SHUTDOWN_DEFAULT)

        // unsafe {
        //     let CStr1: CString = LibC.mallocCString(str1)
        //     system(CStr1)
        // }        
        // unsafe {
        //     let CStr2: CString = LibC.mallocCString(str2)
        //     system(CStr2)
        // }

        mysqlConnection.close()
    }
}
