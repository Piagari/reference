/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package mysqlclient_ffi

/*
 * sql语句预执行
 */
public class MysqlStatement <: Statement {
    private var mysql: CPointer<Unit>
    var stmt: CPointer<Unit>
    let closed = AtomicBool(false)

    /*
     * 初始化sql语句预执行
     *
     * 参数 mysql - 初始化的mysql
     * 参数 stmt - 初始化的stmt
     */
    init(mysql: CPointer<Unit>, stmt: CPointer<Unit>) {
        this.mysql = mysql
        this.stmt = stmt
    }

    /*
     * 预执行 sql 语句中，占位参数的列信息（不支持）
     */
    public override prop parameterColumnInfos: Array<ColumnInfo> {
        get() {
            return []
        }
    }

    /*
     * 预执行sql语句中，占位的参数个数
     */
    public prop parameterCount: Int64 {
        get() {
            var count: UInt64 = 0
            unsafe {
                // 预准备语句中的参数数
                count = mysql_stmt_param_count(stmt)
            }
            return Int64(count)
        }
    }

    /**
     * 设置预执行sql语句选项(不支持)
     */
    public override func setOption(_: String, _: String): Unit {
    }

    /**
     * 设置预执行sql语句选项
     *
     * 参数 option - C中枚举 enum enum_stmt_attr_type
     * 参数 arg - 值
     * 异常 SqlException - 参数设置错误。
     */
    public func setOption(option: MysqlStmtAttrType, arg: Bool): Unit {
        unsafe {
            let argCPointer: CPointer<Byte> = LibC.malloc<Byte>()
            if (arg) {
                argCPointer.write(1)
            } else {
                argCPointer.write(0)
            }
            let argCPointer1: CPointer<Unit> = CPointer<Unit>(argCPointer)

            // 设置预准备语句的属性值
            let isBool: Bool = mysql_stmt_attr_set(stmt, option.toInt32(), argCPointer1)
            LibC.free<Byte>(argCPointer)
            if (isBool) {
                // 发生错误为非零值
                throw SqlException(mysql_stmt_error(stmt).toString())
            }
        }
    }

    /**
     * 设置预执行sql语句选项
     *
     * 参数 option - C中枚举 enum enum_stmt_attr_type
     * 参数 arg - 值
     * 异常 SqlException - 参数设置错误。
     */
    public func setOption(option: MysqlStmtAttrType, arg: UInt64): Unit {
        unsafe {
            let argCPointer: CPointer<UInt64> = LibC.malloc<UInt64>()
            argCPointer.write(arg)
            let argCPointer1: CPointer<Unit> = CPointer<Unit>(argCPointer)

            // 设置预准备语句的属性值
            let isBool: Bool = mysql_stmt_attr_set(stmt, option.toInt32(), argCPointer1)
            LibC.free<UInt64>(argCPointer)
            if (isBool) {
                // 发生错误为非零值
                throw SqlException(mysql_stmt_error(stmt).toString())
            }
        }
    }

