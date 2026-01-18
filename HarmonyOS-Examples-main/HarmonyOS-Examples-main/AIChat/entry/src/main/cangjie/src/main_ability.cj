package ohos_app_cangjie_entry

internal import ohos.base.AppLog
internal import ohos.ability.AbilityContext
internal import ohos.ability.AbilityStage
internal import ohos.ability.LaunchReason
internal import cj_res_entry.app
internal import ohos.ability.getStageContext

public var gloabl_context: Option<AbilityContext> = None

class MainAbility <: Ability {
    public init() {
        super()
        registerSelf()
    }

    public override func onCreate(want: Want, launchParam: LaunchParam): Unit {
        AppLog.info("MainAbility OnCreated.${want.abilityName}")
        match (launchParam.launchReason) {
            case LaunchReason.START_ABILITY => AppLog.info("START_ABILITY")
            case _ => ()
        }
    }

    public override func onWindowStageCreate(windowStage: WindowStage): Unit {
        AppLog.info("MainAbility onWindowStageCreate.")
        windowStage.loadContent("MainView")
        gloabl_context = Some(this.context)
    }
}
