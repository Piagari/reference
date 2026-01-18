// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*

/*
 * MysqlDriver.openString接口参数问题抛IllegalArgumentException异常
 */
main(): Int64 {
    // 初始化数据库驱动
    let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

    var isBool: Bool = false
    try {
        mysqlDriver.open("HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=;UNIX_SOCKET=;CLIENT_FLAG=0")
    } catch (e: SqlException) {
        isBool = true
        @Assert(true, e.message.contains("Url is error!"))
    }
    @Assert(true, isBool)

    isBool = false
    try {
        mysqlDriver.open("HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=;UNIX_SOCKET=3306;CLIENT_FLAG=")
    } catch (e: SqlException) {
        isBool = true
        @Assert(true, e.message.contains("Url is error!"))
    }
    @Assert(true, isBool)

    isBool = false
    try {
        mysqlDriver.open("HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=;UNIX_SOCKET=;CLIENT_FLAG=")
    } catch (e: SqlException) {
        isBool = true
        @Assert(true, e.message.contains("Url is error!"))
    }
    @Assert(true, isBool)

    isBool = false
    try {
        mysqlDriver.open("HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=q;UNIX_SOCKET=;CLIENT_FLAG=0")
    } catch (e: SqlException) {
        isBool = true
        @Assert(true, e.message.contains("Url is error!"))
    }
    @Assert(true, isBool)

    isBool = false
    try {
        mysqlDriver.open("HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=p")
    } catch (e: SqlException) {
        isBool = true
        @Assert(true, e.message.contains("Url is error!"))
    }
    @Assert(true, isBool)

    return 0
}
