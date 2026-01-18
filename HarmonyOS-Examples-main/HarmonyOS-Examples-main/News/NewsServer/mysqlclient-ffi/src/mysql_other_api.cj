/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package mysqlclient_ffi

public class MysqlCharSetApi {
    private var mysql: CPointer<Unit>

    /*
     * 初始化非CDBC接口
     *
     * 参数 mysqlConnection - 连接
     */
    public init(mysqlConnection: MysqlConnection) {
        mysql = mysqlConnection.mysql
    }

    /*
     * 当前连接的默认字符集名称
     *
     * 返回值 String - 默认字符集名称
     */
    public func mysqlCharacterSetName(): String {
        unsafe {
            mysql_character_set_name(mysql).toString()
        }
    }

    /*
     * 设置当前连接默认字符集
     *
     * 参数 charset - 默认字符集
     * 返回值 Int32 - 设置结果
     */
    public func mysqlSetCharacterSet(charset: String): Int32 {
        unsafe {
            let charsetCString: CString = LibC.mallocCString(charset)
            let ret: Int32 = mysql_set_character_set(mysql, charsetCString)
            LibC.free(charsetCString)
            return ret
        }
    }
}

public class MysqlConnectionApi {
    private var mysql: CPointer<Unit>

    /*
     * 初始化非CDBC接口
     *
     * 参数 mysqlConnection - 连接
     */
    public init(mysqlConnection: MysqlConnection) {
        mysql = mysqlConnection.mysql
    }

    /*
     * 在打开的连接上更改用户和数据库
     *
     * 参数 user - 用户名
     * 参数 passwd - 密码
     * 参数 db - 数据库名称
     * 返回值 Bool - 打开结果
     */
    public func mysqlChangeUser(user: String, passwd: String, db: String): Bool {
        unsafe {
            let userCString: CString = LibC.mallocCString(user)
            let pwdCString: CString = LibC.mallocCString(passwd)
            let dbCString: CString = LibC.mallocCString(db)
            let ret: Bool = mysql_change_user(mysql, userCString, pwdCString, dbCString)
            LibC.free(userCString)
            LibC.free(pwdCString)
            LibC.free(dbCString)
            return ret
        }
    }

    /*
     * 选择数据库
     *
     * 参数 db - 数据库名称
     * 返回值 Int32 - 选择结果
     */
    public func mysqlSelectDb(db: String): Int32 {
        unsafe {
            let dbCString: CString = LibC.mallocCString(db)
            let ret: Int32 = mysql_select_db(mysql, dbCString)
            LibC.free(dbCString)
            return ret
        }
    }

    /*
     * 重置连接以清除会话状态
     *
     * 返回值 Int32 - 结果
     */
    public func mysqlResetConnection(): Int32 {
        unsafe {
            return mysql_reset_connection(mysql)
        }
    }
}

public class MysqlInfoApi {
    private var mysql: CPointer<Unit>

    /*
     * 初始化非CDBC接口
     *
     * 参数 mysqlConnection - 连接
     */
    public init(mysqlConnection: MysqlConnection) {
        mysql = mysqlConnection.mysql
    }

    /*
     * 最近调用的 MySQL 函数的错误号
     *
     * 返回值 UInt32 - 错误号
     */
    public func mysqlErrno(): UInt32 {
        unsafe {
            return mysql_errno(mysql)
        }
    }

    /*
     * 最近调用的 MySQL 函数的错误信息
     *
     * 返回值 String - 错误信息
     */
    public func mysqlError(): String {
        unsafe {
            return mysql_error(mysql).toString()
        }
    }

    /*
     * 最近调用的 MySQL 函数的 SQLSTATE 值
     *
     * 返回值 String - SQLSTATE 值
     */
    public func mysqlSqlstate(): String {
        unsafe {
            return mysql_sqlstate(mysql).toString()
        }
    }

    /*
     * 上一个语句的警告计数
     *
     * 返回值 UInt32 - 警告计数
     */
    public func mysqlWarningCount(): UInt32 {
        unsafe {
            return mysql_warning_count(mysql)
        }
    }

    /*
     * 有关最近执行的语句的信息
     *
     * 返回值 String - 最近执行的语句的信息
     */
    public func mysqlInfo(): String {
        unsafe {
            return mysql_info(mysql).toString()
        }
    }

    /*
     * 将调试信息写入错误日志
     *
     * 返回值 Int32 - 结果
     */
    public func mysqlDumpDebugInfo(): Int32 {
        unsafe {
            return mysql_dump_debug_info(mysql)
        }
    }
}

