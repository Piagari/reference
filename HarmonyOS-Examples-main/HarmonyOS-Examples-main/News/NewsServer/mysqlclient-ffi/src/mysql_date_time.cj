/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package mysqlclient_ffi

/*
 * 年、月、日、时、分、秒不包含时区
 */
public class SqlDateTime <: SqlDbType {
    private var dateTime: DateTime

    /*
     * 初始化SQL数据类型
     *
     * 参数 dateTime - 日期数据
     */
    public init(dateTime: DateTime) {
        this.dateTime = dateTime
    }

    /*
     * 数据
     */
    public mut prop value: DateTime {
        get() {
            dateTime
        }
        set(value) {
            dateTime = value
        }
    }

    /*
     * 类型名称
     */
    public prop name: String {
        get() {
            "SqlTimestampWithoutTz"
        }
    }
}

/*
 * 年、月、日、时、分、秒不包含时区，数据可能为None
 */
public class SqlNullableDateTime <: SqlNullableDbType {
    private var dateTime: ?DateTime

    /*
     * 初始化SQL数据类型
     *
     * 参数 dateTime - 日期数据
     */
    public init(dateTime: ?DateTime) {
        this.dateTime = dateTime
    }

    /*
     * 数据
     */
    public mut prop value: ?DateTime {
        get() {
            dateTime
        }
        set(value) {
            dateTime = value
        }
    }

    /*
     * 类型名称
     */
    public prop name: String {
        get() {
            "SqlNullableTimestampWithoutTz"
        }
    }
}
