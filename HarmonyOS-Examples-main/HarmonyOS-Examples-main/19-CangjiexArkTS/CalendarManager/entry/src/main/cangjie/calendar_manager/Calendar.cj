/**
 * Created on 2025/8/23
 */
package ohos_app_cangjie_entry.calendar_manager

import std.collection.ArrayList

import ohos.base.*
import ohos.ark_interop.*

import ohos_app_cangjie_arkts_interop.base.*

public class Calendar <: ArkTSClass & JSConvertible<Calendar>{
    public let id: ArkTSOptionalReadOnlyProperty<Number>

    public let addEvent: ArkTSAsyncMethod<Number>
    public let deleteEvent: ArkTSAsyncMethod<Unit>
    public let getEvents: ArkTSAsyncMethod<ArrayList<Event>>

    public init(jsObj: JSObject) {
        super(jsObj)
        this.id = optionalReadOnlyProp("id")
        this.addEvent = asyncMethod("addEvent")
        this.deleteEvent = asyncMethod("deleteEvent")
        this.getEvents = asyncMethod("getEvents")
    }

    public static func fromJSV(value: ?JSValue): ?Calendar {
        fromJSVHelper(value, "Calendar", { v: JSValue => v.isObject() }) { v: JSValue =>
            Calendar(v.asObject())
        }
    }
}