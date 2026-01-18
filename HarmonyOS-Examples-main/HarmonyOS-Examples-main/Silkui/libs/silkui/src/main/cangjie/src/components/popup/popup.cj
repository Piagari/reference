/**
 * Created on 2025/5/8
 *
 * SilkPopup 弹出层组件
 *
 * 弹出层组件用于在页面中弹出一个浮层，可以包含各种内容，如消息提示、选择器等。
 *
 * ## 基础用法
 * ```
 * SilkPopup(
 *   show: showPopup,
 *   props: SilkPopupOptions(),
 *   Children: {
 *     => Text("内容").padding(64)
 *   }
 * )
 * ```
 *
 * ## 弹出位置
 * ```
 * SilkPopup(
 *   show: showPopup,
 *   props: SilkPopupOptions(
 *     position: SilkPopupPosition.BOTTOM
 *   ),
 *   Children: {
 *     => Text("底部弹出").padding(64)
 *   }
 * )
 * ```
 *
 * ## 关闭图标
 * ```
 * SilkPopup(
 *   show: showPopup,
 *   props: SilkPopupOptions(
 *     showClose: true
 *   ),
 *   Children: {
 *     => Text("带关闭图标").padding(64)
 *   }
 * )
 * ```
 *
 * @module silkui/components/popup
 */
package silkui.components.popup

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.state_macro_manage.*
import cj_res_silkui.*
import silkui.types.DefaultBuilder
import ohos.window.Window
import ohos.window.getLastWindow
import ohos.ability.getStageContext
import silkui.utils.ResourceColorToColor
import std.os.posix.close
import silkui.SilkUIBorderRadiuses
import silkui.constants.getColorConstant
import silkui.constants.SilkColorKey
import silkui.components.icon.SilkIcon
import silkui.constants.getPopupSizeConstant
import silkui.constants.SilkPopupSizeKey
import silkui.constants.getPopupColorConstant
import silkui.constants.SilkPopupColorKey
import std.sync.Timer
import std.sync.sleep
import std.time.*
import ohos.prompt_action.PromptAction
import silkui.constants.getIntConstant
import silkui.constants.SilkIntKey

/**
 * 安全区域参数结构体
 *
 * 用于存储顶部和底部安全区域的高度
 */
struct AreaParams {
    /**
     * 顶部安全区域高度
     */
    var top: Float64

    /**
     * 底部安全区域高度
     */
    var bottom: Float64

    /**
     * 创建安全区域参数
     *
     * @param top 顶部安全区域高度
     * @param bottom 底部安全区域高度
     */
    public init(top: Float64, bottom: Float64) {
        this.top = top
        this.bottom = bottom
    }
}

/**
 * 弹出层内部组件
 *
 * 用于实现弹出层的具体UI和交互逻辑
 */
@CustomDialog
class PopupComp {
    /**
     * 弹出层控制器
     *
     * 用于控制弹出层的显示和隐藏
     */
    var controller: Option<CustomDialogController> = Option.None

    /**
     * 弹出层配置选项
     */
    var props: SilkPopupOptions = SilkPopupOptions()

    /**
     * 自定义内容构建器
     *
     * 用于构建弹出层的内容区域
     */
    @BuilderParam
    var Children: () -> Unit = DefaultBuilder
    public var _Children: Option<(CustomView) -> ViewBuilder> = Option.None
    /**
     * 是否关闭弹出层
     *
     * 当值为true时，触发关闭动画
     */
    @State
    @Watch[finished]
    var isClose: Bool = false

    /**
     * 安全区域高度
     *
     * 存储顶部和底部安全区域的高度
     */
    @State
    var safeHeight: AreaParams = AreaParams(0.0, 0.0)

    /**
     * 弹出层内容点击回调
     */
    public var click: () -> Unit = {=>}

    /**
     * 遮罩层点击回调
     */
    public var clickOverlay: () -> Unit = {=>}

    /**
     * 关闭按钮点击回调
     */
    public var clickClose: () -> Unit = {=>}

