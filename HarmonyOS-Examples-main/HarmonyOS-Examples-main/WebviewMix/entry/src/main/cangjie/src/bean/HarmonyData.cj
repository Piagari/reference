/**
 * Created on 2024/9/10
 */
package ohos_app_cangjie_entry.bean
import serialization.serialization.*
import std.math.*
import encoding.json.*
import std.collection.*

public class HarmonyData <:Serializable<HarmonyData>{

    public var links:Option<DataItem> = Option<DataItem>.None
    public var open_sources:Option<DataItem> = Option<DataItem>.None
    public var tools:Option<DataItem> = Option<DataItem>.None

    public func serialize(): DataModel {

        return DataModelStruct()
         .add(field<Option<DataItem>>("links", links))
         .add(field<Option<DataItem>>("open_sources", open_sources))
         .add(field<Option<DataItem>>("tools", tools))
    }

    public static func deserialize(dm: DataModel): HarmonyData {

        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = HarmonyData()
        result.links = Option<DataItem>.deserialize(dms.get("links"))
        result.open_sources = Option<DataItem>.deserialize(dms.get("open_sources"))
        result.tools = Option<DataItem>.deserialize(dms.get("tools"))

        return  result

    }
}