public class MysqlListApi {
    private var mysql: CPointer<Unit>

    /*
     * 初始化非CDBC接口
     *
     * 参数 mysqlConnection - 连接
     */
    public init(mysqlConnection: MysqlConnection) {
        mysql = mysqlConnection.mysql
    }

    /*
     * 返回与正则表达式匹配的数据库名称
     *
     * 参数 wild - 正则表达式
     * 返回值 CPointer<Unit> - 数据库名称
     */
    public func mysqlListDbs(wild: String): CPointer<Unit> {
        unsafe {
            let wildCString: CString = LibC.mallocCString(wild)
            let ret: CPointer<Unit> = mysql_list_dbs(mysql, wildCString)
            LibC.free(wildCString)
            return ret
        }
    }

    /*
     * 返回与正则表达式匹配的表名
     *
     * 参数 wild - 正则表达式
     * 返回值 CPointer<Unit> - 表名
     */
    public func mysqlListTables(wild: String): CPointer<Unit> {
        unsafe {
            let wildCString: CString = LibC.mallocCString(wild)
            let ret: CPointer<Unit> = mysql_list_tables(mysql, wildCString)
            LibC.free(wildCString)
            return ret
        }
    }

    /*
     * 当前服务器线程列表
     *
     * 返回值 CPointer<Unit> - 服务器线程列表
     */
    public func mysqlListTables(): CPointer<Unit> {
        unsafe {
            return mysql_list_processes(mysql)
        }
    }

    /*
     * 返回与正则表达式匹配的字段名称
     *
     * 参数 table - 表名
     * 参数 wild - 正则表达式
     * 返回值 CPointer<Unit> - 字段名称
     */
    public func mysqlListFields(table: String, wild: String): CPointer<Unit> {
        unsafe {
            let tableCString: CString = LibC.mallocCString(table)
            let wildCString: CString = LibC.mallocCString(wild)
            let ret: CPointer<Unit> = mysql_list_fields(mysql, tableCString, wildCString)
            LibC.free(tableCString)
            LibC.free(wildCString)
            return ret
        }
    }
}

public class MysqlRecordApi {
    private var mysql: CPointer<Unit>

    /*
     * 初始化非CDBC接口
     *
     * 参数 mysqlConnection - 连接
     */
    public init(mysqlConnection: MysqlConnection) {
        mysql = mysqlConnection.mysql
    }

    /*
     * 执行语句
     *
     * 参数 q - sql语句
     * 返回值 Int32 - 返回状态
     */
    public func mysqlQuery(q: String): Int32 {
        unsafe {
            let cstr: CString = LibC.mallocCString(q)
            let ret: Int32 = mysql_query(mysql, cstr)
            LibC.free(cstr)
            return ret
        }
    }

    /*
     * 查询语句
     *
     * 参数 q - sql语句
     * 返回值 Int32 - 返回状态
     */
    public func mysqlSendQuery(q: String): Int32 {
        unsafe {
            let cstr: CString = LibC.mallocCString(q)
            let ret: Int32 = mysql_send_query(mysql, cstr, UInt64(cstr.size()))
            LibC.free(cstr)
            return ret
        }
    }

    /*
     * 执行语句
     *
     * 参数 q - sql语句
     * 返回值 Int32 - 返回状态
     */
    public func mysqlRealQuery(q: String): Int32 {
        unsafe {
            let cstr: CString = LibC.mallocCString(q)
            let ret: Int32 = mysql_real_query(mysql, cstr, UInt64(cstr.size()))
            LibC.free(cstr)
            return ret
        }
    }

    /*
     * 检索和存储整个结果集
     *
     * 返回值 CPointer<Unit> - 结果集指针
     */
    public func mysqlStoreResult(): CPointer<Unit> {
        unsafe {
            return mysql_store_result(mysql)
        }
    }

    /*
     * 结果集中的列数
     *
     * 参数 result - 结果集
     * 返回值 UInt32 - 列数
     */
    public func mysqlNumFields(result: CPointer<Unit>): UInt32 {
        unsafe {
            return mysql_num_fields(result)
        }
    }

    /*
     * 确定是否已读取结果集的最后一行
     *
     * 参数 result - 结果集
     * 返回值 Bool - 是否是最后一行
     */
    public func mysqlEof(result: CPointer<Unit>): Bool {
        unsafe {
            return mysql_eof(result)
        }
    }

    /*
     * 结果集中的行数
     *
     * 参数 result - 结果集
     * 返回值 UInt64 - 行数
     */
    public func mysqlNumRows(result: CPointer<Unit>): UInt64 {
        unsafe {
            return mysql_num_rows(result)
        }
    }

