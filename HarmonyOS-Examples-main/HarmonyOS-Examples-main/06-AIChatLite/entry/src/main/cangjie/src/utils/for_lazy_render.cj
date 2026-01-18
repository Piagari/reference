/**
 * Created on 2024/10/24
 */
package ohos_app_cangjie_entry.utils

import ohos.base.*
import ohos.component.*
import std.collection.ArrayList

public class GeneralDataSource<T> <: IDataSource<T> {
    public let data: ArrayList<T>
    public var listener: Option<DataChangeListener> = None

    public init(data: Array<T>) {
        this.data = ArrayList<T>(data)
    }

    public init(data: ArrayList<T>) {
        this.data = data
    }

    // 实现 IDataSource 的接口函数
    public override func totalCount(): Int64 {
        return data.size
    }

    public override func getData(index: Int64): T {
        return data[index]
    }

    public override func onRegisterDataChangeListener(listener: DataChangeListener): Unit {
        this.listener = listener
    }

    public override func onUnregisterDataChangeListener(listener: DataChangeListener): Unit {
        this.listener = None
    }

    public func append(item: T) {
        data.append(item)
        listener?.onDataReloaded()
    }

    public func get(index: Int64): T {
        if (index < 0) {
            data[data.size + index]
        } else {
            data[index]
        }
    }

    public func set(index: Int64, item: T) {
        if (index < 0) {
            data[data.size + index] = item
        } else {
            data[index] = item
        }
        listener?.onDataReloaded()
    }
}