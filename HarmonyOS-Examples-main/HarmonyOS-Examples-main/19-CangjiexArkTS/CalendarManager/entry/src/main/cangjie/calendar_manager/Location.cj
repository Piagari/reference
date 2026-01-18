/**
 * Created on 2025/8/26
 */
package ohos_app_cangjie_entry.calendar_manager

import ohos.ark_interop.*

import ohos_app_cangjie_arkts_interop.base.*

public class Location <: ArkTSClass & JSConvertible<Location> {
    public let location: ArkTSOptionalReadWriteProperty<String>
    public let longitude: ArkTSOptionalReadWriteProperty<Number>
    public let latitude: ArkTSOptionalReadWriteProperty<Number>

    public init(jsObj: JSObject) {
        super(jsObj)
        this.location = optionalProp("location")
        this.longitude = optionalProp("longitude")
        this.latitude = optionalProp("latitude")
    }

    public init(location!: ?String = None, longitude!: ?Number = None, latitude!: ?Number = None) {
        this(createJSObject(("location", location), ("longitude", longitude), ("latitude", latitude)))
    }

    public static func fromJSV(value: ?JSValue): ?Location {
        fromJSVHelper(value, "Location", { v: JSValue => v.isObject() }) { v: JSValue =>
            Location(v.asObject())
        }
    }
}