    /*
     * 提取下一个结果集行
     *
     * 参数 result - 结果集
     * 返回值 CPointer<CString> - 下一个结果集行
     */
    public func mysqlFetchRow(result: CPointer<Unit>): CPointer<CString> {
        unsafe {
            return mysql_fetch_row(result)
        }
    }

    /*
     * 上次更新、删除或插入语句更改/删除/插入的行数
     *
     * 返回值 UInt64 - 行数
     */
    public func mysqlAffectedRows(): UInt64 {
        unsafe {
            return mysql_affected_rows(mysql)
        }
    }

    /*
     * 释放结果集内存
     *
     * 参数 result - 结果集
     */
    public func mysqlFreeResult(result: CPointer<Unit>): Unit {
        unsafe {
            mysql_free_result(result)
        }
    }

    /*
     * 为列生成的 ID 以前的声明AUTO_INCREMENT
     *
     * 返回值 UInt64 - 生成的插入id
     */
    public func mysqlInsertId(): UInt64 {
        unsafe {
            return mysql_insert_id(mysql)
        }
    }
}

public class MysqlServerApi {
    private var mysql: CPointer<Unit>

    /*
     * 初始化非CDBC接口
     *
     * 参数 mysqlConnection - 连接
     */
    public init(mysqlConnection: MysqlConnection) {
        mysql = mysqlConnection.mysql
    }

    /*
     * 初始化 MySQL C API 库
     *
     * 参数 argc - 参数个数
     * 参数 argv - 参数
     * 参数 groups - 要读取的配置文件组名数组
     * 返回值 Int32 - 返回状态
     */
    public func mysqlServerInit(argc: Int32, argv: CPointer<CString>, groups: CPointer<CString>): Int32 {
        unsafe {
            return mysql_server_init(argc, argv, groups)
        }
    }

    /*
     * 完成 MySQL C API 库
     */
    public func mysqlServerEnd(): Unit {
        unsafe {
            mysql_server_end()
        }
    }

    /*
     * 关闭 MySQL 服务器
     *
     * 参数 shutdownLevel - 关闭方式
     * 返回值 Int32 - 返回状态
     */
    public func mysqlShutdown(shutdownLevel: MysqlShutdownLevel): Int32 {
        unsafe {
            return mysql_shutdown(mysql, shutdownLevel.toInt32())
        }
    }

    /*
     * 刷新或重置表和缓存
     *
     * 参数 refreshOptions - 刷新选项
     * 返回值 Int32 - 返回状态
     */
    public func mysqlRefresh(refreshOptions: UInt32): Int32 {
        unsafe {
            return mysql_refresh(mysql, refreshOptions)
        }
    }

    /*
     * 终止线程
     *
     * 参数 pid - 线程id
     * 返回值 Int32 - 返回状态
     */
    public func mysqlKill(pid: UInt64): Int32 {
        unsafe {
            return mysql_kill(mysql, pid)
        }
    }
}

public class MysqlSslApi {
    private var mysql: CPointer<Unit>

    /*
     * 初始化非CDBC接口
     *
     * 参数 mysqlConnection - 连接
     */
    public init(mysqlConnection: MysqlConnection) {
        mysql = mysqlConnection.mysql
    }

    /*
     * 准备与服务器建立 SSL 连接
     *
     * 参数 keyString - 客户端的路径名 私钥文件
     * 参数 cert - 客户端的路径名 公钥证书文件
     * 参数 ca - 证书的路径名 颁发机构 （CA） 证书文件。此选项（如果使用） 必须指定服务器使用的相同证书
     * 参数 capath - 目录的路径名 包含受信任的 SSL CA 证书文件
     * 参数 cipher - 允许的密码列表 用于 SSL 加密
     * 返回值 Bool - 是否成功
     */
    public func mysqlSslSet(keyString: String, cert: String, ca: String, capath: String, cipher: String): Bool {
        unsafe {
            let keyCString: CString = LibC.mallocCString(keyString)
            let certCString: CString = LibC.mallocCString(cert)
            let caCString: CString = LibC.mallocCString(ca)
            let capathCString: CString = LibC.mallocCString(capath)
            let cipherCString: CString = LibC.mallocCString(cipher)

            let ret: Bool = mysql_ssl_set(mysql, keyCString, certCString, caCString, capathCString, cipherCString)

            LibC.free(keyCString)
            LibC.free(certCString)
            LibC.free(caCString)
            LibC.free(capathCString)
            LibC.free(cipherCString)

            return ret
        }
    }

