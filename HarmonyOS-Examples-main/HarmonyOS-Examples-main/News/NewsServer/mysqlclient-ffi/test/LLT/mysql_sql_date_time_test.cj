// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*
import std.math.*

main(): Int64 {
    let mysqlSqlDateTimeTest: MysqlSqlDateTimeTest = MysqlSqlDateTimeTest()

    mysqlSqlDateTimeTest.mysqlSqlDateTimeTest01()
    mysqlSqlDateTimeTest.mysqlSqlDateTimeTest02()
    mysqlSqlDateTimeTest.mysqlSqlDateTimeTest03()
    mysqlSqlDateTimeTest.mysqlSqlDateTimeTest04()
    mysqlSqlDateTimeTest.mysqlSqlDateTimeTest05()

    mysqlSqlDateTimeTest.mysqlSqlDateTimeTest06()
    mysqlSqlDateTimeTest.mysqlSqlDateTimeTest07()
    mysqlSqlDateTimeTest.mysqlSqlDateTimeTest08()
    mysqlSqlDateTimeTest.mysqlSqlDateTimeTest09()
    mysqlSqlDateTimeTest.mysqlSqlDateTimeTest10()

    return 0
}

@Test
public class MysqlSqlDateTimeTest {
    @TestCase
    public func mysqlSqlDateTimeTest01(): Unit {
        let dateTime: DateTime = DateTime.nowUTC()
        let sqlDateTime: SqlDateTime = SqlDateTime(dateTime)
        @Assert("SqlTimestampWithoutTz", sqlDateTime.name)
        let dateTime1: DateTime = sqlDateTime.value
        @Assert(dateTime.year, dateTime1.year)
        @Assert(dateTime.monthValue, dateTime1.monthValue)
        @Assert(dateTime.dayOfMonth, dateTime1.dayOfMonth)
    }

    @TestCase
    public func mysqlSqlDateTimeTest02(): Unit {
        let dateTime: DateTime = DateTime.nowUTC()
        let sqlDateTime: SqlDateTime = SqlDateTime(dateTime)
        @Assert("SqlTimestampWithoutTz", sqlDateTime.name)
        sqlDateTime.value = DateTime.of(year: 2002, month: 10, dayOfMonth: 20)
        let dateTime1: DateTime = sqlDateTime.value
        @Assert(2002, dateTime1.year)
        @Assert(10, dateTime1.monthValue)
        @Assert(20, dateTime1.dayOfMonth)
    }

    @TestCase
    public func mysqlSqlDateTimeTest03(): Unit {
        let dateTime: DateTime = DateTime.of(year: 2002, month: 10, dayOfMonth: 20)
        let sqlDateTime: SqlDateTime = SqlDateTime(dateTime)
        @Assert("SqlTimestampWithoutTz", sqlDateTime.name)
        let dateTime1: DateTime = sqlDateTime.value
        @Assert(2002, dateTime1.year)
        @Assert(10, dateTime1.monthValue)
        @Assert(20, dateTime1.dayOfMonth)
    }

    @TestCase
    public func mysqlSqlDateTimeTest04(): Unit {
        let dateTime: DateTime = DateTime.of(year: 2002, month: 10, dayOfMonth: 20)
        let sqlDateTime: SqlDateTime = SqlDateTime(dateTime)
        @Assert("SqlTimestampWithoutTz", sqlDateTime.name)
        sqlDateTime.value = DateTime.of(year: 2012, month: 6, dayOfMonth: 1)
        let dateTime1: DateTime = sqlDateTime.value
        @Assert(2012, dateTime1.year)
        @Assert(6, dateTime1.monthValue)
        @Assert(1, dateTime1.dayOfMonth)
    }

