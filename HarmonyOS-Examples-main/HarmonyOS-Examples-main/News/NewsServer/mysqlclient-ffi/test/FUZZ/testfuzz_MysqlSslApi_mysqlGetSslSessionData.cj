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
        
func fuzz_MysqlSslApi_mysqlGetSslSessionData(dp: DataProvider): Int32 {
    let mysqlSslApi: MysqlSslApi = MysqlSslApi(mysqlConnection)
    // public func mysqlGetSslSessionData(nTicket: UInt32, outLen: CPointer<UInt32>): Unit
    try {
        mysqlSslApi.mysqlGetSslSessionData(dp.consumeUInt32(),CPointer<UInt32>())
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_MysqlSslApi_mysqlGetSslSessionData).startFuzz()

    return 0
}
