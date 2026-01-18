/**
 * Created on 2024/10/24
 */
package ohos_app_cangjie_entry.util

import ohos.base.*
import ohos.component.*
import std.collection.ArrayList

public class GeneralDataSource<T> <: IDataSource<T> {
  public let data: ArrayList<T>

  public init(data: Array<T>) {
    this.data = ArrayList<T>(data)
  }

  public init(data: ArrayList<T>) {
    this.data = data
  }

  public var listener: Option<DataChangeListener> = None

  public func totalCount(): Int64 {
    return data.size
  }

  public func getData(index: Int64): T {
    return data[index]
  }

  public func onRegisterDataChangeListener(listener: DataChangeListener): Unit {
    this.listener = listener
  }

  public func onUnregisterDataChangeListener(listener: DataChangeListener): Unit {
    this.listener = None
  }

  public func notifyChange() {
    listener.getOrThrow().onDataReloaded()
  }

  public func append(item: T) {
    data.append(item)
    notifyChange()
  }
  public func set(index: Int64,item: T) {
    data[index] = item
    notifyChange()
  }
}