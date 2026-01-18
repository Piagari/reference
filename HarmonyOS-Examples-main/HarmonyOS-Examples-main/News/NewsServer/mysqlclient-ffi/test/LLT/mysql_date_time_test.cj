// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*

main(): Int64 {
    let mysqlDateTimeTest: MysqlDateTimeTest = MysqlDateTimeTest()

    mysqlDateTimeTest.mysqlDateTimeTest01()

    return 0
}

/*
 * +----------------+----------+------+-----+---------+-------+
 * | Field          | Type     | Null | Key | Default | Extra |
 * +----------------+----------+------+-----+---------+-------+
 * | id             | bigint   | NO   |     | NULL    |       |
 * | dateTimeValue1 | datetime | NO   |     | NULL    |       |
 * | datetimeValue2 | datetime | YES  |     | NULL    |       |
 * +----------------+----------+------+-----+---------+-------+
 */
@Test
public class MysqlDateTimeTest {
    @TestCase
    public func mysqlDateTimeTest01(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
        @Assert("mysql", mysqlDriver.name)
        @Assert(true, mysqlDriver.version.size > 0)

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        // 删除t_test2名称数据表
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date_time")
        mysqlStatement1.update()
        mysqlStatement1.close()

        // 创建t_test2名称数据表
        var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test_date_time(id bigint not null, dateTimeValue1 datetime not null, datetimeValue2 datetime)"
        )
        mysqlStatement2.update()
        mysqlStatement2.close()

        // 通过传入的 sql 语句，返回一个预执行的 Statement 对象实例
        var mysqlStatement3: MysqlStatement = mysqlConnection.prepareStatement(
            "insert into  t_test_date_time(id,dateTimeValue1,dateTimeValue2)  VALUES(?,?,?)")
        @Assert(3, mysqlStatement3.parameterCount)

        let dateTime1: DateTime = DateTime.nowUTC()
        var id: SqlBigInt = SqlBigInt(1)
        var date1: SqlDateTime = SqlDateTime(dateTime1)
        var date2: SqlNullableDateTime = SqlNullableDateTime(None)
        var arrDb: Array<SqlDbType> = [id, date1, date2]

        // 执行插入语句插入数据
        var mysqlUpdateResult1: MysqlUpdateResult = mysqlStatement3.update(arrDb)
        @Assert(1, mysqlUpdateResult1.rowCount)
        let dateTime2: DateTime = DateTime.of(year: 2011, month: 10, dayOfMonth: 30, hour: 8, minute: 10, second: 30)
        let dateTime3: DateTime = DateTime.of(year: 1993, month: 5, dayOfMonth: 3, hour: 12, minute: 5, second: 3)
        id = SqlBigInt(2)
        date1 = SqlDateTime(dateTime2)
        date2 = SqlNullableDateTime(dateTime3)
        arrDb = [id, date1, date2]

        // 执行插入语句插入数据
        var mysqlUpdateResult2: MysqlUpdateResult = mysqlStatement3.update(arrDb)
        @Assert(1, mysqlUpdateResult2.rowCount)

        let dateTime4: DateTime = DateTime.of(year: 2010, month: 9, dayOfMonth: 29, hour: 18, minute: 20, second: 40)
        let dateTime5: DateTime = DateTime.of(year: 1992, month: 4, dayOfMonth: 18, hour: 22, minute: 35, second: 53)
        id = SqlBigInt(3)
        date1 = SqlDateTime(dateTime4)
        date2 = SqlNullableDateTime(dateTime5)
        arrDb = [id, date1, date2]

        // 执行插入语句插入数据
        var mysqlUpdateResult3: MysqlUpdateResult = mysqlStatement3.update(arrDb)
        @Assert(1, mysqlUpdateResult3.rowCount)
        mysqlStatement3.close()

        // 查询语句预执行语句
        var mysqlStatement4: MysqlStatement = mysqlConnection.prepareStatement(
            "select * from t_test_date_time where id = 1")
        @Assert(0, mysqlStatement4.parameterCount)
        var mysqlQueryResult: MysqlQueryResult = mysqlStatement4.query()
        let mysqlColumnInfos: Array<MysqlColumnInfo> = mysqlQueryResult.mysqlColumnInfos

        @Assert("id", mysqlColumnInfos[0].name)
        @Assert("SqlBigInt", mysqlColumnInfos[0].typeName)
        @Assert(0, mysqlColumnInfos[0].displaySize)
        @Assert(20, mysqlColumnInfos[0].length)
        @Assert(0, mysqlColumnInfos[0].scale)
        @Assert(true, mysqlColumnInfos[0].nullable)

        @Assert("dateTimeValue1", mysqlColumnInfos[1].name)
        @Assert("SqlDateTime", mysqlColumnInfos[1].typeName)
        @Assert(0, mysqlColumnInfos[1].displaySize)
        @Assert(19, mysqlColumnInfos[1].length)
        @Assert(0, mysqlColumnInfos[1].scale)
        @Assert(true, mysqlColumnInfos[1].nullable)

        @Assert("datetimeValue2", mysqlColumnInfos[2].name)
        @Assert("SqlNullableDateTime", mysqlColumnInfos[2].typeName)
        @Assert(0, mysqlColumnInfos[2].displaySize)
        @Assert(19, mysqlColumnInfos[2].length)
        @Assert(0, mysqlColumnInfos[2].scale)
        @Assert(false, mysqlColumnInfos[2].nullable)