    /*
     * 当前 SSL 密码
     *
     * 返回值 String - 命名用于连接的加密密码的字符串
     */
    public func mysqlGetSslCipher(): String {
        unsafe {
            return mysql_get_ssl_cipher(mysql).toString()
        }
    }

    /*
     * 会话是否重复使用
     *
     * 返回值 Bool - 会话是否重复使用
     */
    public func mysqlGetSslSessionReused(): Bool {
        unsafe {
            return mysql_get_ssl_session_reused(mysql)
        }
    }

    /*
     * 返回启用 SSL 的连接的会话数据
     *
     * 参数 nTicket - nTicket
     * 参数 outLen - outLen
     */
    public func mysqlGetSslSessionData(nTicket: UInt32, outLen: CPointer<UInt32>): Unit {
        unsafe {
            mysql_get_ssl_session_data(mysql, nTicket, outLen)
        }
    }

    /*
     * 释放上次 mysql_get_ssl_session_data（） 调用的会话数据句柄
     *
     * 参数 data - 释放的数据
     * 返回值 Bool - 成功或失败
     */
    public func mysqlFreeSslSessionData(data: CPointer<Unit>): Bool {
        unsafe {
            return mysql_free_ssl_session_data(mysql, data)
        }
    }
}

public class MysqlStmtApi {
    private var stmt: CPointer<Unit>

    /*
     * 初始化非CDBC接口
     *
     * 参数 mysqlStatement - 预执行
     */
    public init(mysqlStatement: MysqlStatement) {
        stmt = mysqlStatement.stmt
    }

    /*
     * 最近调用的MySQL准备语句的错误消息功能
     *
     * 返回值 String - 错误消息
     */
    public func mysqlStmtError(): String {
        unsafe {
            return mysql_stmt_error(stmt).toString()
        }
    }

    /*
     * 在服务器端重置语句缓冲区
     *
     * 返回值 Bool - 成功或失败
     */
    public func mysqlStmtReset(): Bool {
        unsafe {
            return mysql_stmt_reset(stmt)
        }
    }

    /*
     * 释放分配给语句处理程序的资源
     *
     * 返回值 Bool - 成功或失败
     */
    public func mysqlStmtFreeResult(): Bool {
        unsafe {
            return mysql_stmt_free_result(stmt)
        }
    }

    /*
     * 检索和存储整个结果集
     *
     * 返回值 Int32 - 成功的个数
     */
    public func mysqlStmtStoreResult(): Int32 {
        unsafe {
            return mysql_stmt_store_result(stmt)
        }
    }

    /*
     * 最近调用的 MySQL 准备语句的错误号
     *
     * 返回值 UInt32 - 错误号
     */
    public func mysqlStmtErrno(): UInt32 {
        unsafe {
            return mysql_stmt_errno(stmt)
        }
    }

    /*
     * 最近调用的 MySQL 准备语句的 SQLSTATE值功能
     *
     * 返回值 String - 包含 SQLSTATE 的以 null 结尾的字符串 错误代码
     */
    public func mysqlStmtSqlstate(): String {
        unsafe {
            return mysql_stmt_sqlstate(stmt).toString()
        }
    }

    /*
     * 缓冲语句结果集中的行计数
     *
     * 返回值 UInt64 - 行计数
     */
    public func mysqlStmtNumRows(): UInt64 {
        unsafe {
            return mysql_stmt_num_rows(stmt)
        }
    }

    /*
     * 插入列生成的ID号
     *
     * 返回值 UInt64 - ID号
     */
    public func mysqlStmtInsertId(): UInt64 {
        unsafe {
            return mysql_stmt_insert_id(stmt)
        }
    }
}

public class MysqlthreadApi {
    private var mysql: CPointer<Unit>

    /*
     * 初始化非CDBC接口
     *
     * 参数 mysqlConnection - 连接
     */
    public init(mysqlConnection: MysqlConnection) {
        mysql = mysqlConnection.mysql
    }

    /*
     * 当前线程 ID
     *
     * 返回值 UInt64 - 线程 ID
     */
    public func mysqlThreadId(): UInt64 {
        unsafe {
            return mysql_thread_id(mysql)
        }
    }

    /*
     * 初始化线程处理程序
     *
     * 返回值 Bool - 是否成功
     */
    public func mysqlThreadInit(): Bool {
        unsafe {
            return mysql_thread_init()
        }
    }

    /*
     * 	完成线程处理程序
     */
    public func mysqlThreadEnd(): Unit {
        unsafe {
            mysql_thread_end()
        }
    }
}
