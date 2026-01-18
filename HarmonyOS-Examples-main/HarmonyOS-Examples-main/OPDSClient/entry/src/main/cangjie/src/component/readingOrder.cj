/**
 * Created on 2024/8/26
 * 具体书页
 */
package ohos_app_cangjie_entry.component
// metadata.cj

import ohos.state_macro_manage.*

@Component
protected class ReadingOrderComponent {
    @Link
    var readingOrder: ReadingOrder

    func build() {
        Image(readingOrder.href).expandSafeArea(types: [SafeAreaType.SYSTEM]).transition(
            TransitionEffect.OPACITY.animation(AnimateParam(duration: 1000, curve: Curve.Ease)))
    }
}

@Observed
protected class ReadingOrder {
    @Publish
    var width: Int64 = 0
    @Publish
    var height: Int64 = 0
    @Publish
    var href: String = ""
    @Publish
    var type_u: String = ""
    //    public var templated: Bool

    public static func fromJson(r: JsonReader): ReadingOrder {
        var res = ReadingOrder()
        while (let Some(v) <- r.peek()) {
            match (v) {
                case BeginObject =>
                    r.startObject()
                    while (r.peek() != EndObject) {
                        let n = r.readName()
                        match (n) {
                            case "width" => res.width = r.readValue<Int64>()
                            case "height" => res.height = r.readValue<Int64>()
                            case "href" => res.href = r.readValue<String>()
                            case "type" => res.type_u = r.readValue<String>()
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
    public static func fromJsonArray(r: JsonReader): ArrayList<ReadingOrder> {
        r.startArray()
        var list = ArrayList<ReadingOrder>()
        while (let Some(v) <- r.peek()) {
            match (v) {
                case BeginObject => list.append(ReadingOrder.fromJson(r))
                case EndArray =>
                    r.endArray()
                    break
                case _ => throw Exception()
            }
        }
        list
    }
}
