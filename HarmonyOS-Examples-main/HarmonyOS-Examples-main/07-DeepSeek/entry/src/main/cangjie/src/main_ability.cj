package ohos_app_cangjie_entry
import ohos_app_cangjie_entry.util.g_abilityContext

internal import ohos.base.AppLog
internal import ohos.ability.AbilityStage
internal import ohos.ability.AbilityContext
internal import ohos.ability.LaunchReason
internal import cj_res_entry.app

class MainAbility <: Ability {
    public init() {
        super()
        registerSelf()
    }

    public override func onCreate(want: Want, launchParam: LaunchParam): Unit {
        AppLog.info("MainAbility OnCreated.${want.abilityName}")
        g_abilityContext = this.context
        match (launchParam.launchReason) {
            case LaunchReason.START_ABILITY => AppLog.info("START_ABILITY")
            case _ => ()
        }
    }

    public override func onWindowStageCreate(windowStage: WindowStage): Unit {
        AppLog.info("MainAbility onWindowStageCreate.")
        windowStage.loadContent("EntryView")
    }
}

