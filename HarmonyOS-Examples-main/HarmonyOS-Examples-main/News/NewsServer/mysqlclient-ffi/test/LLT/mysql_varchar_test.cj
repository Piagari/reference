// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*

main(): Int64 {
    let mysqlVarcharTest: MysqlVarcharTest = MysqlVarcharTest()

    mysqlVarcharTest.deleteDB()
    mysqlVarcharTest.createDB()

    mysqlVarcharTest.mysqlVarcharTest01()

    return 0
}

/*
 * +---------------+---------------+------+-----+---------+-------+
 * | Field         | Type          | Null | Key | Default | Extra |
 * +---------------+---------------+------+-----+---------+-------+
 * | id            | bigint        | NO   |     | NULL    |       |
 * | varcharValue1 | varchar(5500) | NO   |     | NULL    |       |
 * | varcharValue2 | varchar(50)   | YES  |     | NULL    |       |
 * +---------------+---------------+------+-----+---------+-------+
 */
@Test
public class MysqlVarcharTest {
    func deleteDB() {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        // 删除t_test名称数据表
        var mysqlStatement: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_varchar")
        mysqlStatement.update()

        mysqlStatement.close()
        mysqlConnection.close()
    }

    func createDB() {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        // 创建t_test名称数据表
        var mysqlStatement: MysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test_varchar(id bigint not null, varcharValue1 varchar(5500) not null, varcharValue2 varchar(50)) CHARSET=utf8"
        )
        mysqlStatement.update()