    /**
     * 执行sql语句，得到更新结果
     *
     * 参数 params - 填充预执行语句中问号的数据。
     * 返回值 UpdateResult - 更新结果。
     * 异常 SqlException - 传入参数错误。
     */
    public override func update(params: Array<SqlDbType>): MysqlUpdateResult {
        let rows: Int64
        if (parameterCount == params.size) {
            unsafe {
                var bindsCP: CPointer<Unit> = LibC.malloc<Unit>()
                if (params.size > 0) {
                    bindsCP = init_bind(params.size)
                }
                if (bindsCP.isNull()) {
                    // 初始化失败，有可能内存不足导致的malloc失败
                    throw SqlException("Init Bind Failed!")
                }
                for (i in 0..params.size) {
                    var isBool: Bool = cjTypeToMysqlType(bindsCP, i, params[i])
                    if (!isBool) {
                        free_mysql_cj(bindsCP, i)
                        throw SqlException("Malloc  Failed!")
                    }
                }

                // 将应用程序数据缓冲区与prepared语句中的参数标记关联
                let isBool: Bool = mysql_stmt_bind_param(stmt, bindsCP)
                if (isBool) {
                    free_mysql_cj(bindsCP, params.size)

                    // 发生错误非零值，true在c语言中是1，false是0.
                    throw SqlException(mysql_stmt_error(stmt).toString())
                }

                // 	执行预准备语句
                let execute: Int32 = mysql_stmt_execute(stmt)
                if (execute != 0) {
                    free_mysql_cj(bindsCP, params.size)

                    // 发生错误非零值
                    throw SqlException(mysql_stmt_error(stmt).toString())
                }
                free_mysql_cj(bindsCP, params.size)

                // 上次更新、删除或插入语句更改/删除/插入的行数
                rows = Int64(mysql_stmt_affected_rows(stmt))
                return MysqlUpdateResult(rows, this.stmt)
            }
        } else {
            throw SqlException("update wrong number of parameters.")
        }
    }

    /**
     * 执行sql语句，得到查询结果
     *
     * 参数 params - 填充预执行语句中问号的数据。
     * 返回值 QueryResult - 查询结果。
     * 异常 SqlException - 传入参数错误。
     */
    public override func query(params: Array<SqlDbType>): MysqlQueryResult {
        if (parameterCount == params.size) {
            unsafe {
                var bindsCP: CPointer<Unit> = LibC.malloc<Unit>()
                if (params.size > 0) {
                    bindsCP = init_bind(params.size)
                }
                if (bindsCP.isNull()) {
                    // 初始化失败，有可能内存不足导致的malloc失败
                    throw SqlException("Init Bind Failed!")
                }
                for (i in 0..params.size) {
                    var isBool: Bool = cjTypeToMysqlType(bindsCP, i, params[i])
                    if (!isBool) {
                        free_mysql_cj(bindsCP, i)
                        throw SqlException("Malloc  Failed!")
                    }
                }

                // 将应用程序数据缓冲区与prepared语句中的参数标记关联
                let isBool: Bool = mysql_stmt_bind_param(stmt, bindsCP)
                if (isBool) {
                    free_mysql_cj(bindsCP, params.size)

                    // 发生错误非零值，true在c语言中是1，false是0.
                    throw SqlException(mysql_stmt_error(stmt).toString())
                }
                let execute: Int32 = mysql_stmt_execute(stmt)
                if (execute != 0) {
                    free_mysql_cj(bindsCP, params.size)

                    // 发生错误非零值
                    throw SqlException(mysql_stmt_error(stmt).toString())
                }
                free_mysql_cj(bindsCP, params.size)

                return MysqlQueryResult(stmt, getInfo())
            }
        } else {
            throw SqlException("query wrong number of parameters.")
        }
    }

    /*
     * 关闭资源
     *
     * 异常 SqlException - 关闭资源失败。
     */
    public override func close(): Unit {
        if (isClosed()) {
            return
        }
        closed.store(true)
        unsafe {
            // 释放预准备语句内存资源
            let isBool: Bool = mysql_stmt_close(stmt)
            if (isBool) {
                throw SqlException(mysql_stmt_error(stmt).toString())
            }
        }
    }

    /*
     * 判断资源是否关闭
     *
     * 返回值 Bool - 如果已经关闭返回true，否则返回false
     */
    public override func isClosed(): Bool {
        return closed.load()
    }

