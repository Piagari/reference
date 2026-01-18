/**
 * Created on 2024/8/24
 * 超链接按钮
 */
package ohos_app_cangjie_entry.component

import ohos.state_macro_manage.*

extend Image {
    func icon() {
        this.fillColor(@r(app.color.primary)).width(24)
    }
}

@Component
protected class LinkComponent {
    @Link
    var link: Link
    @Link
    var metadata: Metadata
    @State
    var flexGrow: Int64 = 0
    @Link
    var search: Bool = false
    @State
    var keyWord: String = ""
    protected override func aboutToAppear() {
        if (link.rel == "self") {
            this.flexGrow = 1
        }
    }

    func build() {
        Row(18) {
            if (link.rel == "search") {
                if (search) {
                    TextInput(placeholder: '输入关键词', text: this.keyWord).width(80.percent).height(36).onChange(
                        {
                        value: String => this.keyWord = value
                    }).onBlur({
                        => search = false
                    }).id("search_input").onAppear({
                        => FocusControl.requestFocus("search_input")
                    }).onSubmit(
                        {
                        key => Router.push(url: "Content", params: link.href.replace("{?query}", "?query=${keyWord}"))
                    }).transition(
                        TransitionEffect.OPACITY.animation(
                        AnimateParam(duration: 1000, curve: Curve.Ease)))
                }
                Image(@r(app.media.search)).icon().onClick(
                    {
                        evt =>
                        if (search) {
                            Router.push(url: "Content", params: link.href.replace("{?query}", "?query=${keyWord}"))
                        }
                        search = true
                    }
                )
            } else if (link.rel == "self") {
                if (!search && metadata.description == "") {
                    Text(metadata.title).fontSize(22).fontColor(@r(app.color.primary)).fontWeight(FontWeight.Medium).
                        onClick({
                        evt => Router.push(url: "Content", params: link.href)
                    })
                }
            } else if (link.rel == "previous") {
                Image(@r(app.media.back)).icon().onClick({
                    evt => Router.push(url: "Content", params: link.href)
                })
            } else if (link.rel == "next") {
                Image(@r(app.media.back)).icon().rotateY(180).onClick(
                    {
                    evt => Router.push(url: "Content", params: link.href)
                })
            }
        }.flexGrow(flexGrow)
    }
}

@Observed
protected class Link {
    @Publish
    var title: String = ""
    @Publish
    public var rel: String = ""
    @Publish
    public var href: String = ""
    @Publish
    public var type_u: String = ""
    //    public var templated: Bool

    public static func fromJson(r: JsonReader): Link {
        var res = Link()
        while (let Some(v) <- r.peek()) {
            match (v) {
                case BeginObject =>
                    r.startObject()
                    while (r.peek() != EndObject) {
                        let n = r.readName()
                        match (n) {
                            case "title" => res.title = r.readValue<String>()
                            case "rel" => res.rel = r.readValue<String>()
                            case "href" => res.href = r.readValue<String>()
                            case "type_u" => res.type_u = r.readValue<String>()
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
    public static func fromJsonArray(r: JsonReader): ArrayList<Link> {
        r.startArray()
        var list = ArrayList<Link>()
        while (let Some(v) <- r.peek()) {
            match (v) {
                case BeginObject =>
                    let link = Link.fromJson(r)
                    if (link.rel == "self") {
                        list.prepend(link)
                    } else {
                        list.append(link)
                    }
                case EndArray =>
                    r.endArray()
                    break
                case _ => throw Exception()
            }
        }
        list
    }
}
