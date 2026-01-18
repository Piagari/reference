# mysqlclient-ffi库

## 介绍

基于 libmysqlclient 实现 database 包。

## CDBC接口

### 数据库驱动接口

#### 介绍

数据库驱动

#### 主要接口

##### public class MysqlDriver <: Driver

```cangjie
public class MysqlDriver <: Driver {
    /*
     * 初始化驱动
     *
     * 参数 name - 驱动名称
     * 异常 SqlException - 内存不足导致初始化失败
     */
    public init(name: String)

    /**
     * 驱动名称
     */
    public override prop name: String

    /**
     * 驱动版本
     *
     * 异常 SqlException - 获取版本失败
     */
    public override prop version: String

    /**
     * 指示驱动程序是否与连接池亲和。
     * 如果否，则不建议使用连接池。
     * 比如sqlite驱动连接池化的收益不明显，不建议使用连接池
     */
    public override prop preferredPooling: Bool

    /*
     * 通过connectionString和选项打开数据源
     *
     * 参数 connectionString - 数据库连接字符串
     * 参数 _ - key,value的tuple数组，打开数据源的选项
     * 返回值 Datasource - 数据源实例
     * 异常 SqlException - connectionString连接内容不正确会导致异常
     */
    public override func open(connectionString: String, _: Array<(String, String)>): MysqlDatasource
}
```

### 数据源接口

#### 介绍

数据源

#### 主要接口

##### public class MysqlDatasource <: Datasource

```cangjie
public class MysqlDatasource <: Datasource {
    /*
     * 设置连接选项(不支持)
     */
    public override func setOption(_: String, _: String): Unit

    /*
     * 连接前设置选项
     *
     * 参数 key - C中枚举 enum mysql_option
     * 参数 value - 值
     */
    public func setOption(key: MysqlOption, value: String): Unit

    /*
     * 连接前设置选项
     *
     * 参数 key - C中枚举 enum mysql_option
     * 参数 value - 值
     */
    public func setOption(key: MysqlOption, value: UInt32): Unit

    /*
     * 连接前设置选项
     *
     * 参数 key - C中枚举 enum mysql_option
     * 参数 value - 值
     */
    public func setOption(key: MysqlOption, value: UInt64): Unit

    /*
     * 连接前设置选项
     *
     * 参数 key - C中枚举 enum mysql_option
     * 参数 value - 值
     */
    public func setOption(key: MysqlOption, value: Bool): Unit

    /*
     * 返回一个可用的连接
     *
     * 返回值 Connection - 数据库连接实例
     * 异常 SqlException - 和mysql server连接失败会导致异常
     */
    public override func connect(): MysqlConnection

    /*
     * 关闭资源 （不支持）
     */
    public override func close(): Unit

    /*
     * 判断资源是否关闭（不支持）
     *
     * 返回值 Bool - 如果已经关闭返回true，否则返回false
     */
    public override func isClosed(): Bool
}
```

### 数据库连接接口

#### 介绍

数据库连接

#### 主要接口

##### public class MysqlConnection <: Connection

```cangjie
public class MysqlConnection <: Connection {    
    /*
     * connection标识ID
     */
    public prop objId: UInt64

    /**
     * 描述与数据源连接的当前状态
     */
    public override prop state: ConnectionState

    /**
     * 返回连接到的数据源元数据(不支持)
     *
     * 返回值 Map<String, String> - 数据源元数据
     */
    public override func getMetaData(): Map<String, String>

    /*
     * 设置连接选项
     *
     * 参数 option - C中枚举 enum enum_mysql_set_option
     * 异常 SqlException - 设置错误
     */
    public func setOption(option: MysqlSetOption): Unit

    /**
     * 通过传入的 sql 语句，返回一个预执行的 Statement 对象实例
     *
     * 参数 sql - 预执行的 sql 语句，sql 语句的参数只支持 ? 符号占位符
     * 返回值 Statement - 一个可以执行 sql 语句的实例对象
     * 异常 SqlException - 可能传入SQL语句错误
     */
    public override func prepareStatement(sql: String): MysqlStatement

    /**
     * 创建事务对象
     *
     * 返回值 MysqlTransaction - 事务对象
     */
    public override func createTransaction(): MysqlTransaction

    /*
     * 关闭资源
     */
    public override func close(): Unit

    /*
     * 判断资源是否关闭
     *
     * 返回值 Bool - 如果已经关闭返回true，否则返回false
     */
    public override func isClosed(): Bool

    /*
     * ping服务器，保持连接
     */
    public func mysqlPing(): Unit
}
```

### sql语句预执行接口

#### 介绍

sql语句预执行

#### 主要接口

##### public class MysqlStatement <: Statement

