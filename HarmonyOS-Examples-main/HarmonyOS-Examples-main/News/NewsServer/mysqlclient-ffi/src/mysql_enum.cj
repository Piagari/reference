/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package mysqlclient_ffi

/*--------------------- C中枚举 enum enum_stmt_attr_type ---------------------*/
public enum MysqlStmtAttrType <: Equatable<MysqlStmtAttrType> {
    | STMT_ATTR_UPDATE_MAX_LENGTH
    | STMT_ATTR_CURSOR_TYPE
    | STMT_ATTR_PREFETCH_ROWS

    func toInt32(): Int32 {
        if (this == STMT_ATTR_UPDATE_MAX_LENGTH) {
            return 0
        }
        if (this == STMT_ATTR_CURSOR_TYPE) {
            return 1
        }
        if (this == STMT_ATTR_CURSOR_TYPE) {
            return 2
        }
        return -1
    }

    /*
     * 枚举是否相等
     *
     * 参数 that - 枚举
     * 返回值 Bool - 是否相等
     */
    public operator func ==(that: MysqlStmtAttrType): Bool {
        match ((this, that)) {
            case (STMT_ATTR_UPDATE_MAX_LENGTH, STMT_ATTR_UPDATE_MAX_LENGTH) => true
            case (STMT_ATTR_CURSOR_TYPE, STMT_ATTR_CURSOR_TYPE) => true
            case (STMT_ATTR_PREFETCH_ROWS, STMT_ATTR_PREFETCH_ROWS) => true
            case _ => false
        }
    }

    /*
     * 枚举是否不相等
     *
     * 参数 that - 枚举
     * 返回值 Bool - 是否不相等
     */
    public operator func !=(that: MysqlStmtAttrType): Bool {
        return !(this == that)
    }
}

/*--------------------- C中枚举 enum enum_mysql_set_option ---------------------*/
public enum MysqlSetOption <: Equatable<MysqlSetOption> {
    | MYSQL_OPTION_MULTI_STATEMENTS_ON
    | MYSQL_OPTION_MULTI_STATEMENTS_OFF

    func toInt32(): Int32 {
        if (this == MYSQL_OPTION_MULTI_STATEMENTS_ON) {
            return 0
        }
        if (this == MYSQL_OPTION_MULTI_STATEMENTS_OFF) {
            return 1
        }
        return -1
    }

    /*
     * 枚举是否相等
     *
     * 参数 that - 枚举
     * 返回值 Bool - 是否相等
     */
    public operator func ==(that: MysqlSetOption): Bool {
        match ((this, that)) {
            case (MYSQL_OPTION_MULTI_STATEMENTS_ON, MYSQL_OPTION_MULTI_STATEMENTS_ON) => true
            case (MYSQL_OPTION_MULTI_STATEMENTS_OFF, MYSQL_OPTION_MULTI_STATEMENTS_OFF) => true
            case _ => false
        }
    }

    /*
     * 枚举是否不相等
     *
     * 参数 that - 枚举
     * 返回值 Bool - 是否不相等
     */
    public operator func !=(that: MysqlSetOption): Bool {
        return !(this == that)
    }
}

/*--------------------- C中枚举 enum mysql_option ---------------------*/
public enum MysqlOption <: Equatable<MysqlOption> {
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

