/**
 * Created on 2025/4/24
 */
package silkui.components.toast

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.state_macro_manage.*
import crypto.crypto.SecureRandom
import std.collection.HashMap
import std.sync.Timer
import std.sync.sleep
import std.time.*
import cj_res_silkui.*
import silkui.SilkUIBorderOptions
import silkui.SilkUIPaddingOptions
import silkui.types.*
import silkui.components.loading.*
import silkui.ResourceStr
import silkui.utils.ResourceColorToColor
import silkui.utils.ResourceStrToString
import silkui.components.icon.SilkIcon
import silkui.constants.SilkToastColorKey
import silkui.constants.SilkToastSizeKey
import silkui.constants.SilkToastPaddingKey
import silkui.constants.getToastColorConstant
import silkui.constants.getToastSizeConstant
import silkui.constants.getToastPaddingConstant
import silkui.constants.SilkSizeKey
import silkui.constants.getSizeConstant

@CustomDialog
class CusDialog {
    var controller: Option<CustomDialogController> = Option.None
    var _id: ?String = Option.None
    var toastController: ?SilkToastDynamicController = Option.None
    var typeValue: SilkToastType = SilkToastType.SUCCESS
    var showIcon: Bool = true
    var icon: ?ResourceStr = Option.None
    @State
    var message: ResourceStr = ""
    var loadingType: SilkLoadingType = SilkLoadingType.CIRCULAR
    var loadingSize: ?Length = Option.None
    var wordBreak: ?WordBreak = Option.None
    var duration: ?Int64 = 3000
    var iconSize: ?Length = Option.None
    var style: ?SilkToastStyle = Option.None
    var closeOnClick: Bool = false
    var onClose: Option<() -> Unit> = Option.None
    var onOpened: Option<() -> Unit> = Option.None
    @BuilderParam
    var Content: () -> Unit = DefaultBuilder
    var hasContent: Bool = false

    protected override func aboutToAppear() {
        SilkToastConstants.inited = true
        if (toastController.isSome()) {
            toastController.getOrThrow().setMessage = {value: ResourceStr => message = value}
        }
    }

    func build() {
        Column() {
            if (hasContent) {
                Content()
            } else {
                Column(){
                    if (showIcon && getImage().isSome()) {
                            SilkIcon(
                        name: getImage().getOrThrow(),
                        fontSize: iconSize.getOrThrow(),
                        fontColor: ResourceColorToColor(if (style.isSome()) {
                            style.getOrThrow().fillColor
                        } else {
                            ResourceColorToColor(getToastColorConstant(SilkToastColorKey.TOAST_TEXT_COLOR))
                        })
                    )
                }
                if (typeValue == SilkToastType.LOADING) {
                    Row() {
                        if (loadingSize.isSome()) {
                            SilkLoading(
                            loadingType: loadingType,
                            size: loadingSize.getOrThrow(),
                            color: if (style.isSome()) { style.getOrThrow().fillColor} else { getToastColorConstant(SilkToastColorKey.TOAST_LOADING_ICON_COLOR) }
                        )
                        } else {
                            SilkLoading(
                            loadingType: loadingType,
                            color: if (style.isSome()) { style.getOrThrow().fillColor} else { getToastColorConstant(SilkToastColorKey.TOAST_LOADING_ICON_COLOR) }
                        )
                        }
                    }.padding(4)
                }
                Text(ResourceStrToString(message))
                    .fontSize(getToastSizeConstant(SilkToastSizeKey.TOAST_FONT_SIZE))
//                    .lineHeight(getToastSizeConstant(SilkToastSizeKey.TOAST_LINE_HEIGHT))
                    .fontColor(ResourceColorToColor(getToastColorConstant(SilkToastColorKey.TOAST_TEXT_COLOR)))
                    // TODO wordbreak属性未支持
                    .textAlign(TextAlign.Center)
                .margin(top: if ((showIcon && getImage().isSome()) || typeValue == SilkToastType.LOADING ) { getSizeConstant(SilkSizeKey.PADDING_XS) } else { 0.vp})
                }
                .width<Length>(getWidth())
                .constraintSize(
                minWidth: getConstraintSize().minWidth,
                maxWidth: getConstraintSize().maxWidth,
                minHeight: getConstraintSize().minHeight
            )
                .justifyContent(FlexAlign.Center)
            }
        }

            .padding(
                top: getPadding().top,
                right: getPadding().right,
                bottom: getPadding().bottom,
                left: getPadding().left
            )
            .clip(true)
            .borderRadius(if (style.isSome()) {
                style.getOrThrow().radius
            } else {
                SilkToastStyle().radius
            })
            .backgroundColor(
                ResourceColorToColor(
                if (style.isSome()) {
                    style.getOrThrow().backgroundColor
                } else {
                    SilkToastStyle().backgroundColor
                }
                ))
            .onClick({e => clickHandler()})
            .onAppear({
                => if (onOpened.isSome()) {
                    onOpened.getOrThrow()()
                }
            })
            .onDisAppear({
                => if (onClose.isSome()) {
                    onClose.getOrThrow()()
                }
            })
    }

