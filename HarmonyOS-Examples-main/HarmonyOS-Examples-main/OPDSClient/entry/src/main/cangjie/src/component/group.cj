/**
 * Created on 2024/8/24
 * 目录页的分类
 */
package ohos_app_cangjie_entry.component

import ohos.hilog.*
import ohos.state_macro_manage.*

@Component
protected class GroupComponent {
    @Link
    var group: Group

    func build() {
        Column(12) {
            ForEach(
                group.links,
                itemGeneratorFunc: {
                    item: Link, _: Int64 => LinkComponent(link: item, search: false, metadata: group.metadata)
                }
            )
            if (group.navigation.size == 0 && group.publications.size == 0) {
                Text("杂鱼没有任何东西捏~❤").fontSize(16).fontColor(@r(app.color.sub_text)).fontWeight(
                    FontWeight.Lighter)
            }
            Flex(FlexParams(wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center)) {
                ForEach(
                    group.navigation,
                    itemGeneratorFunc: {
                        item: Link, _: Int64 => NavigationComponent(navigation: item)
                    }
                )
            }.width(100.percent)
            Scroll {
                Row() {
                    ForEach(
                        group.publications,
                        itemGeneratorFunc: {
                            item: Publication, _: Int64 => PublicationComponent(publication: item)
                        }
                    )
                }
            }.width(100.percent).scrollable(ScrollDirection.Horizontal)
        }.width(100.percent).transition(
            TransitionEffect.translate(TranslateOptions(y: 20.vp)).animation(
            AnimateParam(duration: 1000, curve: Curve.Ease)))
    }
}

@Observed
protected class Group {
    @Publish
    var metadata: Metadata = Metadata()
    @Publish
    var links: ArrayList<Link> = ArrayList<Link>()
    @Publish
    var navigation: ArrayList<Link> = ArrayList<Link>()
    @Publish
    var publications: ArrayList<Publication> = ArrayList<Publication>()

    public static func fromJson(r: JsonReader): Group {
        var res = Group()
        while (let Some(v) <- r.peek()) {
            match (v) {
                case BeginObject =>
                    r.startObject()
                    while (r.peek() != EndObject) {
                        let n = r.readName()
                        match (n) {
                            case "metadata" => res.metadata = Metadata.fromJson(r)
                            case "links" => res.links = Link.fromJsonArray(r)
                            case "navigation" => res.navigation = Link.fromJsonArray(r)
                            case "publications" => res.publications = Publication.fromJsonArray(r)
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
    public static func fromJsonArray(r: JsonReader): ArrayList<Group> {
        r.startArray()
        var list = ArrayList<Group>()
        while (let Some(v) <- r.peek()) {
            match (v) {
                case BeginObject => list.append(Group.fromJson(r))
                case EndArray =>
                    r.endArray()
                    break
                case _ => throw Exception()
            }
        }
        list
    }
}