```cangjie
public class MysqlStatement <: Statement {
    /*
     * 预执行 sql 语句中，占位参数的列信息（不支持）
     */
    public override prop parameterColumnInfos: Array<ColumnInfo>

    /*
     * 预执行sql语句中，占位的参数个数
     */
    public prop parameterCount: Int64

    /**
     * 设置预执行sql语句选项(不支持)
     */
    public override func setOption(_: String, _: String): Unit

    /**
     * 设置预执行sql语句选项
     *
     * 参数 option - C中枚举 enum enum_stmt_attr_type
     * 参数 arg - 值
     * 异常 SqlException - 参数设置错误。
     */
    public func setOption(option: MysqlStmtAttrType, arg: Bool): Unit

    /**
     * 设置预执行sql语句选项
     *
     * 参数 option - C中枚举 enum enum_stmt_attr_type
     * 参数 arg - 值
     * 异常 SqlException - 参数设置错误。
     */
    public func setOption(option: MysqlStmtAttrType, arg: UInt64): Unit

    /**
     * 执行sql语句，得到更新结果
     *
     * 参数 params - 填充预执行语句中问号的数据。
     * 返回值 UpdateResult - 更新结果。
     * 异常 SqlException - 传入参数错误。
     */
    public override func update(params: Array<SqlDbType>): MysqlUpdateResult

    /**
     * 执行sql语句，得到查询结果
     *
     * 参数 params - 填充预执行语句中问号的数据。
     * 返回值 QueryResult - 查询结果。
     * 异常 SqlException - 传入参数错误。
     */
    public override func query(params: Array<SqlDbType>): MysqlQueryResult

    /*
     * 关闭资源
     *
     * 异常 SqlException - 关闭资源失败。
     */
    public override func close(): Unit

    /*
     * 判断资源是否关闭
     *
     * 返回值 Bool - 如果已经关闭返回true，否则返回false
     */
    public override func isClosed(): Bool
}
```

### 执行Insert、Update、Delete语句产生的结果接口

#### 介绍

执行Insert、Update、Delete语句产生的结果

#### 主要接口

##### public class MysqlUpdateResult <: UpdateResult

```cangjie
public class MysqlUpdateResult <: UpdateResult {
    /*
     * 执行Insert,Update,Delete语句影响的行数
     */
    public override prop rowCount: Int64

    /*
     * 执行Insert语句自动生成的最后rowID，如果不支持则为0
     */
    public override prop lastInsertId: Int64
}
```

### 执行Select语句产生的结果接口

#### 介绍

执行Select语句产生的结果

#### 主要接口

##### public class MysqlQueryResult <: QueryResult

```cangjie
public class MysqlQueryResult <: QueryResult {
    /*
     * 返回结果集的列信息，比如列名，列类型，列长度，是否允许数据库Null值等（不支持）
     */
    public override prop columnInfos: Array<ColumnInfo>

    /*
     * 返回结果集的列信息，比如列名，列类型，列长度，是否允许数据库Null值等
     */
    public prop mysqlColumnInfos: Array<MysqlColumnInfo>

    /*
     * 向后移动一行，必须先调用一次next才能移动到第一行，第二次调用移动到第二行，依此类推。
     * 当返回true时，驱动会在values中填入行数据；当返回false时结束，且不会修改values的内容。
     *
     * 参数 values - 需要填充返回的数据
     * 返回值 Bool - 存在下一行则返回true，否则返回false
     * 异常 SqlException - 传入参数错误
     */
    public override func next(values: Array<SqlDbType>): Bool

    /*
     * 关闭资源
     *
     * 异常 SqlException - 关闭资源失败。
     */
    public override func close(): Unit

    /*
     * 判断资源是否关闭
     * 返回值 Bool - 如果已经关闭返回true，否则返回false
     */
    public override func isClosed(): Bool
}
```

### 执行Select/Query语句返回结果的列信息接口

#### 介绍

执行Select/Query语句返回结果的列信息

#### 主要接口

##### public class MysqlColumnInfo <: ColumnInfo

```cangjie
public class MysqlColumnInfo <: ColumnInfo {
    /*
     * 初始化执行Select/Query语句返回结果的列信息
     *
     * 参数 name - 列名或者别名
     * 参数 typeName - 列类型名称
     * 参数 displaySize - 列值的最大显示长度
     * 参数 length - 获取列值大小
     * 参数 scale - 列值的小数长度
     * 参数 nullable - 列值是否允许数据库Null值
     */
    public init(name: String, typeName: String, displaySize: Int64, length: Int64, scale: Int64, nullable: Bool)

    /*
     * 列名或者别名
     */
    public override prop name: String

    /*
     * 列类型名称，如果在SqlDataType中定义
     * 返回SqlDataType.toString(),如果未在SqlDataType中定义，由数据库驱动定义
     */
    public override prop typeName: String

    /*
     * 列值的最大显示长度，如果无限制，则应该返回Int64.Max（仍然受数据库的限制）
     */
    public override prop displaySize: Int64

    /**
     * 获取列值大小。
     */
    public override prop length: Int64

    /*
     * 列值的小数长度，如果无小数部分，返回0
     */
    public override prop scale: Int64

    /*
     * 列值是否允许数据库Null值
     */
    public override prop nullable: Bool
}
```

### 定义数据库事务的核心行为接口

#### 介绍

定义数据库事务的核心行为

#### 主要接口

##### public class MysqlTransaction <: Transaction

