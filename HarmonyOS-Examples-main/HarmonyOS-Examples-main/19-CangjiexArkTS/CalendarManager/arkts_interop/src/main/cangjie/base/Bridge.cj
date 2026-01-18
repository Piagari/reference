/**
 * Created on 2025/8/26
 */
package ohos_app_cangjie_arkts_interop.base

import std.collection.ArrayList

import ohos.ark_interop.*
import ohos.base.AsyncError
import ohos.base.AsyncCallback
import ohos.ability_access_ctrl.*
import ohos.ability.AbilityContext
import ohos.ability.getStageContext
import ohos.ark_interop_helper.StageContext
import ohos.ark_interop_helper.getJSContext
import std.sync.ReentrantMutex
import std.sync.Monitor

public class ArkTSBridge {
    private static let modules: ArrayList<ArkTSModule> = ArrayList<ArkTSModule>()
    private static let requiredPermissions: ArrayList<String> = ArrayList<String>()
    private static var runtime: ?JSRuntime = None
    private static var abilityContext: ?AbilityContext = None

    public static func registerModule(module: ArkTSModule): Unit {
        frameworkLog.info("Registering ArkTS module: ${module.moduleName}")
        modules.append(module)
    }

    public static func initialize(context: AbilityContext): Unit {
        abilityContext = context

        for (m in modules) {
            for (p in m.permissions) {
                if (!requiredPermissions.contains(p)) {
                    requiredPermissions.append(p)
                }
            }
        }

        frameworkLog.info("${modules.size} modules registered, with ${requiredPermissions.size} unique permissions.")
    }

    public static func requestPermissions(): Unit {
        if (requiredPermissions.isEmpty()) {
            frameworkLog.info("No permissions registered to request.")
            return
        }

        let monitor: Monitor = Monitor()
        let resultHolder: ResultHolder = ResultHolder()

        let resultCallback: AsyncCallback<PermissionRequestResult> = {
            err: ?AsyncError, data: ?PermissionRequestResult =>
            synchronized (monitor) {
                resultHolder.error = err
                resultHolder.result = data
                resultHolder.isDone = true
                monitor.notifyAll()
            }
        }

        let atManager: AtManager = AbilityAccessCtrl.createAtManager()
        let stageContext: StageContext = getStageContext(getAbilityContext())

        atManager.requestPermissionsFromUser(stageContext, requiredPermissions.toArray(), resultCallback)

        synchronized (monitor) {
            while(!resultHolder.isDone) {
                monitor.wait()
            }
        }

        if (resultHolder.error.isSome() || resultHolder.result.isNone()) {
            frameworkLog.error("failed to request permissions.")
            return
        }

        let result: PermissionRequestResult = resultHolder.result.getOrThrow()
        for (i in 0..result.permissions.size) {
            frameworkLog.debug("permissionResultCallback: ${result.permissions[i]} is ${result.authResults[i]}")
        }
    }

    public static func getRuntime(): JSRuntime {
        runtime ?? { =>
            let v: JSRuntime = JSRuntime()
            runtime = v
            v
        }()
    }

    public static func getMainContext(): JSContext {
        getRuntime().mainContext
    }

    public static func getAbilityContext(): AbilityContext {
        abilityContext ?? throw UnInitializedException("Get abilityContext failed.")
    }

    public static func getJSContext(): JSValue {
        getJSContext(getRuntime(), getAbilityContext())
    }
}

private class ResultHolder {
    public var result: ?PermissionRequestResult = None
    public var error: ?AsyncError = None
    public var isDone: Bool = false
}