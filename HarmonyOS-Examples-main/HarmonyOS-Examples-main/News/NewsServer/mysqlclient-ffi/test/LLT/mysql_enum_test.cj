// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import mysqlclient_ffi.*
import std.unittest.*
import std.unittest.testmacro.*
import std.database.sql.*
import std.time.*

main(): Int64 {
    let mysqlEnumTest: MysqlEnumTest = MysqlEnumTest()

    mysqlEnumTest.mysqlEnumTest01()
    mysqlEnumTest.mysqlEnumTest02()
    mysqlEnumTest.mysqlEnumTest03()
    mysqlEnumTest.mysqlEnumTest04()

    return 0
}

@Test
public class MysqlEnumTest {
    @TestCase
    public func mysqlEnumTest01(): Unit {
        let mysqlStmtAttrType1: MysqlStmtAttrType = MysqlStmtAttrType.STMT_ATTR_UPDATE_MAX_LENGTH
        let mysqlStmtAttrType2: MysqlStmtAttrType = MysqlStmtAttrType.STMT_ATTR_CURSOR_TYPE
        let mysqlStmtAttrType3: MysqlStmtAttrType = MysqlStmtAttrType.STMT_ATTR_PREFETCH_ROWS
        @Assert(true, mysqlStmtAttrType1 == mysqlStmtAttrType1)
        @Assert(true, mysqlStmtAttrType2 == mysqlStmtAttrType2)
        @Assert(true, mysqlStmtAttrType3 == mysqlStmtAttrType3)
        @Assert(true, mysqlStmtAttrType1 != mysqlStmtAttrType3)
        @Assert(true, mysqlStmtAttrType2 != mysqlStmtAttrType3)
    }

    @TestCase
    public func mysqlEnumTest02(): Unit {
        let mysqlSetOption1: MysqlSetOption = MysqlSetOption.MYSQL_OPTION_MULTI_STATEMENTS_ON
        let mysqlSetOption2: MysqlSetOption = MysqlSetOption.MYSQL_OPTION_MULTI_STATEMENTS_OFF
        @Assert(true, mysqlSetOption1 == mysqlSetOption1)
        @Assert(true, mysqlSetOption2 == mysqlSetOption2)
        @Assert(true, mysqlSetOption1 != mysqlSetOption2)
    }