        id = SqlBigInt(3)
        date1 = SqlDateTime(dateTime4)
        date2 = SqlNullableDateTime(dateTime5)
        arrDb = [id, date1, date2]

        var isBool: Bool = mysqlQueryResult.next(arrDb)
        @Assert(true, isBool)
        @Assert(1, (arrDb[0] as SqlBigInt).getOrThrow().value)
        let dateTimeQuery: DateTime = (arrDb[1] as SqlDateTime).getOrThrow().value
        @Assert(dateTime1.year, dateTimeQuery.year)
        @Assert(dateTime1.monthValue, dateTimeQuery.monthValue)
        @Assert(dateTime1.dayOfMonth, dateTimeQuery.dayOfMonth)
        @Assert(dateTime1.hour, dateTimeQuery.hour)
        @Assert(dateTime1.minute, dateTimeQuery.minute)
        @Assert(dateTime1.second, dateTimeQuery.second)
        let sqlNullableDate: SqlNullableDateTime = (arrDb[2] as SqlNullableDateTime).getOrThrow()
        match (sqlNullableDate.value) {
            case Some(_) => @Assert(0, 1)
            case None => @Assert(1, 1)
        }

        id = SqlBigInt(3)
        date1 = SqlDateTime(dateTime4)
        date2 = SqlNullableDateTime(dateTime5)
        arrDb = [id, date1, date2]
        isBool = mysqlQueryResult.next(arrDb)
        @Assert(false, isBool)
        mysqlStatement4.close()

        // 删除语句预执行语句
        let mysqlStatement5: MysqlStatement = mysqlConnection.prepareStatement(
            "delete from t_test_date_time where id = ?")
        @Assert(1, mysqlStatement5.parameterCount)

        id = SqlBigInt(1)
        arrDb = [id]

        // 执行删除语句
        let mysqlUpdateResult4: MysqlUpdateResult = mysqlStatement5.update(arrDb)
        @Assert(1, mysqlUpdateResult4.rowCount)
        mysqlStatement5.close()

        // 查询语句预执行语句
        let mysqlStatement6: MysqlStatement = mysqlConnection.prepareStatement(
            "select * from t_test_date_time where id = 1")

        // 执行查询语句
        let mysqlQueryResult1: MysqlQueryResult = mysqlStatement6.query()

        id = SqlBigInt(3)
        date1 = SqlDateTime(dateTime4)
        date2 = SqlNullableDateTime(dateTime5)
        arrDb = [id, date1, date2]

        // 获取数据
        isBool = mysqlQueryResult1.next(arrDb)
        @Assert(false, isBool)
        mysqlStatement6.close()

        // 更新语句预执行语句
        let mysqlStatement7: MysqlStatement = mysqlConnection.prepareStatement(
            "update t_test_date_time set dateTimeValue1 = ?, dateTimeValue2 = ?  where id = ?")
        @Assert(3, mysqlStatement7.parameterCount)

        id = SqlBigInt(2)
        let dateTime6: DateTime = DateTime.of(year: 1840, month: 1, dayOfMonth: 1, hour: 9, minute: 11, second: 31)
        let dateTime7: DateTime = DateTime.of(year: 1841, month: 2, dayOfMonth: 2, hour: 13, minute: 6, second: 4)
        date1 = SqlDateTime(dateTime6)
        date2 = SqlNullableDateTime(dateTime7)
        arrDb = [date1, date2, id]

        // 执行更新语句
        let mysqlUpdateResult5: MysqlUpdateResult = mysqlStatement7.update(arrDb)
        @Assert(1, mysqlUpdateResult5.rowCount)
        mysqlStatement7.close()

        // 查询语句预执行语句
        let mysqlStatement8: MysqlStatement = mysqlConnection.prepareStatement(
            "select * from t_test_date_time where id = 2")

        // 执行查询语句
        var mysqlQueryResult2: MysqlQueryResult = mysqlStatement8.query()

        id = SqlBigInt(3)
        date1 = SqlDateTime(dateTime4)
        date2 = SqlNullableDateTime(dateTime5)
        arrDb = [id, date1, date2]

        // 获取数据
        isBool = mysqlQueryResult2.next(arrDb)
        @Assert(true, isBool)
        @Assert(2, (arrDb[0] as SqlBigInt).getOrThrow().value)
        let dateTimeQuery1: DateTime = (arrDb[1] as SqlDateTime).getOrThrow().value
        @Assert(1840, dateTimeQuery1.year)
        @Assert(1, dateTimeQuery1.monthValue)
        @Assert(1, dateTimeQuery1.dayOfMonth)
        @Assert(9, dateTimeQuery1.hour)
        @Assert(11, dateTimeQuery1.minute)
        @Assert(31, dateTimeQuery1.second)
        let dateTimeQuery2: DateTime = (arrDb[2] as SqlNullableDateTime).getOrThrow().value.getOrThrow()
        @Assert(1841, dateTimeQuery2.year)
        @Assert(2, dateTimeQuery2.monthValue)
        @Assert(2, dateTimeQuery2.dayOfMonth)
        @Assert(13, dateTimeQuery2.hour)
        @Assert(6, dateTimeQuery2.minute)
        @Assert(4, dateTimeQuery2.second)
        mysqlStatement8.close()

        // 删除t_test名称数据表
        let mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date_time")
        mysqlStatement9.update()
        mysqlStatement9.close()

        // 关闭链接
        mysqlConnection.close()
    }
}
