// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*
import std.collection.*

main(): Int64 {
    let mysqlIntTest: MysqlIntTest = MysqlIntTest()

    mysqlIntTest.mysqlIntTest01() // add one data
    mysqlIntTest.mysqlIntTest02() // add two data
    mysqlIntTest.mysqlIntTest03() // select one data
    mysqlIntTest.mysqlIntTest04() // delete one data
    mysqlIntTest.mysqlIntTest05() // update one data
    mysqlIntTest.mysqlIntTest06() // update null data
    return 0
}

@Test
public class MysqlIntTest {
    /*
     * +-------+-------------+------+-----+---------+-------+
     * | Field | Type        | Null | Key | Default | Extra |
     * +-------+-------------+------+-----+---------+-------+
     * | id    | bigint      | YES  |     | NULL    |       |
     * | name  | varchar(50) | YES  |     | NULL    |       |
     * | intt  | int         | YES  |     | NULL    |       |
     * | char1 | char(50)    | YES  |     | NULL    |       |
     * | tiny  | tinyint     | YES  |     | NULL    |       |
     * | small | smallint    | YES  |     | NULL    |       |
     * | flo   | float       | YES  |     | NULL    |       |
     * | dou   | double      | YES  |     | NULL    |       |
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
    @TestCase
    public func mysqlIntTest01(): Unit {
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
        mysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test(id bigint, name varchar(50),intt int, char1 char(50), tiny tinyint, small smallint, flo float, dou double)"
        )
        mysqlStatement.update()
        mysqlStatement.close()

        // 插入数据预执行语句
        mysqlStatement = mysqlConnection.prepareStatement(
            "insert into t_test(id, name, intt, char1, tiny, small, flo, dou)  VALUES(?,?,?,?,?,?,?,?)")
        @Assert(8, mysqlStatement.parameterCount)

        var id: SqlNullableBigInt = SqlNullableBigInt(1)
        var name: SqlNullableVarchar = SqlNullableVarchar("lihao111")
        var intt: SqlNullableInteger = SqlNullableInteger(1)
        var char1: SqlNullableChar = SqlNullableChar("lihao111")

        var tiny: SqlNullableByte = SqlNullableByte(1)
        var small: SqlNullableSmallInt = SqlNullableSmallInt(1)
        var flo: SqlNullableReal = SqlNullableReal(0.0)
        var dou: SqlNullableDouble = SqlNullableDouble(0.0)

        var arrDb: Array<SqlDbType> = [id, name, intt, char1, tiny, small, flo, dou]

        // 执行插入语句插入数据
        var mysqlUpdateResult: MysqlUpdateResult = mysqlStatement.update(arrDb)
        @Assert(1, mysqlUpdateResult.rowCount)
        mysqlStatement.close()

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    public func mysqlIntTest02(): Unit {
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

        // 插入数据预执行语句
        var mysqlStatement = mysqlConnection.prepareStatement(
            "insert into t_test(id, name, intt, char1, tiny, small, flo, dou)  VALUES(?,?,?,?,?,?,?,?)")
        @Assert(8, mysqlStatement.parameterCount)

        var id: SqlNullableBigInt = SqlNullableBigInt(2)
        var name: SqlNullableVarchar = SqlNullableVarchar("lihao222")
        var intt: SqlNullableInteger = SqlNullableInteger(1)
        var char1: SqlNullableChar = SqlNullableChar("lihao222")

        var tiny: SqlNullableByte = SqlNullableByte(1)
        var small: SqlNullableSmallInt = SqlNullableSmallInt(1)
        var flo: SqlNullableReal = SqlNullableReal(0.0)
        var dou: SqlNullableDouble = SqlNullableDouble(0.0)

        var arrDb: Array<SqlDbType> = [id, name, intt, char1, tiny, small, flo, dou]

        // 执行插入语句插入数据
        var mysqlUpdateResult = mysqlStatement.update(arrDb)
        @Assert(1, mysqlUpdateResult.rowCount)
        mysqlStatement.close()

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    public func mysqlIntTest03(): Unit {
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

        // 查询语句预执行语句
        var mysqlStatement = mysqlConnection.prepareStatement("select * from t_test where id = ?")
        @Assert(1, mysqlStatement.parameterCount)

        var id: SqlNullableBigInt = SqlNullableBigInt(2)
        var arrDb: Array<SqlDbType> = [id]

        // 执行查询语句
        var mysqlQueryResult: MysqlQueryResult = mysqlStatement.query(arrDb)
        let mysqlColumnInfos: Array<MysqlColumnInfo> = mysqlQueryResult.mysqlColumnInfos
        @Assert(8, mysqlColumnInfos.size)

        @Assert("id", mysqlColumnInfos[0].name)
        @Assert("SqlNullableBigInt", mysqlColumnInfos[0].typeName)
        @Assert(0, mysqlColumnInfos[0].displaySize)
        @Assert(20, mysqlColumnInfos[0].length)
        @Assert(0, mysqlColumnInfos[0].scale)
        @Assert(false, mysqlColumnInfos[0].nullable)

        @Assert("name", mysqlColumnInfos[1].name)
        @Assert("SqlNullableVarchar", mysqlColumnInfos[1].typeName)
        @Assert(0, mysqlColumnInfos[1].displaySize)
        @Assert(200, mysqlColumnInfos[1].length)
        @Assert(0, mysqlColumnInfos[1].scale)
        @Assert(false, mysqlColumnInfos[1].nullable)

        @Assert("intt", mysqlColumnInfos[2].name)
        @Assert("SqlNullableInteger", mysqlColumnInfos[2].typeName)
        @Assert(0, mysqlColumnInfos[2].displaySize)
        @Assert(11, mysqlColumnInfos[2].length)
        @Assert(0, mysqlColumnInfos[2].scale)
        @Assert(false, mysqlColumnInfos[2].nullable)

        @Assert("char1", mysqlColumnInfos[3].name)
        @Assert("SqlNullableChar", mysqlColumnInfos[3].typeName)
        @Assert(0, mysqlColumnInfos[3].displaySize)
        @Assert(200, mysqlColumnInfos[3].length)
        @Assert(0, mysqlColumnInfos[3].scale)
        @Assert(false, mysqlColumnInfos[3].nullable)

        @Assert("tiny", mysqlColumnInfos[4].name)
        @Assert("SqlNullableByte", mysqlColumnInfos[4].typeName)
        @Assert(0, mysqlColumnInfos[4].displaySize)
        @Assert(4, mysqlColumnInfos[4].length)
        @Assert(0, mysqlColumnInfos[4].scale)
        @Assert(false, mysqlColumnInfos[4].nullable)

        @Assert("small", mysqlColumnInfos[5].name)
        @Assert("SqlNullableSmallInt", mysqlColumnInfos[5].typeName)
        @Assert(0, mysqlColumnInfos[5].displaySize)
        @Assert(6, mysqlColumnInfos[5].length)
        @Assert(0, mysqlColumnInfos[5].scale)
        @Assert(false, mysqlColumnInfos[5].nullable)

        @Assert("flo", mysqlColumnInfos[6].name)
        @Assert("SqlNullableReal", mysqlColumnInfos[6].typeName)
        @Assert(0, mysqlColumnInfos[6].displaySize)
        @Assert(12, mysqlColumnInfos[6].length)
        @Assert(31, mysqlColumnInfos[6].scale)
        @Assert(false, mysqlColumnInfos[6].nullable)

        @Assert("dou", mysqlColumnInfos[7].name)
        @Assert("SqlNullableDouble", mysqlColumnInfos[7].typeName)
        @Assert(0, mysqlColumnInfos[7].displaySize)
        @Assert(22, mysqlColumnInfos[7].length)
        @Assert(31, mysqlColumnInfos[7].scale)
        @Assert(false, mysqlColumnInfos[7].nullable)

        var name: SqlNullableVarchar = SqlNullableVarchar("")
        var intt: SqlNullableInteger = SqlNullableInteger(1)
        var char1: SqlNullableChar = SqlNullableChar("")

        var tiny: SqlNullableByte = SqlNullableByte(1)
        var small: SqlNullableSmallInt = SqlNullableSmallInt(1)
        var flo: SqlNullableReal = SqlNullableReal(0.0)
        var dou: SqlNullableDouble = SqlNullableDouble(0.0)

        if (!mysqlColumnInfos[0].nullable || mysqlColumnInfos[0].typeName == "SqlBigInt") {
            id = SqlNullableBigInt(0)
        }
        if (!mysqlColumnInfos[1].nullable || mysqlColumnInfos[1].typeName == "SqlVarchar") {
            name = SqlNullableVarchar("")
        }
        if (!mysqlColumnInfos[2].nullable || mysqlColumnInfos[2].typeName == "SqlInteger") {
            intt = SqlNullableInteger(0)
        }
        if (!mysqlColumnInfos[3].nullable || mysqlColumnInfos[3].typeName == "SqlChar") {
            char1 = SqlNullableChar("")
        }
        if (!mysqlColumnInfos[4].nullable || mysqlColumnInfos[4].typeName == "SqlByte") {
            tiny = SqlNullableByte(0)
        }
        if (!mysqlColumnInfos[5].nullable || mysqlColumnInfos[5].typeName == "SqlSmallInt") {
            small = SqlNullableSmallInt(0)
        }
        if (!mysqlColumnInfos[6].nullable || mysqlColumnInfos[6].typeName == "SqlReal") {
            flo = SqlNullableReal(0.0)
        }
        if (!mysqlColumnInfos[7].nullable || mysqlColumnInfos[7].typeName == "SqlDouble") {
            dou = SqlNullableDouble(0.0)
        }

        arrDb = [id, name, intt, char1, tiny, small, flo, dou]

        // 获取数据
        var isBool: Bool = mysqlQueryResult.next(arrDb)
        @Assert(true, isBool)

        @Assert(2, (arrDb[0] as SqlNullableBigInt).getOrThrow().value.getOrThrow())
        @Assert("lihao222", (arrDb[1] as SqlNullableVarchar).getOrThrow().value.getOrThrow())
        @Assert(1, (arrDb[2] as SqlNullableInteger).getOrThrow().value.getOrThrow())
        @Assert("lihao222", (arrDb[3] as SqlNullableChar).getOrThrow().value.getOrThrow())
        @Assert(1, (arrDb[4] as SqlNullableByte).getOrThrow().value.getOrThrow())
        @Assert(1, (arrDb[5] as SqlNullableSmallInt).getOrThrow().value.getOrThrow())
        @Assert(0.0, (arrDb[6] as SqlNullableReal).getOrThrow().value.getOrThrow())
        @Assert(0.0, (arrDb[7] as SqlNullableDouble).getOrThrow().value.getOrThrow())

        mysqlStatement.close()

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    public func mysqlIntTest04(): Unit {
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

        // 删除语句预执行语句
        var mysqlStatement = mysqlConnection.prepareStatement("delete from t_test where name = ?")
        @Assert(1, mysqlStatement.parameterCount)

        var name: SqlNullableVarchar = SqlNullableVarchar("lihao222")
        var arrDb: Array<SqlDbType> = [name]

        // 执行删除语句
        var mysqlUpdateResult: MysqlUpdateResult = mysqlStatement.update(arrDb)
        @Assert(1, mysqlUpdateResult.rowCount)
        mysqlStatement.close()

        // 查询语句预执行语句
        mysqlStatement = mysqlConnection.prepareStatement("select * from t_test where id = ?")
        @Assert(1, mysqlStatement.parameterCount)

        var id = SqlNullableBigInt(2)
        arrDb = [id]

        // 执行查询语句
        var mysqlQueryResult: MysqlQueryResult = mysqlStatement.query(arrDb)

        name = SqlNullableVarchar("")
        var intt: SqlNullableInteger = SqlNullableInteger(1)
        var char1: SqlNullableChar = SqlNullableChar("")

        var tiny: SqlNullableByte = SqlNullableByte(1)
        var small: SqlNullableSmallInt = SqlNullableSmallInt(1)
        var flo: SqlNullableReal = SqlNullableReal(0.0)
        var dou: SqlNullableDouble = SqlNullableDouble(0.0)

        arrDb = [id, name, intt, char1, tiny, small, flo, dou]

        // 获取数据
        let isBool = mysqlQueryResult.next(arrDb)
        @Assert(false, isBool)
        mysqlStatement.close()

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    public func mysqlIntTest05(): Unit {
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

        // 更新语句预执行语句
        var mysqlStatement = mysqlConnection.prepareStatement("update t_test set name = ?, intt = ? where id = ?")
        @Assert(3, mysqlStatement.parameterCount)

        var name: SqlNullableVarchar = SqlNullableVarchar("lihao333")
        var intt: SqlNullableInteger = SqlNullableInteger(11)
        var id: SqlNullableBigInt = SqlNullableBigInt(1)

        var arrDb: Array<SqlDbType> = [name, intt, id]

        // 执行更新语句
        var mysqlUpdateResult: MysqlUpdateResult = mysqlStatement.update(arrDb)
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
        @Assert(8, mysqlColumnInfos.size)

        id = SqlNullableBigInt(1)
        name = SqlNullableVarchar("")
        intt = SqlNullableInteger(1)
        var char1: SqlNullableChar = SqlNullableChar("")

        var tiny: SqlNullableByte = SqlNullableByte(1)
        var small: SqlNullableSmallInt = SqlNullableSmallInt(1)
        var flo: SqlNullableReal = SqlNullableReal(0.0)
        var dou: SqlNullableDouble = SqlNullableDouble(0.0)

        arrDb = [id, name, intt, char1, tiny, small, flo, dou]

        // 获取数据
        var isBool: Bool = mysqlQueryResult.next(arrDb)
        @Assert(true, isBool)

        @Assert(1, (arrDb[0] as SqlNullableBigInt).getOrThrow().value.getOrThrow())
        @Assert("lihao333", (arrDb[1] as SqlNullableVarchar).getOrThrow().value.getOrThrow())
        @Assert(11, (arrDb[2] as SqlNullableInteger).getOrThrow().value.getOrThrow())
        mysqlStatement.close()

        // 关闭链接
        mysqlConnection.close()
    }

    @TestCase
    public func mysqlIntTest06(): Unit {
        // 查询nullable----------------
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

        var mysqlStatement = mysqlConnection.prepareStatement(
            "update t_test set name = ?, intt = ?, char1 = ?, tiny = ?, small = ?, flo = ?, dou = ?  where id = ?")
        @Assert(8, mysqlStatement.parameterCount)

        var name: SqlNullableVarchar = SqlNullableVarchar(None)
        var intt: SqlNullableInteger = SqlNullableInteger(None)
        var char1: SqlNullableChar = SqlNullableChar(None)

        var tiny: SqlNullableByte = SqlNullableByte(None)
        var small: SqlNullableSmallInt = SqlNullableSmallInt(None)
        var flo: SqlNullableReal = SqlNullableReal(None)
        var dou: SqlNullableDouble = SqlNullableDouble(None)

        var id: SqlNullableBigInt = SqlNullableBigInt(1)

        var arrDb: Array<SqlDbType> = [name, intt, char1, tiny, small, flo, dou, id]

        // 执行更新语句
        var mysqlUpdateResult: MysqlUpdateResult = mysqlStatement.update(arrDb)
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
        @Assert(8, mysqlColumnInfos.size)

        id = SqlNullableBigInt(1)
        name = SqlNullableVarchar("")
        intt = SqlNullableInteger(1)
        char1 = SqlNullableChar("")

        tiny = SqlNullableByte(1)
        small = SqlNullableSmallInt(1)
        flo = SqlNullableReal(0.0)
        dou = SqlNullableDouble(0.0)

        arrDb = [id, name, intt, char1, tiny, small, flo, dou]

        // 获取数据
        let isBool: Bool = mysqlQueryResult.next(arrDb)
        @Assert(true, isBool)

        @Assert(1, (arrDb[0] as SqlNullableBigInt).getOrThrow().value.getOrThrow())

        match ((arrDb[1] as SqlNullableVarchar).getOrThrow().value) {
            case Some(_) => @Assert(1, 0)

            case None => @Assert(1, 1)
        }

        match ((arrDb[2] as SqlNullableInteger).getOrThrow().value) {
            case Some(_) => @Assert(1, 0)

            case None => @Assert(1, 1)
        }

        match ((arrDb[3] as SqlNullableChar).getOrThrow().value) {
            case Some(_) => @Assert(1, 0)

            case None => @Assert(1, 1)
        }

        match ((arrDb[4] as SqlNullableByte).getOrThrow().value) {
            case Some(_) => @Assert(1, 0)

            case None => @Assert(1, 1)
        }

        match ((arrDb[5] as SqlNullableSmallInt).getOrThrow().value) {
            case Some(_) => @Assert(1, 0)

            case None => @Assert(1, 1)
        }

        match ((arrDb[6] as SqlNullableReal).getOrThrow().value) {
            case Some(_) => @Assert(1, 0)

            case None => @Assert(1, 1)
        }

        match ((arrDb[7] as SqlNullableDouble).getOrThrow().value) {
            case Some(_) => @Assert(1, 0)

            case None => @Assert(1, 1)
        }
        mysqlStatement.close()

        // 删除t_test名称数据表
        mysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test")
        mysqlStatement.update()
        mysqlStatement.close()

        // 关闭链接
        mysqlConnection.close()
    }

    public func getStr(): String {
        let baseStr: String = "lihao22222"
        let sb: StringBuilder = StringBuilder()

        for (_ in 0..100) {
            sb.append(baseStr)
        }
        return sb.toString()
    }
}
