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

func fuzz_MysqlListApi_mysqlListDbs(dp: DataProvider): Int32 {
    let mysqlListApi: MysqlListApi = MysqlListApi(mysqlConnection)
    let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)
    // public func mysqlListDbs(wild: String): CPointer<Unit>
    try {
        let cp1: CPointer<Unit> = mysqlListApi.mysqlListDbs(dp.consumeString(5))
        mysqlRecordApi.mysqlFreeResult(cp1)
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_MysqlListApi_mysqlListDbs).startFuzz()
    mysqlConnection.close()
    return 0
}
