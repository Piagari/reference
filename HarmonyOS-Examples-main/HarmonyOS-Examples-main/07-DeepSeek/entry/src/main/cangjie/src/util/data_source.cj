/**
 * Created on 2024/10/24
 */
package ohos_app_cangjie_entry.util

import ohos.base.*
import ohos.component.*
import std.collection.ArrayList

public class GeneralDataSource<T> <: IDataSource<T> {
    var data: ArrayList<T>
    var listener: Option<DataChangeListener> = None

    public init() {
        this.data = ArrayList<T>()
    }

    public init(data: Array<T>) {
        this.data = ArrayList<T>(data)
    }

    public init(data: ArrayList<T>) {
        this.data = data
    }

    public override func totalCount(): Int64 {
        data.size
    }

    public override func getData(index: Int64): T {
        data[index]
    }

    public override func onRegisterDataChangeListener(listener: DataChangeListener) {
        this.listener = listener
    }

    public override func onUnregisterDataChangeListener(listener: DataChangeListener) {
        this.listener = None
    }

    public operator func [](index: Int64): T {
        data[if (index < 0) {
            data.size + index
        } else {
            index
        }]
    }

    public func notifyChange() { // 不要在 aboutToAppear 中调用，因为 DataChangeListener 还未初始化
        listener.getOrThrow().onDataReloaded()
    }

    public func append(item: T) {
        data.append(item)
        notifyChange()
    }

    public func set(data: ArrayList<T>) {
        this.data = data.clone()
        notifyChange()
    }

    public func update(index: Int64, item: T) {
        data[index] = item
        notifyChange()
    }

    public func get(): Array<T> {
        data.toArray()
    }

    public func clear() {
        data.clear()
        notifyChange()
    }

    public func delete(index: Int64) {
        data.remove(index)
        notifyChange()
    }
}