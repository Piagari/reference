package ohos_app_cangjie_entry

import ohos.base.AppLog
import ohos.ability.AbilityStage

class MyAbilityStage <: AbilityStage {
    public override func onCreate(): Unit {
        AppLog.info("MyAbilityStage onCreated.")
    }
}
