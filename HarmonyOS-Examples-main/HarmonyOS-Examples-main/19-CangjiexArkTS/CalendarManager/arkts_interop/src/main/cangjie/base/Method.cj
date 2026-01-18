/**
 * Created on 2025/8/26
 */
package ohos_app_cangjie_arkts_interop.base

import ohos.ark_interop.*

public open class ArkTSMethod<T> where T <: JSConvertible<T> {
    protected let parentObj: JSObject
    protected let ctx: JSContext
    protected let name: String

    public init(parent: JSObject, ctx: JSContext, name: String) {
        this.parentObj = parent
        this.ctx = ctx
        this.name = name
    }

    protected func convertArgs(args: Array<ToJSValue>): Array<JSValue> {
        Array<JSValue>(args.size) { index =>
            args[index].toJSV(this.ctx)
        }
    }
}

public class ArkTSSyncMethod<T> <: ArkTSMethod<T> where T <: JSConvertible<T> {
    public init(parent: JSObject, ctx: JSContext, name: String) {
        super(parent, ctx, name)
    }

    public func call(args: Array<ToJSValue>): T {
        let jsArgs: Array<JSValue> = super.convertArgs(args)
        let jsResult: JSValue = parentObj.callMethod(name, jsArgs)

        T.fromJSV(jsResult) ?? throw MethodResultRequiredException(name)
    }
}

public class ArkTSAsyncMethod<T> <: ArkTSMethod<T> where T <: JSConvertible<T> {
    public init(parent: JSObject, ctx: JSContext, name: String) {
        super(parent, ctx, name)
    }

    private func createExceptionFromJSValue(jsError: JSValue, methodName: String): ArkTSCallException {
        let jsTypeStr: String = jsError.typeof().toString()
        var errMessage: String = "ArkTS method '${methodName}' failed."
        var originalError: String = ""

        match (jsTypeStr) {
            case "object" =>
                let errObj: JSObject = jsError.asObject()
                let code: Int32 = Int32(Number.fromJSV(errObj.tryGetProperty("code")) ?? -1.0)
                let message: String = String.fromJSV(errObj.tryGetProperty("message")) ?? "Unknown error object."
                originalError = "code: ${code}, message: '${message}'"
            case "string" =>
                originalError = jsError.asString().toString()
            case _ =>
                originalError = "Unexpected error type: ${jsTypeStr}."
        }

        ArkTSCallException(methodName, originalError)
    }

    private func execute(args: Array<JSValue>, callback: InteropCallback<T>): Unit {
        let promise: JSPromise = parentObj.callMethod(name, args).asPromise()

        promise.then(ctx) { _: JSContext, callInfo: JSCallInfo =>
            callback(None, T.fromJSV(callInfo[0]))
            ctx.undefined().toJSValue()
        }.catchError(ctx) { _: JSContext, callInfo: JSCallInfo =>
            let err: ArkTSCallException = createExceptionFromJSValue(callInfo[0], name)
            callback(err, None)
            ctx.undefined().toJSValue()
        }
    }

    public func call(args: Array<ToJSValue>, callback: InteropCallback<T>): Unit {
        let jsArgs: Array<JSValue> = super.convertArgs(args)
        execute(jsArgs, callback)
    }
}