// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*
import std.math.*

main(): Int64 {
    let mysqlColumnInfoTest: MysqlColumnInfoTest = MysqlColumnInfoTest()

    mysqlColumnInfoTest.mysqlColumnInfoTest01()
    mysqlColumnInfoTest.mysqlColumnInfoTest02()
    mysqlColumnInfoTest.mysqlColumnInfoTest03()
    mysqlColumnInfoTest.mysqlColumnInfoTest04()
    mysqlColumnInfoTest.mysqlColumnInfoTest05()

    mysqlColumnInfoTest.mysqlColumnInfoTest06()
    mysqlColumnInfoTest.mysqlColumnInfoTest07()
    mysqlColumnInfoTest.mysqlColumnInfoTest08()
    mysqlColumnInfoTest.mysqlColumnInfoTest09()
    mysqlColumnInfoTest.mysqlColumnInfoTest10()

    return 0
}

@Test
public class MysqlColumnInfoTest {
    @TestCase
    public func mysqlColumnInfoTest01(): Unit {
        let mysqlColumnInfo: MysqlColumnInfo = MysqlColumnInfo("a", "b", 0, 0, 0, true)
        @Assert("a", mysqlColumnInfo.name)
        @Assert("b", mysqlColumnInfo.typeName)
        @Assert(0, mysqlColumnInfo.displaySize)
        @Assert(0, mysqlColumnInfo.length)
        @Assert(0, mysqlColumnInfo.scale)
        @Assert(true, mysqlColumnInfo.nullable)
    }

    @TestCase
    public func mysqlColumnInfoTest02(): Unit {
        let mysqlColumnInfo: MysqlColumnInfo = MysqlColumnInfo("a", "b", -1, -1, -1, true)
        @Assert("a", mysqlColumnInfo.name)
        @Assert("b", mysqlColumnInfo.typeName)
        @Assert(-1, mysqlColumnInfo.displaySize)
        @Assert(-1, mysqlColumnInfo.length)
        @Assert(-1, mysqlColumnInfo.scale)
        @Assert(true, mysqlColumnInfo.nullable)
    }

    @TestCase
    public func mysqlColumnInfoTest03(): Unit {
        let mysqlColumnInfo: MysqlColumnInfo = MysqlColumnInfo("a", "b", -1, -1, -1, false)
        @Assert("a", mysqlColumnInfo.name)
        @Assert("b", mysqlColumnInfo.typeName)
        @Assert(-1, mysqlColumnInfo.displaySize)
        @Assert(-1, mysqlColumnInfo.length)
        @Assert(-1, mysqlColumnInfo.scale)
        @Assert(false, mysqlColumnInfo.nullable)
    }

    @TestCase
    public func mysqlColumnInfoTest04(): Unit {
        let mysqlColumnInfo: MysqlColumnInfo = MysqlColumnInfo("name", "SqlBlob", -1, -1, -1, true)
        @Assert("name", mysqlColumnInfo.name)
        @Assert("SqlBlob", mysqlColumnInfo.typeName)
        @Assert(-1, mysqlColumnInfo.displaySize)
        @Assert(-1, mysqlColumnInfo.length)
        @Assert(-1, mysqlColumnInfo.scale)
        @Assert(true, mysqlColumnInfo.nullable)
    }

    @TestCase
    public func mysqlColumnInfoTest05(): Unit {
        let mysqlColumnInfo: MysqlColumnInfo = MysqlColumnInfo("id", "SqlInteger", -1, -1, -1, true)
        @Assert("id", mysqlColumnInfo.name)
        @Assert("SqlInteger", mysqlColumnInfo.typeName)
        @Assert(-1, mysqlColumnInfo.displaySize)
        @Assert(-1, mysqlColumnInfo.length)
        @Assert(-1, mysqlColumnInfo.scale)
        @Assert(true, mysqlColumnInfo.nullable)
    }

    @TestCase
    public func mysqlColumnInfoTest06(): Unit {
        let mysqlColumnInfo: MysqlColumnInfo = MysqlColumnInfo("id", "SqlInteger", Int64.Min, Int64.Min, Int64.Min, true
        )
        @Assert("id", mysqlColumnInfo.name)
        @Assert("SqlInteger", mysqlColumnInfo.typeName)
        @Assert(Int64.Min, mysqlColumnInfo.displaySize)
        @Assert(Int64.Min, mysqlColumnInfo.length)
        @Assert(Int64.Min, mysqlColumnInfo.scale)
        @Assert(true, mysqlColumnInfo.nullable)
    }

    @TestCase
    public func mysqlColumnInfoTest07(): Unit {
        let mysqlColumnInfo: MysqlColumnInfo = MysqlColumnInfo("id", "SqlInteger", Int64.Max, Int64.Max, Int64.Max, true
        )
        @Assert("id", mysqlColumnInfo.name)
        @Assert("SqlInteger", mysqlColumnInfo.typeName)
        @Assert(Int64.Max, mysqlColumnInfo.displaySize)
        @Assert(Int64.Max, mysqlColumnInfo.length)
        @Assert(Int64.Max, mysqlColumnInfo.scale)
        @Assert(true, mysqlColumnInfo.nullable)
    }

    @TestCase
    public func mysqlColumnInfoTest08(): Unit {
        let mysqlColumnInfo: MysqlColumnInfo = MysqlColumnInfo(
            "name",
            "SqlVarchar",
            Int64.Max,
            Int64.Max,
            Int64.Max,
            true
        )
        @Assert("name", mysqlColumnInfo.name)
        @Assert("SqlVarchar", mysqlColumnInfo.typeName)
        @Assert(Int64.Max, mysqlColumnInfo.displaySize)
        @Assert(Int64.Max, mysqlColumnInfo.length)
        @Assert(Int64.Max, mysqlColumnInfo.scale)
        @Assert(true, mysqlColumnInfo.nullable)
    }

    @TestCase
    public func mysqlColumnInfoTest09(): Unit {
        let mysqlColumnInfo: MysqlColumnInfo = MysqlColumnInfo("name", "SqlVarchar", 10, 10, 10, false)
        @Assert("name", mysqlColumnInfo.name)
        @Assert("SqlVarchar", mysqlColumnInfo.typeName)
        @Assert(10, mysqlColumnInfo.displaySize)
        @Assert(10, mysqlColumnInfo.length)
        @Assert(10, mysqlColumnInfo.scale)
        @Assert(false, mysqlColumnInfo.nullable)
    }

    @TestCase
    public func mysqlColumnInfoTest10(): Unit {
        let mysqlColumnInfo: MysqlColumnInfo = MysqlColumnInfo("name", "SqlVarchar", 10, 10, 10, true)
        @Assert("name", mysqlColumnInfo.name)
        @Assert("SqlVarchar", mysqlColumnInfo.typeName)
        @Assert(10, mysqlColumnInfo.displaySize)
        @Assert(10, mysqlColumnInfo.length)
        @Assert(10, mysqlColumnInfo.scale)
        @Assert(true, mysqlColumnInfo.nullable)
    }
}
