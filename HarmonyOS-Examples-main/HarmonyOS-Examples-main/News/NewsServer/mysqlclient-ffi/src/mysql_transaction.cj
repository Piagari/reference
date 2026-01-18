/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package mysqlclient_ffi

/*
 * 定义数据库事务的核心行为
 */
public class MysqlTransaction <: Transaction {
    private var mysql: CPointer<Unit>
    private var mysqlConnection: MysqlConnection

    /*
     * 初始化数据库事务
     *
     * 参数 mysql - 初始化的mysql
     */
    init(mysql: CPointer<Unit>, mysqlConnection: MysqlConnection) {
        this.mysql = mysql
        this.mysqlConnection = mysqlConnection
    }

    /*
     * 数据库事务隔离级别。
     * 没有提供直接获取数据库事务隔离级别的接口或属性。但是，可以通过执行 SQL 语句来查询事务隔离级别，
     *
     * 异常 SqlException - 数据库事务隔离级别获取设置失败。
     */
    public mut override prop isoLevel: TransactionIsoLevel {
        get() {
            if(mysqlConnection.isClosed()){
                throw SqlException("The database connection has been closed")
            }
            unsafe {
                let sql = "SELECT @@transaction_isolation"
                let sqlcstr: CString = LibC.mallocCString(sql)
                if (mysql_query(mysql, sqlcstr) != 0) {
                    LibC.free(sqlcstr)
                    throw SqlException(mysql_error(mysql).toString())
                }
                let res: CPointer<Unit> = mysql_use_result(mysql)
                let row: CPointer<CString> = mysql_fetch_row(res)
                let tmp: String = row.read().toString()
                LibC.free(sqlcstr)
                mysql_free_result(res)
                match (tmp.toAsciiLower()) {
                    case "chaos" => return TransactionIsoLevel.Chaos
                    case "default" => return TransactionIsoLevel.Unspecified
                    case "linearizable" => return TransactionIsoLevel.Linearizable
                    case "read-committed" => return TransactionIsoLevel.ReadCommitted
                    case "read-uncommitted" => return TransactionIsoLevel.ReadUncommitted
                    case "repeatable-read" => return TransactionIsoLevel.RepeatableRead
                    case "serializable" => return TransactionIsoLevel.Serializable
                    case "snapshot" => return TransactionIsoLevel.Snapshot
                    case _ => throw SqlException("unknown TransactionIsoLevel Type: ${tmp}")
                }
            }
        }
        set(value) {
            if(mysqlConnection.isClosed()){
                throw SqlException("The database connection has been closed")
            }
            unsafe {
                var sql = match (value) {
                    case TransactionIsoLevel.ReadCommitted => "SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED"
                    case TransactionIsoLevel.ReadUncommitted => "SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED"
                    case TransactionIsoLevel.RepeatableRead => "SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ"
                    case TransactionIsoLevel.Serializable => "SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE"
                    case TransactionIsoLevel.Unspecified => "SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ"
                    case _ => throw SqlException("unsupport TransactionIsoLevel Type: ${value}")
                }
                let sqlcstr: CString = LibC.mallocCString(sql)
                if (mysql_query(mysql, sqlcstr) != 0) {
                    LibC.free(sqlcstr)
                    throw SqlException(mysql_error(mysql).toString())
                }
                LibC.free(sqlcstr)
            }
        }
    }

    /*
     * 数据库事务访问模式。
     * 没有提供直接获取数据库事务隔离级别的接口或属性。但是，可以通过执行 SQL 语句来查询事务隔离级别，
     * 返回一个值 0 或 1。如果值是 0，表示事务访问模式是读写模式；如果值是 1，表示事务访问模式是只读模式
     *
     * 异常 SqlException - 数据库事务访问模式获取设置失败。
     */
    public mut override prop accessMode: TransactionAccessMode {
        get() {
            if(mysqlConnection.isClosed()){
                throw SqlException("The database connection has been closed")
            }
            unsafe {
                let sql = "SELECT @@transaction_read_only"
                let sqlcstr: CString = LibC.mallocCString(sql)
                if (mysql_query(mysql, sqlcstr) != 0) {
                    LibC.free(sqlcstr)
                    throw SqlException(mysql_error(mysql).toString())
                }
                let res: CPointer<Unit> = mysql_use_result(mysql)
                let row: CPointer<CString> = mysql_fetch_row(res)
                let tmp: String = row.read().toString()
                LibC.free(sqlcstr)
                mysql_free_result(res)
                match (tmp.toAsciiLower()) {
                    case "0" => return TransactionAccessMode.ReadWrite
                    case "1" => return TransactionAccessMode.ReadOnly
                    case _ => throw SqlException("unknown TransactionAccessMode Type: ${tmp}")
                }
            }
        }
        set(value) {
            if(mysqlConnection.isClosed()){
                throw SqlException("The database connection has been closed")
            }
            unsafe {
                var sql = ""
                match (value) {
                    case TransactionAccessMode.ReadWrite => sql = "SET SESSION transaction_read_only = OFF"
                    case TransactionAccessMode.ReadOnly => sql = "SET SESSION transaction_read_only = ON"
                    case TransactionAccessMode.Unspecified => sql = "SET SESSION transaction_read_only = OFF"
                    case _ => throw SqlException("error")
                }
                let sqlcstr: CString = LibC.mallocCString(sql)
                if (mysql_query(mysql, sqlcstr) != 0) {
                    LibC.free(sqlcstr)
                    throw SqlException(mysql_error(mysql).toString())
                }
                LibC.free(sqlcstr)
            }
        }
    }

