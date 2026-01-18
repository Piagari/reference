/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package mysqlclient_ffi

/*
 * 执行Select/Query语句返回结果的列信息
 */
public class MysqlColumnInfo <: ColumnInfo {
    private var nameString: String
    private var typeNameString: String
    private var displaySizeInt64: Int64
    private var lengthInt64: Int64
    private var scaleInt64: Int64
    private var nullableBool: Bool

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
    public init(name: String, typeName: String, displaySize: Int64, length: Int64, scale: Int64, nullable: Bool) {
        this.nameString = name
        this.typeNameString = typeName
        this.displaySizeInt64 = displaySize
        this.lengthInt64 = length
        this.scaleInt64 = scale
        this.nullableBool = nullable
    }

    /*
     * 列名或者别名
     */
    public override prop name: String {
        get() {
            return nameString
        }
    }

    /*
     * 列类型名称，如果在SqlDataType中定义
     * 返回SqlDataType.toString(),如果未在SqlDataType中定义，由数据库驱动定义
     */
    public override prop typeName: String {
        get() {
            return typeNameString
        }
    }

    /*
     * 列值的最大显示长度，如果无限制，则应该返回Int64.Max（仍然受数据库的限制）
     */
    public override prop displaySize: Int64 {
        get() {
            return displaySizeInt64
        }
    }

    /**
     * 获取列值大小。
     */
    public override prop length: Int64 {
        get() {
            return lengthInt64
        }
    }

    /*
     * 列值的小数长度，如果无小数部分，返回0
     */
    public override prop scale: Int64 {
        get() {
            return scaleInt64
        }
    }

    /*
     * 列值是否允许数据库Null值
     */
    public override prop nullable: Bool {
        get() {
            return nullableBool
        }
    }
}
