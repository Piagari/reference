package ohos_app_cangjie_entry.interop

// 导入ARKTS互操作相关库
internal import ohos.ark_interop.JSModule
internal import ohos.ark_interop.JSContext
internal import ohos.ark_interop.JSCallInfo
internal import ohos.ark_interop.JSValue
internal import cj_res_entry.app

import ohos.base.*
import ohos.ark_interop.*
import ohos.ark_interop_macro.*
import std.collection.*

import std.sync.sleep
import std.time.Duration

internal import ohos.ark_interop.JSFunction
internal import ohos.ark_interop.JSObject
internal import ohos.ark_interop.JSKeyable
internal import ohos.ark_interop.JSCurrentJSContext
internal import ohos.ark_interop.JSInteropType
internal import ohos.ark_interop.SharedObject
import std.collection.HashMap
import ohos.ark_interop_helper.StageContext
import ohos.ark_interop_helper.arkTsValuetoNapiValue
import ohos.ark_interop_helper.isStageMode
import ohos.ark_interop_helper.getContextStageMode
import ohos.base.AppLog
import ohos.hybrid_base.CJPageEntry
import ohos.ark_interop_macro.Interop
import std.collection.ArrayList


let globalJSFunction = HashMap<String, (OcrCallBackFunc) -> Unit>()

// OCR回调函数类型定义（一个接收文件信息和状态的回调函数）
public type OcrCallBackFunc = (OcrFileInfo, Int8) -> Unit

/**
 * OCR文件信息类 - 用于在Cangjie和ArkTS之间传递文件信息
 * @param uri 文件URI
 * @param size 文件大小（字节）
 */
@Interop[ArkTS]
public class OcrFileInfo {
    public OcrFileInfo(
        public let uri: String,
        public let size: Int64,
        public let ocrResult: String
    ) {}
}

@Interop[ArkTS]                                       /* (OcrCallBackFunc) -> Unit */
public func registerJSFunc(name: String, fn: ((OcrFileInfo, Int8) -> Unit) -> Unit): Unit {
    if (globalJSFunction.contains(name)) {
        AppLog.error("registerJSFunc failed(err: func ${name} already exists)")
        return
    }
    globalJSFunction.put(name, fn)
}

@Interop[ArkTS]
public func unregisterJSFunc(name: String): Unit {
    globalJSFunction.remove(name)
}

public func execFuncByName(name: String, callBack: OcrCallBackFunc): Unit {
    if (let Some(fn) <- globalJSFunction.get(name)) {
        fn(callBack)
    }
}

// Toast提示功能注册变量
var showToastFunc: ?(String) -> Unit = None
@Interop[ArkTS]
public func registerShowToast(fn: (String) -> Unit): Unit {
    showToastFunc = fn
}

/*
 * 显示Toast提示
 */
public func showToast(msg: String) {
    if (let Some(fn) <- showToastFunc) {
        fn(msg)
    } else {
        ()
    }
}