    private func getInfo(): Array<MysqlColumnInfo> {
        unsafe {
            let metadataUnit: CPointer<Unit> = mysql_stmt_result_metadata(stmt)
            if (metadataUnit.isNull()) {
                // 不存在准备好的元信息申明，返回NULL
                throw SqlException(mysql_stmt_error(stmt).toString())
            }
            let columnCount: UInt32 = mysql_stmt_field_count(stmt)
            let columnCountInt64: Int64 = Int64(columnCount)
            var cMysqlColumnInfos: Array<MYSQL_COLUMN_INFO> = Array<MYSQL_COLUMN_INFO>(
                columnCountInt64,
                item: MYSQL_COLUMN_INFO()
            )
            var cp: CPointerHandle<MYSQL_COLUMN_INFO> = acquireArrayRawData<MYSQL_COLUMN_INFO>(
                cMysqlColumnInfos.toArray())
            let bytesCPointer: CPointer<MYSQL_COLUMN_INFO> = cp.pointer
            get_res_data(metadataUnit, columnCountInt64, bytesCPointer)
            var mysqlColumnInfos: Array<MysqlColumnInfo> = Array<MysqlColumnInfo>(
                columnCountInt64,
                item: MysqlColumnInfo("", "", 0, 0, 0, false)
            )
            for (i in 0..columnCountInt64) {
                var field: MYSQL_COLUMN_INFO = bytesCPointer.read(i)
                var mysqlColumnInfo: MysqlColumnInfo = MysqlColumnInfo(
                    field.name_string.toString(),
                    mysqlType(field.field_type, field.flags % 2 != 0),
                    field.display_size_int64,
                    field.length_int64,
                    field.scale_int64,
                    field.flags % 2 != 0
                )
                mysqlColumnInfos[i] = mysqlColumnInfo
            }
            releaseArrayRawData<MYSQL_COLUMN_INFO>(cp)
            mysql_free_result(metadataUnit)
            return mysqlColumnInfos
        }
    }
}

