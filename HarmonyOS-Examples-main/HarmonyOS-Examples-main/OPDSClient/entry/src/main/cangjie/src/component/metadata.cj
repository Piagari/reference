/**
 * Created on 2024/8/24
 * 元数据组件，展示书的标题和简介
 */
package ohos_app_cangjie_entry.component

internal import encoding.json.stream.*
internal import std.collection.ArrayList
internal import ohos.{component.*, router.*, state_manage.*, base.*}
internal import ohos.hilog.*
internal import cj_res_entry.app
import ohos.state_macro_manage.*
import std.time.DateTime

@Component
protected class MetadataComponent {
    @Link
    var metadata: Metadata

    protected override func aboutToAppear() {
        Hilog.info(0, "test", "title:${metadata.title}")
    }
    func build() {
        if (metadata.description != "") {
            Column(10) {
                Text(metadata.title).fontSize(20).fontColor(@r(app.color.primary)).fontWeight(FontWeight.Medium)
                Text(metadata.modified.toString("yyyy/MM/dd")).fontSize(16).fontColor(@r(app.color.sub_text))
                Text(metadata.description).fontSize(18).fontColor(@r(app.color.primary))
            }.padding(left: 16, right: 16).transition(
                TransitionEffect.translate(TranslateOptions(y: 20.vp)).animation(
                AnimateParam(duration: 600, curve: Curve.Ease)))
        }
    }
}

@Observed
protected class Metadata {
    @Publish
    var title: String = "s"
    //    @Publish var conformsTo: String = ""
    @Publish
    var modified: DateTime = DateTime.now()
    @Publish
    var description: String = ""
    //    public var itemsPerPage: Int64 = -1
    //    public var currentPage: Int64 = -1
    //    public var numberOfItems: Int64 = -1
    //    public var numberOfPages: Int64 = -1
    //    public var contributor: ArrayList<String> = ArrayList<String>()
    //    public var seriesBelongTo: ArrayList<SeriesBelongTo> = ArrayList<SeriesBelongTo>()

    public static func fromJson(r: JsonReader): Metadata {
        var res = Metadata()
        while (let Some(v) <- r.peek()) {
            match (v) {
                case BeginObject =>
                    r.startObject()
                    while (r.peek() != EndObject) {
                        let n = r.readName()
                        match (n) {
                            case "title" => res.title = r.readValue<String>()
                            case "modified" => res.modified = DateTime.parse(r.readValue<String>())
                            case "description" => res.description = r.readValue<String>()
                            case _ => r.skip()
                        }
                    }
                    r.endObject()
                    break
                case _ => throw Exception()
            }
        }
        res
    }
}
