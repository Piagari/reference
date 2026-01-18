/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package mysqlclient_ffi

/*
 * 获取或初始化结构MYSQL
 * MYSQL *mysql_init(MYSQL *mysql)
 */
@FastNative
foreign func mysql_init(mysql: CPointer<Unit>): CPointer<Unit>

/*
 * 客户端版本（字符串）
 * const char * mysql_get_client_info(void)
 */
@FastNative
foreign func mysql_get_client_info(): CString

/*
 * 连接前设置选项
 * int mysql_options(MYSQL *mysql, enum mysql_option option, const void *arg)
 */
@FastNative
foreign func mysql_options(mysql: CPointer<Unit>, option: Int32, arg1: CPointer<Unit>): Int32

/*
 * 连接到MySQL服务器
 * MYSQL *mysql_real_connect(
 * MYSQL *mysql,
 * const char *host,
 * const char *user,
 * const char *passwd,
 * const char *db,
 * unsigned int port,
 * const char *unix_socket,
 * unsigned long client_flag
 * )
 */
@FastNative
foreign func mysql_real_connect(
    mysql: CPointer<Unit>,
    host: CString,
    user: CString,
    passwd: CString,
    db: CString,
    port: UInt32,
    unix_socket: CString,
    client_flag: UInt64
): CPointer<Unit>

/*
 * 设置当前连接的选项
 * int mysql_set_server_option(MYSQL *mysql, enum enum_mysql_set_option option)
 */
@FastNative
foreign func mysql_set_server_option(mysql: CPointer<Unit>, option: Int32): Int32

/*
 * 服务器状态
 * const char *mysql_stat(MYSQL *mysql)
 */
@FastNative
foreign func mysql_stat(mysql: CPointer<Unit>): CString

/*
 * 为结构分配和初始化内存MYSQL_STMT
 * MYSQL_STMT *mysql_stmt_init(MYSQL *mysql)
 */
@FastNative
foreign func mysql_stmt_init(mysql: CPointer<Unit>): CPointer<Unit>

/*
 * 将预准备语句元数据作为结果集返回
 * MYSQL_RES * mysql_stmt_result_metadata(MYSQL_STMT *stmt)
 */
@FastNative
foreign func mysql_stmt_result_metadata(stmt: CPointer<Unit>): CPointer<Unit>

/*
 * 准备要执行的语句
 * int mysql_stmt_prepare(MYSQL_STMT *stmt, const char *stmt_str, unsigned long length)
 */
@FastNative
foreign func mysql_stmt_prepare(stmt: CPointer<Unit>, stmt_str: CString, length: UInt64): Int32

/*
 * 预准备语句中的参数数
 * unsigned long mysql_stmt_param_count(MYSQL_STMT *stmt)
 */
@FastNative
foreign func mysql_stmt_param_count(stmt: CPointer<Unit>): UInt64

/*
 * 设置预准备语句的属性值
 * bool mysql_stmt_attr_set(MYSQL_STMT *stmt, enum enum_stmt_attr_type option, const void *arg)
 */
@FastNative
foreign func mysql_stmt_attr_set(stmt: CPointer<Unit>, option: Int32, arg: CPointer<Unit>): Bool

/*
 * 执行预准备语句
 * int mysql_stmt_execute(MYSQL_STMT *stmt)
 */
@FastNative
foreign func mysql_stmt_execute(stmt: CPointer<Unit>): Int32

/*
 * 将应用程序数据缓冲区与prepared语句中的参数标记关联
 * bool mysql_stmt_bind_param(MYSQL_STMT *stmt, MYSQL_BIND *bind)
 */
@FastNative
foreign func mysql_stmt_bind_param(stmt: CPointer<Unit>, bind: CPointer<Unit>): Bool

/*
 * 上次更新、删除或插入语句更改/删除/插入的行数
 * uint64_t mysql_stmt_affected_rows(MYSQL *mysql)
 */
@FastNative
foreign func mysql_stmt_affected_rows(stmt: CPointer<Unit>): UInt64

/*
 * 获取当前结果集行的一列的数据
 * int mysql_stmt_fetch_column(MYSQL_STMT *stmt, MYSQL_BIND *bind, unsigned int column, unsigned long offset)
 */