func cjTypeToMysqlType(bindsCP: CPointer<Unit>, index: Int64, sqlDbType: SqlDbType): Bool {
    return match (sqlDbType) {
        // String----SqlChar----CHAR----CHAR----MYSQL_TYPE_STRING----char[]
        case v: SqlChar => setString(bindsCP, index, v.value)
        case v: SqlNullableChar => setString(bindsCP, index, v.value)

        // String----SqlVarchar----VARCHAR----VARCHAR----MYSQL_TYPE_VAR_STRING----char[]
        case v: SqlVarchar => setString(bindsCP, index, v.value)
        case v: SqlNullableVarchar => setString(bindsCP, index, v.value)

        // Array<Byte>----SqlBinary----BINARY----BINARY----MYSQL_TYPE_BLOB----char[]
        case v: SqlBinary => setBytes(bindsCP, index, v.value)
        case v: SqlNullableBinary => setBytes(bindsCP, index, v.value)

        // Array<Byte>----SqlVarBinary----VARBINARY----VARBINARY----MYSQL_TYPE_BLOB----char[]
        case v: SqlVarBinary => setBytes(bindsCP, index, v.value)
        case v: SqlNullableVarBinary => setBytes(bindsCP, index, v.value)

        // 长字符串，mysql输入对应表格没有给出，在输出表格有对应数据
        // Array<InputStream>----SqlClob----CLOB----LONGTEXT----MYSQL_TYPE_LONG_BLOB----char[]
        case v: SqlClob => setClob(bindsCP, index, v.value)
        case v: SqlNullableClob => setClob(bindsCP, index, v.value)

        // Array<InputStream>----SqlBlob----BLOB----BLOB----MYSQL_TYPE_BLOB----char[]
        case v: SqlBlob => setBlob(bindsCP, index, v.value)
        case v: SqlNullableBlob => setBlob(bindsCP, index, v.value)

        // 布尔类型在mysql数据库中表现形式是TINYINT
        // Bool----SqlBool----BOOLEAN----TINYINT----MYSQL_TYPE_TINY----signed char
        case v: SqlBool => setBool(bindsCP, index, v.value)
        case v: SqlNullableBool => setBool(bindsCP, index, v.value)

        // Int8----SqlByte----TINYINT----TINYINT----MYSQL_TYPE_TINY----signed char
        case v: SqlByte => setInt8(bindsCP, index, v.value)
        case v: SqlNullableByte => setInt8(bindsCP, index, v.value)

        // Int16----SqlSmallInt----SMALLINT----SMALLINT----MYSQL_TYPE_SHORT----short int
        case v: SqlSmallInt => setInt16(bindsCP, index, v.value)
        case v: SqlNullableSmallInt => setInt16(bindsCP, index, v.value)

        // SQL类型不同，但是数据值相对应
        // Int32----SqlInteger----INTEGER----INT----MYSQL_TYPE_LONG----int
        case v: SqlInteger => setInt32(bindsCP, index, v.value)
        case v: SqlNullableInteger => setInt32(bindsCP, index, v.value)

        // Int64----SqlBigInt----BIGINT----BIGINT----MYSQL_TYPE_LONGLONG----long long int
        case v: SqlBigInt => setInt64(bindsCP, index, v.value)
        case v: SqlNullableBigInt => setInt64(bindsCP, index, v.value)

        // SQL类型不同，但是数据值相对应
        // Float32----SqlReal----REAL----FLOAT----MYSQL_TYPE_FLOAT----float
        case v: SqlReal => setFloat32(bindsCP, index, v.value)
        case v: SqlNullableReal => setFloat32(bindsCP, index, v.value)

        // Float64----SqlDouble----DOUBLE----DOUBLE----MYSQL_TYPE_DOUBLE----double
        case v: SqlDouble => setFloat64(bindsCP, index, v.value)
        case v: SqlNullableDouble => setFloat64(bindsCP, index, v.value)

        // DateTime----SqlDate----DATE----DATE----MYSQL_TYPE_DATE----MYSQL_TIME
        case v: SqlDate => setDate(bindsCP, index, v.value)
        case v: SqlNullableDate => setDate(bindsCP, index, v.value)

        // DateTime----SqlTime----TIME----TIME----MYSQL_TYPE_TIME----MYSQL_TIME
        case v: SqlTime => setTime(bindsCP, index, v.value)
        case v: SqlNullableTime => setTime(bindsCP, index, v.value)

        // DateTime----SqlTimeTz----TIMETZ----TIME----MYSQL_TYPE_TIME----MYSQL_TIME
        // mysql不支持
        case _: SqlTimeTz => throw SqlException("Unsupported data type.")
        case _: SqlNullableTimeTz => throw SqlException("Unsupported data type.")

        // DateTime----SqlTimestamp----TIMESTAMP----TIMESTAMP----MYSQL_TYPE_TIMESTAMP----MYSQL_TIME
        case v: SqlTimestamp => setTimestamp(bindsCP, index, v.value)
        case v: SqlNullableTimestamp => setTimestamp(bindsCP, index, v.value)

        // Duration----SqlInterval----INTERVAL----DATE----MYSQL_TYPE_DATE----MYSQL_TIME
        // mysql不支持
        case _: SqlInterval => throw SqlException("Unsupported data type.")
        case _: SqlNullableInterval => throw SqlException("Unsupported data type.")

        // 自定义类
        // DATETIME----MYSQL_TYPE_DATETIME----MYSQL_TIME
        case v: SqlDateTime => setDateTime(bindsCP, index, v.value)
        case v: SqlNullableDateTime => setDateTime(bindsCP, index, v.value)

        // 自定义类
        // DECIMAL----MYSQL_TYPE_NEWDECIMAL
        case v: SqlDecimal => setDecimal(bindsCP, index, v.value)
        case v: SqlNullableDecimal => setDecimal(bindsCP, index, v.value)

        case _ => throw SqlException("Unsupported data type.")
    }
}

func setString(bindsCP: CPointer<Unit>, index: Int64, value: Option<String>): Bool {
    match (value) {
        case Some(v) => unsafe {
                let strCtring: CString = LibC.mallocCString(v)
                var ret = set_string(bindsCP, index, strCtring)
                LibC.free(strCtring)
                return ret
            }
        case None => unsafe {
                set_null(bindsCP, index)
            }
    }
}