    /**
     * 弹出层打开动画结束回调
     */
    public var opened: () -> Unit = {=>}

    /**
     * 弹出层关闭动画结束回调
     */
    public var closed: () -> Unit = {=>}

    /**
     * 关闭处理函数
     *
     * 返回一个Future<Bool>，用于控制是否允许关闭弹出层
     */
    public var closeHandler: Option<() -> Future<Bool>> = Option.None

    /**
     * 修改关闭状态的回调函数
     */
    public var changeClose: (callback: () -> Unit) -> Unit = {_ =>}

    /**
     * 组件即将出现时的生命周期方法
     */
    protected override func aboutToAppear() {
        if (props.safeTop || props.safeBottom) {
            safeHeight = getAreaHeight().get()
        }
        finished()
        changeClose({=> isClose = true})
    }

    func build() {
        Column() {
            if (!isClose) {
                Column() {
                    Stack(getClosePosition()) {
                        if (_Children.isSome()) {
                            _Children.getOrThrow()()
                        } else {
                            Children()
                        }
                        if (props.showClose) {
                            Column() {
                                SilkIcon(
                                    name: "cross",
                                    fontSize: getPopupSizeConstant(SilkPopupSizeKey.POPUP_CLOSE_ICON_SIZE),
                                    fontColor: getPopupColorConstant(SilkPopupColorKey.POPUP_CLOSE_ICON_COLOR),
                                    lineHeight: getPopupSizeConstant(SilkPopupSizeKey.POPUP_CLOSE_ICON_SIZE)
                                )
                            }
                                .offset(
                                    x: if (props.closePosition == SilkPopupClosePosition.TOP_LEFT ||
                                        props.closePosition == SilkPopupClosePosition.BOTTOM_LEFT) {
                                        getPopupSizeConstant(SilkPopupSizeKey.POPUP_CLOSE_ICON_MARGIN)
                                    } else {
                                        Length(
                                            -getPopupSizeConstant(SilkPopupSizeKey.POPUP_CLOSE_ICON_MARGIN).value,
                                            unitType: getPopupSizeConstant(SilkPopupSizeKey.POPUP_CLOSE_ICON_MARGIN)
                                                .unitType
                                        )
                                    },
                                    y: if (props.closePosition == SilkPopupClosePosition.TOP_LEFT ||
                                        props.closePosition == SilkPopupClosePosition.TOP_RIGHT) {
                                        getPopupSizeConstant(SilkPopupSizeKey.POPUP_CLOSE_ICON_MARGIN)
                                    } else {
                                        Length(
                                            -getPopupSizeConstant(SilkPopupSizeKey.POPUP_CLOSE_ICON_MARGIN).value,
                                            unitType: getPopupSizeConstant(SilkPopupSizeKey.POPUP_CLOSE_ICON_MARGIN)
                                                .unitType
                                        )
                                    }
                                )
                                .onClick(
                                    {
                                        _ =>
                                        AppLog.info("====== clickClose")
                                        clickClose()
                                        _close()
                                    }
                                )
                        }
                    }
                        .width<Length>(getContentWidth())
                        .constraintSize(
                            maxWidth: getConstraintSize().maxWidth,
                            maxHeight: getConstraintSize().maxHeight
                        )
                        .backgroundColor(ResourceColorToColor(getColorConstant(SilkColorKey.BACKGROUND_2)))
                        .borderRadius(
                            topLeft: getRadius().topLeft,
                            topRight: getRadius().topRight,
                            bottomLeft: getRadius().bottomLeft,
                            bottomRight: getRadius().bottomRight
                        )
                        .transition(getTransition())
                        .padding(
                            top: if (props.safeTop) {
                                safeHeight.top
                            } else {
                                0.0
                            },
                            bottom: if (props.safeBottom) {
                                safeHeight.bottom
                            } else {
                                0.0
                            },
                        )
                        .clip(true)
                        .onClick(
                            {
                                _ =>
                                AppLog.info("====== click");
                                click()
                            }
                        )
                }
                    .width(100.percent)
                    .height(100.percent)
                    .backgroundColor(ResourceColorToColor(props.overlayColor))
                    .justifyContent(getJustifyContent())
                    .alignItems(getAlignItems())
                    .transition(TransitionEffect.OPACITY.animation(AnimateParam(duration: props.duration)))
                    .onClick(
                        {
                            _ =>
                            AppLog.info("====== clickOverlay")
                            clickOverlay()
                            if (props.closeOnClickOverlay) {
                                _close()
                            }
                        }
                    )
            }
        }.width(100.percent).height(100.percent)
    }

