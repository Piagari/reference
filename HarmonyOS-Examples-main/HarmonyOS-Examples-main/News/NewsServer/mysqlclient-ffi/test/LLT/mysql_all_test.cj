// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*

main(): Int64 {
    let mysqlAllTest: MysqlAllTest = MysqlAllTest()

    mysqlAllTest.mysqlAllTest01()

    return 0
}

@Test
public class MysqlAllTest {
    /*
     * +----------------+-------------+------+-----+---------+-------+
     * | Field          | Type        | Null | Key | Default | Extra |
     * +----------------+-------------+------+-----+---------+-------+
     * | id             | bigint      | YES  |     | NULL    |       |
     * | name           | varchar(50) | YES  |     | NULL    |       |
     * | charValue      | char(10)    | YES  |     | NULL    |       |
     * | tinyintValue   | tinyint     | YES  |     | NULL    |       |
     * | smallintValue  | smallint    | YES  |     | NULL    |       |
     * | bigintValue    | bigint      | YES  |     | NULL    |       |
     * | floatValue     | float       | YES  |     | NULL    |       |
     * | doubleValue    | double      | YES  |     | NULL    |       |
     * | textValue      | text        | YES  |     | NULL    |       |
     * | timeValue      | time        | YES  |     | NULL    |       |
     * | dateValue      | date        | YES  |     | NULL    |       |
     * | datetimeValue  | datetime    | YES  |     | NULL    |       |
     * | timestampValue | timestamp   | YES  |     | NULL    |       |
     * +----------------+-------------+------+-----+---------+-------+
     */
    @TestCase
    public func mysqlAllTest01(): Unit {
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
        var mysqlStatement: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test1")
        mysqlStatement.update()
        mysqlStatement.close()

        // 创建t_test名称数据表
        mysqlStatement = mysqlConnection.prepareStatement(
            "create table t_test1(id bigint, name varchar(50),charValue char(10),tinyintValue tinyint,smallintValue smallint,bigintValue bigint,floatValue float,doubleValue double,textValue text,timeValue time,dateValue date,datetimeValue datetime,timestampValue timestamp)"
        )
        mysqlStatement.update()
        mysqlStatement.close()

        // 通过传入的 sql 语句，返回一个预执行的 Statement 对象实例
        mysqlStatement = mysqlConnection.prepareStatement(
            "insert into  t_test1(id,name,charValue,tinyintValue,smallintValue,bigintValue,floatValue,doubleValue,textValue,timeValue,dateValue,datetimeValue,timestampValue)  VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)"
        )
        mysqlStatement.close()

        // 删除t_test名称数据表
        mysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test1")
        mysqlStatement.update()
        mysqlStatement.close()

        println(mysqlConnection.objId)
        @Assert(true, mysqlConnection.objId >= 0)

        // 关闭链接
        mysqlConnection.close()
    }
}