    func toInt32(): Int32 {
        if (this == MYSQL_OPT_CONNECT_TIMEOUT) {
            return 0
        }
        if (this == MYSQL_OPT_COMPRESS) {
            return 1
        }
        if (this == MYSQL_OPT_NAMED_PIPE) {
            return 2
        }
        if (this == MYSQL_INIT_COMMAND) {
            return 3
        }
        if (this == MYSQL_READ_DEFAULT_FILE) {
            return 4
        }
        if (this == MYSQL_READ_DEFAULT_GROUP) {
            return 5
        }
        if (this == MYSQL_SET_CHARSET_DIR) {
            return 6
        }
        if (this == MYSQL_SET_CHARSET_NAME) {
            return 7
        }
        if (this == MYSQL_OPT_LOCAL_INFILE) {
            return 8
        }
        if (this == MYSQL_OPT_PROTOCOL) {
            return 9
        }
        if (this == MYSQL_SHARED_MEMORY_BASE_NAME) {
            return 10
        }
        if (this == MYSQL_OPT_READ_TIMEOUT) {
            return 11
        }
        if (this == MYSQL_OPT_WRITE_TIMEOUT) {
            return 12
        }
        if (this == MYSQL_OPT_USE_RESULT) {
            return 13
        }
        if (this == MYSQL_REPORT_DATA_TRUNCATION) {
            return 14
        }
        if (this == MYSQL_OPT_RECONNECT) {
            return 15
        }
        if (this == MYSQL_PLUGIN_DIR) {
            return 16
        }
        if (this == MYSQL_DEFAULT_AUTH) {
            return 17
        }
        if (this == MYSQL_OPT_BIND) {
            return 18
        }
        if (this == MYSQL_OPT_SSL_KEY) {
            return 19
        }
        if (this == MYSQL_OPT_SSL_CERT) {
            return 20
        }
        if (this == MYSQL_OPT_SSL_CA) {
            return 21
        }
        if (this == MYSQL_OPT_SSL_CAPATH) {
            return 22
        }
        if (this == MYSQL_OPT_SSL_CIPHER) {
            return 23
        }
        if (this == MYSQL_OPT_SSL_CRL) {
            return 24
        }
        if (this == MYSQL_OPT_SSL_CRLPATH) {
            return 25
        }
        if (this == MYSQL_OPT_CONNECT_ATTR_RESET) {
            return 26
        }
        if (this == MYSQL_OPT_CONNECT_ATTR_ADD) {
            return 27
        }
        if (this == MYSQL_OPT_CONNECT_ATTR_DELETE) {
            return 28
        }
        if (this == MYSQL_SERVER_PUBLIC_KEY) {
            return 29
        }
        if (this == MYSQL_ENABLE_CLEARTEXT_PLUGIN) {
            return 30
        }
        if (this == MYSQL_OPT_CAN_HANDLE_EXPIRED_PASSWORDS) {
            return 31
        }
        if (this == MYSQL_OPT_MAX_ALLOWED_PACKET) {
            return 32
        }
        if (this == MYSQL_OPT_NET_BUFFER_LENGTH) {
            return 33
        }
        if (this == MYSQL_OPT_TLS_VERSION) {
            return 34
        }
        if (this == MYSQL_OPT_SSL_MODE) {
            return 35
        }
        if (this == MYSQL_OPT_GET_SERVER_PUBLIC_KEY) {
            return 36
        }
        if (this == MYSQL_OPT_RETRY_COUNT) {
            return 37
        }
        if (this == MYSQL_OPT_OPTIONAL_RESULTSET_METADATA) {
            return 38
        }
        if (this == MYSQL_OPT_SSL_FIPS_MODE) {
            return 39
        }
        if (this == MYSQL_OPT_TLS_CIPHERSUITES) {
            return 40
        }
        if (this == MYSQL_OPT_COMPRESSION_ALGORITHMS) {
            return 41
        }
        if (this == MYSQL_OPT_ZSTD_COMPRESSION_LEVEL) {
            return 42
        }
        if (this == MYSQL_OPT_LOAD_DATA_LOCAL_DIR) {
            return 43
        }
        if (this == MYSQL_OPT_USER_PASSWORD) {
            return 44
        }
        if (this == MYSQL_OPT_SSL_SESSION_DATA) {
            return 45
        }
        return -1
    }

