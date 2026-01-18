package ohos_app_cangjie_entry

import ohos.ability.*
import ohos.window.WindowStage

import ohos_app_cangjie_entry.applog.appLog
import ohos_app_cangjie_arkts_interop.base.*

class MainAbility <: Ability {
    public init() {
        super()
        registerSelf()
    }

    public override func onCreate(want: Want, launchParam: LaunchParam): Unit {
        appLog.info("MainAbility OnCreated.${want.abilityName}")
        match (launchParam.launchReason) {
            case LaunchReason.START_ABILITY => appLog.info("START_ABILITY")
            case _ => ()
        }
        ArkTSBridge.initialize(context)
    }

    public override func onWindowStageCreate(windowStage: WindowStage): Unit {
        appLog.info("MainAbility onWindowStageCreate.")
        ArkTSBridge.requestPermissions()
        windowStage.loadContent("EntryView")
    }
}
