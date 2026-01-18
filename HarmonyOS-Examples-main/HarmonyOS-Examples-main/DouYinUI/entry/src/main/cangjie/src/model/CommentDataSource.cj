/**
 * Created on 2024/10/8
 */
package ohos_app_cangjie_entry.model

internal import ohos.component.*
import std.collection.*

//评论数据懒加载数据源
public class CommentDataSource <: IDataSource<CommentDataModel> {
    public CommentDataSource(public let data_: ArrayList<CommentDataModel>) {}
    public var listenerOp: Option<DataChangeListener> = None

    public func totalCount(): Int64 {
        return data_.size
    }

    public func getData(index: Int64): CommentDataModel {
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
}
