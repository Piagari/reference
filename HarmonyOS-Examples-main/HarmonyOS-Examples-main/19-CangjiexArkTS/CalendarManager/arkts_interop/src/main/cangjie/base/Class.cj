/**
 * Created on 2025/8/26
 */
package ohos_app_cangjie_arkts_interop.base

import ohos.ark_interop.*

public open class ArkTSClass <: ToJSValue {
    public let jsObj: JSObject
    protected static let ctx: JSContext = ArkTSBridge.getMainContext()

    public init(jsObj: JSObject) {
        this.jsObj = jsObj
    }

    protected static func createJSObject(properties: Array<(String, ToJSValue)>): JSObject {
        let obj: JSObject = ctx.object()
        for ((name, p) in properties) {
            let jsValue: JSValue = p.toJSV(ctx)
            if (!jsValue.isUndefined()) {
                obj.setProperty(name, p.toJSV(ctx))
            }
        }
        obj
    }

    public func toJSV(ctx: JSContext): JSValue {
        this.jsObj.toJSValue()
    }

    protected func requiredProp<T>(name: String): ArkTSRequiredReadWriteProperty<T> where T <: JSConvertible<T> {
        ArkTSRequiredReadWriteProperty<T>(this.jsObj, ctx, name)
    }

    protected func optionalProp<T>(name: String): ArkTSOptionalReadWriteProperty<T> where T <: JSConvertible<T> {
        ArkTSOptionalReadWriteProperty<T>(this.jsObj, ctx, name)
    }

    protected func requiredReadOnlyProp<T>(name: String): ArkTSRequiredReadOnlyProperty<T> where T <: JSConvertible<T> {
        ArkTSRequiredReadOnlyProperty<T>(this.jsObj, ctx, name)
    }

    protected func optionalReadOnlyProp<T>(name: String): ArkTSOptionalReadOnlyProperty<T> where T <: JSConvertible<T> {
        ArkTSOptionalReadOnlyProperty<T>(this.jsObj, ctx, name)
    }

    protected func asyncMethod<T>(name: String): ArkTSAsyncMethod<T> where T<: JSConvertible<T> {
        ArkTSAsyncMethod<T>(this.jsObj, ctx, name)
    }

    protected func syncMethod<T>(name: String): ArkTSSyncMethod<T> where T <: JSConvertible<T> {
        ArkTSSyncMethod<T>(this.jsObj, ctx, name)
    }
}