    func getImage(): ?ResourceStr {
        match (icon) {
            case Some(v) => v
            case _ => match (typeValue) {
                case SilkToastType.WARN => @r(app.media.warning)
                case SilkToastType.ERROR => @r(app.media.fail)
                case SilkToastType.SUCCESS => @r(app.media.success)
                case _ => Option.None
            }
        }
    }
    func getWidth(): ?Length {
            if ((showIcon && getImage().isSome()) || typeValue == SilkToastType.LOADING) {
                return getToastSizeConstant(SilkToastSizeKey.TOAST_DEFAULT_WIDTH)
            } else {
                Option.None
            }
    }

    func getPadding(): SilkUIPaddingOptions {
        if (style.isSome() && style.getOrThrow().padding.isSome()) {
            return style.getOrThrow().padding.getOrThrow()
        } else {
            if ((showIcon && getImage().isSome()) || typeValue == SilkToastType.LOADING) {
                return getToastPaddingConstant(SilkToastPaddingKey.TOAST_DEFAULT_PADDING)
            } else {
                getToastPaddingConstant(SilkToastPaddingKey.TOAST_TEXT_PADDING)
            }
        }
    }

    func getConstraintSize(): ConstraintSizeOptions {
        if ((showIcon && getImage().isSome()) || typeValue == SilkToastType.LOADING) {
            return ConstraintSizeOptions(
                maxWidth: getToastSizeConstant(SilkToastSizeKey.TOAST_MAX_WIDTH),
                minHeight: getToastSizeConstant(SilkToastSizeKey.TOAST_DEFAULT_MIN_HEIGHT),
            )
        } else {
            return ConstraintSizeOptions(
                minWidth: getToastSizeConstant(SilkToastSizeKey.TOAST_MIN_WIDTH),
                maxWidth: getToastSizeConstant(SilkToastSizeKey.TOAST_MAX_WIDTH),
            )
        }
    }

    // 事件
    func clickHandler() {
        if (!closeOnClick) {
            return
        };
        if (_id.isNone() && controller.isSome()) {
            controller.getOrThrow().close()
        }
        if (_id.isSome() && !_id.getOrThrow().isEmpty() && SilkToastConstants.controllerMap.contains(_id.getOrThrow())) {
            SilkToastConstants.controllerMap.get(_id.getOrThrow()).getOrThrow().close()
        }
    }
}

@Component
class ToastDialog {
    private var _controller: CustomDialogController = CustomDialogController(
        CustomDialogControllerOptions(builder: CusDialog()))

    private func _mounted(props: SilkToastOptions, toastType: SilkToastType, toastController!: Option<SilkToastDynamicController> = Option.None ): Unit {
        let id = SecureRandom().nextUInt64().toString()
        let _props = props
        _props.toastTyoe = toastType
        let cont = SilkToastConstants.controllerMap.size
        if (cont > 0 && SilkToastConstants.isSingleton) {
            for ((key, value) in SilkToastConstants.controllerMap) {
                value.close()
            }
            SilkToastConstants.controllerMap.clear()
            SilkToastConstants.controller = Option.None
        }
        _controller = CustomDialogController(
            // TODO 缺少isModel属性，SilkToastPosition难以实现
            CustomDialogControllerOptions(
                customStyle: true,
                autoCancel: getAutoCancel(_props),
                alignment: getAlign(_props.showPosition),
                offset: Offset(0.vp, getYOffset(_props)),
                maskColor: if (_props.overlay) { Color(0x33000000) } else { Color.TRANSPARENT }
            )
        )
        _controller.bindView(this)
        _controller.setBuilder(
            {
                =>
                let cjDialog = CusDialog(
                    this,
                    message: ObservedProperty("", _props.message),
                    showIcon: ObservedProperty("", _props.showIcon),
                    icon: ObservedProperty("", _props.icon),
                    iconSize: ObservedProperty("", _props.iconSize),
                    typeValue: ObservedProperty("", _props.toastTyoe),
                    loadingType: ObservedProperty("", _props.loadingType),
                    loadingSize: ObservedProperty("", _props.loadingSize),
                    wordBreak: ObservedProperty("", _props.wordBreak),
                    duration: ObservedProperty("", _props.duration),
                    toastController: ObservedProperty("", toastController),
                    onOpened: ObservedProperty("", _props.onOpened),
                    onClose: ObservedProperty("", _props.onClose),
                    closeOnClick: ObservedProperty("", _props.closeOnClick),
                    _id: ObservedProperty("", id)
                )
                CustomView.create(cjDialog)
                cjDialog.setController(_controller)
            }
        )
        SilkToastConstants.controller = Option.Some(_controller)
        SilkToastConstants.controllerMap.put(id, _controller)
        _controller.open()
        if (_props.duration != 0) {
            spawn {
                =>
                sleep(_props.duration * Duration.millisecond)
                if (SilkToastConstants.controllerMap.contains(id)) {
                    SilkToastConstants.controllerMap.get(id).getOrThrow().close()
                }
            }
        }
    }