@FastNative
foreign func mysql_stmt_fetch_column(stmt: CPointer<Unit>, bind: CPointer<Unit>, column: UInt32, offset: UIntNative): Int32

/*
 * 将应用程序数据缓冲区与结果集中的列相关联
 * bool mysql_stmt_bind_result(MYSQL_STMT *stmt, MYSQL_BIND *bind)
 */
@FastNative
foreign func mysql_stmt_bind_result(stmt: CPointer<Unit>, bind: CPointer<Unit>): Bool

/*
 * 获取下一个结果集行并返回所有绑定列的数据
 * int mysql_stmt_fetch(MYSQL_STMT *stmt)
 */
@FastNative
foreign func mysql_stmt_fetch(stmt: CPointer<Unit>): Int32

/*
 * 最近准备语句的结果列数
 * unsigned int mysql_stmt_field_count(MYSQL_STMT *stmt)
 */
@FastNative
foreign func mysql_stmt_field_count(stmt: CPointer<Unit>): UInt32

/*
 * 设置自动提交模式
 * bool mysql_autocommit(MYSQL *mysql, bool mode)
 */
@FastNative
foreign func mysql_autocommit(mysql: CPointer<Unit>, mode: Bool): Bool

/*
 * 提交事务
 * bool mysql_commit(MYSQL *mysql)
 */
@FastNative
foreign func mysql_commit(mysql: CPointer<Unit>): Bool

/*
 * 回滚事务
 * bool mysql_rollback(MYSQL *mysql)
 */
@FastNative
foreign func mysql_rollback(mysql: CPointer<Unit>): Bool

/*
 * 启动逐行结果集检索
 * MYSQL_RES *mysql_use_result(MYSQL *mysql)
 */
@FastNative
foreign func mysql_use_result(mysql: CPointer<Unit>): CPointer<Unit>

/*
 * 关闭预准备语句
 * bool mysql_stmt_close(MYSQL_STMT *stmt)
 */
@FastNative
foreign func mysql_stmt_close(stmt: CPointer<Unit>): Bool

/*
 * 关闭与服务器的连接
 * void mysql_close(MYSQL *mysql)
 */
@FastNative
foreign func mysql_close(mysql: CPointer<Unit>): Unit

/*
 * 最近调用的MySQL准备语句的错误消息功能
 * const char * mysql_stmt_error(MYSQL_STMT *stmt)
 */
@FastNative
foreign func mysql_stmt_error(stmt: CPointer<Unit>): CString

/*
 * 最近调用的MySQL函数的错误消息
 * const char * mysql_error(MYSQL *mysql)
 */
@FastNative
foreign func mysql_error(mysql: CPointer<Unit>): CString

/*
 * Ping服务器
 * int mysql_ping(MYSQL *mysql)
 */
@FastNative
foreign func mysql_ping(mysql: CPointer<Unit>): Int32

/*
 * 执行语句
 * int mysql_query(MYSQL *mysql, const char *stmt_str)
 */
@FastNative
foreign func mysql_query(mysql: CPointer<Unit>, q: CString): Int32

/*
 * 提取下一个结果集行
 * MYSQL_ROW mysql_fetch_row(MYSQL_RES *result)
 */
@FastNative
foreign func mysql_fetch_row(result: CPointer<Unit>): CPointer<CString>

/*
 * 为列生成的 ID 先前准备好的声明AUTO_INCREMENT
 * uint64_t mysql_stmt_insert_id(MYSQL_STMT *stmt)
 */
@FastNative
foreign func mysql_stmt_insert_id(stmt: CPointer<Unit>): UInt64

/*
 * 客户端版本（整数）
 * unsigned long mysql_get_client_version(void)
 */
@FastNative
foreign func mysql_get_client_version(): UInt64

/*
 * 服务器版本号（字符串）
 * const char *mysql_get_server_info(MYSQL *mysql)
 */
@FastNative
foreign func mysql_get_server_info(mysql: CPointer<Unit>): CString

/*
 * 服务器版本号（整数）
 * unsigned long mysql_get_server_version(MYSQL *mysql)
 */
@FastNative
foreign func mysql_get_server_version(mysql: CPointer<Unit>): UInt64

/*
 * 上次更新、删除或插入语句更改/删除/插入的行数
 * uint64_t mysql_affected_rows(MYSQL *mysql)
 */