```cangjie
public class MysqlTransaction <: Transaction {
    /*
     * 数据库事务隔离级别。
     * 没有提供直接获取数据库事务隔离级别的接口或属性。但是，可以通过执行 SQL 语句来查询事务隔离级别，
     *
     * 异常 SqlException - 数据库事务隔离级别获取设置失败。
     */
    public mut override prop isoLevel: TransactionIsoLevel

    /*
     * 数据库事务访问模式。
     * 没有提供直接获取数据库事务隔离级别的接口或属性。但是，可以通过执行 SQL 语句来查询事务隔离级别，
     * 返回一个值 0 或 1。如果值是 0，表示事务访问模式是读写模式；如果值是 1，表示事务访问模式是只读模式
     *
     * 异常 SqlException - 数据库事务访问模式获取设置失败。
     */
    public mut override prop accessMode: TransactionAccessMode

    /*
     * 数据库事务延迟模式。(不支持)
     * 仅PostgreSQL和PostgreSQL支持
     */
    public mut override prop deferrableMode: TransactionDeferrableMode

    /*
     * 开始数据库事务。
     *
     * 异常 SqlException - 开始数据库事务失败。
     */
    public override func begin(): Unit

    /*
     * 提交数据库事务。
     *
     * 异常 SqlException - 提交数据库事务失败。
     */
    public override func commit(): Unit

    /*
     * 从挂起状态回滚事务。
     *
     * 异常 SqlException - 从挂起状态回滚事务失败。
     */
    public override func rollback(): Unit

    /*
     * 在事务中创建一个指定名称的保存点，可用于回滚事务的一部分。
     *
     * 参数 savePointName - 保存点名称。
     * 异常 SqlException - 提交事务时服务器端发生错误或者事务已提交或回滚或连接已断开。
     */
    public override func save(savePointName: String): Unit

    /*
     * 回滚事务至指定保存点名称。
     *
     * 参数 savePointName - 保存点名称。
     * 异常 SqlException - 提交事务时服务器端发生错误或者事务已提交或回滚或连接已断开。
     */
    public override func rollback(savepointName: String): Unit

    /*
     * 销毁先前在当前事务中定义的保存点。这允许系统在事务结束之前回收一些资源。
     *
     * 参数 savePointName - 保存点名称。
     * 异常 SqlException - 提交事务时服务器端发生错误或者事务已提交或回滚或连接已断开。
     */
    public override func release(savePointName: String): Unit
}
```

### 新增数据结构接口

#### 介绍

新增数据结构

#### 主要接口

##### public class SqlDateTime <: SqlDbType

```cangjie
public class SqlDateTime <: SqlDbType {
    /*
     * 初始化SQL数据类型
     *
     * 参数 dateTime - 日期数据
     */
    public init(dateTime: DateTime)

    /*
     * 数据
     */
    public mut prop value: DateTime

    /*
     * 类型名称
     */
    public prop name: String
}
```

##### public class SqlNullableDateTime <: SqlNullableDbType

```cangjie
public class SqlNullableDateTime <: SqlNullableDbType{
    /*
     * 初始化SQL数据类型
     *
     * 参数 dateTime - 日期数据
     */
    public init(dateTime: ?DateTime)

    /*
     * 数据
     */
    public mut prop value: ?DateTime

    /*
     * 类型名称
     */
    public prop name: String
}
```

### 枚举

#### 介绍

枚举

#### 主要接口

##### public enum MysqlStmtAttrType <: Equatable<MysqlStmtAttrType>

```cangjie
public enum MysqlStmtAttrType <: Equatable<MysqlStmtAttrType> {
    | STMT_ATTR_UPDATE_MAX_LENGTH
    | STMT_ATTR_CURSOR_TYPE
    | STMT_ATTR_PREFETCH_ROWS

    /*
     * 枚举是否相等
     *
     * 参数 that - 枚举
     * 返回值 Bool - 是否相等
     */
    public operator func ==(that: MysqlStmtAttrType): Bool

    /*
     * 枚举是否不相等
     *
     * 参数 that - 枚举
     * 返回值 Bool - 是否不相等
     */
    public operator func !=(that: MysqlStmtAttrType): Bool
}
```

##### public enum MysqlSetOption <: Equatable<MysqlSetOption>

```cangjie
public enum MysqlSetOption <: Equatable<MysqlSetOption>{
    | MYSQL_OPTION_MULTI_STATEMENTS_ON
    | MYSQL_OPTION_MULTI_STATEMENTS_OFF

    /*
     * 枚举是否相等
     *
     * 参数 that - 枚举
     * 返回值 Bool - 是否相等
     */
    public operator func ==(that: MysqlSetOption): Bool

    /*
     * 枚举是否不相等
     *
     * 参数 that - 枚举
     * 返回值 Bool - 是否不相等
     */
    public operator func !=(that: MysqlSetOption): Bool
}
```

##### public enum MysqlSetOption <: Equatable<MysqlSetOption>

