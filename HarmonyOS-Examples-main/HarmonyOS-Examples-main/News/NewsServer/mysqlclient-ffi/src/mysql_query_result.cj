/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package mysqlclient_ffi

/*
 * 执行Select语句产生的结果
 */
public class MysqlQueryResult <: QueryResult {
    private var resultCount: Array<MysqlColumnInfo>
    private var stmt: CPointer<Unit>
    let closed = AtomicBool(false)

    /*
     * 初始化 执行Select语句产生的结果
     *
     * 参数 mysql - 初始化的mysql
     * 参数 stmt - 初始化的stmt
     */
    init(stmt: CPointer<Unit>, resultCount: Array<MysqlColumnInfo>) {
        this.stmt = stmt
        this.resultCount = resultCount
    }

    /*
     * 返回结果集的列信息，比如列名，列类型，列长度，是否允许数据库Null值等（不支持）
     */
    public override prop columnInfos: Array<ColumnInfo> {
        get() {
            Array<ColumnInfo>(resultCount.size, {i => (resultCount[i] as MysqlColumnInfo).getOrThrow()})
        }
    }

    /*
     * 返回结果集的列信息，比如列名，列类型，列长度，是否允许数据库Null值等
     */
    public prop mysqlColumnInfos: Array<MysqlColumnInfo> {
        get() {
            return resultCount
        }
    }

    /*
     * 向后移动一行，必须先调用一次next才能移动到第一行，第二次调用移动到第二行，依此类推。
     * 当返回true时，驱动会在values中填入行数据；当返回false时结束，且不会修改values的内容。
     *
     * 参数 values - 需要填充返回的数据
     * 返回值 Bool - 存在下一行则返回true，否则返回false
     * 异常 SqlException - 传入参数错误
     */
    public override func next(values: Array<SqlDbType>): Bool {
        unsafe {
            var bindsCP: CPointer<Unit> = LibC.malloc<Unit>()
            if (values.size > 0) {
                bindsCP = init_bind(values.size)
            }
            if (bindsCP.isNull()) {
                // 初始化失败，有可能内存不足导致的malloc失败
                throw SqlException("Init Bind Failed!")
            }
            for (i in 0..values.size) {
                var isBool: Bool = cjTypeToMysqlTypeQuery(values[i], bindsCP, i, resultCount[i].length)
                if (!isBool) {
                    free_mysql_cj(bindsCP, i)
                    throw SqlException("Malloc  Failed!")
                }
            }
            let isBool: Bool = mysql_stmt_bind_result(stmt, bindsCP)
            if (isBool) {
                free_mysql_cj(bindsCP, values.size)
                throw SqlException(mysql_stmt_error(stmt).toString())
            }
            var intFetch: Int32 = mysql_stmt_fetch(stmt)
            if (intFetch == 1) {
                // 发生错误。
                free_mysql_cj(bindsCP, values.size)
                throw SqlException(mysql_stmt_error(stmt).toString())
            } else if (intFetch == 100) {
                // 成功，不再存在数据。
                free_mysql_cj(bindsCP, values.size)
                return false
            } else if (intFetch == 101) {
                // 发生数据截断。
            }

            // 成功存在数据或有数据发生数据截断
            for (i in 0..values.size) {
                values[i] = mysqlTypeTocjType(bindsCP, values[i], i)
            }
            free_mysql_cj(bindsCP, values.size)

            return true
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
            let isBool: Bool = mysql_stmt_free_result(stmt)
            if (isBool) {
                throw SqlException(mysql_stmt_error(stmt).toString())
            }
        }
    }

    /*
     * 判断资源是否关闭
     * 返回值 Bool - 如果已经关闭返回true，否则返回false
     */
    public override func isClosed(): Bool {
        return closed.load()
    }
}

