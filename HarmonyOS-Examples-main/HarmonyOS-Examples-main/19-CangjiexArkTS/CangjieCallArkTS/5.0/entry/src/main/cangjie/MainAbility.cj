package ohos_app_cangjie_entry
import ohos_app_cangjie_entry.utils.appLog

import ohos.base.*
import ohos.window.*
import ohos.ability.*
import ohos.state_manage.AppStorage

import ohos_app_cangjie_entry.services.CalendarService

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
        CalendarService.initialize(context)
    }

    public override func onWindowStageCreate(windowStage: WindowStage): Unit {
        AppLog.info("MainAbility onWindowStageCreate.")
        windowStage.loadContent("EntryView")

        let windowClass: Window = windowStage.getMainWindow()

        windowClass.setWindowLayoutFullScreen(true)

        let avoidAreaType: AvoidAreaType = AvoidAreaType.TYPE_SYSTEM
        let avoidArea: AvoidArea = windowClass.getWindowAvoidArea(avoidAreaType)

        let topRectHeight: UInt32 = avoidArea.topRect.height
        appLog.info("topRectHeight: ${topRectHeight}")

        AppStorage.setOrCreate<Length>('topRectHeight', Length(Int64(topRectHeight), unitType: LengthType.px))
    }
}
