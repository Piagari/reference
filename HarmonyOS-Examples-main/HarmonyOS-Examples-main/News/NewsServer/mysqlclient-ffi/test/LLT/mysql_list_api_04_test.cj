// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*
import std.math.*

main(): Int64 {
    let mysqlListApi01Test: MysqlListApi04Test = MysqlListApi04Test()

    mysqlListApi01Test.mysqlListApiTest001()
    mysqlListApi01Test.mysqlListApiTest002()
    mysqlListApi01Test.mysqlListApiTest003()
    mysqlListApi01Test.mysqlListApiTest004()
    mysqlListApi01Test.mysqlListApiTest005()

    mysqlListApi01Test.mysqlListApiTest006()
    mysqlListApi01Test.mysqlListApiTest007()
    mysqlListApi01Test.mysqlListApiTest008()
    mysqlListApi01Test.mysqlListApiTest009()
    mysqlListApi01Test.mysqlListApiTest010()

    return 0
}

@Test
public class MysqlListApi04Test {
    @TestCase
    public func mysqlListApiTest001(): Unit {
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
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement1.update()

        // 创建t_test2名称数据表
        var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test_date(id bigint not null, dateValue1 date not null, dateValue2 date)")
        mysqlStatement2.update()

        let mysqlListApi: MysqlListApi = MysqlListApi(mysqlConnection)
        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)
        let cp1: CPointer<Unit> = mysqlListApi.mysqlListFields("t_test_date", "")
        let retFields: UInt32 = mysqlRecordApi.mysqlNumFields(cp1)
        @Assert(3, retFields)
        let retEof: Bool = mysqlRecordApi.mysqlEof(cp1)
        @Assert(true, retEof)
        let retRows: UInt64 = mysqlRecordApi.mysqlNumRows(cp1)
        @Assert(0, retRows)
        unsafe {
            for (i in 0..retRows) {
                var cpCString: CPointer<CString> = mysqlRecordApi.mysqlFetchRow(cp1)
                for (j in 0..retFields) {
                    var cString: CString = cpCString.read(Int64(j))
                    if (i == 0) {
                        @Assert("information_schema", cString.toString())
                    } else if (i == 1) {
                        @Assert("mysql", cString.toString())
                    } else if (i == 2) {
                        @Assert("performance_schema", cString.toString())
                    } else if (i == 3) {
                        @Assert("sys", cString.toString())
                    }
                }
            }
        }
        mysqlRecordApi.mysqlFreeResult(cp1)

        // 删除t_test名称数据表
        let mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement9.update()

