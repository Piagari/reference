// 3rd_party_lib:mysqlclient-ffi/build/mysqlclient
// 3rd_party_lib_ohos:mysqlclient-ffi/build/aarch64-linux-ohos/mysqlclient
import std.database.sql.*
import std.io.*
import std.time.*
import std.regex.*
import std.math.*
import mysqlclient_ffi.*

@Test
public class OdbcTest {
    init() {}
    @TestCase
    public func test001(): Unit {
        var driver = MysqlDriver("mysql")
        var database = driver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )
        try {
            var conn = database.connect()
            conn.prepareStatement("drop table if exists test")
        } catch (e: SqlException) {
            @Assert(e.message.startsWith("HY000, SqlState: [MySQL][ODBC 8.0(a) Driver]Access denied for user 'root'"))
            @Assert(e.message.endsWith("' (using password: YES), errorCode: 1045"))

            database = driver.open(
                "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
                Array<(String, String)>()
            )
            var conn = database.connect()

            conn.state
            conn.isClosed()
            conn.close()
            conn.close()
        }
    }
}
