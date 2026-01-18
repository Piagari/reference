// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*
import std.math.*

main(): Int64 {
    let mysqlRecordApi01Test: MysqlRecordApi03Test = MysqlRecordApi03Test()

    mysqlRecordApi01Test.mysqlRecordApiTest001()
    mysqlRecordApi01Test.mysqlRecordApiTest002()
    mysqlRecordApi01Test.mysqlRecordApiTest003()
    mysqlRecordApi01Test.mysqlRecordApiTest004()
    mysqlRecordApi01Test.mysqlRecordApiTest005()

    mysqlRecordApi01Test.mysqlRecordApiTest006()
    mysqlRecordApi01Test.mysqlRecordApiTest007()
    mysqlRecordApi01Test.mysqlRecordApiTest008()
    mysqlRecordApi01Test.mysqlRecordApiTest009()
    mysqlRecordApi01Test.mysqlRecordApiTest010()

    mysqlRecordApi01Test.mysqlRecordApiTest011()
    mysqlRecordApi01Test.mysqlRecordApiTest012()
    mysqlRecordApi01Test.mysqlRecordApiTest013()
    mysqlRecordApi01Test.mysqlRecordApiTest014()
    mysqlRecordApi01Test.mysqlRecordApiTest015()

    mysqlRecordApi01Test.mysqlRecordApiTest016()
    mysqlRecordApi01Test.mysqlRecordApiTest017()

    return 0
}

@Test
public class MysqlRecordApi03Test {
    @TestCase
    func mysqlRecordApiTest001(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        // 删除t_test2名称数据表
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_time")
        mysqlStatement1.update()

        // 创建t_test2名称数据表
        var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test_time(id bigint not null, timeValue1 time not null, timeValue2 time)")
        mysqlStatement2.update()

        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)

        // 通过传入的 sql 语句，返回一个预执行的 Statement 对象实例
        var mysqlStatement3: MysqlStatement = mysqlConnection.prepareStatement(
            "insert into  t_test_time(id,timeValue1,timeValue2)  VALUES(?,?,?)")
        @Assert(3, mysqlStatement3.parameterCount)
        let dateTime1: DateTime = DateTime.of(year: 1, month: 1, dayOfMonth: 1, hour: 8, minute: 10, second: 30)
        var id: SqlBigInt = SqlBigInt(1)
        var time1: SqlTime = SqlTime(dateTime1)
        var time2: SqlNullableTime = SqlNullableTime(None)
        var arrDb: Array<SqlDbType> = [id, time1, time2]

        // 执行插入语句插入数据
        var mysqlUpdateResult1: MysqlUpdateResult = mysqlStatement3.update(arrDb)
        @Assert(1, mysqlUpdateResult1.rowCount)
        @Assert(0, mysqlUpdateResult1.lastInsertId)
        var rowUint64: UInt64 = mysqlRecordApi.mysqlAffectedRows()
        @Assert(1, rowUint64)
        var idUint64: UInt64 = mysqlRecordApi.mysqlInsertId()
        @Assert(0, idUint64)

        let dateTime2: DateTime = DateTime.of(year: 1, month: 1, dayOfMonth: 1, hour: 8, minute: 10, second: 30)
        let dateTime3: DateTime = DateTime.of(year: 1, month: 1, dayOfMonth: 1, hour: 12, minute: 5, second: 3)
        id = SqlBigInt(2)
        time1 = SqlTime(dateTime2)
        time2 = SqlNullableTime(dateTime3)
        arrDb = [id, time1, time2]

        // 执行插入语句插入数据
        var mysqlUpdateResult2: MysqlUpdateResult = mysqlStatement3.update(arrDb)
        @Assert(1, mysqlUpdateResult2.rowCount)
        rowUint64 = mysqlRecordApi.mysqlAffectedRows()
        @Assert(1, rowUint64)
        idUint64 = mysqlRecordApi.mysqlInsertId()
        @Assert(0, idUint64)

        let dateTime4: DateTime = DateTime.of(year: 1, month: 1, dayOfMonth: 1, hour: 18, minute: 20, second: 40)
        let dateTime5: DateTime = DateTime.of(year: 1, month: 1, dayOfMonth: 1, hour: 22, minute: 35, second: 53)
        id = SqlBigInt(3)
        time1 = SqlTime(dateTime4)
        time2 = SqlNullableTime(dateTime5)
        arrDb = [id, time1, time2]

        // 执行插入语句插入数据
        var mysqlUpdateResult3: MysqlUpdateResult = mysqlStatement3.update(arrDb)
        @Assert(1, mysqlUpdateResult3.rowCount)
        rowUint64 = mysqlRecordApi.mysqlAffectedRows()
        @Assert(1, rowUint64)
        idUint64 = mysqlRecordApi.mysqlInsertId()
        @Assert(0, idUint64)