    /**
     * 获取内容区域的约束尺寸
     *
     * 根据弹出位置返回不同的约束尺寸
     *
     * @return 约束尺寸选项
     */
    private func getConstraintSize(): ConstraintSizeOptions {
        if (props.position == SilkPopupPosition.CENTER) {
            return ConstraintSizeOptions(
                maxWidth: 95.percent,
                maxHeight: 100.percent,
            )
        } else {
            return ConstraintSizeOptions(
                maxWidth: 100.percent,
                maxHeight: 100.percent,
            )
        }
    }

    /**
     * 获取安全区域高度
     *
     * @return 包含顶部和底部安全区域高度的Future
     */
    private func getAreaHeight(): Future<AreaParams> {
        spawn {
            =>
            // TODO 不知道如何获取安全区域
            AreaParams(0.0, 0.0)
        }
    }

    /**
     * 获取主轴对齐方式
     *
     * 根据弹出位置返回不同的主轴对齐方式
     *
     * @return 主轴对齐方式
     */
    private func getJustifyContent() {
        match (props.position) {
            case SilkPopupPosition.TOP => FlexAlign.Start
            case SilkPopupPosition.LEFT => FlexAlign.Start
            case SilkPopupPosition.RIGHT => FlexAlign.Start
            case SilkPopupPosition.BOTTOM => FlexAlign.End
            case SilkPopupPosition.CENTER => FlexAlign.Center
        }
    }

    /**
     * 获取交叉轴对齐方式
     *
     * 根据弹出位置返回不同的交叉轴对齐方式
     *
     * @return 交叉轴对齐方式
     */
    private func getAlignItems() {
        match (props.position) {
            case SilkPopupPosition.LEFT => HorizontalAlign.Start
            case SilkPopupPosition.RIGHT => HorizontalAlign.End
            case _ => HorizontalAlign.Center
        }
    }

    /**
     * 获取内容宽度
     *
     * 根据弹出位置返回不同的内容宽度
     *
     * @return 内容宽度
     */
    private func getContentWidth() {
        if (props.position == SilkPopupPosition.TOP || props.position == SilkPopupPosition.BOTTOM) {
            100.percent
        } else if (props.position == SilkPopupPosition.CENTER) {
            Option<Length>.None
        } else {
            props.widthValue
        }
    }

    /**
     * 获取圆角设置
     *
     * 根据弹出位置和圆角设置返回不同的圆角配置
     *
     * @return 圆角配置
     */
    private func getRadius() {
        if (props.round) {
            match (props.position) {
                case SilkPopupPosition.TOP => SilkUIBorderRadiuses(
                    bottomLeft: props.roundValue,
                    bottomRight: props.roundValue
                )
                case SilkPopupPosition.BOTTOM => SilkUIBorderRadiuses(
                    topLeft: props.roundValue,
                    topRight: props.roundValue
                )
                case SilkPopupPosition.LEFT => SilkUIBorderRadiuses(
                    topRight: props.roundValue,
                    bottomRight: props.roundValue
                )
                case SilkPopupPosition.RIGHT => SilkUIBorderRadiuses(
                    topLeft: props.roundValue,
                    bottomLeft: props.roundValue
                )
                case _ => SilkUIBorderRadiuses(
                    topLeft: props.roundValue,
                    topRight: props.roundValue,
                    bottomLeft: props.roundValue,
                    bottomRight: props.roundValue
                )
            }
        } else {
            SilkUIBorderRadiuses()
        }
    }

