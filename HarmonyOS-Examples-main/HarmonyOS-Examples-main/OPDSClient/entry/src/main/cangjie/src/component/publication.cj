/**
 * Created on 2024/8/26
 * 具体书的详情组件
 */
package ohos_app_cangjie_entry.component

import ohos.state_macro_manage.*

@Component
protected class PublicationComponent {
    @Link
    var publication: Publication = Publication()

    func build() {
        Column {
            Image(publication.images[0].href).width(100).borderStyle(BorderStyle.Solid).borderWidth(1).borderColor(
                @r(app.color.border)).borderRadius(8)//.transition(TransitionEffect.OPACITY)
            Text(publication.metadata.title).fontSize(16).margin(8).fontColor(@r(app.color.primary))
        }.margin(right: 16).onClick(
            {
            evt => for (item in publication.links) {
                if (item.rel == "self") {
                    Router.push(url: "Content", params: item.href)
                }
            }
        })
    }
}

@Observed
protected class Publication {
    @Publish
    var metadata: Metadata = Metadata()
    var context: String = ""
    @Publish
    var links: ArrayList<Link> = ArrayList<Link>()
    @Publish
    var images: ArrayList<Link> = ArrayList<Link>()
    var readingOrder: ArrayList<Link> = ArrayList<Link>()
    var resources: ArrayList<Link> = ArrayList<Link>()
    var toc: ArrayList<Link> = ArrayList<Link>()
    var landmarks: ArrayList<Link> = ArrayList<Link>()
    var pageList: ArrayList<Link> = ArrayList<Link>()
    //    public var publications:ArrayList<Publication> = ArrayList<Publication>()

    public static func fromJson(r: JsonReader): Publication {
        var res = Publication()
        while (let Some(v) <- r.peek()) {
            match (v) {
                case BeginObject =>
                    r.startObject()
                    while (r.peek() != EndObject) {
                        let n = r.readName()
                        match (n) {
                            case "metadata" => res.metadata = Metadata.fromJson(r)
                            case "images" => res.images = Link.fromJsonArray(r)
                            case "links" => res.links = Link.fromJsonArray(r)
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
    public static func fromJsonArray(r: JsonReader): ArrayList<Publication> {
        r.startArray()
        var list = ArrayList<Publication>()
        while (let Some(v) <- r.peek()) {
            match (v) {
                case BeginObject => list.append(Publication.fromJson(r))
                case EndArray =>
                    r.endArray()
                    break
                case _ => throw Exception()
            }
        }
        list
    }
}
