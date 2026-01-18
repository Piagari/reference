// 3rd_party_lib:mysqlclient-ffi/build/mysqlclient
import std.database.sql.*
import std.io.*
import std.time.*
import std.regex.*
import std.math.*
import mysqlclient_ffi.*
import fuzz.*

var returnFlag: Int32 = 0
let REFRESH_GRANT:UInt32 = 1    /**< Refresh grant tables, FLUSH PRIVILEGES */
let REFRESH_LOG:UInt32 = 2      /**< Start on new log file, FLUSH LOGS */
let REFRESH_TABLES:UInt32 = 4   /**< close all tables, FLUSH TABLES */
let REFRESH_HOSTS:UInt32 = 8    /**< Flush host cache, FLUSH HOSTS */
let REFRESH_STATUS:UInt32 = 16  /**< Flush status variables, FLUSH STATUS */
let REFRESH_THREADS:UInt32 = 32 /**< Flush thread cache */
let REFRESH_REPLICA:UInt32 = 64  // Reset master info and restart replica thread, RESET REPLICA                      \
let REFRESH_MASTER:UInt32 = 128 // Remove all bin logs in the index and truncate the index, RESET MASTER                                              \
let REFRESH_ERROR_LOG:UInt32 = 256    /**< Rotate only the error log */
let REFRESH_ENGINE_LOG:UInt32 = 512   /**< Flush all storage engine logs */
let REFRESH_BINARY_LOG:UInt32 = 1024  /**< Flush the binary log */
let REFRESH_RELAY_LOG:UInt32 = 2048   /**< Flush the relay log */
let REFRESH_GENERAL_LOG:UInt32 = 4096 /**< Flush the general log */
let REFRESH_SLOW_LOG:UInt32 = 8192    /**< Flush the slow query log */
let REFRESH_READ_LOCK:UInt32 = 16384  /**< Lock tables for read. */
let REFRESH_FAST:UInt32 = 32768

let arrBase:Array<UInt32> = [REFRESH_GRANT,REFRESH_LOG,REFRESH_TABLES,REFRESH_HOSTS,REFRESH_STATUS,REFRESH_THREADS,REFRESH_REPLICA,
REFRESH_MASTER,REFRESH_ERROR_LOG,REFRESH_ENGINE_LOG,REFRESH_BINARY_LOG,REFRESH_RELAY_LOG,REFRESH_GENERAL_LOG,REFRESH_SLOW_LOG,REFRESH_READ_LOCK,REFRESH_FAST]

let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
        "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
        Array<(String, String)>())
let mysqlConnection: MysqlConnection = mysqlDatasource.connect()
        
func fuzz_MysqlServerApi_mysqlRefresh(dp: DataProvider): Int32 {
    let mysqlServerApi: MysqlServerApi = MysqlServerApi(mysqlConnection)
    var num = dp.consumeUInt32()
    for (obj in arrBase) {
        if(num == obj){
            // public func mysqlRefresh(refreshOptions: UInt32): Int32
            try {
                mysqlServerApi.mysqlRefresh(num)
            } catch (e1: Exception) {
                returnFlag = 1
            }
        }
    }
    return returnFlag
}

main() {
    Fuzzer(fuzz_MysqlServerApi_mysqlRefresh).startFuzz()

    return 0
}