    /**
     * 获取关闭图标位置
     *
     * 根据关闭图标位置设置返回不同的对齐方式
     *
     * @return 关闭图标对齐方式
     */
    private func getClosePosition() {
        match (props.closePosition) {
            case SilkPopupClosePosition.TOP_LEFT => Alignment.TopStart
            case SilkPopupClosePosition.TOP_RIGHT => Alignment.TopEnd
            case SilkPopupClosePosition.BOTTOM_LEFT => Alignment.BottomStart
            case SilkPopupClosePosition.BOTTOM_RIGHT => Alignment.BottomEnd
        }
    }

    /**
     * 获取过渡动画效果
     *
     * 根据弹出位置返回不同的过渡动画效果
     *
     * @return 过渡动画效果
     */
    private func getTransition() {
        match (props.position) {
            case SilkPopupPosition.BOTTOM => TransitionEffect
                .move(TransitionEdge.BOTTOM)
                .animation(AnimateParam(duration: props.duration))
            case SilkPopupPosition.TOP => TransitionEffect
                .move(TransitionEdge.TOP)
                .animation(AnimateParam(duration: props.duration))
            case SilkPopupPosition.LEFT => TransitionEffect
                .move(TransitionEdge.START)
                .animation(AnimateParam(duration: props.duration))
            case SilkPopupPosition.RIGHT => TransitionEffect
                .move(TransitionEdge.END)
                .animation(AnimateParam(duration: props.duration))
            case SilkPopupPosition.CENTER => TransitionEffect.OPACITY.animation(AnimateParam(duration: props.duration))
        }
    }

    /**
     * 动画完成处理函数
     *
     * 在动画完成后触发相应的回调
     */
    private func finished() {
        spawn {
            =>
            sleep(Int64(props.duration) * Duration.millisecond)
            if (isClose) {
                controller?.close()
                AppLog.info("====== closeed")
                closed()
            } else {
                AppLog.info("====== opened")
                opened()
            }
        }
        return;
    }

    /**
     * 关闭弹出层
     *
     * 调用关闭处理函数并根据返回值决定是否关闭弹出层
     */
    private func _close() {
        let res = closeHandler.getOrThrow()().get()
        if (res) {
            isClose = true
        }
    }
}

/**
 * 弹出层组件
 *
 * 用于在页面中弹出一个浮层，可以包含各种内容
 */
@Component
public class SilkPopup {
    /**
     * 控制弹出层是否显示
     *
     * 当值为true时显示弹出层，为false时隐藏弹出层
     */
    @Link
    @Watch[updateShow]
    var show: Bool = false

    /**
     * 弹出层配置选项
     */
    @Prop
    var props: SilkPopupOptions

    /**
     * 弹出层内容点击回调
     */
    public var click: () -> Unit = {=>}

    /**
     * 遮罩层点击回调
     */
    public var clickOverlay: () -> Unit = {=>}

    /**
     * 关闭按钮点击回调
     */
    public var clickClose: () -> Unit = {=>}

    /**
     * 弹出层打开时立即触发的回调
     */
    public var open: () -> Unit = {=>}

    /**
     * 弹出层打开动画结束后触发的回调
     */
    public var opened: () -> Unit = {=>}

    /**
     * 弹出层关闭时立即触发的回调
     */
    public var close: () -> Unit = {=>}

    /**
     * 弹出层关闭动画结束后触发的回调
     */
    public var closed: () -> Unit = {=>}

    /**
     * 关闭前的回调函数
     *
     * 返回一个Future<Bool>，用于控制是否允许关闭弹出层
     */
    public var beforeClose: Option<() -> Future<Bool>> = Option.None