func mysqlTypeTocjType(bindsCP: CPointer<Unit>, value: SqlDbType, index: Int64): SqlDbType {
    unsafe {
        var bufferTypeCp: CPointer<Unit> = LibC.malloc<Unit>(count: 1)
        var isNullCp: CPointer<Unit> = LibC.malloc<Unit>(count: 1)
        var lengthCp: CPointer<Int64> = LibC.malloc<Int64>(count: 8)
        var bufferCp: CPointer<Unit> = get_sql_buffer(bindsCP, index, bufferTypeCp, isNullCp, lengthCp)
        let sqlDbType: SqlDbType = match (value) {
            // String----SqlChar----CHAR----CHAR----MYSQL_TYPE_STRING----char[]
            case _: SqlChar => getSqlChar(bufferCp)
            case _: SqlNullableChar => getSqlNullableChar(bufferCp, isNullCp)

            // String----SqlVarchar----VARCHAR----VARCHAR----MYSQL_TYPE_VAR_STRING----char[]
            case _: SqlVarchar => getSqlVarchar(bufferCp)
            case _: SqlNullableVarchar => getSqlNullableVarchar(bufferCp, isNullCp)

            // Array<Byte>----SqlBinary----BINARY----BINARY----MYSQL_TYPE_BLOB----char[]
            case _: SqlBinary => getSqlBinary(bufferCp, lengthCp.read())
            case _: SqlNullableBinary => getSqlNullableBinary(bufferCp, lengthCp.read(), isNullCp)

            // Array<Byte>----SqlVarBinary----VARBINARY----VARBINARY----MYSQL_TYPE_BLOB----char[]
            case _: SqlVarBinary => getSqlVarBinary(bufferCp, lengthCp.read())
            case _: SqlNullableVarBinary => getSqlNullableVarBinary(bufferCp, lengthCp.read(), isNullCp)

            // 长字符串，mysql输入对应表格没有给出，在输出表格有对应数据
            // Array<InputStream>----SqlClob----CLOB----LONGTEXT----MYSQL_TYPE_LONG_BLOB----char[]
            case _: SqlClob => getSqlClob(bufferCp, lengthCp.read())
            case _: SqlNullableClob => getSqlNullableClob(bufferCp, lengthCp.read(), isNullCp)

            // Array<InputStream>----SqlBlob----BLOB----BLOB----MYSQL_TYPE_BLOB----char[]
            case _: SqlBlob => getSqlBlob(bufferCp, lengthCp.read())
            case _: SqlNullableBlob => getSqlNullableBlob(bufferCp, lengthCp.read(), isNullCp)

            // 布尔类型在mysql数据库中表现形式是TINYINT
            // Bool----SqlBool----BOOLEAN----TINYINT----MYSQL_TYPE_TINY----signed char
            case _: SqlBool => getSqlBool(bufferCp)
            case _: SqlNullableBool => getSqlNullableBool(bufferCp, isNullCp)

            // Int8----SqlByte----TINYINT----TINYINT----MYSQL_TYPE_TINY----signed char
            case _: SqlByte => getSqlByte(bufferCp)
            case _: SqlNullableByte => getSqlNullableByte(bufferCp, isNullCp)

            // Int16----SqlSmallInt----SMALLINT----SMALLINT----MYSQL_TYPE_SHORT----short int
            case _: SqlSmallInt => getSqlSmallInt(bufferCp)
            case _: SqlNullableSmallInt => getSqlNullableSmallInt(bufferCp, isNullCp)

            // SQL类型不同，但是数据值相对应
            // Int32----SqlInteger----INTEGER----INT----MYSQL_TYPE_LONG----int
            case _: SqlInteger => getSqlInteger(bufferCp)
            case _: SqlNullableInteger => getSqlNullableInteger(bufferCp, isNullCp)

            // Int64----SqlBigInt----BIGINT----BIGINT----MYSQL_TYPE_LONGLONG----long long int
            case _: SqlBigInt => getSqlBigInt(bufferCp)
            case _: SqlNullableBigInt => getSqlNullableBigInt(bufferCp, isNullCp)

            // SQL类型不同，但是数据值相对应
            // Float32----SqlReal----REAL----FLOAT----MYSQL_TYPE_FLOAT----float
            case _: SqlReal => getSqlReal(bufferCp)
            case _: SqlNullableReal => getSqlNullableReal(bufferCp, isNullCp)

            // Float64----SqlDouble----DOUBLE----DOUBLE----MYSQL_TYPE_DOUBLE----double
            case _: SqlDouble => getSqlDouble(bufferCp)
            case _: SqlNullableDouble => getSqlNullableDouble(bufferCp, isNullCp)

            // DateTime----SqlDate----DATE----DATE----MYSQL_TYPE_DATE----MYSQL_TIME
            case _: SqlDate => getSqlDate(bufferCp)
            case _: SqlNullableDate => getSqlNullableDate(bufferCp, isNullCp)

            // DateTime----SqlTime----TIME----TIME----MYSQL_TYPE_TIME----MYSQL_TIME
            case _: SqlTime => getSqlTime(bufferCp)
            case _: SqlNullableTime => getSqlNullableTime(bufferCp, isNullCp)

            // DateTime----SqlTimeTz----TIMETZ----TIME----MYSQL_TYPE_TIME----MYSQL_TIME
            // mysql不支持
            case _: SqlTimeTz => throw SqlException("Unsupported data type.")
            case _: SqlNullableTimeTz => throw SqlException("Unsupported data type.")

            // DateTime----SqlTimestamp----TIMESTAMP----TIMESTAMP----MYSQL_TYPE_TIMESTAMP----MYSQL_TIME
            case _: SqlTimestamp => getSqlTimestamp(bufferCp)
            case _: SqlNullableTimestamp => getSqlNullableTimestamp(bufferCp, isNullCp)

            // Duration----SqlInterval----INTERVAL----DATE----MYSQL_TYPE_DATE----MYSQL_TIME
            // mysql不支持
            case _: SqlInterval => throw SqlException("Unsupported data type.")
            case _: SqlNullableInterval => throw SqlException("Unsupported data type.")

            // 自定义类
            // DATETIME----MYSQL_TYPE_DATETIME----MYSQL_TIME
            case _: SqlDateTime => getSqlDateTime(bufferCp)
            case _: SqlNullableDateTime => getSqlNullableDateTime(bufferCp, isNullCp)

            // 自定义类
            // DECIMAL----MYSQL_TYPE_NEWDECIMAL
            case _: SqlDecimal => getSqlDecimal(bufferCp)
            case _: SqlNullableDecimal => getSqlNullableDecimal(bufferCp, isNullCp)

            case _ => throw SqlException("Unsupported data type.")
        }
        return sqlDbType
    }
}