        // 释放预执行语句内存
        mysqlStatement9.close()

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    public func mysqlListApiTest002(): Unit {
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
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement1.update()

        // 创建t_test2名称数据表
        var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test_date(id bigint not null, dateValue1 date not null, dateValue2 date)")
        mysqlStatement2.update()

        let mysqlListApi: MysqlListApi = MysqlListApi(mysqlConnection)
        let cp1: CPointer<Unit> = mysqlListApi.mysqlListFields("t_test_date", "m")
        if (cp1.isNotNull()) {
            @Assert(1, 0)
        } else {
            @Assert(0, 0)
        }

        // 删除t_test名称数据表
        let mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement9.update()

        // 释放预执行语句内存
        mysqlStatement9.close()

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    public func mysqlListApiTest003(): Unit {
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
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement1.update()

        // 创建t_test2名称数据表
        var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test_date(id bigint not null, dateValue1 date not null, dateValue2 date)")
        mysqlStatement2.update()

        let mysqlListApi: MysqlListApi = MysqlListApi(mysqlConnection)
        let cp1: CPointer<Unit> = mysqlListApi.mysqlListFields("t_test_date", "123")
        if (cp1.isNotNull()) {
            @Assert(1, 0)
        } else {
            @Assert(0, 0)
        }

        // 删除t_test名称数据表
        let mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement9.update()

        // 释放预执行语句内存
        mysqlStatement9.close()

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    public func mysqlListApiTest004(): Unit {
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
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement1.update()

        // 创建t_test2名称数据表
        var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test_date(id bigint not null, dateValue1 date not null, dateValue2 date)")
        mysqlStatement2.update()

        let mysqlListApi: MysqlListApi = MysqlListApi(mysqlConnection)
        let cp1: CPointer<Unit> = mysqlListApi.mysqlListFields("t_test_date", "你好")
        if (cp1.isNotNull()) {
            @Assert(1, 0)
        } else {
            @Assert(0, 0)
        }

        // 删除t_test名称数据表
        let mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement9.update()

        // 释放预执行语句内存
        mysqlStatement9.close()

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    public func mysqlListApiTest005(): Unit {
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
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement1.update()

        // 创建t_test2名称数据表
        var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test_date(id bigint not null, dateValue1 date not null, dateValue2 date)")
        mysqlStatement2.update()

        let mysqlListApi: MysqlListApi = MysqlListApi(mysqlConnection)
        let cp1: CPointer<Unit> = mysqlListApi.mysqlListFields("t_test_date", "你1232qda!@好")
        if (cp1.isNotNull()) {
            @Assert(1, 0)
        } else {
            @Assert(0, 0)
        }

        // 删除t_test名称数据表
        let mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement9.update()

        // 释放预执行语句内存
        mysqlStatement9.close()

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    public func mysqlListApiTest006(): Unit {
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
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement1.update()

        // 创建t_test2名称数据表
        var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test_date(id bigint not null, dateValue1 date not null, dateValue2 date)")
        mysqlStatement2.update()

        let mysqlListApi: MysqlListApi = MysqlListApi(mysqlConnection)
        let cp1: CPointer<Unit> = mysqlListApi.mysqlListFields("t_test_date", "你1232qda!@好")
        if (cp1.isNotNull()) {
            @Assert(1, 0)
        } else {
            @Assert(0, 0)
        }

        // 删除t_test名称数据表
        let mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement9.update()

        // 释放预执行语句内存
        mysqlStatement9.close()

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    public func mysqlListApiTest007(): Unit {
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
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement1.update()

        // 创建t_test2名称数据表
        var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test_date(id bigint not null, dateValue1 date not null, dateValue2 date)")
        mysqlStatement2.update()

        let mysqlListApi: MysqlListApi = MysqlListApi(mysqlConnection)
        let cp1: CPointer<Unit> = mysqlListApi.mysqlListFields("t_test_date1", "mysql")
        if (cp1.isNotNull()) {
            @Assert(1, 0)
        } else {
            @Assert(0, 0)
        }

        // 删除t_test名称数据表
        let mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement9.update()

        // 释放预执行语句内存
        mysqlStatement9.close()

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    public func mysqlListApiTest008(): Unit {
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
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement1.update()

        // 创建t_test2名称数据表
        var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test_date(id bigint not null, dateValue1 date not null, dateValue2 date)")
        mysqlStatement2.update()

        let mysqlListApi: MysqlListApi = MysqlListApi(mysqlConnection)
        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)
        let cp1: CPointer<Unit> = mysqlListApi.mysqlListFields("t_test_date", "id")
        let retFields: UInt32 = mysqlRecordApi.mysqlNumFields(cp1)
        @Assert(1, retFields)
        let retEof: Bool = mysqlRecordApi.mysqlEof(cp1)
        @Assert(true, retEof)
        let retRows: UInt64 = mysqlRecordApi.mysqlNumRows(cp1)
        @Assert(0, retRows)
        unsafe {
            for (i in 0..retRows) {
                var cpCString: CPointer<CString> = mysqlRecordApi.mysqlFetchRow(cp1)
                for (j in 0..retFields) {
                    var cString: CString = cpCString.read(Int64(j))
                    if (i == 0) {
                        @Assert("sys", cString.toString())
                    }
                }
            }
        }
        mysqlRecordApi.mysqlFreeResult(cp1)

        // 删除t_test名称数据表
        let mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement9.update()

        // 释放预执行语句内存
        mysqlStatement9.close()

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    public func mysqlListApiTest009(): Unit {
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
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement1.update()

        // 创建t_test2名称数据表
        var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test_date(id bigint not null, dateValue1 date not null, dateValue2 date)")
        mysqlStatement2.update()

        let mysqlListApi: MysqlListApi = MysqlListApi(mysqlConnection)
        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)
        let cp1: CPointer<Unit> = mysqlListApi.mysqlListFields("t_test_date", "dateValue1")
        let retFields: UInt32 = mysqlRecordApi.mysqlNumFields(cp1)
        @Assert(1, retFields)
        let retEof: Bool = mysqlRecordApi.mysqlEof(cp1)
        @Assert(true, retEof)
        let retRows: UInt64 = mysqlRecordApi.mysqlNumRows(cp1)
        @Assert(0, retRows)
        unsafe {
            for (i in 0..retRows) {
                var cpCString: CPointer<CString> = mysqlRecordApi.mysqlFetchRow(cp1)
                for (j in 0..retFields) {
                    var cString: CString = cpCString.read(Int64(j))
                    if (i == 0) {
                        @Assert("information_schema", cString.toString())
                    }
                }
            }
        }
        mysqlRecordApi.mysqlFreeResult(cp1)

        // 删除t_test名称数据表
        let mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement9.update()

        // 释放预执行语句内存
        mysqlStatement9.close()

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    public func mysqlListApiTest010(): Unit {
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
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement1.update()

        // 创建t_test2名称数据表
        var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test_date(id bigint not null, dateValue1 date not null, dateValue2 date)")
        mysqlStatement2.update()

        let mysqlListApi: MysqlListApi = MysqlListApi(mysqlConnection)
        let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)
        let cp1: CPointer<Unit> = mysqlListApi.mysqlListFields("t_test_date", "dateValue2")
        let retFields: UInt32 = mysqlRecordApi.mysqlNumFields(cp1)
        @Assert(1, retFields)
        let retEof: Bool = mysqlRecordApi.mysqlEof(cp1)
        @Assert(true, retEof)
        let retRows: UInt64 = mysqlRecordApi.mysqlNumRows(cp1)
        @Assert(0, retRows)
        unsafe {
            for (i in 0..retRows) {
                var cpCString: CPointer<CString> = mysqlRecordApi.mysqlFetchRow(cp1)
                for (j in 0..retFields) {
                    var cString: CString = cpCString.read(Int64(j))
                    if (i == 0) {
                        @Assert("performance_schema", cString.toString())
                    }
                }
            }
        }
        mysqlRecordApi.mysqlFreeResult(cp1)

        // 删除t_test名称数据表
        let mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement9.update()

        // 释放预执行语句内存
        mysqlStatement9.close()

        // 关闭链接
        mysqlConnection.close()
    }
}