```cangjie
public enum MysqlOption <: Equatable<MysqlOption>{
    | MYSQL_OPT_CONNECT_TIMEOUT
    | MYSQL_OPT_COMPRESS
    | MYSQL_OPT_NAMED_PIPE
    | MYSQL_INIT_COMMAND
    | MYSQL_READ_DEFAULT_FILE
    | MYSQL_READ_DEFAULT_GROUP
    | MYSQL_SET_CHARSET_DIR
    | MYSQL_SET_CHARSET_NAME
    | MYSQL_OPT_LOCAL_INFILE
    | MYSQL_OPT_PROTOCOL
    | MYSQL_SHARED_MEMORY_BASE_NAME
    | MYSQL_OPT_READ_TIMEOUT
    | MYSQL_OPT_WRITE_TIMEOUT
    | MYSQL_OPT_USE_RESULT
    | MYSQL_REPORT_DATA_TRUNCATION
    | MYSQL_OPT_RECONNECT
    | MYSQL_PLUGIN_DIR
    | MYSQL_DEFAULT_AUTH
    | MYSQL_OPT_BIND
    | MYSQL_OPT_SSL_KEY
    | MYSQL_OPT_SSL_CERT
    | MYSQL_OPT_SSL_CA
    | MYSQL_OPT_SSL_CAPATH
    | MYSQL_OPT_SSL_CIPHER
    | MYSQL_OPT_SSL_CRL
    | MYSQL_OPT_SSL_CRLPATH
    | MYSQL_OPT_CONNECT_ATTR_RESET
    | MYSQL_OPT_CONNECT_ATTR_ADD
    | MYSQL_OPT_CONNECT_ATTR_DELETE
    | MYSQL_SERVER_PUBLIC_KEY
    | MYSQL_ENABLE_CLEARTEXT_PLUGIN
    | MYSQL_OPT_CAN_HANDLE_EXPIRED_PASSWORDS
    | MYSQL_OPT_MAX_ALLOWED_PACKET
    | MYSQL_OPT_NET_BUFFER_LENGTH
    | MYSQL_OPT_TLS_VERSION
    | MYSQL_OPT_SSL_MODE
    | MYSQL_OPT_GET_SERVER_PUBLIC_KEY
    | MYSQL_OPT_RETRY_COUNT
    | MYSQL_OPT_OPTIONAL_RESULTSET_METADATA
    | MYSQL_OPT_SSL_FIPS_MODE
    | MYSQL_OPT_TLS_CIPHERSUITES
    | MYSQL_OPT_COMPRESSION_ALGORITHMS
    | MYSQL_OPT_ZSTD_COMPRESSION_LEVEL
    | MYSQL_OPT_LOAD_DATA_LOCAL_DIR
    | MYSQL_OPT_USER_PASSWORD
    | MYSQL_OPT_SSL_SESSION_DATA

    /*
     * 枚举是否相等
     *
     * 参数 that - 枚举
     * 返回值 Bool - 是否相等
     */
    public operator func ==(that: MysqlOption): Bool

    /*
     * 枚举是否不相等
     *
     * 参数 that - 枚举
     * 返回值 Bool - 是否不相等
     */
    public operator func !=(that: MysqlOption): Bool
}
```

##### public enum MysqlSetOption <: Equatable<MysqlSetOption>

```cangjie
public enum MysqlShutdownLevel <: Equatable<MysqlShutdownLevel>{
    | SHUTDOWN_DEFAULT
    | SHUTDOWN_WAIT_CONNECTIONS
    | SHUTDOWN_WAIT_TRANSACTIONS
    | SHUTDOWN_WAIT_UPDATES
    | SHUTDOWN_WAIT_ALL_BUFFERS
    | SHUTDOWN_WAIT_CRITICAL_BUFFERS
    | KILL_QUERY
    | KILL_CONNECTION

    /*
     * 枚举是否相等
     *
     * 参数 that - 枚举
     * 返回值 Bool - 是否相等
     */
    public operator func ==(that: MysqlShutdownLevel): Bool

    /*
     * 枚举是否不相等
     *
     * 参数 that - 枚举
     * 返回值 Bool - 是否不相等
     */
    public operator func !=(that: MysqlShutdownLevel): Bool
}
```

## 非CDBC接口扩展

### 字符集接口

#### 介绍

字符集相关接口

#### 主要接口

##### public class MysqlCharSetApi

```cangjie
public class MysqlCharSetApi {
    /*
     * 初始化非CDBC接口
     *
     * 参数 mysqlConnection - 连接
     */
    public init(mysqlConnection: MysqlConnection)

    /*
     * 当前连接的默认字符集名称
     *
     * 返回值 String - 默认字符集名称
     */
    public func mysqlCharacterSetName(): String

    /*
     * 设置当前连接默认字符集
     *
     * 参数 charset - 默认字符集
     * 返回值 Int32 - 设置结果
     */
    public func mysqlSetCharacterSet(charset: String): Int32
}
```

### 连接接口

#### 介绍

连接相关接口

#### 主要接口

##### public class MysqlConnectionApi

