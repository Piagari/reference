// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*
import std.math.*

main(): Int64 {
    let mysqlStmtApiTest: MysqlStmtApiTest = MysqlStmtApiTest()

    mysqlStmtApiTest.mysqlStmtApiTest001()
    mysqlStmtApiTest.mysqlStmtApiTest002()
    mysqlStmtApiTest.mysqlStmtApiTest003()
    mysqlStmtApiTest.mysqlStmtApiTest004()
    mysqlStmtApiTest.mysqlStmtApiTest005()

    mysqlStmtApiTest.mysqlStmtApiTest006()
    mysqlStmtApiTest.mysqlStmtApiTest007()

    return 0
}

@Test
public class MysqlStmtApiTest {
    @TestCase
    func mysqlStmtApiTest001(): Unit {
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
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_bigint")
        mysqlStatement1.update()

        let mysqlStmtApi: MysqlStmtApi = MysqlStmtApi(mysqlStatement1)
        let ret1 = mysqlStmtApi.mysqlStmtStoreResult()
        @Assert(0, ret1)

        let retBool1 = mysqlStmtApi.mysqlStmtFreeResult()
        @Assert(false, retBool1)

        let ret2 = mysqlStmtApi.mysqlStmtStoreResult()
        @Assert(0, ret2)

        mysqlStatement1.close()
        mysqlConnection.close()
    }

    @TestCase
    func mysqlStmtApiTest002(): Unit {
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
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_bigint")
        mysqlStatement1.update()

        let mysqlStmtApi: MysqlStmtApi = MysqlStmtApi(mysqlStatement1)
        let ret1 = mysqlStmtApi.mysqlStmtStoreResult()
        @Assert(0, ret1)

        let retBool = mysqlStmtApi.mysqlStmtReset()
        @Assert(false, retBool)

        let ret2 = mysqlStmtApi.mysqlStmtStoreResult()
        @Assert(0, ret2)
        
        mysqlStatement1.close()

        var mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_bigint")
        mysqlStatement9.update()
        mysqlStatement9.close()

        mysqlConnection.close()
    }

    @TestCase
    func mysqlStmtApiTest003(): Unit {
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
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_bigint")
        mysqlStatement1.update()
        mysqlStatement1.close()

        // 创建t_test2名称数据表
        var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test_bigint(id bigint not null, value1 bigint not null, value2 bigint)")
        mysqlStatement2.update()
        mysqlStatement2.close()

        // 通过传入的 sql 语句，返回一个预执行的 Statement 对象实例
        var mysqlStatement3: MysqlStatement = mysqlConnection.prepareStatement(
            "insert into  t_test_bigint(id,value1,value2)  VALUES(1,2,3)")
        mysqlStatement3.update()
        mysqlStatement3.close()

        var mysqlStatement4: MysqlStatement = mysqlConnection.prepareStatement(
            "select * from t_test_bigint where id = 1")
        mysqlStatement4.query()

        let mysqlStmtApi: MysqlStmtApi = MysqlStmtApi(mysqlStatement4)
        let ret1 = mysqlStmtApi.mysqlStmtStoreResult()
        @Assert(0, ret1)

        let retBool1 = mysqlStmtApi.mysqlStmtReset()
        @Assert(false, retBool1)

        let ret2 = mysqlStmtApi.mysqlStmtStoreResult()
        @Assert(1, ret2)
        mysqlStatement4.close()

        var mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_bigint")
        mysqlStatement9.update()
        mysqlStatement9.close()

        mysqlConnection.close()
    }

    @TestCase
    func mysqlStmtApiTest004(): Unit {
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
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_bigint")
        mysqlStatement1.update()
        mysqlStatement1.close()

        // 创建t_test2名称数据表
        var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test_bigint(id bigint not null, value1 bigint not null, value2 bigint)")
        mysqlStatement2.update()
        mysqlStatement2.close()

        // 通过传入的 sql 语句，返回一个预执行的 Statement 对象实例
        var mysqlStatement3: MysqlStatement = mysqlConnection.prepareStatement(
            "insert into  t_test_bigint(id,value1,value2)  VALUES(1,2,3)")
        mysqlStatement3.update()
        mysqlStatement3.close()

        var mysqlStatement4: MysqlStatement = mysqlConnection.prepareStatement(
            "select * from t_test_bigint where id = 1")
        mysqlStatement4.query()

        let mysqlStmtApi: MysqlStmtApi = MysqlStmtApi(mysqlStatement1)
        let ret1 = mysqlStmtApi.mysqlStmtStoreResult()
        @Assert(0, ret1)

        let ret2 = mysqlStmtApi.mysqlStmtStoreResult()
        @Assert(1, ret2)
        mysqlStatement4.close()

        var mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_bigint")
        mysqlStatement9.update()
        mysqlStatement9.close()

        mysqlConnection.close()
    }

