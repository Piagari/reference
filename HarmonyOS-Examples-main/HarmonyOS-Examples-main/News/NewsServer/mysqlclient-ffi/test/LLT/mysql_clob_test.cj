// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*
import std.io.*

main(): Int64 {
    let mysqlClobTest: MysqlClobTest = MysqlClobTest()

    mysqlClobTest.MysqlClobTest01()

    return 0
}

@Test
public class MysqlClobTest {
    /*
     * +-------+-------------+------+-----+---------+-------+
     * | Field | Type        | Null | Key | Default | Extra |
     * +-------+-------------+------+-----+---------+-------+
     * | id    | bigint      | YES  |     | NULL    |       |
     * | name  | longtext    | YES  |     | NULL    |       |
     * +-------+-------------+------+-----+---------+-------+
     */
    @TestCase
    public func MysqlClobTest01(): Unit {
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
        mysqlStatement = mysqlConnection.prepareStatement("create table t_test(id bigint, name longtext)")
        mysqlStatement.update()
        mysqlStatement.close()

        // 插入数据预执行语句
        mysqlStatement = mysqlConnection.prepareStatement("insert into  t_test(id,name)  VALUES(?,?)")
        @Assert(2, mysqlStatement.parameterCount)

        var id: SqlBigInt = SqlBigInt(1)
        let stream = ByteArrayStream()
        stream.write(Array<Byte>(50, item: 89))
        var name: SqlClob = SqlClob(stream)
        var arrDb: Array<SqlDbType> = [id, name]

        // 执行插入语句插入数据
        var mysqlUpdateResult: MysqlUpdateResult = mysqlStatement.update(arrDb)
        @Assert(1, mysqlUpdateResult.rowCount)

        var name2 = SqlNullableClob(ByteArrayStream())
        id = SqlBigInt(2)
        arrDb = [id, name2]

        // 执行插入语句插入空数据2
        mysqlUpdateResult = mysqlStatement.update(arrDb)
        @Assert(1, mysqlUpdateResult.rowCount)
        mysqlStatement.close()

        // 查询语句预执行语句
        mysqlStatement = mysqlConnection.prepareStatement("select * from t_test where id = ?")
        @Assert(1, mysqlStatement.parameterCount)

        id = SqlBigInt(2)
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
        @Assert("SqlNullableBlob", mysqlColumnInfos[1].typeName)
        @Assert(0, mysqlColumnInfos[1].displaySize)
        @Assert(4294967295, mysqlColumnInfos[1].length)
        @Assert(0, mysqlColumnInfos[1].scale)
        @Assert(false, mysqlColumnInfos[1].nullable)

        id = SqlBigInt(0)
        name2 = SqlNullableClob(ByteArrayStream())
        arrDb = [id, name2]

        // 获取数据
        var isBool: Bool = mysqlQueryResult.next(arrDb)
        @Assert(true, isBool)
        @Assert(2, (arrDb[0] as SqlBigInt).getOrThrow().value)
        if (let None <- (arrDb[1] as SqlClob)) {
            @Assert(true, true)
        }
        mysqlStatement.close()

        // 删除语句预执行语句
        mysqlStatement = mysqlConnection.prepareStatement("delete from t_test where name = ?")
        @Assert(1, mysqlStatement.parameterCount)

        name = SqlClob(stream)
        arrDb = [name]

        // 执行删除语句
        mysqlUpdateResult = mysqlStatement.update(arrDb)
        @Assert(1, mysqlUpdateResult.rowCount)
        mysqlStatement.close()

        // 查询语句预执行语句
        mysqlStatement = mysqlConnection.prepareStatement("select * from t_test where id = ?")
        @Assert(1, mysqlStatement.parameterCount)

        id = SqlBigInt(2)
        arrDb = [id]

        // 执行查询语句
        mysqlQueryResult = mysqlStatement.query(arrDb)

        // 获取数据
        id = SqlBigInt(0)
        name2 = SqlNullableClob(ByteArrayStream())
        arrDb = [id, name2]
        isBool = mysqlQueryResult.next(arrDb)
        @Assert(false, isBool)
        mysqlStatement.close()

        // 更新语句预执行语句
        mysqlStatement = mysqlConnection.prepareStatement("update t_test set name = ? where id = ?")
        @Assert(2, mysqlStatement.parameterCount)

        stream.write(Array<Byte>(10, item: 55))
        name = SqlClob(stream)
        id = SqlBigInt(1)
        arrDb = [name, id]

        // 执行更新语句
        mysqlUpdateResult = mysqlStatement.update(arrDb)
        @Assert(1, mysqlUpdateResult.rowCount)
        mysqlStatement.close()

        // 查询语句预执行语句
        mysqlStatement = mysqlConnection.prepareStatement("select * from t_test where id = ?")
        @Assert(1, mysqlStatement.parameterCount)

        id = SqlBigInt(1)
        arrDb = [id]

        // // 执行查询语句
        mysqlQueryResult = mysqlStatement.query(arrDb)

        @Assert(2, mysqlColumnInfos.size)

        @Assert("id", mysqlColumnInfos[0].name)
        @Assert("SqlNullableBigInt", mysqlColumnInfos[0].typeName)
        @Assert(0, mysqlColumnInfos[0].displaySize)
        @Assert(20, mysqlColumnInfos[0].length)
        @Assert(0, mysqlColumnInfos[0].scale)
        @Assert(false, mysqlColumnInfos[0].nullable)

        @Assert("name", mysqlColumnInfos[1].name)
        @Assert("SqlNullableBlob", mysqlColumnInfos[1].typeName)
        @Assert(0, mysqlColumnInfos[1].displaySize)
        @Assert(4294967295, mysqlColumnInfos[1].length)
        @Assert(0, mysqlColumnInfos[1].scale)
        @Assert(false, mysqlColumnInfos[1].nullable)

        id = SqlBigInt(1)
        stream.write(Array<Byte>(10, item: 55))
        name = SqlClob(stream)
        arrDb = [id, name]

        // 获取数据
        isBool = mysqlQueryResult.next(arrDb)
        @Assert(true, isBool)
        @Assert(1, (arrDb[0] as SqlBigInt).getOrThrow().value)
        var buf = Array<Byte>(10, item: 0)
        (arrDb[1] as SqlClob).getOrThrow().value.read(buf)
        @Assert("7777777777", String.fromUtf8(buf))
        mysqlStatement.close()

        //删除t_test名称数据表
        mysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test")
        mysqlStatement.update()

        // 释放预执行语句内存
        mysqlStatement.close()

        // 关闭链接
        mysqlConnection.close()
    }
}