func setBytes(bindsCP: CPointer<Unit>, index: Int64, value: Option<Array<Byte>>): Bool {
    match (value) {
        case Some(v) => unsafe {
                var cp: CPointerHandle<Byte> = acquireArrayRawData<Byte>(v)
                let bytesCPointer: CPointer<UInt8> = cp.pointer
                var ret = set_bytes(bindsCP, index, bytesCPointer, v.size)
                releaseArrayRawData<Byte>(cp)
                return ret
            }
        case None => unsafe {
                set_null(bindsCP, index)
            }
    }
}

func setClob(bindsCP: CPointer<Unit>, index: Int64, value: Option<InputStream>): Bool {
    match (value) {
        case Some(v) =>
            var arr: Array<Byte> = Array<Byte>(1, item: 0)
            var list: ArrayList<Byte> = ArrayList<Byte>()
            var length: Int64 = 0
            while (true) {
                var date: Int64 = v.read(arr)
                if (date == 0) {
                    break
                }
                list.append(arr[0])
                length++
            }
            unsafe {
                var cp: CPointerHandle<Byte> = acquireArrayRawData<Byte>(list.toArray())
                let bytesCPointer: CPointer<UInt8> = cp.pointer
                var ret = set_clob(bindsCP, index, bytesCPointer, list.size)
                releaseArrayRawData<Byte>(cp)
                return ret
            }
        case None => unsafe {
                set_null(bindsCP, index)
            }
    }
}

func setBlob(bindsCP: CPointer<Unit>, index: Int64, value: Option<InputStream>): Bool {
    match (value) {
        case Some(v) =>
            var arr: Array<Byte> = Array<Byte>(1, item: 0)
            var list: ArrayList<Byte> = ArrayList<Byte>()
            var length: Int64 = 0
            while (true) {
                var date: Int64 = v.read(arr)
                if (date == 0) {
                    break
                }
                list.append(arr[0])
                length++
            }
            unsafe {
                var cp: CPointerHandle<Byte> = acquireArrayRawData<Byte>(list.toArray())
                let bytesCPointer: CPointer<UInt8> = cp.pointer
                var ret = set_blob(bindsCP, index, bytesCPointer, list.size)
                releaseArrayRawData<Byte>(cp)
                return ret
            }
        case None => unsafe {
                set_null(bindsCP, index)
            }
    }
}

func setBool(bindsCP: CPointer<Unit>, index: Int64, value: Option<Bool>): Bool {
    match (value) {
        case Some(v) => unsafe {
                if (v) {
                    set_bool(bindsCP, index, 1)
                } else {
                    set_bool(bindsCP, index, 0)
                }
            }
        case None => unsafe {
                set_null(bindsCP, index)
            }
    }
}

func setInt8(bindsCP: CPointer<Unit>, index: Int64, value: Option<Int8>): Bool {
    match (value) {
        case Some(v) => unsafe {
                set_int8(bindsCP, index, v)
            }
        case None => unsafe {
                set_null(bindsCP, index)
            }
    }
}

func setInt16(bindsCP: CPointer<Unit>, index: Int64, value: Option<Int16>): Bool {
    match (value) {
        case Some(v) => unsafe {
                set_int16(bindsCP, index, v)
            }
        case None => unsafe {
                set_null(bindsCP, index)
            }
    }
}

func setInt32(bindsCP: CPointer<Unit>, index: Int64, value: Option<Int32>): Bool {
    match (value) {
        case Some(v) => unsafe {
                set_int32(bindsCP, index, v)
            }
        case None => unsafe {
                set_null(bindsCP, index)
            }
    }
}

func setInt64(bindsCP: CPointer<Unit>, index: Int64, value: Option<Int64>): Bool {
    match (value) {
        case Some(v) => unsafe {
                set_int64(bindsCP, index, v)
            }
        case None => unsafe {
                set_null(bindsCP, index)
            }
    }
}

func setFloat32(bindsCP: CPointer<Unit>, index: Int64, value: Option<Float32>): Bool {
    match (value) {
        case Some(v) => unsafe {
                set_float32(bindsCP, index, v)
            }
        case None => unsafe {
                set_null(bindsCP, index)
            }
    }
}