    /*
     * 枚举是否相等
     *
     * 参数 that - 枚举
     * 返回值 Bool - 是否相等
     */
    public operator func ==(that: MysqlOption): Bool {
        match ((this, that)) {
            case (MYSQL_OPT_CONNECT_TIMEOUT, MYSQL_OPT_CONNECT_TIMEOUT) => true
            case (MYSQL_OPT_COMPRESS, MYSQL_OPT_COMPRESS) => true
            case (MYSQL_OPT_NAMED_PIPE, MYSQL_OPT_NAMED_PIPE) => true
            case (MYSQL_INIT_COMMAND, MYSQL_INIT_COMMAND) => true
            case (MYSQL_READ_DEFAULT_FILE, MYSQL_READ_DEFAULT_FILE) => true
            case (MYSQL_READ_DEFAULT_GROUP, MYSQL_READ_DEFAULT_GROUP) => true
            case (MYSQL_SET_CHARSET_DIR, MYSQL_SET_CHARSET_DIR) => true
            case (MYSQL_SET_CHARSET_NAME, MYSQL_SET_CHARSET_NAME) => true
            case (MYSQL_OPT_LOCAL_INFILE, MYSQL_OPT_LOCAL_INFILE) => true
            case (MYSQL_OPT_PROTOCOL, MYSQL_OPT_PROTOCOL) => true
            case (MYSQL_SHARED_MEMORY_BASE_NAME, MYSQL_SHARED_MEMORY_BASE_NAME) => true
            case (MYSQL_OPT_READ_TIMEOUT, MYSQL_OPT_READ_TIMEOUT) => true
            case (MYSQL_OPT_WRITE_TIMEOUT, MYSQL_OPT_WRITE_TIMEOUT) => true
            case (MYSQL_OPT_USE_RESULT, MYSQL_OPT_USE_RESULT) => true
            case (MYSQL_REPORT_DATA_TRUNCATION, MYSQL_REPORT_DATA_TRUNCATION) => true
            case (MYSQL_OPT_RECONNECT, MYSQL_OPT_RECONNECT) => true
            case (MYSQL_PLUGIN_DIR, MYSQL_PLUGIN_DIR) => true
            case (MYSQL_DEFAULT_AUTH, MYSQL_DEFAULT_AUTH) => true
            case (MYSQL_OPT_BIND, MYSQL_OPT_BIND) => true
            case (MYSQL_OPT_SSL_KEY, MYSQL_OPT_SSL_KEY) => true
            case (MYSQL_OPT_SSL_CERT, MYSQL_OPT_SSL_CERT) => true
            case (MYSQL_OPT_SSL_CA, MYSQL_OPT_SSL_CA) => true
            case (MYSQL_OPT_SSL_CAPATH, MYSQL_OPT_SSL_CAPATH) => true
            case (MYSQL_OPT_SSL_CIPHER, MYSQL_OPT_SSL_CIPHER) => true
            case (MYSQL_OPT_SSL_CRL, MYSQL_OPT_SSL_CRL) => true
            case (MYSQL_OPT_SSL_CRLPATH, MYSQL_OPT_SSL_CRLPATH) => true
            case (MYSQL_OPT_CONNECT_ATTR_RESET, MYSQL_OPT_CONNECT_ATTR_RESET) => true
            case (MYSQL_OPT_CONNECT_ATTR_ADD, MYSQL_OPT_CONNECT_ATTR_ADD) => true
            case (MYSQL_OPT_CONNECT_ATTR_DELETE, MYSQL_OPT_CONNECT_ATTR_DELETE) => true
            case (MYSQL_SERVER_PUBLIC_KEY, MYSQL_SERVER_PUBLIC_KEY) => true
            case (MYSQL_ENABLE_CLEARTEXT_PLUGIN, MYSQL_ENABLE_CLEARTEXT_PLUGIN) => true
            case (MYSQL_OPT_CAN_HANDLE_EXPIRED_PASSWORDS, MYSQL_OPT_CAN_HANDLE_EXPIRED_PASSWORDS) => true
            case (MYSQL_OPT_MAX_ALLOWED_PACKET, MYSQL_OPT_MAX_ALLOWED_PACKET) => true
            case (MYSQL_OPT_NET_BUFFER_LENGTH, MYSQL_OPT_NET_BUFFER_LENGTH) => true
            case (MYSQL_OPT_TLS_VERSION, MYSQL_OPT_TLS_VERSION) => true
            case (MYSQL_OPT_SSL_MODE, MYSQL_OPT_SSL_MODE) => true
            case (MYSQL_OPT_GET_SERVER_PUBLIC_KEY, MYSQL_OPT_GET_SERVER_PUBLIC_KEY) => true
            case (MYSQL_OPT_RETRY_COUNT, MYSQL_OPT_RETRY_COUNT) => true
            case (MYSQL_OPT_OPTIONAL_RESULTSET_METADATA, MYSQL_OPT_OPTIONAL_RESULTSET_METADATA) => true
            case (MYSQL_OPT_SSL_FIPS_MODE, MYSQL_OPT_SSL_FIPS_MODE) => true
            case (MYSQL_OPT_TLS_CIPHERSUITES, MYSQL_OPT_TLS_CIPHERSUITES) => true
            case (MYSQL_OPT_COMPRESSION_ALGORITHMS, MYSQL_OPT_COMPRESSION_ALGORITHMS) => true
            case (MYSQL_OPT_ZSTD_COMPRESSION_LEVEL, MYSQL_OPT_ZSTD_COMPRESSION_LEVEL) => true
            case (MYSQL_OPT_LOAD_DATA_LOCAL_DIR, MYSQL_OPT_LOAD_DATA_LOCAL_DIR) => true
            case (MYSQL_OPT_USER_PASSWORD, MYSQL_OPT_USER_PASSWORD) => true
            case (MYSQL_OPT_SSL_SESSION_DATA, MYSQL_OPT_SSL_SESSION_DATA) => true
            case _ => false
        }
    }

