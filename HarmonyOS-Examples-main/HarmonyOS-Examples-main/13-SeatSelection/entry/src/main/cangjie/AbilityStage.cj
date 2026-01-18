package ohos_app_cangjie_entry

internal import ohos.ability.Want
internal import ohos.ability.Ability
internal import ohos.window.WindowStage
internal import ohos.ability.LaunchParam
import ohos.ability.AbilityStage
import ohos.base.AppLog

class MyAbilityStage <: AbilityStage {
    public override func onCreate(): Unit {
        AppLog.info("MyAbilityStage onCreated.")
    }
}