func getSqlChar(buffer: CPointer<Unit>): SqlDbType {
    unsafe {
        let valueCPointer: CPointer<UInt8> = CPointer<UInt8>(buffer)
        let cstirng: CString = CString(valueCPointer)
        return SqlChar(cstirng.toString())
    }
}

func getSqlNullableChar(buffer: CPointer<Unit>, isNull: CPointer<Unit>): SqlDbType {
    unsafe {
        let isNullCp: CPointer<Bool> = CPointer<Bool>(isNull)
        if (isNullCp.read()) {
            return SqlNullableChar(None)
        } else {
            let valueCPointer: CPointer<UInt8> = CPointer<UInt8>(buffer)
            let cstirng: CString = CString(valueCPointer)
            return SqlNullableChar(cstirng.toString())
        }
    }
}

func getSqlVarchar(buffer: CPointer<Unit>): SqlDbType {
    unsafe {
        let valueCPointer: CPointer<UInt8> = CPointer<UInt8>(buffer)
        let cstirng: CString = CString(valueCPointer)
        return SqlVarchar(cstirng.toString())
    }
}

func getSqlNullableVarchar(buffer: CPointer<Unit>, isNull: CPointer<Unit>): SqlDbType {
    unsafe {
        let isNullCp: CPointer<Bool> = CPointer<Bool>(isNull)
        if (isNullCp.read()) {
            return SqlNullableVarchar(None)
        } else {
            let valueCPointer: CPointer<UInt8> = CPointer<UInt8>(buffer)
            let cstirng: CString = CString(valueCPointer)
            return SqlNullableVarchar(cstirng.toString())
        }
    }
}

func getSqlBinary(buffer: CPointer<Unit>, length: Int64): SqlDbType {
    unsafe {
        let valueCPointer: CPointer<UInt8> = CPointer<UInt8>(buffer)
        var arr = Array<Byte>(length, item: 0)
        for (i in 0..length) {
            arr[i] = valueCPointer.read(i)
        }
        return SqlBinary(arr)
    }
}

func getSqlNullableBinary(buffer: CPointer<Unit>, length: Int64, isNull: CPointer<Unit>): SqlDbType {
    unsafe {
        let isNullCp: CPointer<Bool> = CPointer<Bool>(isNull)
        if (isNullCp.read()) {
            return SqlNullableBinary(None)
        } else {
            let valueCPointer: CPointer<UInt8> = CPointer<UInt8>(buffer)
            var arr = Array<Byte>(length, item: 0)
            for (i in 0..length) {
                arr[i] = valueCPointer.read(i)
            }
            return SqlNullableBinary(arr)
        }
    }
}

func getSqlVarBinary(buffer: CPointer<Unit>, length: Int64): SqlDbType {
    unsafe {
        let valueCPointer: CPointer<UInt8> = CPointer<UInt8>(buffer)
        var arr = Array<Byte>(length, item: 0)
        for (i in 0..length) {
            arr[i] = valueCPointer.read(i)
        }
        return SqlVarBinary(arr)
    }
}

func getSqlNullableVarBinary(buffer: CPointer<Unit>, length: Int64, isNull: CPointer<Unit>): SqlDbType {
    unsafe {
        let isNullCp: CPointer<Bool> = CPointer<Bool>(isNull)
        if (isNullCp.read()) {
            return SqlNullableVarBinary(None)
        } else {
            let valueCPointer: CPointer<UInt8> = CPointer<UInt8>(buffer)
            var arr = Array<Byte>(length, item: 0)
            for (i in 0..length) {
                arr[i] = valueCPointer.read(i)
            }
            return SqlNullableVarBinary(arr)
        }
    }
}