    @TestCase
    public func mysqlEnumTest03(): Unit {
        let mysqlOption1: MysqlOption = MysqlOption.MYSQL_OPT_CONNECT_TIMEOUT
        let mysqlOption2: MysqlOption = MysqlOption.MYSQL_OPT_COMPRESS
        let mysqlOption3: MysqlOption = MysqlOption.MYSQL_OPT_NAMED_PIPE
        let mysqlOption4: MysqlOption = MysqlOption.MYSQL_INIT_COMMAND
        let mysqlOption5: MysqlOption = MysqlOption.MYSQL_READ_DEFAULT_FILE
        let mysqlOption6: MysqlOption = MysqlOption.MYSQL_READ_DEFAULT_GROUP
        let mysqlOption7: MysqlOption = MysqlOption.MYSQL_SET_CHARSET_DIR
        let mysqlOption8: MysqlOption = MysqlOption.MYSQL_SET_CHARSET_NAME
        let mysqlOption9: MysqlOption = MysqlOption.MYSQL_OPT_LOCAL_INFILE
        let mysqlOption10: MysqlOption = MysqlOption.MYSQL_OPT_PROTOCOL
        let mysqlOption11: MysqlOption = MysqlOption.MYSQL_SHARED_MEMORY_BASE_NAME
        let mysqlOption12: MysqlOption = MysqlOption.MYSQL_OPT_READ_TIMEOUT
        let mysqlOption13: MysqlOption = MysqlOption.MYSQL_OPT_WRITE_TIMEOUT
        let mysqlOption14: MysqlOption = MysqlOption.MYSQL_OPT_USE_RESULT
        let mysqlOption15: MysqlOption = MysqlOption.MYSQL_REPORT_DATA_TRUNCATION
        let mysqlOption16: MysqlOption = MysqlOption.MYSQL_OPT_RECONNECT
        let mysqlOption17: MysqlOption = MysqlOption.MYSQL_PLUGIN_DIR
        let mysqlOption18: MysqlOption = MysqlOption.MYSQL_DEFAULT_AUTH
        let mysqlOption19: MysqlOption = MysqlOption.MYSQL_OPT_BIND
        let mysqlOption20: MysqlOption = MysqlOption.MYSQL_OPT_SSL_KEY
        let mysqlOption21: MysqlOption = MysqlOption.MYSQL_OPT_SSL_CERT
        let mysqlOption22: MysqlOption = MysqlOption.MYSQL_OPT_SSL_CA
        let mysqlOption23: MysqlOption = MysqlOption.MYSQL_OPT_SSL_CAPATH
        let mysqlOption24: MysqlOption = MysqlOption.MYSQL_OPT_SSL_CIPHER
        let mysqlOption25: MysqlOption = MysqlOption.MYSQL_OPT_SSL_CRL
        let mysqlOption26: MysqlOption = MysqlOption.MYSQL_OPT_SSL_CRLPATH
        let mysqlOption27: MysqlOption = MysqlOption.MYSQL_OPT_CONNECT_ATTR_RESET
        let mysqlOption28: MysqlOption = MysqlOption.MYSQL_OPT_CONNECT_ATTR_ADD
        let mysqlOption29: MysqlOption = MysqlOption.MYSQL_OPT_CONNECT_ATTR_DELETE
        let mysqlOption30: MysqlOption = MysqlOption.MYSQL_SERVER_PUBLIC_KEY
        let mysqlOption31: MysqlOption = MysqlOption.MYSQL_ENABLE_CLEARTEXT_PLUGIN
        let mysqlOption32: MysqlOption = MysqlOption.MYSQL_OPT_CAN_HANDLE_EXPIRED_PASSWORDS
        let mysqlOption33: MysqlOption = MysqlOption.MYSQL_OPT_MAX_ALLOWED_PACKET
        let mysqlOption34: MysqlOption = MysqlOption.MYSQL_OPT_NET_BUFFER_LENGTH
        let mysqlOption35: MysqlOption = MysqlOption.MYSQL_OPT_TLS_VERSION
        let mysqlOption36: MysqlOption = MysqlOption.MYSQL_OPT_SSL_MODE
        let mysqlOption37: MysqlOption = MysqlOption.MYSQL_OPT_GET_SERVER_PUBLIC_KEY
        let mysqlOption38: MysqlOption = MysqlOption.MYSQL_OPT_RETRY_COUNT
        let mysqlOption39: MysqlOption = MysqlOption.MYSQL_OPT_OPTIONAL_RESULTSET_METADATA
        let mysqlOption40: MysqlOption = MysqlOption.MYSQL_OPT_SSL_FIPS_MODE
        let mysqlOption41: MysqlOption = MysqlOption.MYSQL_OPT_TLS_CIPHERSUITES
        let mysqlOption42: MysqlOption = MysqlOption.MYSQL_OPT_COMPRESSION_ALGORITHMS
        let mysqlOption43: MysqlOption = MysqlOption.MYSQL_OPT_ZSTD_COMPRESSION_LEVEL
        let mysqlOption44: MysqlOption = MysqlOption.MYSQL_OPT_LOAD_DATA_LOCAL_DIR
        let mysqlOption45: MysqlOption = MysqlOption.MYSQL_OPT_USER_PASSWORD
        let mysqlOption46: MysqlOption = MysqlOption.MYSQL_OPT_SSL_SESSION_DATA
        @Assert(true, mysqlOption1 == mysqlOption1)
        @Assert(true, mysqlOption2 == mysqlOption2)
        @Assert(true, mysqlOption3 == mysqlOption3)
        @Assert(true, mysqlOption4 == mysqlOption4)
        @Assert(true, mysqlOption5 == mysqlOption5)
        @Assert(true, mysqlOption6 == mysqlOption6)
        @Assert(true, mysqlOption7 == mysqlOption7)
        @Assert(true, mysqlOption8 == mysqlOption8)
        @Assert(true, mysqlOption9 == mysqlOption9)
        @Assert(true, mysqlOption10 == mysqlOption10)
        @Assert(true, mysqlOption11 == mysqlOption11)
        @Assert(true, mysqlOption12 == mysqlOption12)
        @Assert(true, mysqlOption13 == mysqlOption13)
        @Assert(true, mysqlOption14 == mysqlOption14)
        @Assert(true, mysqlOption15 == mysqlOption15)
        @Assert(true, mysqlOption16 == mysqlOption16)
        @Assert(true, mysqlOption17 == mysqlOption17)
        @Assert(true, mysqlOption18 == mysqlOption18)
        @Assert(true, mysqlOption19 == mysqlOption19)
        @Assert(true, mysqlOption20 == mysqlOption20)
        @Assert(true, mysqlOption21 == mysqlOption21)
        @Assert(true, mysqlOption22 == mysqlOption22)
        @Assert(true, mysqlOption23 == mysqlOption23)
        @Assert(true, mysqlOption24 == mysqlOption24)
        @Assert(true, mysqlOption25 == mysqlOption25)
        @Assert(true, mysqlOption26 == mysqlOption26)
        @Assert(true, mysqlOption27 == mysqlOption27)
        @Assert(true, mysqlOption28 == mysqlOption28)
        @Assert(true, mysqlOption29 == mysqlOption29)
        @Assert(true, mysqlOption30 == mysqlOption30)
        @Assert(true, mysqlOption31 == mysqlOption31)
        @Assert(true, mysqlOption32 == mysqlOption32)
        @Assert(true, mysqlOption33 == mysqlOption33)
        @Assert(true, mysqlOption34 == mysqlOption34)
        @Assert(true, mysqlOption35 == mysqlOption35)
        @Assert(true, mysqlOption36 == mysqlOption36)
        @Assert(true, mysqlOption37 == mysqlOption37)
        @Assert(true, mysqlOption38 == mysqlOption38)
        @Assert(true, mysqlOption39 == mysqlOption39)
        @Assert(true, mysqlOption40 == mysqlOption40)
        @Assert(true, mysqlOption41 == mysqlOption41)
        @Assert(true, mysqlOption42 == mysqlOption42)
        @Assert(true, mysqlOption43 == mysqlOption43)
        @Assert(true, mysqlOption44 == mysqlOption44)
        @Assert(true, mysqlOption45 == mysqlOption45)
        @Assert(true, mysqlOption46 == mysqlOption46)
        @Assert(true, mysqlOption45 != mysqlOption46)
    }