        let retInt32: Int32 = mysqlRecordApi.mysqlRealQuery("select * from t_test_time")
        @Assert(0, retInt32)

        let cpUnit: CPointer<Unit> = mysqlRecordApi.mysqlStoreResult()

        let retFields: UInt32 = mysqlRecordApi.mysqlNumFields(cpUnit)
        @Assert(3, retFields)
        let retEof: Bool = mysqlRecordApi.mysqlEof(cpUnit)
        @Assert(true, retEof)
        let retRows: UInt64 = mysqlRecordApi.mysqlNumRows(cpUnit)
        @Assert(3, retRows)
        unsafe {
            for (i in 0..retRows) {
                var cpCString: CPointer<CString> = mysqlRecordApi.mysqlFetchRow(cpUnit)
                for (j in 0..retFields) {
                    var cString: CString = cpCString.read(Int64(j))
                    if (i == 0 && j == 0) {
                        @Assert("1", cString.toString())
                    }
                    if (i == 0 && j == 1) {
                        @Assert("08:10:30", cString.toString())
                    }
                    if (i == 0 && j == 2) {
                        @Assert("", cString.toString())
                    }
                    if (i == 1 && j == 0) {
                        @Assert("2", cString.toString())
                    }
                    if (i == 1 && j == 1) {
                        @Assert("08:10:30", cString.toString())
                    }
                    if (i == 1 && j == 2) {
                        @Assert("12:05:03", cString.toString())
                    }
                    if (i == 2 && j == 0) {
                        @Assert("3", cString.toString())
                    }
                    if (i == 2 && j == 1) {
                        @Assert("18:20:40", cString.toString())
                    }
                    if (i == 2 && j == 2) {
                        @Assert("22:35:53", cString.toString())
                    }
                }
            }
        }
        mysqlRecordApi.mysqlFreeResult(cpUnit)

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    func mysqlRecordApiTest002(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)

        let retInt32: Int32 = mysqlRecordApi.mysqlRealQuery("")
        @Assert(1, retInt32)

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    func mysqlRecordApiTest003(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)

        let retInt32: Int32 = mysqlRecordApi.mysqlRealQuery(
            "select * from t_test_timet_test_timet_test_timet_test_timet_test_time")
        @Assert(1, retInt32)

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    func mysqlRecordApiTest004(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)

        let retInt32: Int32 = mysqlRecordApi.mysqlRealQuery("select * form t_test_time")
        @Assert(1, retInt32)

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    func mysqlRecordApiTest005(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)

        let retInt32: Int32 = mysqlRecordApi.mysqlRealQuery("drop table if exists t_test_time")
        @Assert(0, retInt32)

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    func mysqlRecordApiTest006(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)

        let retInt32: Int32 = mysqlRecordApi.mysqlRealQuery(
            "create table t_test_time(id bigint not null, timeValue1 time not null, timeValue2 time)")
        @Assert(0, retInt32)

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    func mysqlRecordApiTest007(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)

        let retInt32: Int32 = mysqlRecordApi.mysqlRealQuery("desc t_test_time")
        @Assert(0, retInt32)

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    func mysqlRecordApiTest008(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)

        let retInt32: Int32 = mysqlRecordApi.mysqlRealQuery("alter table t_test_time add(name varchar(100))")
        @Assert(0, retInt32)

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    func mysqlRecordApiTest009(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)

        let retInt32: Int32 = mysqlRecordApi.mysqlRealQuery("alter table t_test_time modify name varchar(30)")
        @Assert(0, retInt32)

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    func mysqlRecordApiTest010(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)

        let retInt32: Int32 = mysqlRecordApi.mysqlRealQuery("alter table t_test_time change name charname varchar(30)")
        @Assert(0, retInt32)

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    func mysqlRecordApiTest011(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)

        let retInt32: Int32 = mysqlRecordApi.mysqlRealQuery("alter table t_test_time drop charname")
        @Assert(0, retInt32)

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    func mysqlRecordApiTest012(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)

        var retInt32: Int32 = mysqlRecordApi.mysqlRealQuery("alter table t_test_time rename to t_test_time1")
        @Assert(0, retInt32)

        retInt32 = mysqlRecordApi.mysqlRealQuery("drop table if exists t_test_time1")
        @Assert(0, retInt32)

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    func mysqlRecordApiTest013(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)

        let retInt32: Int32 = mysqlRecordApi.mysqlRealQuery("create database if not exists mysql1")
        @Assert(0, retInt32)

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    func mysqlRecordApiTest014(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)

        var retInt32: Int32 = mysqlRecordApi.mysqlRealQuery("use mysql1")
        @Assert(0, retInt32)

        retInt32 = mysqlRecordApi.mysqlRealQuery("alter database mysql1 character set utf8")
        @Assert(0, retInt32)

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    func mysqlRecordApiTest015(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)

