package ohos_app_cangjie_SlowFeet

internal import ohos.base.AppLog
internal import ohos.ability.AbilityStage
internal import ohos.ability.LaunchReason
internal import cj_res_SlowFeet.app
import ohos.ability.*
import ohos.ability_access_ctrl.*
import ohos.bundle_manager.*
import ohos.window.*

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
        // TODO: CAMERA 权限 -> 拍视频(上传)
        // let applicationInfo = ApplicationInfo()
//        let atManager = AtManager()
//        var uid = BundleManager.getBundleInfoForSelf(GET_BUNDLE_INFO_DEFAULT.getValue()).appInfo.uid
//        match(atManager.checkAccessToken(UInt32(uid), "ohos.permission.CAMERA")) {
//            case PERMISSION_DENIED => atManager.requestPermissionsFromUser(getStageContext(globalcontext.getOrThrow()), ["ohos.permission.CAMERA"], {_, _ => ()})
//            case PERMISSION_GRANTED => AppLog.info("PERMISSION_GRANTED")
//        }
        // TODO: 避让挖孔
//        var windowClass: Window = windowStage.getMainWindow()
//        windowClass.setWindowLayoutFullScreen(true)
//        windowClass.setWindowSystemBarEnable()
        AppLog.info("MainAbility onWindowStageCreate.")
        windowStage.loadContent("MyView")
    }
}
