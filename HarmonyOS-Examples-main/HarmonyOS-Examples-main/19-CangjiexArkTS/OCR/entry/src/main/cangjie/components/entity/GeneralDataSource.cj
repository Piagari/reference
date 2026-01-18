/**
 * Created on 2025/5/28
 */
package ohos_app_cangjie_entry.components.entity

import ohos.component.DataChangeListener
import ohos.component.IDataSource

import std.collection.ArrayList

public enum ChangeType {
    ADD | UPDATE | DELETE
}

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

    public func notifyOneChange(idx: Int64, changeType!: ChangeType = ADD) {
        if (let ADD <- changeType) {
            listener.getOrThrow().onDataAdd(idx)
        } else if (let UPDATE <- changeType) {
            listener.getOrThrow().onDataChange(idx)
        } else {
            listener.getOrThrow().onDataDelete(idx)
        }
    }

    public func append(item: T) {
        data.append(item)
        notifyOneChange(data.size - 1)
    }

    public func insert(index: Int64, item: T) {
        data.insert(0, item)
        notifyChange()
    }

    public func set(data: ArrayList<T>) {
        this.data = data.clone()
        notifyChange()
    }

    public func update(index: Int64, item: T, notify!: Bool = true) {
        data[index] = item
        if (notify) {
            notifyOneChange(index, changeType: UPDATE)
        }
    }

    public func sortBy(comp: (T, T) -> Ordering): Unit {
        if (data.size > 1) {
            data.sortBy(stable: true, comparator: comp)
            notifyChange()
        }
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
        if (totalCount() == 0) {
            notifyChange()
        } else {
            notifyOneChange(index, changeType: DELETE)
        }
    }

    // 删除index之后的所有数据，不包括index位置的数据
    public func deleteSome(index: Int64) {
        var idx = data.size - 1;
        while (idx > index) {
            data.remove(idx)
            idx = idx - 1;
        }
        notifyChange()
    }

    public func find(check: (Int) -> Bool): Int {
        for (i in 0..this.totalCount()) {
            if (check(i)) {
                return i
            }
        }
        return -1
    }
}
