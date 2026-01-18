package ohos_app_cangjie_entry

import ohos.ability.AbilityStage

import ohos_app_cangjie_entry.applog.appLog

class MyAbilityStage <: AbilityStage {
    public override func onCreate(): Unit {
        appLog.info("MyAbilityStage onCreated.")
    }
}
