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
        
func fuzz_MysqlServerApi_mysqlKill(dp: DataProvider): Int32 {
    let mysqlServerApi: MysqlServerApi = MysqlServerApi(mysqlConnection)
    // public func mysqlKill(pid: UInt64): Int32
    try {
        mysqlServerApi.mysqlKill(dp.consumeUInt64())
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_MysqlServerApi_mysqlKill).startFuzz()

    return 0
}
