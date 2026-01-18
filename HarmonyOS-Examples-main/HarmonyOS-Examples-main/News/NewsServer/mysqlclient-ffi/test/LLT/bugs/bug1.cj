// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*

/*
 * 超长Stirng类型数据报错
 */
main(): Int64 {
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
    var mysqlStatement: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_varchar_long")
    mysqlStatement.update()
    mysqlStatement.close()

    // 创建t_test名称数据表
    var mysqlStatement0: MysqlStatement = mysqlConnection.prepareStatement(
        "create table t_test_varchar_long(varcharValue1 varchar(5500) not null)")
    mysqlStatement0.update()
    mysqlStatement0.close()

    // 插入数据预执行语句
    var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement(
        "insert into  t_test_varchar_long(varcharValue1)  VALUES(?)")
    @Assert(1, mysqlStatement1.parameterCount)

    // 插入一条数据
    var varcharValueOne1: SqlVarchar = SqlVarchar("lihao")
    var arrDb1: Array<SqlDbType> = [varcharValueOne1]
    var mysqlUpdateResult1: MysqlUpdateResult = mysqlStatement1.update(arrDb1)
    @Assert(1, mysqlUpdateResult1.rowCount)

    // 插入一条数据
    // 长度过长bug
    let longStr: String = "01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"
    var varcharValueOne2: SqlVarchar = SqlVarchar(longStr)
    var arrDb2: Array<SqlDbType> = [varcharValueOne2]
    var mysqlUpdateResult2: MysqlUpdateResult = mysqlStatement1.update(arrDb2)
    @Assert(1, mysqlUpdateResult2.rowCount)

    // 插入一条数据
    var varcharValueOne3: SqlVarchar = SqlVarchar("菜鸟课程")
    var arrDb3: Array<SqlDbType> = [varcharValueOne3]
    var mysqlUpdateResult3: MysqlUpdateResult = mysqlStatement1.update(arrDb3)
    @Assert(1, mysqlUpdateResult3.rowCount)
    mysqlStatement1.close()

    // 查询语句预执行语句
    var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
        "select * from t_test_varchar_long where varcharValue1 = ?")
    @Assert(1, mysqlStatement2.parameterCount)

    var varcharValueOne4: SqlVarchar = SqlVarchar(longStr)
    var arrDb4: Array<SqlDbType> = [varcharValueOne4]

    var mysqlQueryResult1: MysqlQueryResult = mysqlStatement2.query(arrDb4)
    var varcharValueOne5: SqlVarchar = SqlVarchar("")
    var arrDb5: Array<SqlDbType> = [varcharValueOne5]
    var isBool1: Bool = mysqlQueryResult1.next(arrDb5)
    @Assert(true, isBool1)
    @Assert(longStr, (arrDb5[0] as SqlVarchar).getOrThrow().value)
    mysqlStatement2.close()

    // 删除语句预执行语句
    var mysqlStatement3: MysqlStatement = mysqlConnection.prepareStatement(
        "delete from t_test_varchar_long where varcharValue1 = ?")
    @Assert(1, mysqlStatement3.parameterCount)
    var varcharValueOne6: SqlVarchar = SqlVarchar(longStr)
    var arrDb6: Array<SqlDbType> = [varcharValueOne6]
    var mysqlUpdateResult4: MysqlUpdateResult = mysqlStatement3.update(arrDb6)
    @Assert(1, mysqlUpdateResult4.rowCount)
    mysqlStatement3.close()

    // 查询语句预执行语句
    var mysqlStatement4: MysqlStatement = mysqlConnection.prepareStatement(
        "select * from t_test_varchar_long where varcharValue1 = ?")
    @Assert(1, mysqlStatement4.parameterCount)
    var varcharValueOne7: SqlVarchar = SqlVarchar(longStr)
    var arrDb7: Array<SqlDbType> = [varcharValueOne7]
    var mysqlQueryResult2: MysqlQueryResult = mysqlStatement4.query(arrDb7)
    var varcharValueOne8: SqlVarchar = SqlVarchar("")
    var arrDb8: Array<SqlDbType> = [varcharValueOne8]
    var isBool2: Bool = mysqlQueryResult2.next(arrDb8)
    @Assert(false, isBool2)
    mysqlStatement4.close()

    // 更新语句预执行语句
    let mysqlStatement7: MysqlStatement = mysqlConnection.prepareStatement(
        "update t_test_varchar_long set varcharValue1 = ?  where varcharValue1 = ?")
    @Assert(2, mysqlStatement7.parameterCount)

    var varcharValueOne9: SqlVarchar = SqlVarchar("lihao")
    var varcharValueOne90: SqlVarchar = SqlVarchar(
        "11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"
    )
    var arrDb9: Array<SqlDbType> = [varcharValueOne90, varcharValueOne9]

    // 执行更新语句
    let mysqlUpdateResult5: MysqlUpdateResult = mysqlStatement7.update(arrDb9)
    @Assert(1, mysqlUpdateResult5.rowCount)
    mysqlStatement7.close()

    // 查询语句预执行语句
    let mysqlStatement8: MysqlStatement = mysqlConnection.prepareStatement(
        "select * from t_test_varchar_long where varcharValue1 = '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'"
    )

    // 执行查询语句
    var mysqlQueryResult3: MysqlQueryResult = mysqlStatement8.query()

    var varcharValueOne10: SqlVarchar = SqlVarchar("")
    var arrDb10: Array<SqlDbType> = [varcharValueOne10]

    // 获取数据
    let isBool10: Bool = mysqlQueryResult3.next(arrDb10)
    @Assert(true, isBool10)
    mysqlStatement8.close()

    // 删除t_test名称数据表
    let mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_varchar_long")
    mysqlStatement9.update()

    // 释放预执行语句内存
    mysqlStatement9.close()

    // 关闭链接
    mysqlConnection.close()

    return 0
}