        let retInt32: Int32 = mysqlRecordApi.mysqlRealQuery("drop database if exists mysql1")
        @Assert(0, retInt32)

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    func mysqlRecordApiTest016(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)

        var retInt32: Int32 = mysqlRecordApi.mysqlRealQuery("drop table if exists t_test_varchar")
        @Assert(0, retInt32)

        retInt32 = mysqlRecordApi.mysqlRealQuery(
            "create table t_test_varchar(id bigint not null, varcharValue1 varchar(5500) not null, varcharValue2 varchar(50))"
        )
        @Assert(0, retInt32)

        retInt32 = mysqlRecordApi.mysqlRealQuery(
            "insert into t_test_varchar(id,varcharValue1,varcharValue2) values(0,'lihua','100')")
        @Assert(0, retInt32)

        retInt32 = mysqlRecordApi.mysqlRealQuery("insert into t_test_varchar values(1,'liumei','99')")
        @Assert(0, retInt32)

        retInt32 = mysqlRecordApi.mysqlRealQuery("insert into t_test_varchar values(2,'wangwu','89')")
        @Assert(0, retInt32)

        retInt32 = mysqlRecordApi.mysqlRealQuery("insert into t_test_varchar values(3,'zhangsan','70')")
        @Assert(0, retInt32)

        retInt32 = mysqlRecordApi.mysqlRealQuery("insert into t_test_varchar values(4,'madongmei','60')")
        @Assert(0, retInt32)

        retInt32 = mysqlRecordApi.mysqlRealQuery(
            "update t_test_varchar set varcharValue1='liumei', varcharValue2='98' where id=1")
        @Assert(0, retInt32)

        retInt32 = mysqlRecordApi.mysqlRealQuery("delete from t_test_varchar where id=1")
        @Assert(0, retInt32)

        retInt32 = mysqlRecordApi.mysqlRealQuery("truncate table t_test_varchar")
        @Assert(0, retInt32)

        retInt32 = mysqlRecordApi.mysqlRealQuery("drop table if exists t_test_varchar")
        @Assert(0, retInt32)

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    func mysqlRecordApiTest017(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)

        var retInt32: Int32 = mysqlRecordApi.mysqlRealQuery("drop table if exists t_test_varchar")
        @Assert(0, retInt32)

        retInt32 = mysqlRecordApi.mysqlRealQuery(
            "create table t_test_varchar(id bigint not null, varcharValue1 varchar(5500) not null, varcharValue2 varchar(50))"
        )
        @Assert(0, retInt32)

        retInt32 = mysqlRecordApi.mysqlRealQuery(
            "insert into t_test_varchar(id,varcharValue1,varcharValue2) values(0,'lihua','100')")
        @Assert(0, retInt32)

        retInt32 = mysqlRecordApi.mysqlRealQuery("insert into t_test_varchar values(1,'liumei','99')")
        @Assert(0, retInt32)

        retInt32 = mysqlRecordApi.mysqlRealQuery("insert into t_test_varchar values(2,'wangwu','89')")
        @Assert(0, retInt32)

        retInt32 = mysqlRecordApi.mysqlRealQuery("insert into t_test_varchar values(3,'zhangsan','70')")
        @Assert(0, retInt32)

        retInt32 = mysqlRecordApi.mysqlRealQuery("insert into t_test_varchar values(4,'madongmei','60')")
        @Assert(0, retInt32)

        retInt32 = mysqlRecordApi.mysqlRealQuery("select * from t_test_varchar")
        @Assert(0, retInt32)
        mysqlRecordApi.mysqlStoreResult()

        retInt32 = mysqlRecordApi.mysqlRealQuery("select id from t_test_varchar")
        @Assert(0, retInt32)
        mysqlRecordApi.mysqlStoreResult()

        retInt32 = mysqlRecordApi.mysqlRealQuery("select * from t_test_varchar where id=1")
        @Assert(0, retInt32)
        mysqlRecordApi.mysqlStoreResult()

        retInt32 = mysqlRecordApi.mysqlRealQuery("select * from t_test_varchar where varcharValue1 like '%li%'")
        @Assert(0, retInt32)
        mysqlRecordApi.mysqlStoreResult()

        retInt32 = mysqlRecordApi.mysqlRealQuery("select * from t_test_varchar where id!=2")
        @Assert(0, retInt32)
        mysqlRecordApi.mysqlStoreResult()

        retInt32 = mysqlRecordApi.mysqlRealQuery("select * from t_test_varchar where id=2 or varcharValue1='lihua'")
        @Assert(0, retInt32)
        mysqlRecordApi.mysqlStoreResult()

        retInt32 = mysqlRecordApi.mysqlRealQuery("drop table if exists t_test_varchar")
        @Assert(0, retInt32)

        // 关闭链接
        mysqlConnection.close()
    }
}