```cangjie
public class MysqlConnectionApi {
    /*
     * 初始化非CDBC接口
     *
     * 参数 mysqlConnection - 连接
     */
    public init(mysqlConnection: MysqlConnection)

    /*
     * 在打开的连接上更改用户和数据库
     *
     * 参数 user - 用户名
     * 参数 passwd - 密码
     * 参数 db - 数据库名称
     * 返回值 Bool - 打开结果
     */
    public func mysqlChangeUser(user: String, passwd: String, db: String): Bool

    /*
     * 选择数据库
     *
     * 参数 db - 数据库名称
     * 返回值 Int32 - 选择结果
     */
    public func mysqlSelectDb(db: String): Int32

    /*
     * 重置连接以清除会话状态
     *
     * 返回值 Int32 - 结果
     */
    public func mysqlResetConnection(): Int32
}
```

### 信息接口

#### 介绍

信息相关接口

#### 主要接口

##### public class MysqlInfoApi

```cangjie
public class MysqlInfoApi {
    /*
     * 初始化非CDBC接口
     *
     * 参数 mysqlConnection - 连接
     */
    public init(mysqlConnection: MysqlConnection)

    /*
     * 最近调用的 MySQL 函数的错误号
     *
     * 返回值 UInt32 - 错误号
     */
    public func mysqlErrno(): UInt32

    /*
     * 最近调用的 MySQL 函数的错误信息
     *
     * 返回值 String - 错误信息
     */
    public func mysqlError(): String

    /*
     * 最近调用的 MySQL 函数的 SQLSTATE 值
     *
     * 返回值 String - SQLSTATE 值
     */
    public func mysqlSqlstate(): String

    /*
     * 上一个语句的警告计数
     *
     * 返回值 UInt32 - 警告计数
     */
    public func mysqlWarningCount(): UInt32

    /*
     * 有关最近执行的语句的信息
     *
     * 返回值 String - 最近执行的语句的信息
     */
    public func mysqlInfo(): String

    /*
     * 将调试信息写入错误日志
     *
     * 返回值 Int32 - 结果
     */
    public func mysqlDumpDebugInfo(): Int32
}
```

### 匹配列表信息接口

#### 介绍

信息相关接口

#### 主要接口

##### public class MysqlListApi

```cangjie
public class MysqlListApi {
    /*
     * 初始化非CDBC接口
     *
     * 参数 mysqlConnection - 连接
     */
    public init(mysqlConnection: MysqlConnection)

    /*
     * 返回与正则表达式匹配的数据库名称
     *
     * 参数 wild - 正则表达式
     * 返回值 CPointer<Unit> - 数据库名称
     */
    public func mysqlListDbs(wild: String): CPointer<Unit>

    /*
     * 返回与正则表达式匹配的表名
     *
     * 参数 wild - 正则表达式
     * 返回值 CPointer<Unit> - 表名
     */
    public func mysqlListTables(wild: String): CPointer<Unit>

    /*
     * 当前服务器线程列表
     *
     * 返回值 CPointer<Unit> - 服务器线程列表
     */
    public func mysqlListTables(): CPointer<Unit>

    /*
     * 返回与正则表达式匹配的字段名称
     *
     * 参数 table - 表名
     * 参数 wild - 正则表达式
     * 返回值 CPointer<Unit> - 字段名称
     */
    public func mysqlListFields(table: String, wild: String): CPointer<Unit>
}
```

### 直接连接接口

#### 介绍

直连数据库

#### 主要接口

##### public class MysqlRecordApi

```cangjie
public class MysqlRecordApi {
    /*
     * 初始化非CDBC接口
     *
     * 参数 mysqlConnection - 连接
     */
    public init(mysqlConnection: MysqlConnection)

    /*
     * 执行语句
     *
     * 参数 q - sql语句
     * 返回值 Int32 - 返回状态
     */
    public func mysqlQuery(q: String): Int32

    /*
     * 查询语句
     *
     * 参数 q - sql语句
     * 参数 length - sql语句长度
     * 返回值 Int32 - 返回状态
     */
    public func mysqlSendQuery(q: String): Int32

    /*
     * 执行语句
     *
     * 参数 q - sql语句
     * 参数 length - sql语句的字节长度
     * 返回值 Int32 - 返回状态
     */
    public func mysqlRealQuery(q: String): Int32

    /*
     * 检索和存储整个结果集
     *
     * 返回值 CPointer<Unit> - 结果集指针
     */
    public func mysqlStoreResult(): CPointer<Unit>

    /*
     * 结果集中的列数
     *
     * 参数 result - 结果集
     * 返回值 UInt32 - 列数
     */
    public func mysqlNumFields(result: CPointer<Unit>): UInt32

    /*
     * 确定是否已读取结果集的最后一行
     *
     * 参数 result - 结果集
     * 返回值 Bool - 是否是最后一行
     */
    public func mysqlEof(result: CPointer<Unit>): Bool

    /*
     * 结果集中的行数
     *
     * 参数 result - 结果集
     * 返回值 UInt64 - 行数
     */
    public func mysqlNumRows(result: CPointer<Unit>): UInt64

    /*
     * 提取下一个结果集行
     *
     * 参数 result - 结果集
     * 返回值 CPointer<CString> - 下一个结果集行
     */
    public func mysqlFetchRow(result: CPointer<Unit>): CPointer<CString>

    /*
     * 上次更新、删除或插入语句更改/删除/插入的行数
     *
     * 返回值 UInt64 - 行数
     */
    public func mysqlAffectedRows(): UInt64

    /*
     * 释放结果集内存
     *
     * 参数 result - 结果集
     */
    public func mysqlFreeResult(result: CPointer<Unit>): Unit

    /*
     * 为列生成的 ID 以前的声明AUTO_INCREMENT
     *
     * 返回值 UInt64 - 生成的插入id
     */
    public func mysqlInsertId(): UInt64
}
```

