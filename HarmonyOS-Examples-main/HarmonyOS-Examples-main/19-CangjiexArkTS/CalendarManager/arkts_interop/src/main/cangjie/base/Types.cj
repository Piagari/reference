/**
 * Created on 2025/8/22
 */
package ohos_app_cangjie_arkts_interop.base

import std.collection.ArrayList

import ohos.ark_interop.*

public type Number = Float64

public type InteropCallback<T> = (?ArkTSCallException, ?T) -> Unit

public interface IfLet<T> {
    func ifLet(f: (T) -> Unit): Unit
}

extend<T> Option<T> <: IfLet<T> {
    public func ifLet(f: (T) -> Unit): Unit {
        if (let Some(v) <- this) {
            f(v)
        }
    }
}

public interface Try { // Why must add an extra interface to export this extension????
    func tryGetProperty(key: JSKeyable): ?JSValue
}

extend JSObject <: Try {
    public func tryGetProperty(key: JSKeyable): ?JSValue {
        let result = this.getProperty(key)
        if (result.isUndefined()) {
            None
        } else {
            result
        }
    }
}

public interface ToJSValue {
    func toJSV(context: JSContext): JSValue
}

extend<T> Option<T> <: ToJSValue where T <: ToJSValue {
    public func toJSV(ctx: JSContext): JSValue {
        if (let Some(v) <- this) {
            v.toJSV(ctx)
        } else {
            frameworkLog.warn("convert ?T to undefined JSValue")
            ctx.undefined().toJSValue()
        }
    }
}

public interface JSConvertible<T> <: ToJSValue {
    static func fromJSV(value: ?JSValue): ?T
}

extend<T> ArrayList<T> <: JSConvertible<ArrayList<T>> where T <: JSConvertible<T> {
    public func toJSV(ctx: JSContext): JSValue {
        this.toArray().toJSV(ctx)
    }

    public static func fromJSV(value: ?JSValue): ?ArrayList<T> {
        fromJSVHelper(value, "Array", { v: JSValue => v.isArray() }) { v: JSValue =>
            let jsArr: JSArray = v.asArray()
            let arr: ArrayList<T> = ArrayList<T>()
            for (i in 0..jsArr.size) {
                T.fromJSV(jsArr[i]).ifLet { item => arr.append(item) }
            }
            arr
        }
    }
}

extend<T> Array<T> <: JSConvertible<Array<T>> where T <: JSConvertible<T> {
    public func toJSV(ctx: JSContext): JSValue {
        let arr: Array<JSValue> = Array<JSValue>(this.size) { index =>
            this[index].toJSV(ctx)
        }
        ctx.array(arr.toArray()).toJSValue()
    }

    public static func fromJSV(value: ?JSValue): ?Array<T> {
        let arr: ArrayList<T> = ArrayList<T>.fromJSV(value) ?? return None
        arr.toArray()
    }
}

extend String <: JSConvertible<String> {
    public func toJSV(ctx: JSContext): JSValue {
        ctx.string(this).toJSValue()
    }

    public static func fromJSV(value: ?JSValue): ?String {
        fromJSVHelper(value, "String", { v: JSValue => v.isString() }) { v: JSValue =>
            v.asString().toString()
        }
    }
}

extend Number <: JSConvertible<Number> {
    public func toJSV(ctx: JSContext): JSValue {
        ctx.number(this).toJSValue()
    }

    public static func fromJSV(value: ?JSValue): ?Number {
        fromJSVHelper(value, "Number", { v: JSValue => v.isNumber() }) { v: JSValue =>
            v.asNumber().toFloat64()
        }
    }
}

extend Bool <: JSConvertible<Bool> {
    public func toJSV(ctx: JSContext): JSValue {
        ctx.boolean(this).toJSValue()
    }

    public static func fromJSV(value: ?JSValue): ?Bool {
        fromJSVHelper(value, "Boolean", { v: JSValue => v.isBoolean() }) { v: JSValue =>
            v.asBoolean().toBool()
        }
    }
}

extend Unit <: JSConvertible<Unit> {
    public func toJSV(ctx: JSContext): JSValue {
        ctx.undefined().toJSValue()
    }

    public static func fromJSV(value: ?JSValue): ?Unit {
        fromJSVHelper(value, "", { v: JSValue => true }) { v: JSValue =>
            ()
        }
    }
}

extend JSPromise {
    public func then(ctx: JSContext, onFulfilled: JSLambda): JSPromise {
        this.then(ctx.function(onFulfilled))
        this
    }

    public func catchError(ctx: JSContext, onRejected: JSLambda): Unit {
        this.catchError(ctx.function(onRejected))
    }
}

public func fromJSVHelper<T>(value: ?JSValue, expected: String, typeCheck: (JSValue) -> Bool, converter: (JSValue) -> T): ?T {
    if (value.isNone() || value.getOrThrow().isUndefined() || value.getOrThrow().isNull()) {
        return None
    }
    let jsVal: JSValue = value.getOrThrow()

    if (!typeCheck(jsVal)) {
        throw ArkTSConversionException("Expected ${expected} but got ${jsVal.typeof().toString()}.")
    }

    converter(jsVal)
}