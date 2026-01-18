// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*

main(): Int64 {
    let mysqlDriverTest: MysqlDriverTest = MysqlDriverTest()

    mysqlDriverTest.mysqlDriverTest01()
    mysqlDriverTest.mysqlDriverTest02()
    mysqlDriverTest.mysqlDriverTest03()
    mysqlDriverTest.mysqlDriverTest04()
    mysqlDriverTest.mysqlDriverTest05()

    mysqlDriverTest.mysqlDriverTest06()
    mysqlDriverTest.mysqlDriverTest07()
    mysqlDriverTest.mysqlDriverTest08()
    mysqlDriverTest.mysqlDriverTest09()
    mysqlDriverTest.mysqlDriverTest10()

    mysqlDriverTest.mysqlDriverTest11()
    mysqlDriverTest.mysqlDriverTest12()
    mysqlDriverTest.mysqlDriverTest13()
    mysqlDriverTest.mysqlDriverTest14()
    mysqlDriverTest.mysqlDriverTest15()

    mysqlDriverTest.mysqlDriverTest16()
    mysqlDriverTest.mysqlDriverTest17()
    mysqlDriverTest.mysqlDriverTest18()
    mysqlDriverTest.mysqlDriverTest19()

    return 0
}

@Test
public class MysqlDriverTest {
    @TestCase
    public func mysqlDriverTest01(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
        @Assert(true, mysqlDriver.name.size > 0)
        @Assert("mysql", mysqlDriver.name)
        @Assert(true, mysqlDriver.version.size > 0)
        @Assert(true, mysqlDriver.preferredPooling)
    }

    @TestCase
    public func mysqlDriverTest02(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("12423432423")
        @Assert(true, mysqlDriver.name.size > 0)
        @Assert("12423432423", mysqlDriver.name)
        @Assert(true, mysqlDriver.version.size > 0)
        @Assert(true, mysqlDriver.preferredPooling)
    }

    @TestCase
    public func mysqlDriverTest03(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver(",/.';][[]32190583207571]")
        @Assert(true, mysqlDriver.name.size > 0)
        @Assert(",/.';][[]32190583207571]", mysqlDriver.name)
        @Assert(true, mysqlDriver.version.size > 0)
        @Assert(true, mysqlDriver.preferredPooling)
    }

    @TestCase
    public func mysqlDriverTest04(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("adssa你好421312")
        @Assert(true, mysqlDriver.name.size > 0)
        @Assert("adssa你好421312", mysqlDriver.name)
        @Assert(true, mysqlDriver.version.size > 0)
        @Assert(true, mysqlDriver.preferredPooling)
    }

    @TestCase
    public func mysqlDriverTest05(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("")
        @Assert(true, mysqlDriver.name.size == 0)
        @Assert("", mysqlDriver.name)
        @Assert(true, mysqlDriver.version.size > 0)
        @Assert(true, mysqlDriver.preferredPooling)
    }

    @TestCase
    public func mysqlDriverTest06(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("测试ceshi——000032123")
        @Assert(true, mysqlDriver.name.size > 0)
        @Assert("测试ceshi——000032123", mysqlDriver.name)
        @Assert(true, mysqlDriver.version.size > 0)
        @Assert(true, mysqlDriver.preferredPooling)
    }

    @TestCase
    public func mysqlDriverTest07(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("测试 ceshi —— 000032123")
        @Assert(true, mysqlDriver.name.size > 0)
        @Assert("测试 ceshi —— 000032123", mysqlDriver.name)
        @Assert(true, mysqlDriver.version.size > 0)
        @Assert(true, mysqlDriver.preferredPooling)
    }

    @TestCase
    public func mysqlDriverTest08(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("abcd")
        @Assert(true, mysqlDriver.name.size > 0)
        @Assert("abcd", mysqlDriver.name)
        @Assert(true, mysqlDriver.version.size > 0)
        @Assert(true, mysqlDriver.preferredPooling)
    }