### 服务接口

#### 介绍

服务相关接口

#### 主要接口

##### public class MysqlServerApi

```cangjie
public class MysqlServerApi {
    /*
     * 初始化非CDBC接口
     *
     * 参数 mysqlConnection - 连接
     */
    public init(mysqlConnection: MysqlConnection) 

    /*
     * 初始化 MySQL C API 库
     *
     * 参数 argc - 参数个数
     * 参数 argv - 参数
     * 参数 groups - 要读取的配置文件组名数组
     * 返回值 Int32 - 返回状态
     */
    public func mysqlServerInit(argc: Int32, argv: CPointer<CString>, groups: CPointer<CString>): Int32

    /*
     * 完成 MySQL C API 库
     */
    public func mysqlServerEnd(): Unit

    /*
     * 关闭 MySQL 服务器
     *
     * 参数 shutdownLevel - 关闭方式
     * 返回值 Int32 - 返回状态
     */
    public func mysqlShutdown(shutdownLevel: MysqlShutdownLevel): Int32

    /*
     * 刷新或重置表和缓存
     *
     * 参数 refreshOptions - 刷新选项
     * 返回值 Int32 - 返回状态
     */
    public func mysqlRefresh(refreshOptions: UInt32): Int32

    /*
     * 终止线程
     *
     * 参数 pid - 线程id
     * 返回值 Int32 - 返回状态
     */
    public func mysqlKill(pid: UInt64): Int32
}
```

### ssl接口

#### 介绍

ssl相关

#### 主要接口

##### public class MysqlSslApi

```cangjie
public class MysqlSslApi {
    /*
     * 初始化非CDBC接口
     *
     * 参数 mysqlConnection - 连接
     */
    public init(mysqlConnection: MysqlConnection)

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
    public func mysqlSslSet(keyString: String, cert: String, ca: String, capath: String, cipher: String): Bool

    /*
     * 当前 SSL 密码
     *
     * 返回值 String - 命名用于连接的加密密码的字符串
     */
    public func mysqlGetSslCipher(): String

    /*
     * 会话是否重复使用
     *
     * 返回值 Bool - 会话是否重复使用
     */
    public func mysqlGetSslSessionReused(): Bool

    /*
     * 返回启用 SSL 的连接的会话数据
     *
     * 参数 nTicket - nTicket
     * 参数 outLen - outLen
     */
    public func mysqlGetSslSessionData(nTicket: UInt32, outLen: CPointer<UInt32>): Unit

    /*
     * 释放上次 mysql_get_ssl_session_data（） 调用的会话数据句柄
     *
     * 参数 data - 释放的数据
     * 返回值 Bool - 成功或失败
     */
    public func mysqlFreeSslSessionData(data: CPointer<Unit>): Bool
}
```

### mysql预连接接口

#### 介绍

mysql预连接相关接口

#### 主要接口

##### public class MysqlStmtApi

```cangjie
public class MysqlStmtApi {    
    /*
     * 初始化非CDBC接口
     *
     * 参数 mysqlStatement - 预执行
     */
    public init(mysqlStatement: MysqlStatement)

    /*
     * 最近调用的MySQL准备语句的错误消息功能
     *
     * 返回值 String - 错误消息
     */
    public func mysqlStmtError(): String

    /*
     * 在服务器端重置语句缓冲区
     *
     * 返回值 Bool - 成功或失败
     */
    public func mysqlStmtReset(): Bool

    /*
     * 释放分配给语句处理程序的资源
     *
     * 返回值 Bool - 成功或失败
     */
    public func mysqlStmtFreeResult(): Bool

    /*
     * 检索和存储整个结果集
     *
     * 返回值 Int32 - 成功的个数
     */
    public func mysqlStmtStoreResult(): Int32

    /*
     * 最近调用的 MySQL 准备语句的错误号
     *
     * 返回值 UInt32 - 错误号
     */
    public func mysqlStmtErrno(): UInt32

    /*
     * 最近调用的 MySQL 准备语句的 SQLSTATE值功能
     *
     * 返回值 String - 包含 SQLSTATE 的以 null 结尾的字符串 错误代码
     */
    public func mysqlStmtSqlstate(): String

    /*
     * 缓冲语句结果集中的行计数
     *
     * 返回值 UInt64 - 行计数
     */
    public func mysqlStmtNumRows(): UInt64

    /*
     * 插入列生成的ID号
     *
     * 返回值 UInt64 - ID号
     */
    public func mysqlStmtInsertId(): UInt64
}
```

### mysql线程接口

#### 介绍

mysql线程相关接口

#### 主要接口

##### public class MysqlthreadApi

