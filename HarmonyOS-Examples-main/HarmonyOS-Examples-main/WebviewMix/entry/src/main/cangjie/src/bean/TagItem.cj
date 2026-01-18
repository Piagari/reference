/**
 * Created on 2024/9/10
 */
package ohos_app_cangjie_entry.bean
import serialization.serialization.*
import std.math.*
import encoding.json.*
import std.collection.*

public class TagItem <:Serializable<TagItem> {

     public var name:String = ""
     public var url:String = ""


   public func serialize(): DataModel {
        return DataModelStruct()
                .add(field<String>("name", name))
                .add(field<String>("url", url))

    }

    public static func deserialize(dm: DataModel): TagItem {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = TagItem()
        result.name = String.deserialize(dms.get("name"))
        result.url = String.deserialize(dms.get("url"))

        return  result

    }
}