@FastNative
foreign func mysql_affected_rows(mysql: CPointer<Unit>): UInt64

/*
 * 检索和存储整个结果集
 * int mysql_stmt_store_result(MYSQL_STMT *stmt)
 */
@FastNative
foreign func mysql_stmt_store_result(stmt: CPointer<Unit>): Int32

/*
 * 当前连接的默认字符集名称
 * const char * mysql_character_set_name(MYSQL *mysql)
 */
@FastNative
foreign func mysql_character_set_name(mysql: CPointer<Unit>): CString

/*
 * 设置当前连接默认字符集
 * int mysql_set_character_set(MYSQL *mysql, const char *csname)
 */
@FastNative
foreign func mysql_set_character_set(mysql: CPointer<Unit>, charset: CString): Int32

/*
 * 重置连接以清除会话状态
 * int mysql_reset_connection(MYSQL *mysql)
 */
@FastNative
foreign func mysql_reset_connection(mysql: CPointer<Unit>): Int32

/*
 * 在打开的连接上更改用户和数据库
 * bool mysql_change_user(MYSQL *mysql, const char *user, const char *password, const char *db)
 */
@FastNative
foreign func mysql_change_user(mysql: CPointer<Unit>, user: CString, passwd: CString, db: CString): Bool

/*
 * 选择数据库
 * int mysql_select_db(MYSQL *mysql, const char *db)
 */
@FastNative
foreign func mysql_select_db(mysql: CPointer<Unit>, db: CString): Int32

/*
 * 最近调用的 MySQL 函数的错误号
 * unsigned int mysql_errno(MYSQL *mysql)
 */
@FastNative
foreign func mysql_errno(mysql: CPointer<Unit>): UInt32

/*
 * 最近调用的 MySQL 函数的 SQLSTATE 值
 * const char *mysql_sqlstate(MYSQL *mysql)
 */
@FastNative
foreign func mysql_sqlstate(mysql: CPointer<Unit>): CString

/*
 * 上一个语句的警告计数
 * unsigned int mysql_warning_count(MYSQL *mysql)
 */
@FastNative
foreign func mysql_warning_count(mysql: CPointer<Unit>): UInt32

/*
 * 有关最近执行的语句的信息
 * const char *mysql_info(MYSQL *mysql)
 */
@FastNative
foreign func mysql_info(mysql: CPointer<Unit>): CString

/*
 * 导致服务器将调试信息写入错误日志
 * int mysql_dump_debug_info(MYSQL *mysql)
 */
@FastNative
foreign func mysql_dump_debug_info(mysql: CPointer<Unit>): Int32

/*
 * 返回与正则表达式匹配的数据库名称
 * MYSQL_RES * mysql_list_dbs(MYSQL *mysql, const char *wild)
 */
@FastNative
foreign func mysql_list_dbs(mysql: CPointer<Unit>, wild: CString): CPointer<Unit>

/*
 * 返回与正则表达式匹配的表名
 * MYSQL_RES *mysql_list_tables(MYSQL *mysql, const char *wild)
 */
@FastNative
foreign func mysql_list_tables(mysql: CPointer<Unit>, wild: CString): CPointer<Unit>

/*
 * 当前服务器线程列表
 * MYSQL_RES *mysql_list_processes(MYSQL *mysql)
 */
@FastNative
foreign func mysql_list_processes(mysql: CPointer<Unit>): CPointer<Unit>

/*
 * 返回与正则表达式匹配的字段名称
 * MYSQL_RES * mysql_list_fields(MYSQL *mysql, const char *table, const char *wild)
 */
@FastNative
foreign func mysql_list_fields(mysql: CPointer<Unit>, table: CString, wild: CString): CPointer<Unit>

/*
 * 查询语句
 * int STDCALL mysql_send_query(MYSQL *mysql, const char *q, unsigned long length)
 */
@FastNative
foreign func mysql_send_query(mysql: CPointer<Unit>, q: CString, length: UInt64): Int32

/*
 * 执行语句
 * int mysql_real_query(MYSQL *mysql, const char *stmt_str, unsigned long length)
 */
@FastNative
foreign func mysql_real_query(mysql: CPointer<Unit>, stmtStr: CString, length: UInt64): Int32