        mysqlStatement.close()
        mysqlConnection.close()
    }

    @TestCase
    public func mysqlVarcharTest01(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            Array<(String, String)>()
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        // 插入数据预执行语句
        var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement(
            "insert into  t_test_varchar(id,varcharValue1,varcharValue2)  VALUES(?,?,?)")
        @Assert(3, mysqlStatement1.parameterCount)

        // 插入一条数据
        var id1: SqlBigInt = SqlBigInt(1)
        var varcharValueOne1: SqlVarchar = SqlVarchar("lihao")
        var varcharValueTwo1: SqlNullableVarchar = SqlNullableVarchar("no.1")
        var arrDb1: Array<SqlDbType> = [id1, varcharValueOne1, varcharValueTwo1]
        var mysqlUpdateResult1: MysqlUpdateResult = mysqlStatement1.update(arrDb1)
        @Assert(1, mysqlUpdateResult1.rowCount)

        // 插入一条数据
        let longStr: String = "012345678"
        var id2: SqlBigInt = SqlBigInt(2)
        var varcharValueOne2: SqlVarchar = SqlVarchar(longStr)
        var varcharValueTwo2: SqlNullableVarchar = SqlNullableVarchar("菜鸟课程")
        var arrDb2: Array<SqlDbType> = [id2, varcharValueOne2, varcharValueTwo2]
        var mysqlUpdateResult2: MysqlUpdateResult = mysqlStatement1.update(arrDb2)
        @Assert(1, mysqlUpdateResult2.rowCount)

        // 插入一条数据
        var id3: SqlBigInt = SqlBigInt(3)
        var varcharValueOne3: SqlVarchar = SqlVarchar(longStr)
        var varcharValueTwo3: SqlNullableVarchar = SqlNullableVarchar(None)
        var arrDb3: Array<SqlDbType> = [id3, varcharValueOne3, varcharValueTwo3]
        var mysqlUpdateResult3: MysqlUpdateResult = mysqlStatement1.update(arrDb3)
        @Assert(1, mysqlUpdateResult3.rowCount)
        mysqlStatement1.close()

        // 查询语句预执行语句
        var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
            "select * from t_test_varchar where id = ?")
        @Assert(1, mysqlStatement2.parameterCount)

        var id4: SqlBigInt = SqlBigInt(2)
        var arrDb4: Array<SqlDbType> = [id4]

        var mysqlQueryResult1: MysqlQueryResult = mysqlStatement2.query(arrDb4)

        let mysqlColumnInfos1: Array<MysqlColumnInfo> = mysqlQueryResult1.mysqlColumnInfos
        @Assert(3, mysqlColumnInfos1.size)

        @Assert("id", mysqlColumnInfos1[0].name)
        @Assert("SqlBigInt", mysqlColumnInfos1[0].typeName)
        @Assert(0, mysqlColumnInfos1[0].displaySize)
        @Assert(20, mysqlColumnInfos1[0].length)
        @Assert(0, mysqlColumnInfos1[0].scale)
        @Assert(true, mysqlColumnInfos1[0].nullable)

        @Assert("varcharValue1", mysqlColumnInfos1[1].name)
        @Assert("SqlVarchar", mysqlColumnInfos1[1].typeName)
        @Assert(0, mysqlColumnInfos1[1].displaySize)
        @Assert(22000, mysqlColumnInfos1[1].length)
        @Assert(0, mysqlColumnInfos1[1].scale)
        @Assert(true, mysqlColumnInfos1[1].nullable)

        @Assert("varcharValue2", mysqlColumnInfos1[2].name)
        @Assert("SqlNullableVarchar", mysqlColumnInfos1[2].typeName)
        @Assert(0, mysqlColumnInfos1[2].displaySize)
        @Assert(200, mysqlColumnInfos1[2].length)
        @Assert(0, mysqlColumnInfos1[2].scale)
        @Assert(false, mysqlColumnInfos1[2].nullable)

        var id5: SqlBigInt = SqlBigInt(1)
        var varcharValueOne5: SqlVarchar = SqlVarchar("")
        var varcharValueTwo5: SqlNullableVarchar = SqlNullableVarchar("")
        var arrDb5: Array<SqlDbType> = [id5, varcharValueOne5, varcharValueTwo5]
        var isBool1: Bool = mysqlQueryResult1.next(arrDb5)
        mysqlQueryResult1.close()
        @Assert(true, isBool1)
        @Assert(2, (arrDb5[0] as SqlBigInt).getOrThrow().value)
        @Assert(longStr, (arrDb5[1] as SqlVarchar).getOrThrow().value)
        @Assert("菜鸟课程", (arrDb5[2] as SqlNullableVarchar).getOrThrow().value.getOrThrow())
        mysqlStatement2.close()

        // 删除语句预执行语句
        var mysqlStatement3: MysqlStatement = mysqlConnection.prepareStatement(
            "delete from t_test_varchar where id = 2")
        @Assert(0, mysqlStatement3.parameterCount)
        var mysqlUpdateResult4: MysqlUpdateResult = mysqlStatement3.update()
        @Assert(1, mysqlUpdateResult4.rowCount)
        mysqlStatement3.close()

        // 查询语句预执行语句
        var mysqlStatement4: MysqlStatement = mysqlConnection.prepareStatement(
            "select * from t_test_varchar where id = ?")
        @Assert(1, mysqlStatement4.parameterCount)
        var id6: SqlBigInt = SqlBigInt(2)
        var arrDb6: Array<SqlDbType> = [id6]
        var mysqlQueryResult2: MysqlQueryResult = mysqlStatement4.query(arrDb6)
        var id7: SqlBigInt = SqlBigInt(1)
        var varcharValueOne7: SqlVarchar = SqlVarchar("")
        var varcharValueTwo7: SqlNullableVarchar = SqlNullableVarchar("")
        var arrDb7: Array<SqlDbType> = [id7, varcharValueOne7, varcharValueTwo7]
        var isBool2: Bool = mysqlQueryResult2.next(arrDb7)
        @Assert(false, isBool2)
        mysqlStatement4.close()

        // 更新语句预执行语句
        let mysqlStatement7: MysqlStatement = mysqlConnection.prepareStatement(
            "update t_test_varchar set varcharValue1 = ?  where id = ?")
        @Assert(2, mysqlStatement7.parameterCount)

        var id9: SqlBigInt = SqlBigInt(1)
        var varcharValueOne90: SqlVarchar = SqlVarchar("111111111111111111111111111111111111111111111111111111")
        var arrDb9: Array<SqlDbType> = [varcharValueOne90, id9]

        // 执行更新语句
        let mysqlUpdateResult5: MysqlUpdateResult = mysqlStatement7.update(arrDb9)
        @Assert(1, mysqlUpdateResult5.rowCount)
        mysqlStatement7.close()

        // 查询语句预执行语句
        let mysqlStatement8: MysqlStatement = mysqlConnection.prepareStatement(
            "select * from t_test_varchar where id = 1")

        // 执行查询语句
        var mysqlQueryResult3: MysqlQueryResult = mysqlStatement8.query()

        var id10: SqlBigInt = SqlBigInt(1)
        var varcharValueOne10: SqlVarchar = SqlVarchar("")
        var varcharValueTwo10: SqlNullableVarchar = SqlNullableVarchar("")
        var arrDb10: Array<SqlDbType> = [id10, varcharValueOne10, varcharValueTwo10]

        // 获取数据
        let isBool10: Bool = mysqlQueryResult3.next(arrDb10)
        @Assert(true, isBool10)
        mysqlStatement8.close()

        // 删除t_test名称数据表
        let mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_varchar")
        mysqlStatement9.update()
        mysqlStatement9.close()

        // 关闭链接
        mysqlConnection.close()
    }
}
