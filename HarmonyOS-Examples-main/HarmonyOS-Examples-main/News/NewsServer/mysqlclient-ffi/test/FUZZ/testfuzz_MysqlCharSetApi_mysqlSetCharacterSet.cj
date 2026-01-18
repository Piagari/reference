// 3rd_party_lib:mysqlclient-ffi/build/mysqlclient
import std.database.sql.*
import std.io.*
import std.time.*
import std.regex.*
import std.math.*
import mysqlclient_ffi.*
import fuzz.*

var returnFlag: Int32 = 0
let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
        "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
        Array<(String, String)>())
let mysqlConnection: MysqlConnection = mysqlDatasource.connect()
        
func fuzz_MysqlCharSetApi_mysqlSetCharacterSet(dp: DataProvider): Int32 {
    let mysqlCharSetApi: MysqlCharSetApi = MysqlCharSetApi(mysqlConnection)
    // public func mysqlSetCharacterSet(charset: String): Int32
    try {
        mysqlCharSetApi.mysqlSetCharacterSet(dp.consumeString(10))
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_MysqlCharSetApi_mysqlSetCharacterSet).startFuzz()

    return 0
}