    public func success(props: SilkToastOptions) {
        _mounted(props, SilkToastType.SUCCESS)
    }
    public func success(props: ResourceStr) {
        _mounted(SilkToastOptions(message: props), SilkToastType.SUCCESS)
    }

    public func error(props: SilkToastOptions) {
        _mounted(props, SilkToastType.ERROR)
    }
    public func error(props: ResourceStr) {
        _mounted(SilkToastOptions(message: props), SilkToastType.ERROR)
    }

    public func toast(props: SilkToastOptions) {
        _mounted(props, SilkToastType.TOAST)
    }
    public func toast(props: ResourceStr) {
        _mounted(SilkToastOptions(message: props), SilkToastType.TOAST)
    }

    public func warn(props: SilkToastOptions) {
        _mounted(props, SilkToastType.WARN)
    }
    public func warn(props: ResourceStr) {
        _mounted(SilkToastOptions(message: props), SilkToastType.WARN)
    }

    public func loading(props: SilkToastOptions) {
        let controller = SilkToastDynamicController()
        _mounted(props, SilkToastType.LOADING, toastController: controller)
        return controller
    }
    public func loading(props: ResourceStr) {
        let controller = SilkToastDynamicController()
        _mounted(SilkToastOptions(message: props), SilkToastType.LOADING, toastController: controller)
        return controller
    }

    func build() {
    }

    func getAlign(showPosition: SilkToastPosition): DialogAlignment {
        match (showPosition) {
            case SilkToastPosition.TOP => DialogAlignment.Top
            case SilkToastPosition.BOTTOM => DialogAlignment.Bottom
            case SilkToastPosition.CENTER => DialogAlignment.Center
            case _ => DialogAlignment.Center
        }
    }
    func getAutoCancel(props: SilkToastOptions): Bool {
        if (props.forbidClick) {
            return false
        } else {
            if (props.closeOnClickOverlay) {
                return true
            } else {
                return false
            }
        }
    }
    func getYOffset(props: SilkToastOptions): Length {
        match (props.showPosition) {
            case SilkToastPosition.TOP => props.offset
            case SilkToastPosition.BOTTOM => match (props.offset.unitType) {
            	case LengthType.percent => Length(-props.offset.value * 100.0, unitType: LengthType.percent)
            	case _ => Length(-props.offset.value, unitType: props.offset.unitType)
            }
            case SilkToastPosition.CENTER => 0.vp
            case _ => 0.vp
        }
    }
}


public class SilkToast {
    private static var _comp: Option<ToastDialog> = Option.None
    public static func silkToastInit(parent: Option<CustomView>) {
        SilkToastConstants.inited = true
        _comp = ToastDialog(parent)
    }

    public static func success(props: SilkToastOptions) {
        if (_comp.isNone() || !SilkToastConstants.inited) {
            SilkToast.silkToastInit(Option.None)
        }
        _comp.getOrThrow().success(props)
    }
    public static func success(props: ResourceStr) {
        if (_comp.isNone() || !SilkToastConstants.inited) {
            SilkToast.silkToastInit(Option.None)
        }
        _comp.getOrThrow().success(props)
    }
    public static func error(props: SilkToastOptions) {
        if (_comp.isNone() || !SilkToastConstants.inited) {
            SilkToast.silkToastInit(Option.None)
        }
        _comp.getOrThrow().error(props)
    }
    public static func error(props: ResourceStr) {
        if (_comp.isNone() || !SilkToastConstants.inited) {
            SilkToast.silkToastInit(Option.None)
        }
        _comp.getOrThrow().error(props)
    }
    public static func toast(props: SilkToastOptions) {
        if (_comp.isNone() || !SilkToastConstants.inited) {
            SilkToast.silkToastInit(Option.None)
        }
        _comp.getOrThrow().toast(props)
    }
    public static func toast(props: ResourceStr) {
        if (_comp.isNone() || !SilkToastConstants.inited) {
            SilkToast.silkToastInit(Option.None)
        }
        _comp.getOrThrow().toast(props)
    }
    public static func warn(props: SilkToastOptions) {
        if (_comp.isNone() || !SilkToastConstants.inited) {
            SilkToast.silkToastInit(Option.None)
        }
        _comp.getOrThrow().warn(props)
    }
    public static func warn(props: ResourceStr) {
        if (_comp.isNone() || !SilkToastConstants.inited) {
            SilkToast.silkToastInit(Option.None)
        }
        _comp.getOrThrow().warn(props)
    }
        public static func loading(props: SilkToastOptions) {
            if (_comp.isNone() || !SilkToastConstants.inited) {
                SilkToast.silkToastInit(Option.None)
            }
            _comp.getOrThrow().loading(props)
        }
        public static func loading(props: ResourceStr) {
            if (_comp.isNone() || !SilkToastConstants.inited) {
                SilkToast.silkToastInit(Option.None)
            }
            _comp.getOrThrow().loading(props)
        }