func setFloat64(bindsCP: CPointer<Unit>, index: Int64, value: Option<Float64>): Bool {
    match (value) {
        case Some(v) => unsafe {
                set_float64(bindsCP, index, v)
            }
        case None => unsafe {
                set_null(bindsCP, index)
            }
    }
}

func setDate(bindsCP: CPointer<Unit>, index: Int64, value: Option<DateTime>): Bool {
    match (value) {
        case Some(v) => unsafe {
                set_date(bindsCP, index, UInt32(v.year), UInt32(v.monthValue), UInt32(v.dayOfMonth))
            }
        case None => unsafe {
                set_null(bindsCP, index)
            }
    }
}

func setTime(bindsCP: CPointer<Unit>, index: Int64, value: Option<DateTime>): Bool {
    match (value) {
        case Some(v) => unsafe {
                set_time(bindsCP, index, UInt32(v.hour), UInt32(v.minute), UInt32(v.second))
            }
        case None => unsafe {
                set_null(bindsCP, index)
            }
    }
}

func setTimestamp(bindsCP: CPointer<Unit>, index: Int64, value: Option<DateTime>): Bool {
    match (value) {
        case Some(v) => unsafe {
                set_timestamp(
                    bindsCP,
                    index,
                    UInt32(v.year),
                    UInt32(v.monthValue),
                    UInt32(v.dayOfMonth),
                    UInt32(v.hour),
                    UInt32(v.minute),
                    UInt32(v.second)
                )
            }
        case None => unsafe {
                set_null(bindsCP, index)
            }
    }
}

func setDateTime(bindsCP: CPointer<Unit>, index: Int64, value: Option<DateTime>): Bool {
    match (value) {
        case Some(v) => unsafe {
                set_date_time(
                    bindsCP,
                    index,
                    UInt32(v.year),
                    UInt32(v.monthValue),
                    UInt32(v.dayOfMonth),
                    UInt32(v.hour),
                    UInt32(v.minute),
                    UInt32(v.second)
                )
            }
        case None => unsafe {
            set_null(bindsCP, index)
        }
    }
}

func setDecimal(bindsCP: CPointer<Unit>, index: Int64, value: Option<Decimal>): Bool {
    match (value) {
        case Some(v) => unsafe {
            let strCtring: CString = LibC.mallocCString(v.toString())
            var ret = set_decimal(bindsCP, index, strCtring)
            LibC.free(strCtring)
            return ret
        }
        case None => unsafe {
                set_null(bindsCP, index)
            }
    }
}