```cangjie
public class MysqlthreadApi {
    /*
     * 初始化非CDBC接口
     *
     * 参数 mysqlConnection - 连接
     */
    public init(mysqlConnection: MysqlConnection)

    /*
     * 当前线程 ID
     *
     * 返回值 UInt64 - 线程 ID
     */
    public func mysqlThreadId(): UInt64

    /*
     * 初始化线程处理程序
     *
     * 返回值 Bool - 是否成功
     */
    public func mysqlThreadInit(): Bool

    /*
     * 	完成线程处理程序
     */
    public func mysqlThreadEnd(): Unit
}
```

#### 示例

#### public class MysqlCharSetApi

```cangjie
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*

main():Int64{
    // 初始化数据库驱动
    let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

    // 通过connectionString和选项打开数据源
    let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
        "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
            rray<(String, String)>()
    )

    // 返回一个可用的链接
    let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

    let mysqlCharSetApi: MysqlCharSetApi = MysqlCharSetApi(mysqlConnection)
    @Assert("utf8mb4", mysqlCharSetApi.mysqlCharacterSetName())

    var ret: Int32 = mysqlCharSetApi.mysqlSetCharacterSet("utf8")
    @Assert(true, ret == 0)
    @Assert("utf8mb3", mysqlCharSetApi.mysqlCharacterSetName())

    ret = mysqlCharSetApi.mysqlSetCharacterSet("ascii")
    @Assert(true, ret == 0)
    @Assert("ascii", mysqlCharSetApi.mysqlCharacterSetName())

    ret = mysqlCharSetApi.mysqlSetCharacterSet("gbk")
    @Assert(true, ret == 0)
    @Assert("gbk", mysqlCharSetApi.mysqlCharacterSetName())

    ret = mysqlCharSetApi.mysqlSetCharacterSet("utf8mb4")
    @Assert(true, ret == 0)
    @Assert("utf8mb4", mysqlCharSetApi.mysqlCharacterSetName())

    mysqlConnection.close()
}
```

#### public class MysqlConnectionApi

```cangjie
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*

main():Int64{
    // 初始化数据库驱动
    let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

    // 通过connectionString和选项打开数据源
    let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
        "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
        Array<(String, String)>()
    )

    // 返回一个可用的链接
    let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

    let mysqlConnectionApi: MysqlConnectionApi = MysqlConnectionApi(mysqlConnection)
    let ret: Int32 = mysqlConnectionApi.mysqlSelectDb("mysql")
    @Assert(0, ret)

    mysqlConnection.close()
}
```

#### public class MysqlInfoApi

```cangjie
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*

main():Int64{ 
    // 初始化数据库驱动
    let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

    // 通过connectionString和选项打开数据源
    let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
        "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
        Array<(String, String)>()
    )

    // 返回一个可用的链接
    let mysqlConnection: MysqlConnection = mysqlDatasource.connect()
    let mysqlInfoApi: MysqlInfoApi = MysqlInfoApi(mysqlConnection)
    let retErrno: UInt32 = mysqlInfoApi.mysqlErrno()
    @Assert(0, retErrno)
    let strError: String = mysqlInfoApi.mysqlError()
    @Assert("", strError)
    let strState: String = mysqlInfoApi.mysqlSqlstate()
    @Assert("00000", strState)
    let retCount: UInt32 = mysqlInfoApi.mysqlWarningCount()
    @Assert(0, retCount)
    let strInfo: String = mysqlInfoApi.mysqlInfo()
    @Assert("", strInfo)
    let retInfo: Int32 = mysqlInfoApi.mysqlDumpDebugInfo()
    @Assert(0, retInfo)

    mysqlConnection.close()
}
```

#### public class MysqlListApi

```cangjie
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*

main():Int64{
    // 初始化数据库驱动
    let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

    // 通过connectionString和选项打开数据源
    let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
        "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
        Array<(String, String)>()
    )

    // 返回一个可用的链接
    let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

    let mysqlListApi: MysqlListApi = MysqlListApi(mysqlConnection)
    let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)
    let cp1: CPointer<Unit> = mysqlListApi.mysqlListDbs("information_schema")
    let retFields: UInt32 = mysqlRecordApi.mysqlNumFields(cp1)
    @Assert(1, retFields)
    let retEof: Bool = mysqlRecordApi.mysqlEof(cp1)
    @Assert(true, retEof)
    let retRows: UInt64 = mysqlRecordApi.mysqlNumRows(cp1)
    @Assert(1, retRows)
    unsafe {
        for (i in 0..retRows) {
            var cpCString: CPointer<CString> = mysqlRecordApi.mysqlFetchRow(cp1)
            for (j in 0..retFields) {
                var cString: CString = cpCString.read(Int64(j))
                if (i == 0) {
                    @Assert("information_schema", cString.toString())
                }
            }
        }
    }
    mysqlRecordApi.mysqlFreeResult(cp1)

    mysqlConnection.close()
}
```

#### public class MysqlRecordApi

```cangjie
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*

main():Int64{
    // 初始化数据库驱动
    let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

    // 通过connectionString和选项打开数据源
    let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
        "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
        Array<(String, String)>()
    )

    // 返回一个可用的链接
    let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

    let mysqlRecordApi: MysqlRecordApi = MysqlRecordApi(mysqlConnection)

    let retInt32: Int32 = mysqlRecordApi.mysqlQuery("")
    @Assert(1, retInt32)

    // 关闭链接
    mysqlConnection.close()
}
```