func getSqlClob(buffer: CPointer<Unit>, length: Int64): SqlDbType {
    unsafe {
        let valueCPointer: CPointer<UInt8> = CPointer<UInt8>(buffer)
        var arr = Array<Byte>(length, item: 0)
        for (i in 0..length) {
            arr[i] = valueCPointer.read(i)
        }
        var output = ByteArrayStream()
        output.write(arr)
        return SqlClob(output)
    }
}

func getSqlNullableClob(buffer: CPointer<Unit>, length: Int64, isNull: CPointer<Unit>): SqlDbType {
    unsafe {
        let isNullCp: CPointer<Bool> = CPointer<Bool>(isNull)
        if (isNullCp.read()) {
            return SqlNullableClob(None)
        } else {
            let valueCPointer: CPointer<UInt8> = CPointer<UInt8>(buffer)
            var arr = Array<Byte>(length, item: 0)
            for (i in 0..length) {
                arr[i] = valueCPointer.read(i)
            }
            var output = ByteArrayStream()
            output.write(arr)
            return SqlNullableClob(output)
        }
    }
}

func getSqlBlob(buffer: CPointer<Unit>, length: Int64): SqlDbType {
    unsafe {
        let valueCPointer: CPointer<UInt8> = CPointer<UInt8>(buffer)
        var arr = Array<Byte>(length, item: 0)
        for (i in 0..length) {
            arr[i] = valueCPointer.read(i)
        }
        var output = ByteArrayStream()
        output.write(arr)
        return SqlBlob(output)
    }
}

func getSqlNullableBlob(buffer: CPointer<Unit>, length: Int64, isNull: CPointer<Unit>): SqlDbType {
    unsafe {
        let isNullCp: CPointer<Bool> = CPointer<Bool>(isNull)
        if (isNullCp.read()) {
            return SqlNullableBlob(None)
        } else {
            let valueCPointer: CPointer<UInt8> = CPointer<UInt8>(buffer)
            var arr = Array<Byte>(length, item: 0)
            for (i in 0..length) {
                arr[i] = valueCPointer.read(i)
            }
            var output = ByteArrayStream()
            output.write(arr)
            return SqlNullableBlob(output)
        }
    }
}

func getSqlBool(buffer: CPointer<Unit>): SqlDbType {
    unsafe {
        let valueCPointer: CPointer<Int8> = CPointer<Int8>(buffer)
        let sqlValue: Bool = intToBool(valueCPointer.read())
        return SqlBool(sqlValue)
    }
}

func getSqlNullableBool(buffer: CPointer<Unit>, isNull: CPointer<Unit>): SqlDbType {
    unsafe {
        let isNullCp: CPointer<Bool> = CPointer<Bool>(isNull)
        if (isNullCp.read()) {
            return SqlNullableBool(None)
        } else {
            let valueCPointer: CPointer<Int8> = CPointer<Int8>(buffer)
            let sqlValue: Bool = intToBool(valueCPointer.read())
            return SqlNullableBool(sqlValue)
        }
    }
}

func intToBool(typeInt: Int8): Bool {
    if (typeInt == 0) {
        return false
    } else if (typeInt == 1) {
        return true
    }
    throw SqlException("Unsupported data type.")
}

func getSqlByte(buffer: CPointer<Unit>): SqlDbType {
    unsafe {
        let valueCPointer: CPointer<Int8> = CPointer<Int8>(buffer)
        let sqlValue: Int8 = valueCPointer.read()
        return SqlByte(sqlValue)
    }
}

func getSqlNullableByte(buffer: CPointer<Unit>, isNull: CPointer<Unit>): SqlDbType {
    unsafe {
        let isNullCp: CPointer<Bool> = CPointer<Bool>(isNull)
        if (isNullCp.read()) {
            return SqlNullableByte(None)
        } else {
            let valueCPointer: CPointer<Int8> = CPointer<Int8>(buffer)
            let sqlValue: Int8 = valueCPointer.read()
            return SqlNullableByte(sqlValue)
        }
    }
}

func getSqlSmallInt(buffer: CPointer<Unit>): SqlDbType {
    unsafe {
        let valueCPointer: CPointer<Int16> = CPointer<Int16>(buffer)
        let sqlValue: Int16 = valueCPointer.read()
        return SqlSmallInt(sqlValue)
    }
}

