// 3rd_party_lib:mysqlclient-ffi/build/mysqlclient
import std.database.sql.*
import std.io.*
import std.time.*
import std.regex.*
import std.math.*
import mysqlclient_ffi.*
import fuzz.*

var returnFlag: Int32 = 0
var driver = MysqlDriver("mysql")

func fuzz_MysqlDatasource_setOption_string(dp: DataProvider): Int32 {
    let datasource:MysqlDatasource = driver.open(
        "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
        Array<(String, String)>()
    )
    //  public func setOption(key: MysqlOption, value: String): Unit
    try {
        datasource.setOption(MysqlOption.MYSQL_OPT_CONNECT_TIMEOUT,dp.consumeString(10))
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_MysqlDatasource_setOption_string).startFuzz()

    return 0
}
