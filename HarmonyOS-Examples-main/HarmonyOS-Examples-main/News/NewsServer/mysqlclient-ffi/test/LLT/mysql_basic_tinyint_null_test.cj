// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*

main(): Int64 {
    let mysqlTinyintTest: MysqlTinyintTest = MysqlTinyintTest()

    mysqlTinyintTest.mysqlTinyintTest01()

    return 0
}

/*
 * +------------+------------+------+-----+---------+-------+
 * | Field      | Type       | Null | Key | Default | Extra |
 * +------------+------------+------+-----+---------+-------+
 * | id         | bigint     | NO   |     | NULL    |       |
 * | value1     | tinyint    | NO   |     | NULL    |       |
 * | value2     | tinyint    | YES  |     | NULL    |       |
 * +------------+------------+------+-----+---------+-------+
 */
@Test
public class MysqlTinyintTest {
    @TestCase
    public func mysqlTinyintTest01(): Unit {
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
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_tinyint")
        mysqlStatement1.update()
        mysqlStatement1.close()

        // 创建t_test2名称数据表
        var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test_tinyint(id bigint not null, value1 tinyint not null, value2 tinyint)")
        mysqlStatement2.update()
        mysqlStatement2.close()

        // 通过传入的 sql 语句，返回一个预执行的 Statement 对象实例
        var mysqlStatement3: MysqlStatement = mysqlConnection.prepareStatement(
            "insert into  t_test_tinyint(id,value1,value2)  VALUES(?,?,?)")
        @Assert(3, mysqlStatement3.parameterCount)

        var id: SqlBigInt = SqlBigInt(1)
        var data1: SqlByte = SqlByte(11)
        var data2: SqlNullableByte = SqlNullableByte(None)
        var arrDb: Array<SqlDbType> = [id, data1, data2]

        // 执行插入语句插入数据
        var mysqlUpdateResult1: MysqlUpdateResult = mysqlStatement3.update(arrDb)
        @Assert(1, mysqlUpdateResult1.rowCount)

        id = SqlBigInt(2)
        data1 = SqlByte(22)
        data2 = SqlNullableByte(44)
        arrDb = [id, data1, data2]

        // 执行插入语句插入数据
        var mysqlUpdateResult2: MysqlUpdateResult = mysqlStatement3.update(arrDb)
        @Assert(1, mysqlUpdateResult2.rowCount)

        id = SqlBigInt(3)
        data1 = SqlByte(33)
        data2 = SqlNullableByte(66)
        arrDb = [id, data1, data2]

        // 执行插入语句插入数据
        var mysqlUpdateResult3: MysqlUpdateResult = mysqlStatement3.update(arrDb)
        @Assert(1, mysqlUpdateResult3.rowCount)
        mysqlStatement3.close()

        // 查询语句预执行语句
        var mysqlStatement4: MysqlStatement = mysqlConnection.prepareStatement(
            "select * from t_test_tinyint where id = 1")
        @Assert(0, mysqlStatement4.parameterCount)
        var mysqlQueryResult: MysqlQueryResult = mysqlStatement4.query()
        let mysqlColumnInfos: Array<MysqlColumnInfo> = mysqlQueryResult.mysqlColumnInfos

        @Assert("id", mysqlColumnInfos[0].name)
        @Assert("SqlBigInt", mysqlColumnInfos[0].typeName)
        @Assert(0, mysqlColumnInfos[0].displaySize)
        @Assert(20, mysqlColumnInfos[0].length)
        @Assert(0, mysqlColumnInfos[0].scale)
        @Assert(true, mysqlColumnInfos[0].nullable)

        @Assert("value1", mysqlColumnInfos[1].name)
        @Assert("SqlByte", mysqlColumnInfos[1].typeName)
        @Assert(0, mysqlColumnInfos[1].displaySize)
        @Assert(4, mysqlColumnInfos[1].length)
        @Assert(0, mysqlColumnInfos[1].scale)
        @Assert(true, mysqlColumnInfos[1].nullable)

        @Assert("value2", mysqlColumnInfos[2].name)
        @Assert("SqlNullableByte", mysqlColumnInfos[2].typeName)
        @Assert(0, mysqlColumnInfos[2].displaySize)
        @Assert(4, mysqlColumnInfos[2].length)
        @Assert(0, mysqlColumnInfos[2].scale)
        @Assert(false, mysqlColumnInfos[2].nullable)

        id = SqlBigInt(3)
        data1 = SqlByte(1)
        data2 = SqlNullableByte(1)
        arrDb = [id, data1, data2]

        var isBool: Bool = mysqlQueryResult.next(arrDb)
        @Assert(true, isBool)
        @Assert(1, (arrDb[0] as SqlBigInt).getOrThrow().value)
        @Assert(11, (arrDb[1] as SqlByte).getOrThrow().value)

        let sqlNullableData: SqlNullableByte = (arrDb[2] as SqlNullableByte).getOrThrow()
        match (sqlNullableData.value) {
            case Some(_) => @Assert(0, 1)
            case None => @Assert(1, 1)
        }

        id = SqlBigInt(3)
        data1 = SqlByte(1)
        data2 = SqlNullableByte(1)
        arrDb = [id, data1, data2]
        isBool = mysqlQueryResult.next(arrDb)
        @Assert(false, isBool)
        mysqlStatement4.close()

        // 删除语句预执行语句
        let mysqlStatement5: MysqlStatement = mysqlConnection.prepareStatement(
            "delete from t_test_tinyint where id = ?")
        @Assert(1, mysqlStatement5.parameterCount)

        id = SqlBigInt(1)
        arrDb = [id]

        // 执行删除语句
        let mysqlUpdateResult4: MysqlUpdateResult = mysqlStatement5.update(arrDb)
        @Assert(1, mysqlUpdateResult4.rowCount)
        mysqlStatement5.close()

        // 查询语句预执行语句
        let mysqlStatement6: MysqlStatement = mysqlConnection.prepareStatement(
            "select * from t_test_tinyint where id = 1")

        // 执行查询语句
        let mysqlQueryResult1: MysqlQueryResult = mysqlStatement6.query()

        id = SqlBigInt(3)
        data1 = SqlByte(1)
        data2 = SqlNullableByte(1)
        arrDb = [id, data1, data2]

        // 获取数据
        isBool = mysqlQueryResult1.next(arrDb)
        @Assert(false, isBool)
        mysqlStatement6.close()

        // 更新语句预执行语句
        let mysqlStatement7: MysqlStatement = mysqlConnection.prepareStatement(
            "update t_test_tinyint set value1 = ?, value2 = ?  where id = ?")
        @Assert(3, mysqlStatement7.parameterCount)

        id = SqlBigInt(2)
        data1 = SqlByte(122)
        data2 = SqlNullableByte(124)
        arrDb = [data1, data2, id]

        // 执行更新语句
        let mysqlUpdateResult5: MysqlUpdateResult = mysqlStatement7.update(arrDb)
        @Assert(1, mysqlUpdateResult5.rowCount)
        mysqlStatement7.close()

        // 查询语句预执行语句
        let mysqlStatement8: MysqlStatement = mysqlConnection.prepareStatement(
            "select * from t_test_tinyint where id = 2")

        // 执行查询语句
        var mysqlQueryResult2: MysqlQueryResult = mysqlStatement8.query()

        id = SqlBigInt(3)
        data1 = SqlByte(1)
        data2 = SqlNullableByte(1)
        arrDb = [id, data1, data2]

        // 获取数据
        isBool = mysqlQueryResult2.next(arrDb)
        @Assert(true, isBool)
        @Assert(2, (arrDb[0] as SqlBigInt).getOrThrow().value)
        @Assert(122, (arrDb[1] as SqlByte).getOrThrow().value)
        @Assert(124, (arrDb[2] as SqlNullableByte).getOrThrow().value)
        mysqlStatement8.close()

        // 删除t_test名称数据表
        let mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_tinyint")
        mysqlStatement9.update()

        // 释放预执行语句内存
        mysqlStatement9.close()

        // 关闭链接
        mysqlConnection.close()
    }
}
