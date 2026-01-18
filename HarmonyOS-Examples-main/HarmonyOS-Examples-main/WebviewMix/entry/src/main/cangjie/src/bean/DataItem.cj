/**
 * Created on 2024/9/10
 */
package ohos_app_cangjie_entry.bean
import serialization.serialization.*
import std.math.*
import encoding.json.*
import std.collection.*

// MARK: - Links+CourseItem
public class DataItem <:Serializable<DataItem>{

    public var articleList: Option<ArrayList<ArticleItem>> = Option<ArrayList<ArticleItem>>.None
    public var author: String = ""
    public var children: Array<String> = [] //为空，添加String
    public var courseId: Int64 = 0
    public var cover:String = ""
    public var desc: String = ""
    public var id: Int64 = 0
    public var lisense:String = ""
    public var lisenseLink: String = ""
    public var name: String = ""
    public var order:Int64 = 0
    public var parentChapterId:Int64 = 0
    //public var `type`: Int64 = 0 //此处解析易出错
    public var userControlSetTop: Bool = false
    public var visible: Int64 = 0

    public func serialize(): DataModel {
        return DataModelStruct()
        .add(field<Option<ArrayList<ArticleItem>>>("articleList", articleList))
        .add(field<String>("author", author))
        .add(field<Array<String>>("children", children))
        .add(field<Int64>("courseId", courseId))
        .add(field<String>("cover", cover))
        .add(field<String>("desc", desc))
        .add(field<Int64>("id", id))
        .add(field<String>("lisense", lisense))
        .add(field<String>("lisenseLink", lisenseLink))
        .add(field<String>("name", name))
        .add(field<Int64>("order", order))
        .add(field<Int64>("parentChapterId", parentChapterId))
        //.add(field<Int64>("`type`", `type`))
        .add(field<Bool>("userControlSetTop", userControlSetTop))
        .add(field<Int64>("visible", visible))

    }
    public static func deserialize(dm: DataModel): DataItem {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = DataItem()
        result.articleList = Option<ArrayList<ArticleItem>>.deserialize(dms.get("articleList"))
        result.author = String.deserialize(dms.get("author"))
        result.children = Array<String>.deserialize(dms.get("children"))
        result.courseId = Int64.deserialize(dms.get("courseId"))
        result.cover = String.deserialize(dms.get("cover"))
        result.desc = String.deserialize(dms.get("desc"))
        result.id = Int64.deserialize(dms.get("id"))
        result.lisense = String.deserialize(dms.get("lisense"))
        result.lisenseLink = String.deserialize(dms.get("lisenseLink"))
        result.name = String.deserialize(dms.get("name"))
        result.order = Int64.deserialize(dms.get("order"))
        result.parentChapterId = Int64.deserialize(dms.get("parentChapterId"))
        //result.`type` = Int64.deserialize(dms.get("type"))
        result.userControlSetTop = Bool.deserialize(dms.get("userControlSetTop"))
        result.visible = Int64.deserialize(dms.get("visible"))

        return  result

    }

}