    @TestCase
    public func mysqlSqlDateTimeTest05(): Unit {
        let dateTime: DateTime = DateTime.of(year: 2002, month: 10, dayOfMonth: 20, hour: 10, minute: 20, second: 30)
        let sqlDateTime: SqlDateTime = SqlDateTime(dateTime)
        @Assert("SqlTimestampWithoutTz", sqlDateTime.name)
        sqlDateTime.value = DateTime.of(year: 2012, month: 6, dayOfMonth: 1, hour: 11, minute: 21, second: 31)
        let dateTime1: DateTime = sqlDateTime.value
        @Assert(2012, dateTime1.year)
        @Assert(6, dateTime1.monthValue)
        @Assert(1, dateTime1.dayOfMonth)
        @Assert(11, dateTime1.hour)
        @Assert(21, dateTime1.minute)
        @Assert(31, dateTime1.second)
    }

    @TestCase
    public func mysqlSqlDateTimeTest06(): Unit {
        let dateTime: DateTime = DateTime.nowUTC()
        let sqlDateTime: SqlDateTime = SqlDateTime(dateTime)
        @Assert("SqlTimestampWithoutTz", sqlDateTime.name)
        let dateTime1: DateTime = sqlDateTime.value
        @Assert(dateTime.year, dateTime1.year)
        @Assert(dateTime.monthValue, dateTime1.monthValue)
        @Assert(dateTime.dayOfMonth, dateTime1.dayOfMonth)
        @Assert(dateTime.dayOfMonth, dateTime1.dayOfMonth)
        @Assert(dateTime.hour, dateTime1.hour)
        @Assert(dateTime.minute, dateTime1.minute)
        @Assert(dateTime.second, dateTime1.second)
    }

    @TestCase
    public func mysqlSqlDateTimeTest07(): Unit {
        let sqlNullableDateTime: SqlNullableDateTime = SqlNullableDateTime(None)
        @Assert("SqlNullableTimestampWithoutTz", sqlNullableDateTime.name)
        let dateTime1: ?DateTime = sqlNullableDateTime.value
        match (dateTime1) {
            case Some(_) => @Assert(0, 1)
            case None => @Assert(1, 1)
        }
    }

    @TestCase
    public func mysqlSqlDateTimeTest08(): Unit {
        let sqlNullableDateTime: SqlNullableDateTime = SqlNullableDateTime(None)
        @Assert("SqlNullableTimestampWithoutTz", sqlNullableDateTime.name)
        let dateTime1: ?DateTime = sqlNullableDateTime.value
        match (dateTime1) {
            case Some(_) => @Assert(0, 1)
            case None => @Assert(1, 1)
        }
        sqlNullableDateTime.value = DateTime.nowUTC()
        let dateTime2: ?DateTime = sqlNullableDateTime.value
        match (dateTime2) {
            case Some(_) => @Assert(1, 1)
            case None => @Assert(0, 1)
        }
    }

    @TestCase
    public func mysqlSqlDateTimeTest09(): Unit {
        let dateTime: DateTime = DateTime.nowUTC()
        let sqlNullableDateTime: SqlNullableDateTime = SqlNullableDateTime(dateTime)
        @Assert("SqlNullableTimestampWithoutTz", sqlNullableDateTime.name)
        let dateTime1: DateTime = sqlNullableDateTime.value.getOrThrow()
        @Assert(dateTime.year, dateTime1.year)
        @Assert(dateTime.monthValue, dateTime1.monthValue)
        @Assert(dateTime.dayOfMonth, dateTime1.dayOfMonth)
    }

    @TestCase
    public func mysqlSqlDateTimeTest10(): Unit {
        let dateTime: DateTime = DateTime.nowUTC()
        let sqlNullableDateTime: SqlNullableDateTime = SqlNullableDateTime(dateTime)
        @Assert("SqlNullableTimestampWithoutTz", sqlNullableDateTime.name)
        let dateTime1: DateTime = sqlNullableDateTime.value.getOrThrow()
        @Assert(dateTime.year, dateTime1.year)
        @Assert(dateTime.monthValue, dateTime1.monthValue)
        @Assert(dateTime.dayOfMonth, dateTime1.dayOfMonth)
        @Assert(dateTime.dayOfMonth, dateTime1.dayOfMonth)
        @Assert(dateTime.hour, dateTime1.hour)
        @Assert(dateTime.minute, dateTime1.minute)
        @Assert(dateTime.second, dateTime1.second)
    }
}
