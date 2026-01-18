package ohos_app_cangjie_entry

internal import ohos.ability.Ability
internal import ohos.ability.Want
internal import ohos.ability.LaunchParam
internal import ohos.window.WindowStage
import ohos.font.Font
import cj_res_entry.*

class MyAbilityStage <: AbilityStage {
    public override func onCreate(): Unit {

        AppLog.info("MyAbilityStage onCreated.")
    }
}
