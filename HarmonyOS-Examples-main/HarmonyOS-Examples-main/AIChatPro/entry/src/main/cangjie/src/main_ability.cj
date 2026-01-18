package ohos_app_cangjie_entry

internal import ohos.base.AppLog
internal import ohos.ability.AbilityContext
internal import ohos.ability.AbilityStage
internal import ohos.ability.LaunchReason
internal import cj_res_entry.app
internal import ohos.ability.getStageContext

var globalAbilityContext: Option<AbilityContext> = Option<AbilityContext>.None

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
        globalAbilityContext = Some(this.context)
    }

    public override func onWindowStageCreate(windowStage: WindowStage): Unit {
        AppLog.info("MainAbility onWindowStageCreate.");
        windowStage.loadContent("MyView");
        // gloabl_context = Some(this.context);
    }
}


func createAbility(): MainAbility {
    MainAbility()
}

let ABILITY_REGISTER_RESULT = Ability.registerCreator("CangjieAbility", createAbility)

public func get_context(): AbilityContext {
    match (globalAbilityContext) {
        case Some(context) =>
            context
        case _ =>
            throw Exception("get globalAbilityContext failed")
    }
}

public func get_stage_context() {
  return getStageContext(get_context());
}