    @TestCase
    func mysqlStmtApiTest005(): Unit {
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
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_bigint")
        mysqlStatement1.update()
        mysqlStatement1.close()

        // 创建t_test2名称数据表
        var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test_bigint(id bigint not null, value1 bigint not null, value2 bigint)")
        mysqlStatement2.update()
        mysqlStatement2.close()

        // 通过传入的 sql 语句，返回一个预执行的 Statement 对象实例
        var mysqlStatement3: MysqlStatement = mysqlConnection.prepareStatement(
            "insert into  t_test_bigint(id,value1,value2)  VALUES(1,2,3)")
        mysqlStatement3.update()
        mysqlStatement3.close()

        var mysqlStatement4: MysqlStatement = mysqlConnection.prepareStatement(
            "select * from t_test_bigint where id = 1")
        mysqlStatement4.query()

        let mysqlStmtApi: MysqlStmtApi = MysqlStmtApi(mysqlStatement4)
        let ret1 = mysqlStmtApi.mysqlStmtStoreResult()
        @Assert(0, ret1)

        let retBool1 = mysqlStmtApi.mysqlStmtFreeResult()
        @Assert(false, retBool1)

        let ret2 = mysqlStmtApi.mysqlStmtStoreResult()
        @Assert(1, ret2)
        mysqlStatement4.close()

        var mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_bigint")
        mysqlStatement9.update()
        mysqlStatement9.close()

        mysqlConnection.close()
    }

    @TestCase
    func mysqlStmtApiTest006(): Unit {
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
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_bigint")
        mysqlStatement1.update()
        mysqlStatement1.close()

        // 创建t_test2名称数据表
        var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test_bigint(id bigint not null, value1 bigint not null, value2 bigint)")
        mysqlStatement2.update()
        mysqlStatement2.close()

        // 通过传入的 sql 语句，返回一个预执行的 Statement 对象实例
        var mysqlStatement3: MysqlStatement = mysqlConnection.prepareStatement(
            "insert into  t_test_bigint(id,value1,value2)  VALUES(1,2,3)")
        mysqlStatement3.update()
        mysqlStatement3.close()

        var mysqlStatement4: MysqlStatement = mysqlConnection.prepareStatement(
            "select * from t_test_bigint where id = 1")
        var mysqlQueryResult: MysqlQueryResult = mysqlStatement4.query()
        var id: SqlBigInt = SqlBigInt(3)
        var data1: SqlBigInt = SqlBigInt(1)
        var data2: SqlNullableBigInt = SqlNullableBigInt(1)
        var arrDb: Array<SqlDbType> = [id, data1, data2]

        var isBool: Bool = mysqlQueryResult.next(arrDb)

        @Assert(true, isBool)
        @Assert(1, (arrDb[0] as SqlBigInt).getOrThrow().value)
        @Assert(2, (arrDb[1] as SqlBigInt).getOrThrow().value)
        @Assert(3, (arrDb[2] as SqlNullableBigInt).getOrThrow().value)

        let mysqlStmtApi: MysqlStmtApi = MysqlStmtApi(mysqlStatement4)
        let ret1 = mysqlStmtApi.mysqlStmtStoreResult()
        @Assert(0, ret1)

        let retBool1 = mysqlStmtApi.mysqlStmtFreeResult()
        @Assert(false, retBool1)

        let ret2 = mysqlStmtApi.mysqlStmtStoreResult()
        @Assert(1, ret2)
        mysqlStatement4.close()

        var mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_bigint")
        mysqlStatement9.update()
        mysqlStatement9.close()

        mysqlConnection.close()
    }

    @TestCase
    func mysqlStmtApiTest007(): Unit {
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
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_bigint")
        mysqlStatement1.update()
        mysqlStatement1.close()

        // 创建t_test2名称数据表
        var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test_bigint(id bigint not null, value1 bigint not null, value2 bigint)")
        mysqlStatement2.update()
        mysqlStatement2.close()

        // 通过传入的 sql 语句，返回一个预执行的 Statement 对象实例
        var mysqlStatement3: MysqlStatement = mysqlConnection.prepareStatement(
            "insert into  t_test_bigint(id,value1,value2)  VALUES(1,2,3)")
        mysqlStatement3.update()

        let mysqlStmtApi: MysqlStmtApi = MysqlStmtApi(mysqlStatement3)

        var retBool: Bool = mysqlStmtApi.mysqlStmtReset()
        @Assert(false, retBool)

        var retStr: String = mysqlStmtApi.mysqlStmtError()
        @Assert("", retStr)

        var retUInt32: UInt32 = mysqlStmtApi.mysqlStmtErrno()
        @Assert(0, retUInt32)

        retStr = mysqlStmtApi.mysqlStmtSqlstate()
        @Assert("00000", retStr)

        var retUInt64: UInt64 = mysqlStmtApi.mysqlStmtNumRows()
        @Assert(0, retUInt64)

        retUInt64 = mysqlStmtApi.mysqlStmtInsertId()
        @Assert(0, retUInt64)
        mysqlStatement3.close()

        var mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_bigint")
        mysqlStatement9.update()
        mysqlStatement9.close()

        mysqlConnection.close()
    }
}