func getSqlNullableSmallInt(buffer: CPointer<Unit>, isNull: CPointer<Unit>): SqlDbType {
    unsafe {
        let isNullCp: CPointer<Bool> = CPointer<Bool>(isNull)
        if (isNullCp.read()) {
            return SqlNullableSmallInt(None)
        } else {
            let valueCPointer: CPointer<Int16> = CPointer<Int16>(buffer)
            let sqlValue: Int16 = valueCPointer.read()
            return SqlNullableSmallInt(sqlValue)
        }
    }
}

func getSqlInteger(buffer: CPointer<Unit>): SqlDbType {
    unsafe {
        let valueCPointer: CPointer<Int32> = CPointer<Int32>(buffer)
        let sqlValue: Int32 = valueCPointer.read()
        return SqlInteger(sqlValue)
    }
}

func getSqlNullableInteger(buffer: CPointer<Unit>, isNull: CPointer<Unit>): SqlDbType {
    unsafe {
        let isNullCp: CPointer<Bool> = CPointer<Bool>(isNull)
        if (isNullCp.read()) {
            return SqlNullableInteger(None)
        } else {
            let valueCPointer: CPointer<Int32> = CPointer<Int32>(buffer)
            let sqlValue: Int32 = valueCPointer.read()
            return SqlNullableInteger(sqlValue)
        }
    }
}

func getSqlBigInt(buffer: CPointer<Unit>): SqlDbType {
    unsafe {
        let valueCPointer: CPointer<Int64> = CPointer<Int64>(buffer)
        let sqlValue: Int64 = valueCPointer.read()
        return SqlBigInt(sqlValue)
    }
}

func getSqlNullableBigInt(buffer: CPointer<Unit>, isNull: CPointer<Unit>): SqlDbType {
    unsafe {
        let isNullCp: CPointer<Bool> = CPointer<Bool>(isNull)
        if (isNullCp.read()) {
            return SqlNullableBigInt(None)
        } else {
            let valueCPointer: CPointer<Int64> = CPointer<Int64>(buffer)
            let sqlValue: Int64 = valueCPointer.read()
            return SqlNullableBigInt(sqlValue)
        }
    }
}

func getSqlReal(buffer: CPointer<Unit>): SqlDbType {
    unsafe {
        let valueCPointer: CPointer<Float32> = CPointer<Float32>(buffer)
        let sqlValue: Float32 = valueCPointer.read()
        return SqlReal(sqlValue)
    }
}

func getSqlNullableReal(buffer: CPointer<Unit>, isNull: CPointer<Unit>): SqlDbType {
    unsafe {
        let isNullCp: CPointer<Bool> = CPointer<Bool>(isNull)
        if (isNullCp.read()) {
            return SqlNullableReal(None)
        } else {
            let valueCPointer: CPointer<Float32> = CPointer<Float32>(buffer)
            let sqlValue: Float32 = valueCPointer.read()
            return SqlNullableReal(sqlValue)
        }
    }
}

func getSqlDouble(buffer: CPointer<Unit>): SqlDbType {
    unsafe {
        let valueCPointer: CPointer<Float64> = CPointer<Float64>(buffer)
        let sqlValue: Float64 = valueCPointer.read()
        return SqlDouble(sqlValue)
    }
}

func getSqlNullableDouble(buffer: CPointer<Unit>, isNull: CPointer<Unit>): SqlDbType {
    unsafe {
        let isNullCp: CPointer<Bool> = CPointer<Bool>(isNull)
        if (isNullCp.read()) {
            return SqlNullableDouble(None)
        } else {
            let valueCPointer: CPointer<Float64> = CPointer<Float64>(buffer)
            let sqlValue: Float64 = valueCPointer.read()
            return SqlNullableDouble(sqlValue)
        }
    }
}

func getSqlDate(buffer: CPointer<Unit>): SqlDbType {
    unsafe {
        var yearCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        var monthCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        var dayCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        var hourCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        var minuteCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        var secondCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        get_sql_time(buffer, yearCp, monthCp, dayCp, hourCp, minuteCp, secondCp);
        let dateTime: DateTime = DateTime.of(
            year: Int64(yearCp.read()),
            month: Int64(monthCp.read()),
            dayOfMonth: Int64(dayCp.read())
        )
        LibC.free<UInt32>(yearCp)
        LibC.free<UInt32>(monthCp)
        LibC.free<UInt32>(dayCp)
        LibC.free<UInt32>(hourCp)
        LibC.free<UInt32>(minuteCp)
        LibC.free<UInt32>(secondCp)
        return SqlDate(dateTime)
    }
}