    @TestCase
    public func mysqlEnumTest04(): Unit {
        let mysqlShutdownLevel1: MysqlShutdownLevel = MysqlShutdownLevel.SHUTDOWN_DEFAULT
        let mysqlShutdownLevel2: MysqlShutdownLevel = MysqlShutdownLevel.SHUTDOWN_WAIT_CONNECTIONS
        let mysqlShutdownLevel3: MysqlShutdownLevel = MysqlShutdownLevel.SHUTDOWN_WAIT_TRANSACTIONS
        let mysqlShutdownLevel4: MysqlShutdownLevel = MysqlShutdownLevel.SHUTDOWN_WAIT_UPDATES
        let mysqlShutdownLevel5: MysqlShutdownLevel = MysqlShutdownLevel.SHUTDOWN_WAIT_ALL_BUFFERS
        let mysqlShutdownLevel6: MysqlShutdownLevel = MysqlShutdownLevel.SHUTDOWN_WAIT_CRITICAL_BUFFERS
        let mysqlShutdownLevel7: MysqlShutdownLevel = MysqlShutdownLevel.KILL_QUERY
        let mysqlShutdownLevel8: MysqlShutdownLevel = MysqlShutdownLevel.KILL_CONNECTION
        @Assert(true, mysqlShutdownLevel1 == mysqlShutdownLevel1)
        @Assert(true, mysqlShutdownLevel2 == mysqlShutdownLevel2)
        @Assert(true, mysqlShutdownLevel3 == mysqlShutdownLevel3)
        @Assert(true, mysqlShutdownLevel4 == mysqlShutdownLevel4)
        @Assert(true, mysqlShutdownLevel5 == mysqlShutdownLevel5)
        @Assert(true, mysqlShutdownLevel6 == mysqlShutdownLevel6)
        @Assert(true, mysqlShutdownLevel7 == mysqlShutdownLevel7)
        @Assert(true, mysqlShutdownLevel8 == mysqlShutdownLevel8)
        @Assert(true, mysqlShutdownLevel1 != mysqlShutdownLevel2)
        @Assert(true, mysqlShutdownLevel1 != mysqlShutdownLevel3)
        @Assert(true, mysqlShutdownLevel1 != mysqlShutdownLevel4)
        @Assert(true, mysqlShutdownLevel1 != mysqlShutdownLevel5)
        @Assert(true, mysqlShutdownLevel1 != mysqlShutdownLevel6)
        @Assert(true, mysqlShutdownLevel1 != mysqlShutdownLevel7)
        @Assert(true, mysqlShutdownLevel1 != mysqlShutdownLevel8)
    }
}