    public static func closeToast() {
        if (SilkToastConstants.controllerMap.size > 0) {
            for ((key, value) in SilkToastConstants.controllerMap) {
                value.close()
            }
            SilkToastConstants.controllerMap.clear()
        } else {
            if (SilkToastConstants.controller.isSome()) {
                SilkToastConstants.controller.getOrThrow().close()
            }
        }
    }
}

@Component
public class SilkToastComponent {
    @Link
    @Watch[update]
    var show: Bool
    var props: SilkToastOptions = SilkToastOptions()
    var style: Option<SilkToastStyle> = Option.None
    var controller: CustomDialogController = CustomDialogController(
        CustomDialogControllerOptions(builder: CusDialog()))
    @BuilderParam
    var Content: () -> Unit = DefaultBuilder
    var hasContent: Bool = false

    func update(): Unit {
        if (show) {
            controller.open()
            spawn {
                sleep(props.duration * Duration.millisecond)
                controller.close()
                show = false
            }
        } else {
            controller.close()
            show = false
        }
    }

    protected override func aboutToAppear() {
        controller = CustomDialogController(
            CustomDialogControllerOptions(
                customStyle: true,
                autoCancel: getAutoCancel(props),
                alignment: getAlign(props.showPosition),
                offset: Offset(0.vp, getYOffset(props)),
                maskColor: if (props.overlay) { Color(0x33000000) } else { Color.TRANSPARENT }
            )
        )
        controller.bindView(this)
        controller.setBuilder({
            =>
            let cjDialog = CusDialog(
                    this,
                    message: ObservedProperty("", props.message),
                    showIcon: ObservedProperty("", props.showIcon),
                    icon: ObservedProperty("", props.icon),
                    typeValue: ObservedProperty("", props.toastTyoe),
                    loadingType: ObservedProperty("", props.loadingType),
                    loadingSize: ObservedProperty("", props.loadingSize),
                    wordBreak: ObservedProperty("", props.wordBreak),
                    duration: ObservedProperty("", props.duration),
                    Content: ObservedProperty("", Content),
                    hasContent: ObservedProperty("", hasContent),
                    style: ObservedProperty("", style),
                    onOpened: ObservedProperty("", props.onOpened),
                    onClose: ObservedProperty("", props.onClose)
                )
                CustomView.create(cjDialog)
                cjDialog.setController(controller)
        })
    }
    func build() {
    }

    func getAlign(showPosition: SilkToastPosition): DialogAlignment {
        match (showPosition) {
            case SilkToastPosition.TOP => DialogAlignment.Top
            case SilkToastPosition.BOTTOM => DialogAlignment.Bottom
            case SilkToastPosition.CENTER => DialogAlignment.Center
            case _ => DialogAlignment.Center
        }
    }
    func getAutoCancel(props: SilkToastOptions): Bool {
        if (props.forbidClick) {
            return false
        } else {
            if (props.closeOnClickOverlay) {
                return true
            } else {
                return false
            }
        }
    }
    func getYOffset(props: SilkToastOptions): Length {
        match (props.showPosition) {
            case SilkToastPosition.TOP => props.offset
            case SilkToastPosition.BOTTOM => match (props.offset.unitType) {
            	case LengthType.percent => Length(-props.offset.value * 100.0, unitType: LengthType.percent)
            	case _ => Length(-props.offset.value, unitType: props.offset.unitType)
            }
            case SilkToastPosition.CENTER => 0.vp
            case _ => 0.vp
        }
    }
}

// 切换弹窗是否允许同时存在
public func allowMultipleToast(flag: Option<Bool>) {
    if (flag.isNone() || !flag.getOrThrow()) {
        SilkToastConstants.isSingleton = true
    } else {
        SilkToastConstants.isSingleton = false
    }
}