func getSqlNullableDate(buffer: CPointer<Unit>, isNull: CPointer<Unit>): SqlDbType {
    unsafe {
        let isNullCp: CPointer<Bool> = CPointer<Bool>(isNull)
        if (isNullCp.read()) {
            return SqlNullableDate(None)
        } else {
            var yearCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            var monthCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            var dayCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            var hourCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            var minuteCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            var secondCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            get_sql_time(buffer, yearCp, monthCp, dayCp, hourCp, minuteCp, secondCp);
            let dateTime: DateTime = DateTime.of(
                year: Int64(yearCp.read()),
                month: Int64(monthCp.read()),
                dayOfMonth: Int64(dayCp.read())
            )
            LibC.free<UInt32>(yearCp)
            LibC.free<UInt32>(monthCp)
            LibC.free<UInt32>(dayCp)
            LibC.free<UInt32>(hourCp)
            LibC.free<UInt32>(minuteCp)
            LibC.free<UInt32>(secondCp)
            return SqlNullableDate(dateTime)
        }
    }
}

func getSqlTime(buffer: CPointer<Unit>): SqlDbType {
    unsafe {
        var yearCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        var monthCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        var dayCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        var hourCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        var minuteCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        var secondCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        get_sql_time(buffer, yearCp, monthCp, dayCp, hourCp, minuteCp, secondCp);
        let dateTime: DateTime = DateTime.of(
            year: 1970,
            month: 1,
            dayOfMonth: 1,
            hour: Int64(hourCp.read()),
            minute: Int64(minuteCp.read()),
            second: Int64(secondCp.read())
        )
        LibC.free<UInt32>(yearCp)
        LibC.free<UInt32>(monthCp)
        LibC.free<UInt32>(dayCp)
        LibC.free<UInt32>(hourCp)
        LibC.free<UInt32>(minuteCp)
        LibC.free<UInt32>(secondCp)
        return SqlTime(dateTime)
    }
}

func getSqlNullableTime(buffer: CPointer<Unit>, isNull: CPointer<Unit>): SqlDbType {
    unsafe {
        let isNullCp: CPointer<Bool> = CPointer<Bool>(isNull)
        if (isNullCp.read()) {
            return SqlNullableTime(None)
        } else {
            var yearCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            var monthCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            var dayCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            var hourCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            var minuteCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            var secondCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            get_sql_time(buffer, yearCp, monthCp, dayCp, hourCp, minuteCp, secondCp);
            let dateTime: DateTime = DateTime.of(
                year: 1970,
                month: 1,
                dayOfMonth: 1,
                hour: Int64(hourCp.read()),
                minute: Int64(minuteCp.read()),
                second: Int64(secondCp.read())
            )
            LibC.free<UInt32>(yearCp)
            LibC.free<UInt32>(monthCp)
            LibC.free<UInt32>(dayCp)
            LibC.free<UInt32>(hourCp)
            LibC.free<UInt32>(minuteCp)
            LibC.free<UInt32>(secondCp)
            return SqlNullableTime(dateTime)
        }
    }
}

func getSqlTimestamp(buffer: CPointer<Unit>): SqlDbType {
    unsafe {
        var yearCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        var monthCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        var dayCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        var hourCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        var minuteCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        var secondCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        get_sql_time(buffer, yearCp, monthCp, dayCp, hourCp, minuteCp, secondCp);
        let dateTime: DateTime = DateTime.of(
            year: Int64(yearCp.read()),
            month: Int64(monthCp.read()),
            dayOfMonth: Int64(dayCp.read()),
            hour: Int64(hourCp.read()),
            minute: Int64(minuteCp.read()),
            second: Int64(secondCp.read())
        )
        LibC.free<UInt32>(yearCp)
        LibC.free<UInt32>(monthCp)
        LibC.free<UInt32>(dayCp)
        LibC.free<UInt32>(hourCp)
        LibC.free<UInt32>(minuteCp)
        LibC.free<UInt32>(secondCp)
        return SqlTimestamp(dateTime)
    }
}

func getSqlNullableTimestamp(buffer: CPointer<Unit>, isNull: CPointer<Unit>): SqlDbType {
    unsafe {
        let isNullCp: CPointer<Bool> = CPointer<Bool>(isNull)
        if (isNullCp.read()) {
            return SqlNullableTimestamp(None)
        } else {
            var yearCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            var monthCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            var dayCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            var hourCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            var minuteCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            var secondCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            get_sql_time(buffer, yearCp, monthCp, dayCp, hourCp, minuteCp, secondCp);
            let dateTime: DateTime = DateTime.of(
                year: Int64(yearCp.read()),
                month: Int64(monthCp.read()),
                dayOfMonth: Int64(dayCp.read()),
                hour: Int64(hourCp.read()),
                minute: Int64(minuteCp.read()),
                second: Int64(secondCp.read())
            )
            LibC.free<UInt32>(yearCp)
            LibC.free<UInt32>(monthCp)
            LibC.free<UInt32>(dayCp)
            LibC.free<UInt32>(hourCp)
            LibC.free<UInt32>(minuteCp)
            LibC.free<UInt32>(secondCp)
            return SqlNullableTimestamp(dateTime)
        }
    }
}