/*
 * 检索和存储整个结果集
 * MYSQL_RES *mysql_store_result(MYSQL *mysql)
 */
@FastNative
foreign func mysql_store_result(mysql: CPointer<Unit>): CPointer<Unit>

/*
 * 结果集中的列数
 * unsigned int mysql_num_fields(MYSQL_RES *result)
 */
@FastNative
foreign func mysql_num_fields(result: CPointer<Unit>): UInt32

/*
 * 确定是否已读取结果集的最后一行
 * bool mysql_eof(MYSQL_RES *result)
 */
@FastNative
foreign func mysql_eof(result: CPointer<Unit>): Bool

/*
 * 结果集中的行数
 * uint64_t mysql_num_rows(MYSQL_RES *result)
 */
@FastNative
foreign func mysql_num_rows(result: CPointer<Unit>): UInt64

/*
 * 释放结果集内存
 * void mysql_free_result(MYSQL_RES *result)
 */
@FastNative
foreign func mysql_free_result(result: CPointer<Unit>): Unit

/*
 * 初始化 MySQL C API 库
 * int mysql_server_init(int argc, char **argv, char **groups)
 */
@FastNative
foreign func mysql_server_init(argc: Int32, argv: CPointer<CString>, groups: CPointer<CString>): Int32

/*
 * 完成 MySQL C API 库
 * void mysql_server_end(void)
 */
@FastNative
foreign func mysql_server_end(): Unit

/*
 * 关闭 MySQL 服务器
 * int mysql_shutdown(MYSQL *mysql, enum mysql_enum_shutdown_level shutdown_level)
 */
@FastNative
foreign func mysql_shutdown(mysql: CPointer<Unit>, shutdown_level: Int32): Int32

/*
 * 刷新或重置表和缓存
 * int mysql_refresh(MYSQL *mysql, unsigned int options)
 */
@FastNative
foreign func mysql_refresh(mysql: CPointer<Unit>, refresh_options: UInt32): Int32

/*
 * 终止线程
 * int mysql_kill(MYSQL *mysql, unsigned long pid)
 */
@FastNative
foreign func mysql_kill(mysql: CPointer<Unit>, pid: UInt64): Int32

/*
 * 准备与服务器建立 SSL 连接
 * bool STDCALL mysql_ssl_set(
 * MYSQL *mysql,
 * const char *key,
 * const char *cert,
 * const char *ca,
 * const char *capath,
 * const char *cipher
 * );
 */
@FastNative
foreign func mysql_ssl_set(
    mysql: CPointer<Unit>,
    key: CString,
    ert: CString,
    ca: CString,
    capath: CString,
    cipher: CString
): Bool

/*
 * 当前 SSL 密码
 * const char * mysql_get_ssl_cipher(MYSQL *mysql)
 */
@FastNative
foreign func mysql_get_ssl_cipher(mysql: CPointer<Unit>): CString

/*
 * 会话是否重复使用
 * bool mysql_get_ssl_session_reused(MYSQL *mysql)
 */
@FastNative
foreign func mysql_get_ssl_session_reused(mysql: CPointer<Unit>): Bool

/*
 * 返回启用 SSL 的连接的会话数据
 * void *mysql_get_ssl_session_data(MYSQL *,  unsigned int n_ticket,  unsigned int *out_len)
 */
@FastNative
foreign func mysql_get_ssl_session_data(mysql: CPointer<Unit>, n_ticket: UInt32, out_len: CPointer<UInt32>): CPointer<Unit>

/*
 * 释放上次 mysql_get_ssl_session_data（） 调用的会话数据句柄
 * bool mysql_free_ssl_session_data(MYSQL *, void *data)
 */
@FastNative
foreign func mysql_free_ssl_session_data(mysql: CPointer<Unit>, data: CPointer<Unit>): Bool

/*
 * 在服务器端重置语句缓冲区
 * bool mysql_stmt_reset(MYSQL_STMT *stmt)
 */
@FastNative
foreign func mysql_stmt_reset(stmt: CPointer<Unit>): Bool

/*
 * 释放分配给语句处理程序的资源
 * bool mysql_stmt_free_result(MYSQL_STMT *stmt)
 */
@FastNative
foreign func mysql_stmt_free_result(stmt: CPointer<Unit>): Bool

