/**
 * Created on 2024/9/11
 */
package ohos_app_cangjie_entry.bean
import serialization.serialization.*
import std.math.*
import encoding.json.*
import std.collection.*

// MARK: - Links
public open class BaseBean <:Serializable<BaseBean>{

    public open func serialize(): DataModel {

        return DataModelStruct()

    }
    public static  func deserialize(dm: DataModel): BaseBean {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = BaseBean()

        return  result
    }
}