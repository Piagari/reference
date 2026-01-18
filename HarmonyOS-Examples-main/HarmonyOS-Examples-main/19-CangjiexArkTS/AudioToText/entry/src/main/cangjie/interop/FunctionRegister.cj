/**
 * Created on 2025/7/24
 */
package ohos_app_cangjie_entry.interop

import ohos.base.*
import ohos.ark_interop.*
import ohos.ark_interop_macro.*
import std.collection.*
import ohos.base.*
import ohos.ark_interop.*
import ohos.ark_interop_macro.*
import std.collection.*

let globalJSFunction = HashMap<String, ((AudioFileInfo) -> Unit) -> Unit>()

@Interop[ArkTS]
public class AudioFileInfo {
    public AudioFileInfo(
        public let recognitionResult: String
    ) {}
}

@Interop[ArkTS]
public func registerJSFunc(name: String, fn: ((AudioFileInfo) -> Unit) -> Unit): Unit {
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

public func execFuncByName(name: String, callBack: (AudioFileInfo) -> Unit): Unit {
    if (let Some(fn) <- globalJSFunction.get(name)) {
        fn(callBack)
    }
}