/*
 * 最近调用的 MySQL 准备语句的错误号 功能
 * unsigned int mysql_stmt_errno(MYSQL_STMT *stmt)
 */
@FastNative
foreign func mysql_stmt_errno(stmt: CPointer<Unit>): UInt32

/*
 * 最近调用的 MySQL 准备语句的 SQLSTATE 值 功能
 * const char * mysql_stmt_sqlstate(MYSQL_STMT *stmt)
 */
@FastNative
foreign func mysql_stmt_sqlstate(stmt: CPointer<Unit>): CString

/*
 * 缓冲语句结果集中的行计数
 * uint64_t mysql_stmt_num_rows(MYSQL_STMT *stmt)
 */
@FastNative
foreign func mysql_stmt_num_rows(stmt: CPointer<Unit>): UInt64

/*
 * 为列生成的 ID 以前的声明AUTO_INCREMENT
 * uint64_t mysql_insert_id(MYSQL *mysql)
 */
@FastNative
foreign func mysql_insert_id(mysql: CPointer<Unit>): UInt64

/*
 * 当前线程 ID
 * unsigned long mysql_thread_id(MYSQL *mysql)
 */
@FastNative
foreign func mysql_thread_id(mysql: CPointer<Unit>): UInt64

/*
 * 初始化线程处理程序
 * bool mysql_thread_init(void)
 */
@FastNative
foreign func mysql_thread_init(): Bool

/*
 * 完成线程处理程序
 * void mysql_thread_end(void)
 */
@FastNative
foreign func mysql_thread_end(): Unit

/*--------------------- C基础API ---------------------*/
/*
 * 尝试重新调整之前调用 malloc 或 calloc 所分配的 ptr 所指向的内存块的大小
 * void *realloc(void *ptr, size_t size)
 */
@FastNative
foreign func realloc(ptr: CPointer<Unit>, size: UInt64): CPointer<Unit>

/*
 * 分配所需的内存空间，并返回一个指向它的指针。
 * void *malloc(size_t size)
 */
@FastNative
foreign func malloc(size: UIntNative): CPointer<Unit>

/*--------------------- 自定义API,统一Linux和Windows ---------------------*/
/*
 * 初始化MYSQL_BIND
 * MYSQL_BIND *init_bind(int size)
 */
@FastNative
foreign func init_bind(size: Int64): CPointer<Unit>

/*
 * 设置String类型的值
 * void set_string(MYSQL_BIND *mysqlBind, int64_t index, char *value)
 */
@FastNative
foreign func set_string(bind: CPointer<Unit>, index: Int64, value: CString): Bool

/*
 * 设置Bytes类型的值
 * void set_bytes(MYSQL_BIND *mysqlBind, int64_t index,char *value,int64_t length)
 */
@FastNative
foreign func set_bytes(bind: CPointer<Unit>, index: Int64, value: CPointer<UInt8>, length: Int64): Bool

/*
 * 设置Clob类型的值
 * void set_clob(MYSQL_BIND *mysqlBind, int64_t index,char *value,int64_t length)
 */
@FastNative
foreign func set_clob(bind: CPointer<Unit>, index: Int64, value: CPointer<UInt8>, length: Int64): Bool

/*
 * 设置Clob类型的值
 * void set_blob(MYSQL_BIND *mysqlBind, int64_t index,char *value,int64_t length)
 */
@FastNative
foreign func set_blob(bind: CPointer<Unit>, index: Int64, value: CPointer<UInt8>, length: Int64): Bool

/*
 * 设置Bool类型的值
 * void set_bool(MYSQL_BIND *mysqlBind, int64_t index,bool value)
 */
@FastNative
foreign func set_bool(bind: CPointer<Unit>, index: Int64, value: Int8): Bool

/*
 * 设置Int8类型的值
 * void set_int8(MYSQL_BIND *mysqlBind, int64_t index,signed char value)
 */
@FastNative
foreign func set_int8(bind: CPointer<Unit>, index: Int64, value: Int8): Bool

/*
 * 设置Int16类型的值
 * void set_int16(MYSQL_BIND *mysqlBind, int64_t index,short value)
 */
@FastNative
foreign func set_int16(bind: CPointer<Unit>, index: Int64, value: Int16): Bool

