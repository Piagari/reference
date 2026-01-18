// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*

main(): Int64 {
    let mysqlPooledDatasouceTest: MysqlPooledDatasouceTest = MysqlPooledDatasouceTest()

    mysqlPooledDatasouceTest.mysqlPooledDatasouceTest01()

    return 0
}

@Test
public class MysqlPooledDatasouceTest {
    @TestCase
    public func mysqlPooledDatasouceTest01(): Unit {
        // 初始化数据库驱动
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
        // 通过connectionString和选项打开数据源
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0")
        // 数据库连接池
        var pooledDatasource: PooledDatasource = PooledDatasource(mysqlDatasource)
        // 获取链接
        let connection: Connection = pooledDatasource.connect()
        // 删除表格，防止表格冲突
        var statement: Statement = connection.prepareStatement("drop table if exists t_test10000")
        @Assert(0, statement.parameterColumnInfos.size)
        statement.update()
        statement.close()
        // 创建t_test10000名称数据表
        var statement1: Statement = connection.prepareStatement("create table t_test10000(id bigint,name varchar(50))")
        @Assert(0, statement1.parameterColumnInfos.size)
        statement1.update()
        statement1.close()
        // 通过传入的 sql 语句，返回一个预执行的 Statement 对象实例，插入数据
        var statement2: Statement = connection.prepareStatement("insert into t_test10000(id,name) VALUES(?,?)")
        var id: SqlNullableBigInt = SqlNullableBigInt(1)
        var name: SqlNullableVarchar = SqlNullableVarchar("lihao111")
        var arrDb: Array<SqlDbType> = [id, name]
        var updateResult: UpdateResult = statement2.update(arrDb)
        @Assert(1, updateResult.rowCount)
        statement2.close()
        // 查询语句预执行语句
        var statement3: Statement = connection.prepareStatement("select * from t_test10000 where id = ?")
        var id1: SqlNullableBigInt = SqlNullableBigInt(1)
        var arrDb1: Array<SqlDbType> = [id1]
        var queryResult: QueryResult = statement3.query(arrDb1)
        let columnInfos: Array<ColumnInfo> = queryResult.columnInfos
        @Assert(2, columnInfos.size)
        var id2: SqlNullableBigInt = SqlNullableBigInt(0)
        var name2: SqlNullableVarchar = SqlNullableVarchar("")
        var arrDb2: Array<SqlDbType> = [id2, name2]
        var isBool: Bool = queryResult.next(arrDb2)
        @Assert(true, isBool)
        @Assert(1, (arrDb2[0] as SqlNullableBigInt).getOrThrow().value.getOrThrow())
        @Assert("lihao111", (arrDb2[1] as SqlNullableVarchar).getOrThrow().value.getOrThrow())
        var isBool1: Bool = queryResult.next(arrDb2)
        @Assert(false, isBool1)
        queryResult.close()
        statement3.close()
        // 关闭当前链接
        connection.close()
        // 关闭连接池中的所有连接并阻止其它连接请求调用该方法会阻塞至所有连接关闭并归还到连接池
        if (pooledDatasource.isClosed()) {
            pooledDatasource.close()
        }
    }
}
