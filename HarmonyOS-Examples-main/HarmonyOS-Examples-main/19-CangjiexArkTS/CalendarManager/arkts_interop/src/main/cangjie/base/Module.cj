/**
 * Created on 2025/8/26
 */
package ohos_app_cangjie_arkts_interop.base

import ohos.ark_interop.*

public abstract class ArkTSModule {
    public let moduleName: String
    public let permissions: Array<String>
    protected let jsModule: JSObject
    protected let ctx: JSContext = ArkTSBridge.getMainContext()

    public init(moduleName: String, permissions: Array<String>) {
        this.moduleName = moduleName
        this.permissions = permissions
        this.jsModule = ctx.requireSystemNativeModule(moduleName).asObject()
    }
}