/*
 * 设置Int32类型的值
 * void set_int32(MYSQL_BIND *mysqlBind, int64_t index,int32_t value)
 */
@FastNative
foreign func set_int32(bind: CPointer<Unit>, index: Int64, value: Int32): Bool

/*
 * 设置Int64类型的值
 * void set_int64(MYSQL_BIND *mysqlBind, int64_t index,int64_t value)
 */
@FastNative
foreign func set_int64(bind: CPointer<Unit>, index: Int64, value: Int64): Bool

/*
 * 设置Float32类型的值
 * void set_float32(MYSQL_BIND *mysqlBind, int64_t index,float value)
 */
@FastNative
foreign func set_float32(bind: CPointer<Unit>, index: Int64, value: Float32): Bool

/*
 * 设置Float64类型的值
 * void set_float64(MYSQL_BIND *mysqlBind, int64_t index,double value)
 */
@FastNative
foreign func set_float64(bind: CPointer<Unit>, index: Int64, value: Float64): Bool

/*
 * 设置Date类型的值
 * void set_date(MYSQL_BIND *mysqlBind, int64_t index,uint32_t year,uint32_t monthValue,uint32_t dayOfMonth)
 */
@FastNative
foreign func set_date(bind: CPointer<Unit>, index: Int64, year: UInt32, monthValue: UInt32, dayOfMonth: UInt32): Bool

/*
 * 设置Time类型的值
 * void set_time(MYSQL_BIND *mysqlBind, int64_t index,uint32_t hour,uint32_t minute,uint32_t second)
 */
@FastNative
foreign func set_time(bind: CPointer<Unit>, index: Int64, hour: UInt32, minute: UInt32, second: UInt32): Bool

/*
 * 设置Timestamp类型的值
 * void set_timestamp(MYSQL_BIND *mysqlBind, int64_t index,uint32_t year,uint32_t monthValue,uint32_t dayOfMonth,uint32_t hour,uint32_t minute,uint32_t second)
 */
@FastNative
foreign func set_timestamp(
    bind: CPointer<Unit>,
    index: Int64,
    year: UInt32,
    monthValue: UInt32,
    dayOfMonth: UInt32,
    hour: UInt32,
    minute: UInt32,
    second: UInt32
): Bool

/*
 * 设置setDateTime类型的值
 * void set_date_time(MYSQL_BIND *mysqlBind, int64_t index,uint32_t year,uint32_t monthValue,uint32_t dayOfMonth,uint32_t hour,uint32_t minute,uint32_t second)
 */
@FastNative
foreign func set_date_time(
    bind: CPointer<Unit>,
    index: Int64,
    year: UInt32,
    monthValue: UInt32,
    dayOfMonth: UInt32,
    hour: UInt32,
    minute: UInt32,
    second: UInt32
): Bool

/*
 * 设置Decimal类型的值
 * void set_decimal(MYSQL_BIND *mysqlBind, int64_t index, char *value)
 */
@FastNative
foreign func set_decimal(bind: CPointer<Unit>, index: Int64, value: CString): Bool

/*
 * 设置NULL类型的值,空指针
 * void set_null(MYSQL_BIND *mysqlBind, int64_t index)
 */
@FastNative
foreign func set_null(bind: CPointer<Unit>, index: Int64): Bool

/*
 * 释放内存
 * void free_mysql_cj(MYSQL_BIND *mysqlBind, int64_t index)
 */
@FastNative
foreign func free_mysql_cj(bind: CPointer<Unit>, index: Int64): Unit

/*
 * 获取String类型数据
 * void get_string(MYSQL_BIND *bind, int64_t index, int64_t length)
 */
@FastNative
foreign func get_string(bind: CPointer<Unit>, index: Int64, length: Int64): Bool

/*
 * 获取bytes类型数据
 * void get_bytes(MYSQL_BIND *bind, int64_t index, int64_t length)
 */
@FastNative
foreign func get_bytes(bind: CPointer<Unit>, index: Int64, length: Int64): Bool

/*
 * 获取clob类型数据
 * void get_clob(MYSQL_BIND *bind, int64_t index, int64_t length)
 */
@FastNative
foreign func get_clob(bind: CPointer<Unit>, index: Int64, length: Int64): Bool

