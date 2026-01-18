package ohos_app_cangjie_entry

internal import ohos.base.AppLog
internal import ohos.ability.AbilityStage
internal import ohos.ability.LaunchReason
internal import cj_res_entry.app
import ohos.ability.*
import ohos_app_cangjie_entry.util.WindowUtil

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

        //利用WindowUtil().getWindowUtilRect()方法获取长宽元组
        let widthAndHeight: (UInt32, UInt32) = WindowUtil().getWindowUtilRect(windowStage)
        AppStorage.setOrCreate<(UInt32, UInt32)>("widthAndHeight", widthAndHeight)
        windowStage.loadContent("MyView")
    }
}
