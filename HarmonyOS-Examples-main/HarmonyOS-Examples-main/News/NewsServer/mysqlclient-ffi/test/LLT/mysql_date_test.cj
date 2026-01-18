// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*

main(): Int64 {
    let mysqlDateTest: MysqlDateTest = MysqlDateTest()

    mysqlDateTest.mysqlDateTest01()

    return 0
}

/*
 * +------------+--------+------+-----+---------+-------+
 * | Field      | Type   | Null | Key | Default | Extra |
 * +------------+--------+------+-----+---------+-------+
 * | id         | bigint | NO   |     | NULL    |       |
 * | dateValue1 | date   | NO   |     | NULL    |       |
 * | dateValue2 | date   | YES  |     | NULL    |       |
 * +------------+--------+------+-----+---------+-------+
 */
@Test
public class MysqlDateTest {
    @TestCase
    public func mysqlDateTest01(): Unit {
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
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement1.update()
        mysqlStatement1.close()

        // 创建t_test2名称数据表
        var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test_date(id bigint not null, dateValue1 date not null, dateValue2 date)")
        mysqlStatement2.update()
        mysqlStatement2.close()

        // 通过传入的 sql 语句，返回一个预执行的 Statement 对象实例
        var mysqlStatement3: MysqlStatement = mysqlConnection.prepareStatement(
            "insert into  t_test_date(id,dateValue1,dateValue2)  VALUES(?,?,?)")
        @Assert(3, mysqlStatement3.parameterCount)

        let dateTime1: DateTime = DateTime.nowUTC()
        var id: SqlBigInt = SqlBigInt(1)
        var date1: SqlDate = SqlDate(dateTime1)
        var date2: SqlNullableDate = SqlNullableDate(None)
        var arrDb: Array<SqlDbType> = [id, date1, date2]

        // 执行插入语句插入数据
        var mysqlUpdateResult1: MysqlUpdateResult = mysqlStatement3.update(arrDb)
        @Assert(1, mysqlUpdateResult1.rowCount)

        let dateTime2: DateTime = DateTime.of(year: 2011, month: 10, dayOfMonth: 30)
        let dateTime3: DateTime = DateTime.of(year: 1993, month: 5, dayOfMonth: 3)
        id = SqlBigInt(2)
        date1 = SqlDate(dateTime2)
        date2 = SqlNullableDate(dateTime3)
        arrDb = [id, date1, date2]

        // 执行插入语句插入数据
        var mysqlUpdateResult2: MysqlUpdateResult = mysqlStatement3.update(arrDb)
        @Assert(1, mysqlUpdateResult2.rowCount)

        let dateTime4: DateTime = DateTime.of(year: 2010, month: 9, dayOfMonth: 29)
        let dateTime5: DateTime = DateTime.of(year: 1992, month: 4, dayOfMonth: 18)
        id = SqlBigInt(3)
        date1 = SqlDate(dateTime4)
        date2 = SqlNullableDate(dateTime5)
        arrDb = [id, date1, date2]

        // 执行插入语句插入数据
        var mysqlUpdateResult3: MysqlUpdateResult = mysqlStatement3.update(arrDb)
        @Assert(1, mysqlUpdateResult3.rowCount)
        mysqlStatement3.close()

        // 查询语句预执行语句
        var mysqlStatement4: MysqlStatement = mysqlConnection.prepareStatement("select * from t_test_date where id = 1")
        @Assert(0, mysqlStatement4.parameterCount)
        var mysqlQueryResult: MysqlQueryResult = mysqlStatement4.query()
        let mysqlColumnInfos: Array<MysqlColumnInfo> = mysqlQueryResult.mysqlColumnInfos

        @Assert("id", mysqlColumnInfos[0].name)
        @Assert("SqlBigInt", mysqlColumnInfos[0].typeName)
        @Assert(0, mysqlColumnInfos[0].displaySize)
        @Assert(20, mysqlColumnInfos[0].length)
        @Assert(0, mysqlColumnInfos[0].scale)
        @Assert(true, mysqlColumnInfos[0].nullable)

        @Assert("dateValue1", mysqlColumnInfos[1].name)
        @Assert("SqlDate", mysqlColumnInfos[1].typeName)
        @Assert(0, mysqlColumnInfos[1].displaySize)
        @Assert(10, mysqlColumnInfos[1].length)
        @Assert(0, mysqlColumnInfos[1].scale)
        @Assert(true, mysqlColumnInfos[1].nullable)

        @Assert("dateValue2", mysqlColumnInfos[2].name)
        @Assert("SqlNullableDate", mysqlColumnInfos[2].typeName)
        @Assert(0, mysqlColumnInfos[2].displaySize)
        @Assert(10, mysqlColumnInfos[2].length)
        @Assert(0, mysqlColumnInfos[2].scale)
        @Assert(false, mysqlColumnInfos[2].nullable)

        id = SqlBigInt(3)
        date1 = SqlDate(dateTime4)
        date2 = SqlNullableDate(dateTime5)
        arrDb = [id, date1, date2]

        var isBool: Bool = mysqlQueryResult.next(arrDb)
        @Assert(true, isBool)
        @Assert(1, (arrDb[0] as SqlBigInt).getOrThrow().value)
        let dateTimeQuery: DateTime = (arrDb[1] as SqlDate).getOrThrow().value
        @Assert(dateTime1.year, dateTimeQuery.year)
        @Assert(dateTime1.monthValue, dateTimeQuery.monthValue)
        @Assert(dateTime1.dayOfMonth, dateTimeQuery.dayOfMonth)
        let sqlNullableDate: SqlNullableDate = (arrDb[2] as SqlNullableDate).getOrThrow()
        match (sqlNullableDate.value) {
            case Some(_) => @Assert(0, 1)
            case None => @Assert(1, 1)
        }

        id = SqlBigInt(3)
        date1 = SqlDate(dateTime4)
        date2 = SqlNullableDate(dateTime5)
        arrDb = [id, date1, date2]
        isBool = mysqlQueryResult.next(arrDb)
        @Assert(false, isBool)
        mysqlStatement4.close()

        // 删除语句预执行语句
        let mysqlStatement5: MysqlStatement = mysqlConnection.prepareStatement("delete from t_test_date where id = ?")
        @Assert(1, mysqlStatement5.parameterCount)

        id = SqlBigInt(1)
        arrDb = [id]

        // 执行删除语句
        let mysqlUpdateResult4: MysqlUpdateResult = mysqlStatement5.update(arrDb)
        @Assert(1, mysqlUpdateResult4.rowCount)
        mysqlStatement5.close()

        // 查询语句预执行语句
        let mysqlStatement6: MysqlStatement = mysqlConnection.prepareStatement("select * from t_test_date where id = 1")

        // 执行查询语句
        let mysqlQueryResult1: MysqlQueryResult = mysqlStatement6.query()

        id = SqlBigInt(3)
        date1 = SqlDate(dateTime4)
        date2 = SqlNullableDate(dateTime5)
        arrDb = [id, date1, date2]

        // 获取数据
        isBool = mysqlQueryResult1.next(arrDb)
        @Assert(false, isBool)
        mysqlStatement6.close()

        // 更新语句预执行语句
        let mysqlStatement7: MysqlStatement = mysqlConnection.prepareStatement(
            "update t_test_date set dateValue1 = ?, dateValue2 = ?  where id = ?")
        @Assert(3, mysqlStatement7.parameterCount)

        id = SqlBigInt(2)
        let dateTime6: DateTime = DateTime.of(year: 1840, month: 1, dayOfMonth: 1)
        let dateTime7: DateTime = DateTime.of(year: 1841, month: 2, dayOfMonth: 2)
        date1 = SqlDate(dateTime6)
        date2 = SqlNullableDate(dateTime7)
        arrDb = [date1, date2, id]

        // 执行更新语句
        let mysqlUpdateResult5: MysqlUpdateResult = mysqlStatement7.update(arrDb)
        @Assert(1, mysqlUpdateResult5.rowCount)
        mysqlStatement7.close()

        // 查询语句预执行语句
        let mysqlStatement8: MysqlStatement = mysqlConnection.prepareStatement("select * from t_test_date where id = 2")

        // 执行查询语句
        var mysqlQueryResult2: MysqlQueryResult = mysqlStatement8.query()

        id = SqlBigInt(3)
        date1 = SqlDate(dateTime4)
        date2 = SqlNullableDate(dateTime5)
        arrDb = [id, date1, date2]

        // 获取数据
        isBool = mysqlQueryResult2.next(arrDb)
        @Assert(true, isBool)
        @Assert(2, (arrDb[0] as SqlBigInt).getOrThrow().value)
        let dateTimeQuery1: DateTime = (arrDb[1] as SqlDate).getOrThrow().value
        @Assert(1840, dateTimeQuery1.year)
        @Assert(1, dateTimeQuery1.monthValue)
        @Assert(1, dateTimeQuery1.dayOfMonth)
        let dateTimeQuery2: DateTime = (arrDb[2] as SqlNullableDate).getOrThrow().value.getOrThrow()
        @Assert(1841, dateTimeQuery2.year)
        @Assert(2, dateTimeQuery2.monthValue)
        @Assert(2, dateTimeQuery2.dayOfMonth)
        mysqlStatement8.close()

        // 删除t_test名称数据表
        let mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_date")
        mysqlStatement9.update()
        mysqlStatement9.close()

        // 关闭链接
        mysqlConnection.close()
    }
}
