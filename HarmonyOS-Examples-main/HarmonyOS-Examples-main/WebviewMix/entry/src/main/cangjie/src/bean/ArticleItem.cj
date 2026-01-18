/**
 * Created on 2024/9/10
 */
package ohos_app_cangjie_entry.bean
import serialization.serialization.*
import std.math.*
import encoding.json.*
import std.collection.*

// MARK: - ArticleList-文章Item
public class ArticleItem <:Serializable<ArticleItem>{

    public var adminAdd: Bool = false
    public var apkLink: String = ""
    public var audit: Int64 = 1
    public var author: String = ""
    public var canEdit: Bool = false
    public var chapterId: Int64 = 0
    public var chapterName: String = ""
    public var collect: Bool = false
    public var courseId: Int64 = 1
    public var desc: String = ""
    public var descMd : String = ""
    public var envelopePic: String = ""
    public var fresh: Bool = false
    public var host: String = ""
    public var id: Int64 = 0
    public var isAdminAdd: Bool = false
    public var link: String = ""
    public var niceDate: String = ""
    public var niceShareDate: String = ""
    public var origin: String = ""
    public var prefix: String = ""
    public var projectLink: String = ""
    public var publishTime: Int64 = 0
    public var realSuperChapterId: Int64 = 0
    public var selfVisible: Int64 =0
    public var shareDate: Int64 = 0
    public var shareUser: String = ""
    public var superChapterId: Int64 = 0
    public var superChapterName: String = ""
    public var tags: Option<Array<TagItem>> = Option<Array<TagItem>>.None
    public var title: String = ""
    //public var `type`:Int64 = 0
    public var userId:Int64 = 0
    public var visible:Int64 = 0
    public var zan: Int64 =0

    public func serialize(): DataModel {
        return DataModelStruct()
         .add(field<Bool>("adminAdd", adminAdd))
         .add(field<String>("apkLink", apkLink))
         .add(field<Int64>("audit", audit))
         .add(field<String>("author", author))
         .add(field<Bool>("canEdit", canEdit))
         .add(field<Int64>("chapterId", chapterId))
         .add(field<String>("chapterName", chapterName))
         .add(field<Bool>("collect", collect))
         .add(field<Int64>("courseId", courseId))
         .add(field<String>("desc", desc))
         .add(field<String>("descMd", descMd))
         .add(field<String>("envelopePic", envelopePic))
         .add(field<Bool>("fresh", fresh))
         .add(field<String>("host", host))
         .add(field<Int64>("id", id))
         .add(field<Bool>("isAdminAdd", isAdminAdd))
         .add(field<String>("link", link))
         .add(field<String>("niceDate", niceDate))
         .add(field<String>("niceShareDate", niceShareDate))
         .add(field<String>("origin", origin))
         .add(field<String>("prefix", prefix))
         .add(field<String>("projectLink", projectLink))
         .add(field<Int64>("publishTime", publishTime))
         .add(field<Int64>("realSuperChapterId", realSuperChapterId))
         .add(field<Int64>("selfVisible", selfVisible))
         .add(field<Int64>("shareDate", shareDate))
         .add(field<String>("shareUser", shareUser))
         .add(field<Int64>("superChapterId", superChapterId))
         .add(field<String>("superChapterName", superChapterName))
         .add(field<Option<Array<TagItem>>>("tags", tags))
         .add(field<String>("title", title))
         //.add(field<Int64>("`type`", `type`))
         .add(field<Int64>("userId", userId))
         .add(field<Int64>("visible", visible))
         .add(field<Int64>("zan", zan))
    }
        public static func deserialize(dm: DataModel): ArticleItem {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = ArticleItem()
        result.adminAdd = Bool.deserialize(dms.get("adminAdd"))
        result.apkLink = String.deserialize(dms.get("apkLink"))
        result.audit = Int64.deserialize(dms.get("audit"))
        result.author = String.deserialize(dms.get("author"))
        result.canEdit = Bool.deserialize(dms.get("canEdit"))
        result.chapterId = Int64.deserialize(dms.get("chapterId"))
        result.chapterName = String.deserialize(dms.get("chapterName"))
        result.collect = Bool.deserialize(dms.get("collect"))
        result.courseId = Int64.deserialize(dms.get("courseId"))
        result.desc = String.deserialize(dms.get("desc"))
        result.descMd = String.deserialize(dms.get("descMd"))
        result.envelopePic = String.deserialize(dms.get("envelopePic"))
        result.fresh = Bool.deserialize(dms.get("fresh"))
        result.host = String.deserialize(dms.get("host"))
        result.id = Int64.deserialize(dms.get("id"))
        result.isAdminAdd = Bool.deserialize(dms.get("isAdminAdd"))
        result.link = String.deserialize(dms.get("link"))
        result.niceDate = String.deserialize(dms.get("niceDate"))
        result.niceShareDate = String.deserialize(dms.get("niceShareDate"))
        result.origin = String.deserialize(dms.get("origin"))
        result.prefix = String.deserialize(dms.get("prefix"))
        result.projectLink = String.deserialize(dms.get("projectLink"))
        result.publishTime = Int64.deserialize(dms.get("publishTime"))
        result.realSuperChapterId = Int64.deserialize(dms.get("realSuperChapterId"))
        result.selfVisible = Int64.deserialize(dms.get("selfVisible"))
        result.shareDate = Int64.deserialize(dms.get("shareDate"))
        result.shareUser = String.deserialize(dms.get("shareUser"))
        result.superChapterId = Int64.deserialize(dms.get("superChapterId"))
        result.superChapterName = String.deserialize(dms.get("superChapterName"))
        result.tags = Array<TagItem>.deserialize(dms.get("tags"))
        result.title = String.deserialize(dms.get("title"))
        //result.`type` = Int64.deserialize(dms.get("type"))
        result.userId = Int64.deserialize(dms.get("userId"))
        result.visible = Int64.deserialize(dms.get("visible"))
        result.zan = Int64.deserialize(dms.get("zan"))
        return result
    }

}