    @TestCase
    public func mysqlDriverTest09(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("1234")
        @Assert(true, mysqlDriver.name.size > 0)
        @Assert("1234", mysqlDriver.name)
        @Assert(true, mysqlDriver.version.size > 0)
        @Assert(true, mysqlDriver.preferredPooling)
    }

    @TestCase
    public func mysqlDriverTest10(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("~!@#$%&^&*()_+{}|<>?:")
        @Assert(true, mysqlDriver.name.size > 0)
        @Assert("~!@#$%&^&*()_+{}|<>?:", mysqlDriver.name)
        @Assert(true, mysqlDriver.version.size > 0)
        @Assert(true, mysqlDriver.preferredPooling)
    }

    @TestCase
    public func mysqlDriverTest11(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
        @Assert(true, mysqlDriver.name.size > 0)
        @Assert("mysql", mysqlDriver.name)
        @Assert(true, mysqlDriver.version.size > 0)
        @Assert(true, mysqlDriver.preferredPooling)
        try {
            mysqlDriver.open(
                "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=",
                Array<(String, String)>()
            )
            @Assert(0, 1)
        } catch (e: SqlException) {
            @Assert(true, e.message.contains("Url is error"))
        }
    }

    @TestCase
    public func mysqlDriverTest12(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
        @Assert(true, mysqlDriver.name.size > 0)
        @Assert("mysql", mysqlDriver.name)
        @Assert(true, mysqlDriver.version.size > 0)
        @Assert(true, mysqlDriver.preferredPooling)
        try {
            mysqlDriver.open(
                "HOST==localhost;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
                Array<(String, String)>()
            )
            @Assert(0, 1)
        } catch (e: SqlException) {
            @Assert(true, e.message.contains("Url is error"))
        }
    }

    @TestCase
    public func mysqlDriverTest13(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
        @Assert(true, mysqlDriver.name.size > 0)
        @Assert("mysql", mysqlDriver.name)
        @Assert(true, mysqlDriver.version.size > 0)
        @Assert(true, mysqlDriver.preferredPooling)
        try {
            mysqlDriver.open(
                "mysql=localhost;USER=root;PWD=123456;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
                Array<(String, String)>()
            )
            @Assert(0, 1)
        } catch (e: SqlException) {
            @Assert(true, e.message.contains("Url is error"))
        }
    }

    @TestCase
    public func mysqlDriverTest14(): Unit {
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
    }

    @TestCase
    public func mysqlDriverTest15(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        var isBool: Bool = false
        try {
            mysqlDriver.open("HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=;UNIX_SOCKET=3306;CLIENT_FLAG=")
        } catch (e: SqlException) {
            isBool = true
            @Assert(true, e.message.contains("Url is error!"))
        }
        @Assert(true, isBool)
    }

    @TestCase
    public func mysqlDriverTest16(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        var isBool: Bool = false
        try {
            mysqlDriver.open("HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=;UNIX_SOCKET=;CLIENT_FLAG=")
        } catch (e: SqlException) {
            isBool = true
            @Assert(true, e.message.contains("Url is error!"))
        }
        @Assert(true, isBool)
    }

    @TestCase
    public func mysqlDriverTest17(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        var isBool: Bool = false

        try {
            mysqlDriver.open("HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=q;UNIX_SOCKET=;CLIENT_FLAG=0")
        } catch (e: SqlException) {
            isBool = true
            @Assert(true, e.message.contains("Url is error!"))
        }
        @Assert(true, isBool)
    }

    @TestCase
    public func mysqlDriverTest18(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
        var isBool: Bool = false
        try {
            mysqlDriver.open("HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=p")
        } catch (e: SqlException) {
            isBool = true
            @Assert(true, e.message.contains("Url is error!"))
        }
        @Assert(true, isBool)
    }

    @TestCase
    public func mysqlDriverTest19(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
        var isBool: Bool = false
        try {
            mysqlDriver.open("HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=a;UNIX_SOCKET=;CLIENT_FLAG=p")
        } catch (e: SqlException) {
            isBool = true
            @Assert(true, e.message.contains("Url is error!"))
        }
        @Assert(true, isBool)
    }
}