func getSqlDateTime(buffer: CPointer<Unit>): SqlDbType {
    unsafe {
        var yearCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        var monthCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        var dayCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        var hourCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        var minuteCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        var secondCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
        get_sql_time(buffer, yearCp, monthCp, dayCp, hourCp, minuteCp, secondCp);
        let dateTime: DateTime = DateTime.of(
            year: Int64(yearCp.read()),
            month: Int64(monthCp.read()),
            dayOfMonth: Int64(dayCp.read()),
            hour: Int64(hourCp.read()),
            minute: Int64(minuteCp.read()),
            second: Int64(secondCp.read())
        )
        LibC.free<UInt32>(yearCp)
        LibC.free<UInt32>(monthCp)
        LibC.free<UInt32>(dayCp)
        LibC.free<UInt32>(hourCp)
        LibC.free<UInt32>(minuteCp)
        LibC.free<UInt32>(secondCp)
        return SqlDateTime(dateTime)
    }
}

func getSqlNullableDateTime(buffer: CPointer<Unit>, isNull: CPointer<Unit>): SqlDbType {
    unsafe {
        let isNullCp: CPointer<Bool> = CPointer<Bool>(isNull)
        if (isNullCp.read()) {
            return SqlNullableDateTime(None)
        } else {
            var yearCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            var monthCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            var dayCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            var hourCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            var minuteCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            var secondCp: CPointer<UInt32> = LibC.malloc<UInt32>(count: 4)
            get_sql_time(buffer, yearCp, monthCp, dayCp, hourCp, minuteCp, secondCp);
            let dateTime: DateTime = DateTime.of(
                year: Int64(yearCp.read()),
                month: Int64(monthCp.read()),
                dayOfMonth: Int64(dayCp.read()),
                hour: Int64(hourCp.read()),
                minute: Int64(minuteCp.read()),
                second: Int64(secondCp.read())
            )
            LibC.free<UInt32>(yearCp)
            LibC.free<UInt32>(monthCp)
            LibC.free<UInt32>(dayCp)
            LibC.free<UInt32>(hourCp)
            LibC.free<UInt32>(minuteCp)
            LibC.free<UInt32>(secondCp)
            return SqlNullableDateTime(dateTime)
        }
    }
}

func getSqlDecimal(buffer: CPointer<Unit>): SqlDbType {
    unsafe {
        let valueCPointer: CPointer<UInt8> = CPointer<UInt8>(buffer)
        let cstirng: CString = CString(valueCPointer)
        return SqlDecimal(Decimal(cstirng.toString()))
    }
}

func getSqlNullableDecimal(buffer: CPointer<Unit>, isNull: CPointer<Unit>): SqlDbType {
    unsafe {
        let isNullCp: CPointer<Bool> = CPointer<Bool>(isNull)
        if (isNullCp.read()) {
            return SqlNullableDecimal(None)
        } else {
            let valueCPointer: CPointer<UInt8> = CPointer<UInt8>(buffer)
            let cstirng: CString = CString(valueCPointer)
            return SqlNullableDecimal(Decimal(cstirng.toString()))
        }
    }
}

