/**
 * Created on 2024/8/24
 * 内容解析页，得到链接的json内容并生成页面
 */
package ohos_app_cangjie_entry
// content.cj

import encoding.json.stream.*
import std.{io.*, time.*}
import ohos.net.http.*
import ohos.hilog.*
import ohos.state_macro_manage.*
import std.collection.{HashMap, ArrayList}
import ohos_app_cangjie_entry.component.*
import ohos.resource_manager.*
import encoding.base64.*

@Entry
@Component
class Content {
    @State
    var metadata: Metadata = Metadata()
    @State
    var links: ArrayList<Link> = ArrayList<Link>()
    @State
    var navigation: ArrayList<Link> = ArrayList<Link>()
    @State
    var groups: ArrayList<Group> = ArrayList<Group>()
    @State
    var publications: ArrayList<Publication> = ArrayList<Publication>()
    @State
    var readingOrder: ArrayList<ReadingOrder> = ArrayList<ReadingOrder>()
    @State
    var error: Bool = false
    @State
    var search: Bool = false
    @State
    var hideMetadata: Bool = false
    protected override func onPageShow() {
        this.getJson()
    }
    func build() {
        Column(8) {
            if (!this.error && readingOrder.size == 0) {
                //顶栏部分
                Row(6) {
                    Image(@r(app.media.back)).fillColor(@r(app.color.primary)).width(20).onClick({
                        evt => Router.back()
                    })
                    ForEach(
                        this.links,
                        itemGeneratorFunc: {
                            item: Link, _: Int64 => LinkComponent(link: item, search: search, metadata: metadata)
                        }
                    )
                }.padding(8).width(100.percent)
                if (!this.hideMetadata) {
                    MetadataComponent(metadata: metadata)
                }
                Flex(FlexParams(wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center)) {
                    ForEach(
                        this.navigation,
                        itemGeneratorFunc: {
                            item: Link, _: Int64 => NavigationComponent(navigation: item)
                        }
                    )
                }.padding(left: 16, right: 16).width(100.percent)
                Column(16) { //主要部分
                    ForEach(
                        this.groups,
                        itemGeneratorFunc: {
                            item: Group, _: Int64 => GroupComponent(group: item)
                        }
                    )
                    Scroll {
                        GridRow(
                            columns: GridRowColumnOption(xs: 1, sm: 3, md: 6, lg: 9, xl: 12, xxl: 15),
                            gutter: GutterOption(x: 5.vp, y: 10.vp),
                            direction: GridRowDirection.GridRowRow
                        ) {
                            ForEach(
                                this.publications,
                                itemGeneratorFunc: {
                                    item: Publication, _: Int64 => GridCol() {
                                        PublicationComponent(publication: item)
                                    }
                                }
                            )
                        }.width(100.percent).alignItems(ItemAlign.Center).padding(5.vp)
                    }.width(100.percent).scrollable(ScrollDirection.Vertical).flexGrow(20).transition(
                        TransitionEffect.translate(TranslateOptions(y: 20.vp)).animation(
                        AnimateParam(duration: 1000, curve: Curve.Ease))).onTouch({
                        evt => this.hideMetadata = true
                    }).onScrollEdge(
                        {
                        edge => match (edge) {
                            case Edge.Top => this.hideMetadata = false
                            case _ => for (link in links) {
                                if (link.rel == "next") {
                                    Router.push(url: "Content", params: link.href)
                                }
                            }
                        }
                    })
                }.backgroundColor(@r(app.color.white)).padding(16).flexGrow(1).borderRadius(8).transition(
                    TransitionEffect.asymmetric(TransitionEffect.translate(TranslateOptions(y: 20.vp)),
                    TransitionEffect.OPACITY).animation(AnimateParam(duration: 600, curve: Curve.Ease))).expand()
            //                .shadow( 暂未支持CJResource
            //                    radius: 16,
            //                    color: Color(@r(app.color.sub)),
            //                    offsetY: -8
            //                )
            } else if (readingOrder.size > 0) {
                //阅读界面
                Scroll {
                    GridRow(
                        columns: GridRowColumnOption(xs: 1, sm: 1, md: 2, lg: 2, xl: 2, xxl: 3),
                        gutter: GutterOption(x: 5.vp, y: 10.vp),
                        direction: GridRowDirection.GridRowRow
                    ) {
                        ForEach(
                            this.readingOrder,
                            itemGeneratorFunc: {
                                item: ReadingOrder, _: Int64 => GridCol() {
                                    ReadingOrderComponent(readingOrder: item)
                                }
                            }
                        )
                    }.width(100.percent).alignItems(ItemAlign.Center)
                }.width(100.percent).height(100.percent).scrollable(ScrollDirection.Vertical).expandSafeArea(
                    types: [SafeAreaType.SYSTEM])
            }
        }.expand().backgroundColor(@r(app.color.Back))
    }

    func errBack() {
        if (this.error) {
            PromptAction.showToast(message: "地址无效")
            Router.back()
        }
    }

    func getJson() {
        var url = ""
        match (Router.getParams()) {
            case Some(v) => url = v
            case None => throw NoneValueException()
        }
        Hilog.info(0, "test", "url: ${url}")
        let httpRequest = createHttp()
        let username = AppStorage.get<String>("user").getOrThrow()
        let password = AppStorage.get<String>("password").getOrThrow()
        let verstr = toBase64String("${username};${password}".toArray())
        Hilog.error(0, "test", "verstr: ${verstr}")
        let option = HttpRequestOptions(expectDataType: HttpDataType.STRING,
            header: HashMap<String, String>([("Authorization", "Basic ${verstr}")]))
        httpRequest.request(
            url,
            {
                err, resp =>
                if (let Some(e) <- err) {
                    Hilog.error(0, "test", "exception: ${e.message}")
                    this.error = true
                }
                if (let Some(r) <- resp) {
                    let res = r.result.toString()
                    Hilog.info(0, "test", "header: ${r.header}")
                    match (r.resultType) {
                        case HttpDataType.STRING => Hilog.info(0, "test", "get string")
                        case HttpDataType.ARRAY_BUFFER => Hilog.info(0, "test", "get array buffer")
                    }
                    this.parseJson(res)
                    Hilog.info(0, "test", "res: ${res}")
                } else {
                    PromptAction.showToast(message: "地址访问失败")
                    Hilog.error(0, "test", "resp is none")
                    this.error = true
                }
                Hilog.error(0, "test", "exception: ${this.error}")
                httpRequest.destroy()
            },
            options: option
        )
    }
    func parseJson(jsonStr: String) {
        var bas = ByteArrayStream()
        unsafe { bas.write(jsonStr.rawData()) }
        var reader = JsonReader(bas)
        while (let Some(v) <- reader.peek()) {
            match (v) {
                case BeginObject =>
                    reader.startObject()
                    while (reader.peek() != EndObject) {
                        let n = reader.readName()
                        match (n) {
                            case "metadata" => this.metadata = Metadata.fromJson(reader)
                            case "links" => this.links = Link.fromJsonArray(reader)
                            case "navigation" => this.navigation = Link.fromJsonArray(reader)
                            case "groups" => this.groups = Group.fromJsonArray(reader)
                            case "publications" => this.publications = Publication.fromJsonArray(reader)
                            case "readingOrder" => this.readingOrder = ReadingOrder.fromJsonArray(reader)
                            case _ => reader.skip()
                        }
                    }
                    reader.endObject()
                    break
                case _ => throw Exception()
            }
        }
    }
}
