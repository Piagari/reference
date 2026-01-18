/**
 * Created on 2025年6月11日
 */
package ohos_app_cangjie_entry


/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import std.collection.ArrayList

/**
 * 基础DataSource
 */
public open class MessageBaseDataSource<T> <: IDataSource<T> {
    public MessageBaseDataSource(let data_: ArrayList<T>) {}

    public var listener: ?DataChangeListener = None

    /**
     * 获得数据总数。
     *
     * @return 数据总数
     */
    public override func totalCount(): Int {
        return data_.size
    }

    /**
     * 获取索引值index对应的数据
     *
     * @param index 索引值
     * @return 数据
     */
    public override func getData(index: Int): T {
        return data_[index]
    }

    /**
     * 获取所有的数据
     *
     * @return 所有的数据
     */
    public func getAllData(): ArrayList<T> {
        return data_
    }

    /**
     * 注册数据改变的监听器
     *
     * @param listener 监听器
     */
    public override func onRegisterDataChangeListener(listener: DataChangeListener): Unit {
        this.listener = listener
    }

    /**
     * 注销数据改变的监听器。
     *
     * @param listener 监听器
     */
    public override func onUnregisterDataChangeListener(listener: DataChangeListener): Unit {
        this.listener = None
    }

    /**
     * 通知组件重新加载所有数据。
     */
    public func notifyChange(): Unit {
        this.listener?.onDataReloaded()
    }

    /**
     * 通知组件index的位置有数据添加。
     *
     * @param index 位置
     */
    public func notifyDataAddChange(index: Int): Unit {
        this.listener?.onDataAdd(index)
    }

    /**
     * 通知组件删除index位置的数据并刷新LazyForEach的展示内容。
     *
     * @param index 位置
     */
    public func notifyDataDeleteChange(index: Int): Unit {
        this.listener?.onDataDelete(index)
    }

    /**
     * 通知组件index的位置有数据有变化。
     *
     * @param index 位置
     */
    public func notifyDataChange(index: Int): Unit {
        this.listener?.onDataChange(index)
    }

    /**
     * 通知组件数据有移动。
     *
     * @param fromIdx 数据移动起始位置。
     * @param toIdx 数据移动目标位置。
     */
    public func notifyDataMoveChange(fromIdx: Int64, toIdx: Int64): Unit {
        this.listener?.onDataMove(fromIdx, toIdx)
    }

    /**
     * 在列表最后添加ArrayList列表
     *
     * @param datas 列表
     */
    public func addDatas(datas: ArrayList<T>) {
        for (item in datas) {
            addData(item)
        }
    }

    /**
     * 在列表最后添加Array列表
     *
     * @param datas 列表
     */
    public func addDatas(datas: Array<T>) {
        for (item in datas) {
            addData(item)
        }
    }

    /**
     * 在列表最后添加一条数据
     *
     * @param data 一条数据
     */
    public func addData(data: T): Unit {
        let index = totalCount()
        data_.append(data)
        notifyDataAddChange(index)
    }

    /**
     * 删除一条数据
     *
     * @param index 一条数据
     */
    public func deleteData(index: Int): Unit {
        data_.remove(index)
        notifyDataDeleteChange(index)
    }

    /**
     * 删除一条数据,并刷新页面
     *
     * @param index 一条数据
     */
    public func removeData(index: Int): Unit {
        data_.remove(index)
    }

    /**
     * 在index位置更新数据,并刷新页面
     *
     * @param index 位置
     * @param data 一条数据
     */
    public func replaceData(index: Int, data: T): Unit {
        data_.set(index, data)
        notifyDataChange(index)
    }

    /**
     * 在index位置更新数据
     *
     * @param index 位置
     * @param data 一条数据
     */
    public func update(index: Int, data: T): Unit {
        data_.set(index, data)
    }

    /**
     * 清空数据
     */
    public func clear(): Unit {
        data_.clear()
        notifyChange()
    }
}

/**
 * Message DataSource
 */
public class MessageDataSource <: MessageBaseDataSource<Message> {
    public MessageDataSource(let data: ArrayList<Message>) {
        super(data)
    }
}