func cjTypeToMysqlTypeQuery(sqlDbType: SqlDbType, bindsCP: CPointer<Unit>, index: Int64, length: Int64): Bool {
    unsafe {
        return match (sqlDbType) {
            // String----SqlChar----CHAR----CHAR----MYSQL_TYPE_STRING----char[]
            case _: SqlChar => get_string(bindsCP, index, length)
            case _: SqlNullableChar => get_string(bindsCP, index, length)

            // String----SqlVarchar----VARCHAR----VARCHAR----MYSQL_TYPE_VAR_STRING----char[]
            case _: SqlVarchar => get_string(bindsCP, index, length)
            case _: SqlNullableVarchar => get_string(bindsCP, index, length)

            // Array<Byte>----SqlBinary----BINARY----BINARY----MYSQL_TYPE_BLOB----char[]
            case _: SqlBinary => get_bytes(bindsCP, index, length)
            case _: SqlNullableBinary => get_bytes(bindsCP, index, length)

            // Array<Byte>----SqlVarBinary----VARBINARY----VARBINARY----MYSQL_TYPE_BLOB----char[]
            case _: SqlVarBinary => get_bytes(bindsCP, index, length)
            case _: SqlNullableVarBinary => get_bytes(bindsCP, index, length)

            // 长字符串，mysql输入对应表格没有给出，在输出表格有对应数据
            // Array<InputStream>----SqlClob----CLOB----LONGTEXT----MYSQL_TYPE_LONG_BLOB----char[]
            case _: SqlClob => get_clob(bindsCP, index, length)
            case _: SqlNullableClob => get_clob(bindsCP, index, length)

            // Array<InputStream>----SqlBlob----BLOB----BLOB----MYSQL_TYPE_BLOB----char[]
            case _: SqlBlob => get_blob(bindsCP, index, length)
            case _: SqlNullableBlob => get_blob(bindsCP, index, length)

            // 布尔类型在mysql数据库中表现形式是TINYINT
            // Bool----SqlBool----BOOLEAN----TINYINT----MYSQL_TYPE_TINY----signed char
            case _: SqlBool => get_bool(bindsCP, index)
            case _: SqlNullableBool => get_bool(bindsCP, index)

            // Int8----SqlByte----TINYINT----TINYINT----MYSQL_TYPE_TINY----signed char
            case _: SqlByte => get_int8(bindsCP, index)
            case _: SqlNullableByte => get_int8(bindsCP, index)

            // Int16----SqlSmallInt----SMALLINT----SMALLINT----MYSQL_TYPE_SHORT----short int
            case _: SqlSmallInt => get_int16(bindsCP, index)
            case _: SqlNullableSmallInt => get_int16(bindsCP, index)

            // SQL类型不同，但是数据值相对应
            // Int32----SqlInteger----INTEGER----INT----MYSQL_TYPE_LONG----int
            case _: SqlInteger => get_int32(bindsCP, index)
            case _: SqlNullableInteger => get_int32(bindsCP, index)

            // Int64----SqlBigInt----BIGINT----BIGINT----MYSQL_TYPE_LONGLONG----long long int
            case _: SqlBigInt => get_int64(bindsCP, index)
            case _: SqlNullableBigInt => get_int64(bindsCP, index)

            // SQL类型不同，但是数据值相对应
            // Float32----SqlReal----REAL----FLOAT----MYSQL_TYPE_FLOAT----float
            case _: SqlReal => get_float32(bindsCP, index)
            case _: SqlNullableReal => get_float32(bindsCP, index)

            // Float64----SqlDouble----DOUBLE----DOUBLE----MYSQL_TYPE_DOUBLE----double
            case _: SqlDouble => get_float64(bindsCP, index)
            case _: SqlNullableDouble => get_float64(bindsCP, index)

            // DateTime----SqlDate----DATE----DATE----MYSQL_TYPE_DATE----MYSQL_TIME
            case _: SqlDate => get_date(bindsCP, index)
            case _: SqlNullableDate => get_date(bindsCP, index)

            // DateTime----SqlTime----TIME----TIME----MYSQL_TYPE_TIME----MYSQL_TIME
            case _: SqlTime => get_time(bindsCP, index)
            case _: SqlNullableTime => get_time(bindsCP, index)

            // DateTime----SqlTimeTz----TIMETZ----TIME----MYSQL_TYPE_TIME----MYSQL_TIME
            // mysql不支持
            case _: SqlTimeTz => throw SqlException("Unsupported data type.")
            case _: SqlNullableTimeTz => throw SqlException("Unsupported data type.")

            // DateTime----SqlTimestamp----TIMESTAMP----TIMESTAMP----MYSQL_TYPE_TIMESTAMP----MYSQL_TIME
            case _: SqlTimestamp => get_timestamp(bindsCP, index)
            case _: SqlNullableTimestamp => get_timestamp(bindsCP, index)

            // Duration----SqlInterval----INTERVAL----DATE----MYSQL_TYPE_DATE----MYSQL_TIME
            // mysql不支持
            case _: SqlInterval => throw SqlException("Unsupported data type.")
            case _: SqlNullableInterval => throw SqlException("Unsupported data type.")

            // 自定义类
            // DATETIME----MYSQL_TYPE_DATETIME----MYSQL_TIME
            case _: SqlDateTime => get_date_time(bindsCP, index)
            case _: SqlNullableDateTime => get_date_time(bindsCP, index)

            // 自定义类
            // DECIMAL----MYSQL_TYPE_NEWDECIMAL
            case _: SqlDecimal => get_decimal(bindsCP, index, length)
            case _: SqlNullableDecimal => get_decimal(bindsCP, index, length)

            case _ => throw SqlException("Unsupported data type.")
        }
    }
}