#### public class MysqlServerApi

```cangjie
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*

main():Int64{
    // 初始化数据库驱动
    let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

    // 通过connectionString和选项打开数据源
    let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
        "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
        Array<(String, String)>()
    )

    // 返回一个可用的链接
    let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

    let mysqlServerApi: MysqlServerApi = MysqlServerApi(mysqlConnection)

    var cpCtringArgv: CPointer<CString> = CPointer<CString>()
    var cpCtringGroups: CPointer<CString> = CPointer<CString>()

    var ret: Int32 = mysqlServerApi.mysqlServerInit(10, cpCtringArgv, cpCtringGroups)
    @Assert(0, ret)

    mysqlServerApi.mysqlServerEnd()

    ret = mysqlServerApi.mysqlRefresh(0)
    @Assert(0, ret)

    ret = mysqlServerApi.mysqlKill(0)
    @Assert(1, ret)

    mysqlConnection.close()
}
```

#### public class MysqlSslApi

```cangjie
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*

main():Int64{
    // 初始化数据库驱动
    let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

    // 通过connectionString和选项打开数据源
    let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
        "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
        Array<(String, String)>()
    )

    // 返回一个可用的链接
    let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

    let mysqlSslApi: MysqlSslApi = MysqlSslApi(mysqlConnection)

    var isBool: Bool = mysqlSslApi.mysqlSslSet("", "", "", "", "")
    @Assert(false, isBool)

    var strCipher: String = mysqlSslApi.mysqlGetSslCipher()
    @Assert("", strCipher)

    isBool = mysqlSslApi.mysqlGetSslSessionReused()
    @Assert(false, isBool)

    mysqlSslApi.mysqlGetSslSessionData(0, CPointer<UInt32>())

    isBool = mysqlSslApi.mysqlFreeSslSessionData(CPointer<Unit>())
    @Assert(true, isBool)

    mysqlConnection.close()
}
```

#### public class MysqlStmtApi

```cangjie
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*

main():Int64{
    // 初始化数据库驱动
    let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

    // 通过connectionString和选项打开数据源
    let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
        "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
        Array<(String, String)>()
    )

    // 返回一个可用的链接
    let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

    // 删除t_test2名称数据表
    var mysqlStatement1: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_bigint")
    mysqlStatement1.update()

    // 创建t_test2名称数据表
    var mysqlStatement2: MysqlStatement = mysqlConnection.prepareStatement(
        "create table t_test_bigint(id bigint not null, value1 bigint not null, value2 bigint)"
    )
    mysqlStatement2.update()

    // 通过传入的 sql 语句，返回一个预执行的 Statement 对象实例
    var mysqlStatement3: MysqlStatement = mysqlConnection.prepareStatement(
        "insert into  t_test_bigint(id,value1,value2)  VALUES(1,2,3)"
    )
    mysqlStatement3.update()

    let mysqlStmtApi: MysqlStmtApi = MysqlStmtApi(mysqlStatement3)

    var retBool: Bool = mysqlStmtApi.mysqlStmtReset()
    @Assert(false, retBool)

    var retStr: String = mysqlStmtApi.mysqlStmtError()
    @Assert("", retStr)

    var retUInt32: UInt32 = mysqlStmtApi.mysqlStmtErrno()
    @Assert(0, retUInt32)

    retStr = mysqlStmtApi.mysqlStmtSqlstate()
    @Assert("00000", retStr)

    var retUInt64: UInt64 = mysqlStmtApi.mysqlStmtNumRows()
    @Assert(0, retUInt64)

    retUInt64 = mysqlStmtApi.mysqlStmtInsertId()
    @Assert(0, retUInt64)

    var mysqlStatement9: MysqlStatement = mysqlConnection.prepareStatement("drop table if exists t_test_bigint")
    mysqlStatement9.update()

    mysqlConnection.close()
}
```

#### public class MysqlthreadApi

```cangjie
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*

main():Int64{
    // 初始化数据库驱动
    let mysqlDriver: MysqlDriver = MysqlDriver("mysql")

    // 通过connectionString和选项打开数据源
    let mysqlDatasource: MysqlDatasource = mysqlDriver.open(
        "HOST=127.0.0.1;USER=root;PASSWD=123;DB=mysql;PORT=3306;UNIX_SOCKET=;CLIENT_FLAG=0",
        Array<(String, String)>()
    )

    // 返回一个可用的链接
    let mysqlConnection: MysqlConnection = mysqlDatasource.connect()

    let mysqlthreadApi: MysqlthreadApi = MysqlthreadApi(mysqlConnection)

    let ret1 = mysqlthreadApi.mysqlThreadId()
    mysqlthreadApi.mysqlThreadEnd()

    let retBool = mysqlthreadApi.mysqlThreadInit()
    let ret2 = mysqlthreadApi.mysqlThreadId()

    @Assert(ret1, ret2)
    @Assert(false, retBool)

    mysqlConnection.close()
}
```

