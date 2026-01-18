/**
 * Created on 2024/8/23
 */
package ohos_app_cangjie_entry.model

import ohos.component.*
import std.collection.*


//视频数据懒加载数据源
public class VideoDataSource <: IDataSource<VideoDataModel> {
    public VideoDataSource(let data_: ArrayList<VideoDataModel>) {}
    public var listenerOp: Option<DataChangeListener> = None
    public func getData(index: Int64): VideoDataModel {
        return data_[index]
    }

    public func onRegisterDataChangeListener(listener: DataChangeListener): Unit {
        listenerOp = listener
    }

    public func onUnregisterDataChangeListener(listener: DataChangeListener): Unit {
        listenerOp = None
    }

    public func notifyChange(): Unit {
        let listener: DataChangeListener = listenerOp.getOrThrow()
        listener.onDataReloaded()
    }

    public func totalCount(): Int64 {
        return data_.size
    }
}