func mysqlType(types: Int32, isNull: Bool): String {
    if (types == MYSQL_TYPE_DECIMAL) {
        return "MYSQL_TYPE_DECIMAL"
    }
    if (types == MYSQL_TYPE_TINY) {
        if (!isNull) {
            return "SqlNullableByte"
        } else {
            return "SqlByte"
        }
    }
    if (types == MYSQL_TYPE_SHORT) {
        if (!isNull) {
            return "SqlNullableSmallInt"
        } else {
            return "SqlSmallInt"
        }
    }
    if (types == MYSQL_TYPE_LONG) {
        if (!isNull) {
            return "SqlNullableInteger"
        } else {
            return "SqlInteger"
        }
    }
    if (types == MYSQL_TYPE_FLOAT) {
        if (!isNull) {
            return "SqlNullableReal"
        } else {
            return "SqlReal"
        }
    }
    if (types == MYSQL_TYPE_DOUBLE) {
        if (!isNull) {
            return "SqlNullableDouble"
        } else {
            return "SqlDouble"
        }
    }
    if (types == MYSQL_TYPE_NULL) {
        return "MYSQL_TYPE_NULL"
    }
    if (types == MYSQL_TYPE_TIMESTAMP) {
        if (!isNull) {
            return "SqlNullableTimestamp"
        } else {
            return "SqlTimestamp"
        }
    }
    if (types == MYSQL_TYPE_LONGLONG) {
        if (!isNull) {
            return "SqlNullableBigInt"
        } else {
            return "SqlBigInt"
        }
    }
    if (types == MYSQL_TYPE_INT24) {
        if (!isNull) {
            return "SqlNullableInteger"
        } else {
            return "SqlInteger"
        }
    }
    if (types == MYSQL_TYPE_DATE) {
        if (!isNull) {
            return "SqlNullableDate"
        } else {
            return "SqlDate"
        }
    }
    if (types == MYSQL_TYPE_TIME) {
        if (!isNull) {
            return "SqlNullableTime"
        } else {
            return "SqlTime"
        }
    }

    // 自定义类型
    if (types == MYSQL_TYPE_DATETIME) {
        if (!isNull) {
            return "SqlNullableDateTime"
        } else {
            return "SqlDateTime"
        }
    }
    if (types == MYSQL_TYPE_YEAR) {
        return "MYSQL_TYPE_YEAR"
    }
    if (types == MYSQL_TYPE_NEWDATE) {
        return "MYSQL_TYPE_NEWDATE"
    }
    if (types == MYSQL_TYPE_VARCHAR) {
        return "MYSQL_TYPE_VARCHAR"
    }
    if (types == MYSQL_TYPE_BIT) {
        return "MYSQL_TYPE_BIT"
    }
    if (types == MYSQL_TYPE_TIMESTAMP2) {
        return "MYSQL_TYPE_TIMESTAMP2"
    }
    if (types == MYSQL_TYPE_DATETIME2) {
        return "MYSQL_TYPE_DATETIME2"
    }
    if (types == MYSQL_TYPE_TIME2) {
        return "MYSQL_TYPE_TIME2"
    }
    if (types == MYSQL_TYPE_TYPED_ARRAY) {
        return "MYSQL_TYPE_TYPED_ARRAY"
    }
    if (types == MYSQL_TYPE_INVALID) {
        return "MYSQL_TYPE_INVALID"
    }
    if (types == MYSQL_TYPE_BOOL) {
        return "MYSQL_TYPE_BOOL"
    }
    if (types == MYSQL_TYPE_JSON) {
        return "MYSQL_TYPE_JSON"
    }
    if (types == MYSQL_TYPE_NEWDECIMAL) {
        if (!isNull) {
            return "SqlNullableDecimal"
        } else {
            return "SqlDecimal"
        }
    }
    if (types == MYSQL_TYPE_ENUM) {
        return "MYSQL_TYPE_ENUM"
    }
    if (types == MYSQL_TYPE_SET) {
        return "MYSQL_TYPE_SET"
    }
    if (types == MYSQL_TYPE_TINY_BLOB) {
        if (!isNull) {
            return "SqlNullableBlob"
        } else {
            return "SqlBlob"
        }
    }
    if (types == MYSQL_TYPE_MEDIUM_BLOB) {
        if (!isNull) {
            return "SqlNullableBlob"
        } else {
            return "SqlBlob"
        }
    }
    if (types == MYSQL_TYPE_LONG_BLOB) {
        if (!isNull) {
            return "SqlNullableClob"
        } else {
            return "SqlClob"
        }
    }
    if (types == MYSQL_TYPE_BLOB) {
        if (!isNull) {
            return "SqlNullableBlob"
        } else {
            return "SqlBlob"
        }
    }
    if (types == MYSQL_TYPE_VAR_STRING) {
        if (!isNull) {
            return "SqlNullableVarchar"
        } else {
            return "SqlVarchar"
        }
    }
    if (types == MYSQL_TYPE_STRING) {
        if (!isNull) {
            return "SqlNullableChar"
        } else {
            return "SqlChar"
        }
    }
    if (types == MYSQL_TYPE_GEOMETRY) {
        return "MYSQL_TYPE_GEOMETRY"
    }
    return "unknownType"
}
