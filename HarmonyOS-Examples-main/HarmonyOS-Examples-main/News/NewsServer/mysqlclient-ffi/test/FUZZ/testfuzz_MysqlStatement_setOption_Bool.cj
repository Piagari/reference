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

let arr: Array<(String, String)> = Array<(String, String)>()
func fuzz_MysqlStatement_setOption_Bool(dp: DataProvider): Int32 {
    let mysqlStatement: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test1")
    // public func setOption(option: MysqlStmtAttrType, arg: Bool): Unit
    try {
        mysqlStatement.setOption(MysqlStmtAttrType.STMT_ATTR_PREFETCH_ROWS,dp.consumeBool())
    } catch (e1: Exception) {
        returnFlag = 1
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_MysqlStatement_setOption_Bool).startFuzz()

    return 0
}
