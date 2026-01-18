package ohos_app_cangjie_entry

internal import ohos.ability.*
internal import ohos.window.WindowStage

class MyAbilityStage <: AbilityStage {
    public override func onCreate(): Unit {
        AppLog.info("MyAbilityStage onCreated.")
    }
}