    /*
     * 枚举是否不相等
     *
     * 参数 that - 枚举
     * 返回值 Bool - 是否不相等
     */
    public operator func !=(that: MysqlOption): Bool {
        return !(this == that)
    }
}

/*--------------------- C中枚举 enum mysql_enum_shutdown_level ---------------------*/
public enum MysqlShutdownLevel <: Equatable<MysqlShutdownLevel> {
    | SHUTDOWN_DEFAULT
    | SHUTDOWN_WAIT_CONNECTIONS
    | SHUTDOWN_WAIT_TRANSACTIONS
    | SHUTDOWN_WAIT_UPDATES
    | SHUTDOWN_WAIT_ALL_BUFFERS
    | SHUTDOWN_WAIT_CRITICAL_BUFFERS
    | KILL_QUERY
    | KILL_CONNECTION

    func toInt32(): Int32 {
        if (this == SHUTDOWN_DEFAULT) {
            return 0
        }
        if (this == SHUTDOWN_WAIT_CONNECTIONS) {
            return 1
        }
        if (this == SHUTDOWN_WAIT_TRANSACTIONS) {
            return 2
        }
        if (this == SHUTDOWN_WAIT_UPDATES) {
            return 8
        }
        if (this == SHUTDOWN_WAIT_ALL_BUFFERS) {
            return 16
        }
        if (this == SHUTDOWN_WAIT_CRITICAL_BUFFERS) {
            return 17
        }
        if (this == KILL_QUERY) {
            return 254
        }
        if (this == KILL_CONNECTION) {
            return 255
        }
        return -1
    }

    /*
     * 枚举是否相等
     *
     * 参数 that - 枚举
     * 返回值 Bool - 是否相等
     */
    public operator func ==(that: MysqlShutdownLevel): Bool {
        match ((this, that)) {
            case (SHUTDOWN_DEFAULT, SHUTDOWN_DEFAULT) => true
            case (SHUTDOWN_WAIT_CONNECTIONS, SHUTDOWN_WAIT_CONNECTIONS) => true
            case (SHUTDOWN_WAIT_TRANSACTIONS, SHUTDOWN_WAIT_TRANSACTIONS) => true
            case (SHUTDOWN_WAIT_UPDATES, SHUTDOWN_WAIT_UPDATES) => true
            case (SHUTDOWN_WAIT_ALL_BUFFERS, SHUTDOWN_WAIT_ALL_BUFFERS) => true
            case (SHUTDOWN_WAIT_CRITICAL_BUFFERS, SHUTDOWN_WAIT_CRITICAL_BUFFERS) => true
            case (KILL_QUERY, KILL_QUERY) => true
            case (KILL_CONNECTION, KILL_CONNECTION) => true
            case _ => false
        }
    }

    /*
     * 枚举是否不相等
     *
     * 参数 that - 枚举
     * 返回值 Bool - 是否不相等
     */
    public operator func !=(that: MysqlShutdownLevel): Bool {
        return !(this == that)
    }
}
