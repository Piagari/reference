/**
 * Created on 2024/9/10
 */
package ohos_app_cangjie_entry.bean
import serialization.serialization.*
import std.math.*
import encoding.json.*
import std.collection.*

public class SearchData <:Serializable<SearchData>{

    public var curPage:Int64 = 0
    public var datas:Option<ArrayList<ArticleItem>> = Option<ArrayList<ArticleItem>>.None
    public var offset:Int64 = 0
    public var over:Bool = false
    public var pageCount:Int64 = 0
    public var size:Int64 = 0
    public var total:Int64 = 0

    public func serialize(): DataModel {
        return DataModelStruct()
        .add(field<Int64>("curPage", curPage))
        .add(field<Option<ArrayList<ArticleItem>>>("datas", datas))
        .add(field<Int64>("offset", offset))
        .add(field<Bool>("over", over))
        .add(field<Int64>("pageCount", pageCount))
        .add(field<Int64>("size", size))
        .add(field<Int64>("total", total))

    }
    public static func deserialize(dm: DataModel): SearchData {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = SearchData()
        result.curPage = Int64.deserialize(dms.get("curPage"))
        result.datas = Option<ArrayList<ArticleItem>>.deserialize(dms.get("datas"))
        result.offset = Int64.deserialize(dms.get("offset"))
        result.over = Bool.deserialize(dms.get("over"))
        result.pageCount = Int64.deserialize(dms.get("pageCount"))
        result.size = Int64.deserialize(dms.get("size"))
        result.total = Int64.deserialize(dms.get("total"))

        return  result

    }


}