/**
 * Created on 2024/9/11
 */
package ohos_app_cangjie_entry.bean
import serialization.serialization.*
import std.math.*
import encoding.json.*
import std.collection.*

// MARK: - 工具-工具Item
public class ToolItem <:Serializable<ToolItem>{

    public var desc: String = ""
    public var icon: String = ""
    public var id: Int64 = 0
    public var isNew: Int64 = 0
    public var link: String = ""
    public var name: String = ""
    public var order: Int64 = 0
    public var showInTab: Int64 = 0
    public var tabName: String = ""
    public var visible: Int64 = 0


    public func serialize(): DataModel {
        return DataModelStruct()
         .add(field<String>("desc", desc))
         .add(field<String>("icon", icon))
         .add(field<Int64>("id", id))
         .add(field<Int64>("isNew", isNew))
         .add(field<String>("link", link))
         .add(field<String>("name", name))
         .add(field<Int64>("order", order))
         .add(field<Int64>("showInTab", showInTab))
         .add(field<String>("tabName", tabName))
        .add(field<Int64>("visible", visible))


    }
    public static func deserialize(dm: DataModel): ToolItem {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = ToolItem()
        result.desc = String.deserialize(dms.get("desc"))
        result.icon = String.deserialize(dms.get("icon"))
        result.id = Int64.deserialize(dms.get("id"))
        result.isNew = Int64.deserialize(dms.get("isNew"))
        result.link = String.deserialize(dms.get("link"))
        result.name = String.deserialize(dms.get("name"))
        result.order = Int64.deserialize(dms.get("order"))
        result.showInTab = Int64.deserialize(dms.get("showInTab"))
        result.tabName = String.deserialize(dms.get("tabName"))
        result.visible = Int64.deserialize(dms.get("visible"))

        return result
    }

}