/*
 * 获取blob类型数据
 * void get_blob(MYSQL_BIND *bind, int64_t index, int64_t length)
 */
@FastNative
foreign func get_blob(bind: CPointer<Unit>, index: Int64, length: Int64): Bool

/*
 * 获取bool类型数据
 * void get_bool(MYSQL_BIND *bind, int64_t index)
 */
@FastNative
foreign func get_bool(bind: CPointer<Unit>, index: Int64): Bool

/*
 * 获取int8类型数据
 * void get_int8(MYSQL_BIND *bind, int64_t index)
 */
@FastNative
foreign func get_int8(bind: CPointer<Unit>, index: Int64): Bool

/*
 * 获取int16类型数据
 * void get_int16(MYSQL_BIND *bind, int64_t index)
 */
@FastNative
foreign func get_int16(bind: CPointer<Unit>, index: Int64): Bool

/*
 * 获取int32类型数据
 * void get_int32(MYSQL_BIND *bind, int64_t index)
 */
@FastNative
foreign func get_int32(bind: CPointer<Unit>, index: Int64): Bool

/*
 * 获取int64类型数据
 * void get_int64(MYSQL_BIND *bind, int64_t index)
 */
@FastNative
foreign func get_int64(bind: CPointer<Unit>, index: Int64): Bool

/*
 * 获取float32类型数据
 * void get_float32(MYSQL_BIND *bind, int64_t index)
 */
@FastNative
foreign func get_float32(bind: CPointer<Unit>, index: Int64): Bool

/*
 * 获取float64类型数据
 * void get_float64(MYSQL_BIND *bind, int64_t index)
 */
@FastNative
foreign func get_float64(bind: CPointer<Unit>, index: Int64): Bool

/*
 * 获取date类型数据
 * void get_date(MYSQL_BIND *bind, int64_t index)
 */
@FastNative
foreign func get_date(bind: CPointer<Unit>, index: Int64): Bool

/*
 * 获取time类型数据
 * void get_time(MYSQL_BIND *bind, int64_t index)
 */
@FastNative
foreign func get_time(bind: CPointer<Unit>, index: Int64): Bool

/*
 * 获取timestamp类型数据
 * void get_timestamp(MYSQL_BIND *bind, int64_t index)
 */
@FastNative
foreign func get_timestamp(bind: CPointer<Unit>, index: Int64): Bool

/*
 * 获取dateTime类型数据
 * void get_date_time(MYSQL_BIND *bind, int64_t index)
 */
@FastNative
foreign func get_date_time(bind: CPointer<Unit>, index: Int64): Bool

/*
 * 获取String类型数据
 * void get_decimal(MYSQL_BIND *bind, int64_t index, int64_t length)
 */
@FastNative
foreign func get_decimal(bind: CPointer<Unit>, index: Int64, length: Int64): Bool

/*
 * 获取MYSQL_BIND中的buffer,buffer_type,is_null,用作仓颉端处理，转换成SqlDbType
 * void *get_sql_buffer(MYSQL_BIND *bind, int64_t index, enum enum_field_types *buffer_type, bool *is_null,int64_t *length)
 */
@FastNative
foreign func get_sql_buffer(
    bind: CPointer<Unit>,
    index: Int64,
    buffer_type: CPointer<Unit>,
    is_null: CPointer<Unit>,
    length: CPointer<Int64>
): CPointer<Unit>

/*
 * 处理time
 * void get_sql_time(MYSQL_TIME *time,unsigned int *year, unsigned int *month, unsigned int *day, unsigned int *hour, unsigned int *minute, unsigned int *second)
 */
@FastNative
foreign func get_sql_time(
    time: CPointer<Unit>,
    year: CPointer<UInt32>,
    month: CPointer<UInt32>,
    day: CPointer<UInt32>,
    hour: CPointer<UInt32>,
    minute: CPointer<UInt32>,
    second: CPointer<UInt32>
): Unit

/*
 * 获取数据库表头信息
 * bool get_res_data(MYSQL_RES *mysql_res_list, int64_t length, MYSQL_COLUMN_INFO *info)
 */
@FastNative
foreign func get_res_data(mysql_res_list: CPointer<Unit>, length: Int64, info: CPointer<MYSQL_COLUMN_INFO>): Unit