    /**
     * 自定义内容构建器
     *
     * 用于构建弹出层的内容区域
     */
    @BuilderParam
    var Children: () -> Unit = DefaultBuilder
    public var _Children: Option<(CustomView) -> ViewBuilder> = Option.None
    /**
     * 弹出层控制器
     *
     * 用于控制弹出层的显示和隐藏
     */
    var controller: CustomDialogController = CustomDialogController(CustomDialogControllerOptions(builder: PopupComp()))

    /**
     * 组件即将出现时的生命周期方法
     *
     * 初始化弹出层控制器并设置相关属性
     */
    protected func aboutToAppear() {
        controller = CustomDialogController(
            CustomDialogControllerOptions(
                customStyle: true,
                alignment: getDialogAlignment(),
                openAnimation: AnimateParam(duration: 0),
                closeAnimation: AnimateParam(duration: 0),
                maskColor: Color.TRANSPARENT,
                // TODO onWillDismiss 阻止遮罩点击关闭 API暂不支持
                autoCancel: props.closeOnClickOverlay
            )
        )
        controller.bindView(this)
        controller.setBuilder(
            {
                =>
                let cjDialog = PopupComp(
                    this,
                    props: ObservedProperty("", props),
                    Children: ObservedProperty("", Children),
                    _Children: ObservedProperty("", _Children),
                    click: ObservedProperty("", click),
                    clickOverlay: ObservedProperty("", clickOverlay),
                    clickClose: ObservedProperty("", clickClose),
                    opened: ObservedProperty("", opened),
                    closed: ObservedProperty("", closed),
                    closeHandler: ObservedProperty("", _compClose),
                    changeClose: ObservedProperty("", changeComp)
                )
                CustomView.create(cjDialog)
                cjDialog.setController(controller)
            }
        )
    }

    /**
     * 构建方法
     *
     * 弹出层组件不需要在UI中渲染任何内容
     */
    func build() {}

    /**
     * 监听show属性变化
     *
     * 当show属性变化时，根据新值显示或隐藏弹出层
     */
    private func updateShow() {
        if (show) {
            showHandler()
        } else {
            closeHandler()
        }
    }

    /**
     * 显示弹出层
     *
     * 触发open回调并打开弹出层
     */
    private func showHandler() {
        AppLog.info("====== open")
        open()
        controller.open()
        show = true
    }

    /**
     * 关闭弹出层
     *
     * 触发close回调并关闭弹出层
     */
    private func closeHandler() {
        close();
        show = false
        CompCallback()
    }

    /**
     * 修改弹框中的isClose属性的回调函数
     *
     * 用于触发关闭时动画
     */
    private var CompCallback: () -> Unit = {=>}

    /**
     * 设置修改关闭状态的回调函数
     *
     * @param callback 回调函数
     */
    private func changeComp(callback: () -> Unit) {
        CompCallback = callback
    }

    /**
     * 提供给组件的关闭方法
     *
     * 用于点击关闭按钮或遮罩层时关闭弹出层
     *
     * @return 包含是否允许关闭的Future
     */
    private func _compClose() {
        if (beforeClose.isSome()) {
            let res = beforeClose.getOrThrow()().get()
            if (res) {
                AppLog.info("====== close")
                show = false
                close();
                spawn {
                    => true
                }
            } else {
                spawn {
                    => false
                }
            }
        } else {
            AppLog.info("====== close")
            show = false
            close()
            spawn {
                => true
            }
        }
    }

    /**
     * 获取对话框对齐方式
     *
     * 根据弹出位置返回不同的对话框对齐方式
     *
     * @return 对话框对齐方式
     */
    private func getDialogAlignment() {
        match (props.position) {
            case SilkPopupPosition.CENTER => DialogAlignment.Default
            case SilkPopupPosition.LEFT => DialogAlignment.TopStart
            case SilkPopupPosition.RIGHT => DialogAlignment.TopEnd
            case SilkPopupPosition.TOP => DialogAlignment.Top
            case SilkPopupPosition.BOTTOM => DialogAlignment.Bottom
        }
    }
}
