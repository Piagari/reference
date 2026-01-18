// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*

/*
 * SqlVarBinary类型查询不正确
 */
main(): Int64 { // 初始化数据库驱动
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
    var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_varbinary")
    mysqlStatement1.update()
    mysqlStatement1.close()

    // 创建t_test2名称数据表
    var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
        "create table t_test_varbinary(id bigint not null, value1 varbinary(50) not null, value2 varbinary(50))")
    mysqlStatement2.update()
    mysqlStatement2.close()

    // 通过传入的 sql 语句，返回一个预执行的 Statement 对象实例
    var mysqlStatement3: MysqlStatement = mysqlConnection.prepareStatement(
        "insert into  t_test_varbinary(id,value1,value2)  VALUES(?,?,?)")
    @Assert(3, mysqlStatement3.parameterCount)

    var id: SqlBigInt = SqlBigInt(1)
    var data1: SqlVarBinary = SqlVarBinary(Array<Byte>(50, item: 89))
    var data2: SqlNullableVarBinary = SqlNullableVarBinary(None)
    var arrDb: Array<SqlDbType> = [id, data1, data2]

    // 执行插入语句插入数据
    var mysqlUpdateResult1: MysqlUpdateResult = mysqlStatement3.update(arrDb)
    @Assert(1, mysqlUpdateResult1.rowCount)

    id = SqlBigInt(2)
    data1 = SqlVarBinary(Array<Byte>(50, item: 88))
    data2 = SqlNullableVarBinary(Array<Byte>(50, item: 87))
    arrDb = [id, data1, data2]

    // 执行插入语句插入数据
    var mysqlUpdateResult2: MysqlUpdateResult = mysqlStatement3.update(arrDb)
    @Assert(1, mysqlUpdateResult2.rowCount)

    id = SqlBigInt(3)
    data1 = SqlVarBinary(Array<Byte>(50, item: 86))
    data2 = SqlNullableVarBinary(Array<Byte>(50, item: 85))
    arrDb = [id, data1, data2]

    // 执行插入语句插入数据
    var mysqlUpdateResult3: MysqlUpdateResult = mysqlStatement3.update(arrDb)
    @Assert(1, mysqlUpdateResult3.rowCount)
    mysqlStatement3.close()

    // 查询语句预执行语句
    var mysqlStatement4: MysqlStatement = mysqlConnection.prepareStatement(
        "select * from t_test_varbinary where id = 1")
    @Assert(0, mysqlStatement4.parameterCount)
    var mysqlQueryResult: MysqlQueryResult = mysqlStatement4.query()

    id = SqlBigInt(3)
    data1 = SqlVarBinary(Array<Byte>())
    data2 = SqlNullableVarBinary(Array<Byte>())
    arrDb = [id, data1, data2]

    var isBool: Bool = mysqlQueryResult.next(arrDb)
    @Assert(true, isBool)
    @Assert(1, (arrDb[0] as SqlBigInt).getOrThrow().value)

    var dataD = Array<Byte>(50, item: 89)
    var bufD = (arrDb[1] as SqlVarBinary).getOrThrow().value

    @Assert(String.fromUtf8(dataD), String.fromUtf8(bufD))

    let sqlNullableData: SqlNullableVarBinary = (arrDb[2] as SqlNullableVarBinary).getOrThrow()
    match (sqlNullableData.value) {
        case Some(_) => @Assert(0, 1)
        case None => @Assert(1, 1)
    }

    id = SqlBigInt(3)
    data1 = SqlVarBinary(Array<Byte>())
    data2 = SqlNullableVarBinary(Array<Byte>())
    arrDb = [id, data1, data2]
    isBool = mysqlQueryResult.next(arrDb)
    @Assert(false, isBool)
    mysqlStatement4.close()

    // 删除语句预执行语句
    let mysqlStatement5: MysqlStatement = mysqlConnection.prepareStatement("delete from t_test_varbinary where id = ?")
    @Assert(1, mysqlStatement5.parameterCount)

    id = SqlBigInt(1)
    arrDb = [id]

    // 执行删除语句
    let mysqlUpdateResult4: MysqlUpdateResult = mysqlStatement5.update(arrDb)
    @Assert(1, mysqlUpdateResult4.rowCount)
    mysqlStatement5.close()

    // 查询语句预执行语句
    let mysqlStatement6: MysqlStatement = mysqlConnection.prepareStatement(
        "select * from t_test_varbinary where id = 1")

    // 执行查询语句
    let mysqlQueryResult1: MysqlQueryResult = mysqlStatement6.query()

    id = SqlBigInt(3)
    data1 = SqlVarBinary(Array<Byte>())
    data2 = SqlNullableVarBinary(Array<Byte>())
    arrDb = [id, data1, data2]

    // 获取数据
    isBool = mysqlQueryResult1.next(arrDb)
    @Assert(false, isBool)
    mysqlStatement6.close()

    // 更新语句预执行语句
    let mysqlStatement7: MysqlStatement = mysqlConnection.prepareStatement(
        "update t_test_varbinary set value1 = ?, value2 = ?  where id = ?")
    @Assert(3, mysqlStatement7.parameterCount)

    id = SqlBigInt(2)
    data1 = SqlVarBinary(Array<Byte>(50, item: 84))
    data2 = SqlNullableVarBinary(Array<Byte>(50, item: 83))
    arrDb = [data1, data2, id]

    // 执行更新语句
    let mysqlUpdateResult5: MysqlUpdateResult = mysqlStatement7.update(arrDb)
    @Assert(1, mysqlUpdateResult5.rowCount)
    mysqlStatement7.close()

    // 查询语句预执行语句
    let mysqlStatement8: MysqlStatement = mysqlConnection.prepareStatement(
        "select * from t_test_varbinary where id = 2")

    // 执行查询语句
    var mysqlQueryResult2: MysqlQueryResult = mysqlStatement8.query()

    id = SqlBigInt(3)
    data1 = SqlVarBinary(Array<Byte>())
    data2 = SqlNullableVarBinary(Array<Byte>())
    arrDb = [id, data1, data2]

    // 获取数据
    isBool = mysqlQueryResult2.next(arrDb)
    @Assert(true, isBool)
    @Assert(2, (arrDb[0] as SqlBigInt).getOrThrow().value)

    var dataD1 = Array<Byte>(50, item: 84)
    var bufD1 = (arrDb[1] as SqlVarBinary).getOrThrow().value
    @Assert(String.fromUtf8(dataD1), String.fromUtf8(bufD1))

    var dataD2 = Array<Byte>(50, item: 83)
    var bufD2 = (arrDb[2] as SqlNullableVarBinary).getOrThrow().value.getOrThrow()
    @Assert(String.fromUtf8(dataD2), String.fromUtf8(bufD2))
    mysqlStatement8.close()

    // 删除t_test名称数据表
    let mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_varbinary")
    mysqlStatement9.update()
    mysqlStatement9.close()

    // 关闭链接
    mysqlConnection.close()

    return 0
}
