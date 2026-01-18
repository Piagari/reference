// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.database.sql.*
import std.time.*

main(): Int64 {
    // 初始化数据库驱动
    let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
    if (mysqlDriver.name == "mysql") {
        println("pass1")
    }
    if (mysqlDriver.version.size > 0) {
        println("pass2")
    }
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
    mysqlStatement = mysqlConnection.prepareStatement("create table t_test(id bigint, name varchar(50))")
    mysqlStatement.update()
    mysqlStatement.close()

    // 插入数据预执行语句
    mysqlStatement = mysqlConnection.prepareStatement("insert into  t_test(id,name)  VALUES(?,?)")
    if (mysqlStatement.parameterCount == 2) {
        println("pass3")
    }

    var id: SqlBigInt = SqlBigInt(1)
    var name: SqlVarchar = SqlVarchar("lihao111")
    var arrDb: Array<SqlDbType> = [id, name]

    // 执行插入语句插入数据
    var mysqlUpdateResult: MysqlUpdateResult = mysqlStatement.update(arrDb)
    if (mysqlUpdateResult.rowCount == 1) {
        println("pass4")
    }

    id = SqlBigInt(2)
    name = SqlVarchar("lihao222")
    arrDb = [id, name]

    // 执行插入语句插入数据
    mysqlUpdateResult = mysqlStatement.update(arrDb)
    if (mysqlUpdateResult.rowCount == 1) {
        println("pass5")
    }
    mysqlStatement.close()

    // 查询语句预执行语句
    mysqlStatement = mysqlConnection.prepareStatement("select * from t_test where id = ?")
    if (mysqlStatement.parameterCount == 1) {
        println("pass6")
    }

    id = SqlBigInt(2)
    arrDb = [id]

    // 执行查询语句
    var mysqlQueryResult: MysqlQueryResult = mysqlStatement.query(arrDb)
    let mysqlColumnInfos: Array<MysqlColumnInfo> = mysqlQueryResult.mysqlColumnInfos
    if (mysqlColumnInfos.size == 2) {
        println("pass7")
    }
    if (mysqlColumnInfos[0].name == "id") {
        println("pass8")
    }
    if (mysqlColumnInfos[0].typeName == "SqlNullableBigInt") {
        println("pass9")
    }
    if (mysqlColumnInfos[0].displaySize == 0) {
        println("pass10")
    }
    if (mysqlColumnInfos[0].length == 20) {
        println("pass11")
    }
    if (mysqlColumnInfos[0].scale == 0) {
        println("pass12")
    }
    if (!mysqlColumnInfos[0].nullable) {
        println("pass13")
    }
    if (mysqlColumnInfos[1].name == "name") {
        println("pass14")
    }
    if (mysqlColumnInfos[1].typeName == "SqlNullableVarchar") {
        println("pass15")
    }
    if (mysqlColumnInfos[1].displaySize == 0) {
        println("pass16")
    }
    if (mysqlColumnInfos[1].length == 200) {
        println("pass17")
    }
    if (mysqlColumnInfos[1].scale == 0) {
        println("pass18")
    }
    if (!mysqlColumnInfos[1].nullable) {
        println("pass19")
    }

    id = SqlBigInt(0)
    name = SqlVarchar("")
    arrDb = [id, name]

    // 获取数据
    var isBool: Bool = mysqlQueryResult.next(arrDb)

    if (isBool) {
        println("pass20")
    }
    if ((arrDb[0] as SqlBigInt).getOrThrow().value == 2) {
        println("pass21")
    }
    if ((arrDb[1] as SqlVarchar).getOrThrow().value == "lihao222") {
        println("pass22")
    }
    mysqlStatement.close()

    // 删除语句预执行语句
    mysqlStatement = mysqlConnection.prepareStatement("delete from t_test where name = ?")
    if (mysqlStatement.parameterCount == 1) {
        println("pass23")
    }

    name = SqlVarchar("lihao222")
    arrDb = [name]

    // 执行删除语句
    mysqlUpdateResult = mysqlStatement.update(arrDb)
    if (mysqlUpdateResult.rowCount == 1) {
        println("pass24")
    }
    mysqlStatement.close()

    // 查询语句预执行语句
    mysqlStatement = mysqlConnection.prepareStatement("select * from t_test where id = ?")
    if (mysqlStatement.parameterCount == 1) {
        println("pass25")
    }

    id = SqlBigInt(2)
    arrDb = [id]

    // 执行查询语句
    mysqlQueryResult = mysqlStatement.query(arrDb)

    // 获取数据
    arrDb = [id, name]
    isBool = mysqlQueryResult.next(arrDb)
    if (!isBool) {
        println("pass26")
    }
    mysqlStatement.close()

    // 更新语句预执行语句
    mysqlStatement = mysqlConnection.prepareStatement("update t_test set name = ? where id = ?")
    if (mysqlStatement.parameterCount == 2) {
        println("pass27")
    }

    name = SqlVarchar("lihao333")
    id = SqlBigInt(1)
    arrDb = [name, id]

    // 执行更新语句
    mysqlUpdateResult = mysqlStatement.update(arrDb)
    if (mysqlUpdateResult.rowCount == 1) {
        println("pass28")
    }
    mysqlStatement.close()

    // 查询语句预执行语句
    mysqlStatement = mysqlConnection.prepareStatement("select * from t_test where id = ?")
    if (mysqlStatement.parameterCount == 1) {
        println("pass29")
    }

    id = SqlBigInt(1)
    arrDb = [id]

    // 执行查询语句
    mysqlQueryResult = mysqlStatement.query(arrDb)
    if (mysqlColumnInfos.size == 2) {
        println("pass30")
    }

    id = SqlBigInt(1)
    name = SqlVarchar("")
    arrDb = [id, name]

    // 获取数据
    isBool = mysqlQueryResult.next(arrDb)
    if (isBool) {
        println("pass31")
    }
    if ((arrDb[0] as SqlBigInt).getOrThrow().value == 1) {
        println("pass32")
    }
    if ((arrDb[1] as SqlVarchar).getOrThrow().value == "lihao333") {
        println("pass33")
    }
    mysqlStatement.close()

    // 删除t_test名称数据表
    mysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test")
    mysqlStatement.update()
    mysqlStatement.close()

    // 关闭链接
    mysqlConnection.close()

    return 0
}
