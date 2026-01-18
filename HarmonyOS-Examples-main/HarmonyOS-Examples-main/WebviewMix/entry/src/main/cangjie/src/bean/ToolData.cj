/**
 * Created on 2024/9/11
 */
package ohos_app_cangjie_entry.bean
import serialization.serialization.*
import std.math.*
import encoding.json.*
import std.collection.*

// MARK: - 工具-工具data
public class ToolData <:Serializable<ToolData>{

    public var data: Option<ArrayList<ToolItem>> = Option<ArrayList<ToolItem>>.None


    public func serialize(): DataModel {
        return DataModelStruct()
         .add(field<Option<ArrayList<ToolItem>>>("data", data))

    }
        public static func deserialize(dm: DataModel): ToolData {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = ToolData()
        result.data = Option<ArrayList<ToolItem>>.deserialize(dms.get("data"))

        return result
    }

}