    /*
     * 数据库事务延迟模式。(不支持)
     * 仅PostgreSQL和PostgreSQL支持
     */
    public mut override prop deferrableMode: TransactionDeferrableMode {
        get() {
            return TransactionDeferrableMode.Deferrable
        }
        set(_) {
        }
    }

    /*
     * 开始数据库事务。
     *
     * 异常 SqlException - 开始数据库事务失败。
     */
    public override func begin(): Unit {
        if(mysqlConnection.isClosed()){
            throw SqlException("The database connection has been closed")
        }
        unsafe {
            // 设置自动提交模式
            let isBool: Bool = mysql_autocommit(mysql, false)
            if (isBool) {
                throw SqlException(mysql_error(mysql).toString())
            }
        }
    }

    /*
     * 提交数据库事务。
     *
     * 异常 SqlException - 提交数据库事务失败。
     */
    public override func commit(): Unit {
        if(mysqlConnection.isClosed()){
            throw SqlException("The database connection has been closed")
        }
        unsafe {
            // 提交事务
            let isBool: Bool = mysql_commit(mysql)
            if (isBool) {
                throw SqlException(mysql_error(mysql).toString())
            }
        }
    }

    /*
     * 从挂起状态回滚事务。
     *
     * 异常 SqlException - 从挂起状态回滚事务失败。
     */
    public override func rollback(): Unit {
        if(mysqlConnection.isClosed()){
            throw SqlException("The database connection has been closed")
        }
        unsafe {
            // 回滚事务 
            let isBool: Bool = mysql_rollback(mysql)
            if (isBool) {
                throw SqlException(mysql_error(mysql).toString())
            }
        }
    }

    /*
     * 在事务中创建一个指定名称的保存点，可用于回滚事务的一部分。
     *
     * 参数 savePointName - 保存点名称。
     * 异常 SqlException - 提交事务时服务器端发生错误或者事务已提交或回滚或连接已断开。
     */
    public override func save(savePointName: String): Unit {
        if(mysqlConnection.isClosed()){
            throw SqlException("The database connection has been closed")
        }
        unsafe {
            let sql = "SAVEPOINT ${savePointName}"
            let sqlcstr: CString = LibC.mallocCString(sql)
            if (mysql_query(mysql, sqlcstr) != 0) {
                LibC.free(sqlcstr)
                throw SqlException(mysql_error(mysql).toString())
            }
            LibC.free(sqlcstr)
        }
    }

    /*
     * 回滚事务至指定保存点名称。
     *
     * 参数 savePointName - 保存点名称。
     * 异常 SqlException - 提交事务时服务器端发生错误或者事务已提交或回滚或连接已断开。
     */
    public override func rollback(savepointName: String): Unit {
        if(mysqlConnection.isClosed()){
            throw SqlException("The database connection has been closed")
        }
        unsafe {
            let sql = "rollback to SAVEPOINT ${savepointName}"
            let sqlcstr: CString = LibC.mallocCString(sql)
            if (mysql_query(mysql, sqlcstr) != 0) {
                LibC.free(sqlcstr)
                throw SqlException(mysql_error(mysql).toString())
            }
            LibC.free(sqlcstr)
        }
    }

    /*
     * 销毁先前在当前事务中定义的保存点。这允许系统在事务结束之前回收一些资源。
     *
     * 参数 savePointName - 保存点名称。
     * 异常 SqlException - 提交事务时服务器端发生错误或者事务已提交或回滚或连接已断开。
     */
    public override func release(savePointName: String): Unit {
        if(mysqlConnection.isClosed()){
            throw SqlException("The database connection has been closed")
        }
        unsafe {
            let sql = "RELEASE SAVEPOINT  ${savePointName}"
            let sqlcstr: CString = LibC.mallocCString(sql)
            if (mysql_query(mysql, sqlcstr) != 0) {
                LibC.free(sqlcstr)
                throw SqlException(mysql_error(mysql).toString())
            }
            LibC.free(sqlcstr)
        }
    }
}
