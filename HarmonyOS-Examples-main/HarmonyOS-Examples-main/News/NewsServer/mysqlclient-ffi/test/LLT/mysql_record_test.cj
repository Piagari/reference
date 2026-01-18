// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*

let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
let arr: Array<(String, String)> = Array<(String, String)>()
let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
    "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
    arr
)
let con: MysqlConnection = mysqlDatasource.connect()

main(): Int64 {
    let recordTest: RecordTest = RecordTest()

    recordTest.RecordTest01()
    recordTest.RecordTest02()
    recordTest.RecordTest03()
    recordTest.RecordTest04()
    recordTest.RecordTest05()
    recordTest.RecordTest06()
    recordTest.RecordTest07()
    recordTest.RecordTest08()

    return 0
}

@Test
public class RecordTest {
    @TestCase
    public func RecordTest01(): Unit {
        let record = MysqlRecordApi(con)
        let res = record.mysqlQuery("SELECT 'Hello, World!' AS message;")
        let val = record.mysqlStoreResult()
        record.mysqlFreeResult(val)
        @Assert(0, res)
    }

    @TestCase
    public func RecordTest02(): Unit {
        let record = MysqlRecordApi(con)
        let sql = "SELECT 'testtestets!' AS message"
        let res = record.mysqlSendQuery(sql)
        let val = record.mysqlStoreResult()
        record.mysqlFreeResult(val)
        @Assert(0, res)
    }

    @TestCase
    public func RecordTest03(): Unit {
        let record = MysqlRecordApi(con)
        let sql = "SELECT 'deeeeeeedededa' AS message"
        let res = record.mysqlRealQuery(sql)
        let val = record.mysqlStoreResult()
        record.mysqlFreeResult(val)
        @Assert(0, res)
    }

    @TestCase
    public func RecordTest04(): Unit {
        let record = MysqlRecordApi(con)
        let res = record.mysqlInsertId()
        @Assert(0, res)
    }

    @TestCase
    public func RecordTest05(): Unit {
        let record = MysqlRecordApi(con)
        let sql = "SELECT 'Hello, World!','asd' AS message;"
        record.mysqlRealQuery(sql)
        let val = record.mysqlStoreResult()
        let res = record.mysqlAffectedRows()
        record.mysqlFreeResult(val)
        @Assert(1, res)
    }

    @TestCase
    public func RecordTest06(): Unit {
        let record = MysqlRecordApi(con)
        let sql = "SELECT 'Hello, World!','asd' AS message;"
        record.mysqlRealQuery(sql)
        let val = record.mysqlStoreResult()
        let res = record.mysqlNumFields(val)
        record.mysqlFreeResult(val)
        @Assert(2, res)
    }

    @TestCase
    public func RecordTest07(): Unit {
        let record = MysqlRecordApi(con)
        let sql = "SELECT 'Hello, World!','asd' AS message;"
        record.mysqlRealQuery(sql)
        let val = record.mysqlStoreResult()
        let res = record.mysqlEof(val)
        record.mysqlFreeResult(val)
        @Assert(true, res)
    }

    @TestCase
    public func RecordTest08(): Unit {
        let record = MysqlRecordApi(con)
        let sql = "SELECT 'Hello, World!','asd' AS message;"
        record.mysqlRealQuery(sql)
        let val = record.mysqlStoreResult()
        let res = unsafe { record.mysqlFetchRow(val).read(1).toString() }
        record.mysqlFreeResult(val)
        @Assert(res, "asd")
    }
}
