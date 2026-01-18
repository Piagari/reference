/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package mysqlclient_ffi

/*
 * 执行Insert、Update、Delete语句产生的结果
 */
public class MysqlUpdateResult <: UpdateResult {
    private var rows: Int64
    private var stmt: CPointer<Unit>

    /*
     * 初始化执行Insert、Update、Delete语句产生的结果
     *
     * 参数 rows - 影响的行数
     * 参数 mysql - 初始化的mysql
     */
    init(rows: Int64, stmt: CPointer<Unit>) {
        this.rows = rows
        this.stmt = stmt
    }

    /*
     * 执行Insert,Update,Delete语句影响的行数
     */
    public override prop rowCount: Int64 {
        get() {
            return rows
        }
    }

    /*
     * 执行Insert语句自动生成的最后rowID，如果不支持则为0
     */
    public override prop lastInsertId: Int64 {
        get() {
            unsafe {
                return Int64(mysql_stmt_insert_id(stmt))
            }
        }
    }
}
