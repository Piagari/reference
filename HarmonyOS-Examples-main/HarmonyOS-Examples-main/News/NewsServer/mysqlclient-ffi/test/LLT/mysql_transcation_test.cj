// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*

main(): Int64 {
    let transactionTest: TransactionTest = TransactionTest()

    transactionTest.TransactionTest01()
    transactionTest.TransactionTest02()
    transactionTest.TransactionTest03()
    transactionTest.TransactionTest04()
    transactionTest.TransactionTest05()

    transactionTest.TransactionTest06()
    transactionTest.TransactionTest07()
    transactionTest.TransactionTest08()
    transactionTest.TransactionTest09()

    return 0
}

@Test
public class TransactionTest {
    @TestCase
    public func TransactionTest01(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
        let arr: Array<(String, String)> = Array<(String, String)>()
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            arr
        )
        let con: MysqlConnection = mysqlDatasource.connect()
        let transaction = con.createTransaction()

        //数据库事务访问模式ReadWrite
        transaction.accessMode = TransactionAccessMode.ReadWrite
        let res = match (transaction.accessMode) {
            case TransactionAccessMode.ReadWrite => 0
            case _ => 1
        }
        @Assert(0, res)

        con.close()
    }

    @TestCase
    public func TransactionTest02(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
        let arr: Array<(String, String)> = Array<(String, String)>()
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            arr
        )
        let con: MysqlConnection = mysqlDatasource.connect()
        let transaction = con.createTransaction()

        //数据库事务隔离级别ReadUncommitted
        transaction.isoLevel = TransactionIsoLevel.ReadUncommitted
        let res = match (transaction.isoLevel) {
            case TransactionIsoLevel.ReadUncommitted => 0
            case _ => 1
        }
        @Assert(0, res)

        con.close()
    }

    @TestCase
    public func TransactionTest03(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
        let arr: Array<(String, String)> = Array<(String, String)>()
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            arr
        )
        let con: MysqlConnection = mysqlDatasource.connect()
        let transaction = con.createTransaction()

        //数据库事务隔离级别Serializable
        transaction.isoLevel = TransactionIsoLevel.Serializable
        let res = match (transaction.isoLevel) {
            case TransactionIsoLevel.Serializable => 0
            case _ => 1
        }
        @Assert(0, res)

        con.close()
    }

    @TestCase
    public func TransactionTest04(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
        let arr: Array<(String, String)> = Array<(String, String)>()
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            arr
        )
        let con: MysqlConnection = mysqlDatasource.connect()
        let transaction = con.createTransaction()

        //数据库事务隔离级别ReadCommitted
        transaction.isoLevel = TransactionIsoLevel.ReadCommitted
        let res = match (transaction.isoLevel) {
            case TransactionIsoLevel.ReadCommitted => 0
            case _ => 1
        }
        @Assert(0, res)

        con.close()
    }

    @TestCase
    public func TransactionTest05(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
        let arr: Array<(String, String)> = Array<(String, String)>()
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            arr
        )
        let con: MysqlConnection = mysqlDatasource.connect()
        let transaction = con.createTransaction()

        //数据库事务隔离级别RepeatableRead
        transaction.isoLevel = TransactionIsoLevel.RepeatableRead
        let res = match (transaction.isoLevel) {
            case TransactionIsoLevel.RepeatableRead => 0
            case _ => 1
        }
        @Assert(0, res)

        con.close()
    }

    @TestCase
    public func TransactionTest06(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
        let arr: Array<(String, String)> = Array<(String, String)>()
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            arr
        )
        let con: MysqlConnection = mysqlDatasource.connect()
        let transaction = con.createTransaction()

        //数据库事务访问模式Readonly
        transaction.accessMode = TransactionAccessMode.ReadOnly
        let res = match (transaction.accessMode) {
            case TransactionAccessMode.ReadOnly => 0
            case _ => 1
        }
        @Assert(0, res)

        con.close()
    }

    @TestCase
    public func TransactionTest07(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
        let arr: Array<(String, String)> = Array<(String, String)>()
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            arr
        )
        let con: MysqlConnection = mysqlDatasource.connect()
        let transaction = con.createTransaction()

        //数据库事务隔离级别RepeatableRead
        transaction.deferrableMode = TransactionDeferrableMode.Deferrable
        let res = match (transaction.deferrableMode) {
            case TransactionDeferrableMode.Deferrable => 0
            case _ => 1
        }
        @Assert(0, res)

        con.close()
    }

    @TestCase
    public func TransactionTest08(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
        let arr: Array<(String, String)> = Array<(String, String)>()
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            arr
        )
        let con: MysqlConnection = mysqlDatasource.connect()
        let transaction = con.createTransaction()
        transaction.begin()
        transaction.save("savePointName")
        transaction.rollback("savePointName")
        transaction.release("savePointName")

        //数据库事务隔离级别RepeatableRead
        transaction.deferrableMode = TransactionDeferrableMode.Deferrable
        let res = match (transaction.deferrableMode) {
            case TransactionDeferrableMode.Deferrable => 0
            case _ => 1
        }
        @Assert(0, res)

        con.close()
    }

    @TestCase
    public func TransactionTest09(): Unit {
        let mysqlDriver: MysqlDriver = MysqlDriver("mysql")
        let arr: Array<(String, String)> = Array<(String, String)>()
        let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
            "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            arr
        )
        let con: MysqlConnection = mysqlDatasource.connect()
        let transaction = con.createTransaction()
        transaction.begin()
        transaction.commit()
        transaction.rollback()

        //数据库事务隔离级别RepeatableRead
        transaction.deferrableMode = TransactionDeferrableMode.Deferrable
        let res = match (transaction.deferrableMode) {
            case TransactionDeferrableMode.Deferrable => 0
            case _ => 1
        }
        @Assert(0, res)

        con.close()
    }
}
