package ohos_app_cangjie_entry

internal import ohos.ability.{AbilityStage, LaunchReason}
internal import ohos.base.AppLog
internal import cj_res_entry.app

class MainAbility <: Ability {
    static var darkMode: Bool = false

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
//        darkMode = this.context.
        AppLog.info("MainAbility onWindowStageCreate.")
        windowStage.loadContent("MainView")
    }
}
