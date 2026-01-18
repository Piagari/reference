/**
 * Created on 2024/9/10
 */
package ohos_app_cangjie_entry.bean
import serialization.serialization.*
import std.math.*
import encoding.json.*
import std.collection.*

/**
* 接口：https://wanandroid.com/harmony/index/json
*/

public class HarmonyBean <:Serializable<HarmonyBean> {
     public var data: Option<HarmonyData> = Option<HarmonyData>.None
     public var errorCode:Int64 = 0
     public var errorMsg:String = ""

   public func serialize(): DataModel {
        return DataModelStruct()
                .add(field<Option<HarmonyData>>("data", data))
                .add(field<Int64>("errorCode", errorCode))
                .add(field<String>("errorMsg", errorMsg))

    }

    public static func deserialize(dm: DataModel): HarmonyBean {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = HarmonyBean()
        result.data = Option<HarmonyData>.deserialize(dms.get("data"))
        result.errorCode = Int64.deserialize(dms.get("errorCode"))
        result.errorMsg = String.deserialize(dms.get("errorMsg"))

        return  result

    }
}
