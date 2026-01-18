// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*
import std.math.numeric.*

main(): Int64 {
    let mysqlDecimalTest: MysqlDecimalTest = MysqlDecimalTest()

    mysqlDecimalTest.mysqlDecimalTest01()

    return 0
}

// @Test
public class MysqlDecimalTest {
    /*
     * +-------+-------------+------+-----+---------+-------+
     * | Field | Type        | Null | Key | Default | Extra |
     * +-------+-------------+------+-----+---------+-------+
     * | id    | bigint      | YES  |     | NULL    |       |
     * | name  | varchar(50) | YES  |     | NULL    |       |
     * +-------+-------------+------+-----+---------+-------+
     * 1、初始化数据库驱动
     * 2、打开数据源
     * 3、返回可用链接
     * 4、删除t_test表,  清除缓存影响
     * 5、创建新的t_test表
     * 6、往t_test表中插入两条数据（1，"lihao111"）（2，"lihao222"）
     * 7、查询id为2的数据，查询到数据
     * 8、删除查询的数据（2，"lihao222"）
     * 9、重新查询id为2的数据，未查询到数据
     * 10、修改剩下的一条数据（1，"lihao111"）-->（1，"lihao333"）
     * 11、查询修改后id为1的数据，查询到数据
     * 12、删除t_test表
     * 13、关闭缓存，关闭连接
     */
    // @TestCase
    public func mysqlDecimalTest01(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
        @Assert(true, mysqlDriver.name.size > 0)
        @Assert(true, mysqlDriver.version.size > 0)
        let arr: Array<(String, String)> = Array<(String, String)>()

        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            arr
        )

        // 返回一个可用的链接
        let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

        // 删除t_test名称数据表
        var mysqlStatement: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test")
        mysqlStatement.update()
        mysqlStatement.close()

        // 创建t_test名称数据表
        mysqlStatement = mysqlConnection.prepareStatement("create table t_test(id bigint, name DECIMAL(10, 4))")
        mysqlStatement.update()
        mysqlStatement.close()

        // 插入数据预执行语句
        mysqlStatement = mysqlConnection.prepareStatement("insert into  t_test(id,name)  VALUES(?,?)")
        @Assert(2, mysqlStatement.parameterCount)

        var id: SqlNullableBigInt = SqlNullableBigInt(1)
        var decimal: Decimal = Decimal("12345.6789")
        var name: SqlNullableDecimal = SqlNullableDecimal(decimal)
        var arrDb: Array<SqlDbType> = [id, name]

        // 执行插入语句插入数据
        var mysqlUpdateResult: MysqlUpdateResult = mysqlStatement.update(arrDb)
        @Assert(1, mysqlUpdateResult.rowCount)

        id = SqlNullableBigInt(2)
        var decimal1: Decimal = Decimal("98765.4321")
        name = SqlNullableDecimal(decimal1)
        arrDb = [id, name]

        // 执行插入语句插入数据
        mysqlUpdateResult = mysqlStatement.update(arrDb)
        @Assert(1, mysqlUpdateResult.rowCount)
        mysqlStatement.close()

        // 查询语句预执行语句
        mysqlStatement = mysqlConnection.prepareStatement("select * from t_test where id = ?")
        @Assert(1, mysqlStatement.parameterCount)

        id = SqlNullableBigInt(1)
        arrDb = [id]

        // 执行查询语句
        var mysqlQueryResult: MysqlQueryResult = mysqlStatement.query(arrDb)
        let mysqlColumnInfos: Array<MysqlColumnInfo> = mysqlQueryResult.mysqlColumnInfos
        @Assert(2, mysqlColumnInfos.size)

        @Assert("id", mysqlColumnInfos[0].name)
        @Assert("SqlNullableBigInt", mysqlColumnInfos[0].typeName)
        @Assert(0, mysqlColumnInfos[0].displaySize)
        @Assert(20, mysqlColumnInfos[0].length)
        @Assert(0, mysqlColumnInfos[0].scale)
        @Assert(false, mysqlColumnInfos[0].nullable)

        @Assert("name", mysqlColumnInfos[1].name)
        @Assert("SqlNullableDecimal", mysqlColumnInfos[1].typeName)
        @Assert(0, mysqlColumnInfos[1].displaySize)
        @Assert(12, mysqlColumnInfos[1].length)
        @Assert(4, mysqlColumnInfos[1].scale)
        @Assert(false, mysqlColumnInfos[1].nullable)

        var id2: SqlNullableBigInt = SqlNullableBigInt(0)
        var decimal2: Decimal = Decimal("0")
        var name2: SqlNullableDecimal = SqlNullableDecimal(decimal2)

        arrDb = [id2, name2]

        // 获取数据
        var isBool: Bool = mysqlQueryResult.next(arrDb)
        @Assert(true, isBool)

        @Assert(1, (arrDb[0] as SqlNullableBigInt).getOrThrow().value.getOrThrow())
        @Assert("12345.6789", (arrDb[1] as SqlNullableDecimal).getOrThrow().value.getOrThrow().toString())
        mysqlStatement.close()

        // 删除语句预执行语句
        mysqlStatement = mysqlConnection.prepareStatement("delete from t_test where id = 1")
        @Assert(0, mysqlStatement.parameterCount)

        // 执行删除语句
        mysqlUpdateResult = mysqlStatement.update()
        @Assert(1, mysqlUpdateResult.rowCount)
        mysqlStatement.close()

        // 查询语句预执行语句
        mysqlStatement = mysqlConnection.prepareStatement("select * from t_test where id = ?")
        @Assert(1, mysqlStatement.parameterCount)

        id = SqlNullableBigInt(1)
        arrDb = [id]

        // 执行查询语句
        mysqlQueryResult = mysqlStatement.query(arrDb)

        // 获取数据
        arrDb = [id, name]
        isBool = mysqlQueryResult.next(arrDb)
        @Assert(false, isBool)
        mysqlStatement.close()

        // 更新语句预执行语句
        mysqlStatement = mysqlConnection.prepareStatement("update t_test set name = ? where id = ?")
        @Assert(2, mysqlStatement.parameterCount)

        var decimal3: Decimal = Decimal("8888.8888")
        name = SqlNullableDecimal(decimal3)
        id = SqlNullableBigInt(2)
        arrDb = [name, id]

        // 执行更新语句
        mysqlUpdateResult = mysqlStatement.update(arrDb)
        @Assert(1, mysqlUpdateResult.rowCount)
        mysqlStatement.close()

        // 查询语句预执行语句
        mysqlStatement = mysqlConnection.prepareStatement("select * from t_test where id = ?")
        @Assert(1, mysqlStatement.parameterCount)

        id = SqlNullableBigInt(2)
        arrDb = [id]

        // 执行查询语句
        mysqlQueryResult = mysqlStatement.query(arrDb)

        id = SqlNullableBigInt(2) 
        var decimal4: Decimal = Decimal("0")
        name = SqlNullableDecimal(decimal4)
        arrDb = [id, name]

        // 获取数据
        isBool = mysqlQueryResult.next(arrDb)
        @Assert(true, isBool)
        
        @Assert(2, (arrDb[0] as SqlNullableBigInt).getOrThrow().value.getOrThrow())
        @Assert("8888.8888", (arrDb[1] as SqlNullableDecimal).getOrThrow().value.getOrThrow().toString())
        mysqlStatement.close()

        // 删除t_test名称数据表
        mysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test")
        mysqlStatement.update()
        mysqlStatement.close()

        // 关闭链接
        mysqlConnection.close()
    }
}
