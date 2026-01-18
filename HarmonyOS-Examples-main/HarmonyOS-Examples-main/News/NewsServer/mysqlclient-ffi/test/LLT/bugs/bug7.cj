// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*

/*
 * MYSQL数据插入后，数据末尾多出\0
 */
main(): Int64 {
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
    var mysqlStatement: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_varchar_long")
    mysqlStatement.update()
    mysqlStatement.close()

    // 创建t_test名称数据表
    mysqlStatement = mysqlConnection.prepareStatement(
        "create table t_test_varchar_long(varcharValue1 varchar(5500) not null)")
    mysqlStatement.update()
    mysqlStatement.close()

    // 插入数据预执行语句
    var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement(
        "insert into  t_test_varchar_long(varcharValue1)  VALUES(?)")
    @Assert(1, mysqlStatement1.parameterCount)

    // 插入一条数据
    var varcharValueOne1: SqlVarchar = SqlVarchar("lihao")
    var arrDb1: Array<SqlDbType> = [varcharValueOne1]
    var mysqlUpdateResult1: MysqlUpdateResult = mysqlStatement1.update(arrDb1)
    @Assert(1, mysqlUpdateResult1.rowCount)
    mysqlStatement1.close()

    // 查询语句预执行语句
    var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
        "select * from t_test_varchar_long where varcharValue1 like 'lihao'")

    var mysqlQueryResult1: MysqlQueryResult = mysqlStatement2.query()

    let mysqlColumnInfos1: Array<MysqlColumnInfo> = mysqlQueryResult1.mysqlColumnInfos
    @Assert(1, mysqlColumnInfos1.size)

    @Assert("varcharValue1", mysqlColumnInfos1[0].name)
    @Assert("SqlVarchar", mysqlColumnInfos1[0].typeName)
    @Assert(0, mysqlColumnInfos1[0].displaySize)
    @Assert(22000, mysqlColumnInfos1[0].length)
    @Assert(0, mysqlColumnInfos1[0].scale)
    @Assert(true, mysqlColumnInfos1[0].nullable)

    var varcharValueOne5: SqlVarchar = SqlVarchar("")
    var arrDb5: Array<SqlDbType> = [varcharValueOne5]
    var isBool1: Bool = mysqlQueryResult1.next(arrDb5)
    @Assert("lihao", (arrDb5[0] as SqlVarchar).getOrThrow().value)
    mysqlStatement2.close()

    // 删除t_test名称数据表
    mysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_varchar_long")
    mysqlStatement.update()
    mysqlStatement.close()

    // 关闭链接
    mysqlConnection.close()

    return 0
}
