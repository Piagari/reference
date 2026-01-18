/**
 * Created on 2025/4/26
 *
 * SilkDialog 对话框组件
 *
 * 对话框用于展示重要信息或请求用户进行操作，支持多种样式和交互方式。
 *
 * ## 基础用法
 * ```
 * SilkDialog(props: SilkDialogOptions(
 *   title: "标题",
 *   message: "内容",
 *   showConfirm: true,
 *   showCancel: true
 * ))
 * ```
 *
 * ## 异步关闭
 * ```
 * SilkDialog(props: SilkDialogOptions(
 *   title: "标题",
 *   message: "内容",
 *   beforeClose: (action) => {
 *     // 返回 Promise
 *     return Future.resolve(true)
 *   }
 * ))
 * ```
 *
 * ## 自定义按钮样式
 * ```
 * SilkDialog(props: SilkDialogOptions(
 *   title: "标题",
 *   message: "内容",
 *   theme: SilkDialogTheme.ROUND_BUTTON
 * ))
 * ```
 *
 * @module silkui/components/dialog
 */
package silkui.components.dialog

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.state_macro_manage.*
import cj_res_silkui.*
import silkui.types.DefaultBuilder
import silkui.components.button.SilkButton
import silkui.components.button.SilkButtonOptions
import silkui.components.button.SilkButtonSize
import silkui.components.button.SilkButtonLoading
import silkui.utils.ResourceColorToColor
import silkui.constants.getColorConstant
import silkui.constants.SilkColorKey
import silkui.SilkUIPaddingOptions
import silkui.constants.getSizeConstant
import silkui.constants.SilkSizeKey
import silkui.utils.ResourceStrToString
import silkui.constants.__SilkDialogHeaderFontWeight
import silkui.constants.getDialogSizeConstant
import silkui.constants.SilkDialogSizeKey

/**
 * 对话框内部组件
 *
 * 用于实现对话框的具体UI和交互逻辑
 */
@CustomDialog
class DialogComp {
    /**
     * 对话框控制器
     *
     * 用于控制对话框的显示和隐藏
     */
    var controller: Option<CustomDialogController> = Option.None

    /**
     * 内容构建器
     *
     * 用于构建对话框的内容区域
     */
    @BuilderParam
    var Body: () -> Unit = DefaultBuilder

    /**
     * 是否有自定义内容
     */
    var hasBody: Bool = false

    /**
     * 底部构建器
     *
     * 用于构建对话框的底部按钮区域
     */
    @BuilderParam
    var Footer: () -> Unit = DefaultBuilder

    /**
     * 是否有自定义底部
     */
    var hasFooter: Bool = false

    /**
     * 头部构建器
     *
     * 用于构建对话框的头部标题区域
     */
    @BuilderParam
    var Header: () -> Unit = DefaultBuilder

    /**
     * 是否有自定义头部
     */
    var hasHeader: Bool = false

    /**
     * 对话框配置选项
     */
    var props: SilkDialogOptions = SilkDialogOptions()

    /**
     * 取消按钮加载状态
     */
    @State
    var cancelLoading: Bool = false

    /**
     * 确认按钮加载状态
     */
    @State
    var okLoading: Bool = false

    func build() {
        Column() {
            HeaderBuilder()
            Column() {
                ContentBuilder()
            }.constraintSize(maxHeight: 100.percent)
            FooterBuilder()
        }
            .width(props.widthValue)
            .clip(true)
            .backgroundColor(ResourceColorToColor(props.bgcColor))
            .borderRadius(props.round)
    }

    @Builder
    func HeaderBuilder() {
        if (hasHeader) {
            Header()
        } else if (!ResourceStrToString(props.title).isEmpty() && ResourceStrToString(props.title).size > 0) {
            Text(ResourceStrToString(props.title))
                .width(100.percent)
                .fontSize(props.titleSize)
                .fontWeight(__SilkDialogHeaderFontWeight)
                .lineHeight(getDialogSizeConstant(SilkDialogSizeKey.DIALOG_HEADER_LINE_HEIGHT))
                .fontColor(ResourceColorToColor(props.titleColor))
                .padding(top: props.headerPadding.top, right: props.headerPadding.right, left: props.headerPadding.left,
                    bottom: props.headerPadding.bottom)
                .textAlign(TextAlign.Center)
        }
    }
    @Builder
    func ContentBuilder() {
        if (hasBody) {
            Body()
        } else if (!ResourceStrToString(props.message).isEmpty() && ResourceStrToString(props.message).size > 0) {
            Text(ResourceStrToString(props.message))
                .width(100.percent)
                .fontSize(props.messageSize)
                .lineHeight(props.messageLineHeight)
                .fontColor(ResourceColorToColor(props.messageColor))
                .padding(top: props.contentPadding.top, right: props.contentPadding.right,
                    left: props.contentPadding.left, bottom: props.contentPadding.bottom)
                .textAlign(props.messageAlign)
        }
    }
    @Builder
    func FooterBuilder() {
        if (hasFooter) {
            Footer()
        } else if (props.showConfirm || props.showCancel) {
            Row() {
                // 只有一个确认按钮
                if (!props.showCancel && props.showConfirm) {
                    SilkButton(
                        props: SilkButtonOptions(
                            text: props.confirmText,
                            square: props.theme != SilkDialogTheme.ROUND_BUTTON,
                            round: props.theme == SilkDialogTheme.ROUND_BUTTON,
                            textColor: props.confirmColor,
                            color: props.confirmBgColor,
                            size: SilkButtonSize.LARGE,
                            linearGradient: props.linearGradient,
                            hasBorder: false
                        ),
                        click: {
                            _
                            =>
                            okLoading = true
                            if (props.beforeClose.isSome()) {
                                spawn {
                                    let res = props.beforeClose.getOrThrow()("confirm").get()
                                    okLoading = false
                                    if (res) {
                                        if (props.onConfirm.isSome()) {
                                            props.onConfirm.getOrThrow()()
                                        }
                                    }
                                }
                                return;
                            } else {
                                if (props.onConfirm.isSome()) {
                                    props.onConfirm.getOrThrow()()
                                }
                                okLoading = false
                            }
                        }
                    )
                } else {
                    Row() {
                        SilkButtonLoading(
                            props: SilkButtonOptions(
                                text: if (cancelLoading) {
                                    String.empty
                                } else {
                                    props.cancelText
                                },
                                square: props.theme != SilkDialogTheme.ROUND_BUTTON,
                                round: props.theme == SilkDialogTheme.ROUND_BUTTON,
                                textColor: props.cancelColor,
                                height: props.buttonHeight,
                                size: SilkButtonSize.LARGE,
                                hasBorder: false,
                                color: props.cancelBgColor,
                            ),
                            loading: cancelLoading,
                            click: {
                                _
                                =>
                                cancelLoading = true
                                if (props.beforeClose.isSome()) {
                                    // 创建一个异步任务来处理beforeClose
                                    spawn {
                                        // 在异步任务中调用beforeClose并获取结果
                                        let res = props.beforeClose.getOrThrow()("cancel").get()

                                        // 异步操作完成后，更新UI状态
                                        // 注意：这里需要确保在UI线程上执行
                                        cancelLoading = false

                                        // 根据结果执行后续操作
                                        if (res) {
                                            if (props.onCancel.isSome()) {
                                                props.onCancel.getOrThrow()()
                                            }
                                        }
                                    }
                                    return;
                                } else {
                                    if (props.onCancel.isSome()) {
                                        props.onCancel.getOrThrow()()
                                    }
                                    cancelLoading = false
                                }
                            }
                        )
                    }.layoutWeight(1)
                    Divider()
                        .vertical(true)
                        .strokeWidth(Length(1, unitType: LengthType.px))
                        .color(ResourceColorToColor(getColorConstant(SilkColorKey.BORDER_COLOR)))
                        .height(props.buttonHeight)
                    Row() {
                        SilkButtonLoading(
                            props: SilkButtonOptions(
                                text: if (okLoading) {
                                    String.empty
                                } else {
                                    props.confirmText
                                },
                                square: props.theme != SilkDialogTheme.ROUND_BUTTON,
                                round: props.theme == SilkDialogTheme.ROUND_BUTTON,
                                textColor: props.confirmColor,
                                color: props.confirmBgColor,
                                height: props.buttonHeight,
                                size: SilkButtonSize.LARGE,
                                hasBorder: false
                            ),
                            loading: okLoading,
                            click: {
                                _
                                =>
                                okLoading = true
                                if (props.beforeClose.isSome()) {
                                    spawn {
                                        let res = props.beforeClose.getOrThrow()("confirm").get()
                                        okLoading = false
                                        if (res) {
                                            if (props.onConfirm.isSome()) {
                                                props.onConfirm.getOrThrow()()
                                            }
                                        }
                                    }
                                    return;
                                } else {
                                    if (props.onConfirm.isSome()) {
                                        props.onConfirm.getOrThrow()()
                                    }
                                    okLoading = false
                                }
                            }
                        )
                    }.layoutWeight(1)
                }
            }
                .padding(
                    top: getPadding().top,
                    bottom: getPadding().bottom,
                    left: getPadding().left,
                    right: getPadding().right
                )
                .justifyContent(FlexAlign.Center)
                .width(100.percent)
                .borderWidth(getBorder())
                .borderStyle(BorderStyle.Solid)
                .borderColor(ResourceColorToColor(getColorConstant(SilkColorKey.BORDER_COLOR)))
        }
    }

    private func getPadding() {
        if (props.bottomPadding.isSome()) {
            return props.bottomPadding.getOrThrow()
        }
        if (props.theme == SilkDialogTheme.DEFAULT) {
            return SilkUIPaddingOptions(left: 0.vp, right: 0.vp)
        } else {
            return SilkUIPaddingOptions(
                top: getSizeConstant(SilkSizeKey.PADDING_XS),
                bottom: getSizeConstant(SilkSizeKey.PADDING_LG),
                left: getSizeConstant(SilkSizeKey.PADDING_LG),
                right: getSizeConstant(SilkSizeKey.PADDING_MD)
            )
        }
    }
    private func getBorder() {
        if (props.theme == SilkDialogTheme.DEFAULT && props.hasDivider) {
            return EdgeWidths(top: 1.px)
        } else {
            return EdgeWidths(top: 0.px)
        }
    }
}

/**
 * 对话框组件
 *
 * 用于展示重要信息或请求用户进行操作
 */
@Component
public class SilkDialog {
    /**
     * 控制对话框是否显示
     *
     * 当值为true时显示对话框，为false时隐藏对话框
     */
    @Link
    @Watch[updateShow]
    var show: Bool = false

    /**
     * 对话框配置选项
     */
    public var props: SilkDialogOptions = SilkDialogOptions()
//    @Prop
//    var confirmButtonDisabled: Bool
//    @Prop
//    var cancelButtonDisabled: Bool

    /**
     * 自定义头部构建器
     *
     * 用于自定义对话框的头部标题区域
     */
    @BuilderParam
    var Header: () -> Unit = DefaultBuilder

    /**
     * 自定义内容构建器
     *
     * 用于自定义对话框的内容区域
     */
    @BuilderParam
    var Body: () -> Unit = DefaultBuilder

    /**
     * 自定义底部构建器
     *
     * 用于自定义对话框的底部按钮区域
     */
    @BuilderParam
    var Footer: () -> Unit = DefaultBuilder

    /**
     * 是否有自定义头部
     */
    var hasHeader: Bool = false

    /**
     * 是否有自定义底部
     */
    var hasFooter: Bool = false

    /**
     * 是否有自定义内容
     */
    var hasBody: Bool = false

    /**
     * 对话框控制器
     *
     * 用于控制对话框的显示和隐藏
     */
    var controller: CustomDialogController = CustomDialogController(
        CustomDialogControllerOptions(builder: DialogComp()))
    func updateShow() {
        if (show) {
            showHandler()
        // TODO 页面跳转监听
        //            if (props.closeOnPopstate) {
        //            }
        } else {
            closeHandler()
        }
    }
    private func callback() {
        show = false
    }
    private func showHandler() {
        controller.open()
        show = true
    }
    private func closeHandler() {
        controller.close()
        show = false
    }

    protected func aboutToAppear() {
        if (props.onConfirm.isNone()) {
            props.onConfirm = {=> show = false}
        }
        if (props.onCancel.isNone()) {
            props.onCancel = {=> show = false}
        }
        controller = CustomDialogController(
            CustomDialogControllerOptions(
                customStyle: true,
                alignment: DialogAlignment.Center
            )
        )
        controller.bindView(this)
        controller.setBuilder(
            {
                => // message: ObservedProperty("", props.message),
                let cjDialog = DialogComp(
                    this,
                    props: ObservedProperty("", props),
                    Header: ObservedProperty("", Header),
                    Body: ObservedProperty("", Body),
                    Footer: ObservedProperty("", Footer),
                    hasHeader: ObservedProperty("", hasHeader),
                    hasFooter: ObservedProperty("", hasFooter),
                    hasBody: ObservedProperty("", hasBody)
                )
                CustomView.create(cjDialog)
                cjDialog.setController(controller)
            }
        )
    }

    func build() {
    }
}

/**
 * 函数式对话框组件
 *
 * 用于实现函数调用方式显示对话框
 */
@Component
class SilkDialogFn {
    /**
     * 对话框控制器
     *
     * 用于控制对话框的显示和隐藏
     */
    private var _controller: CustomDialogController = CustomDialogController(
        CustomDialogControllerOptions(builder: DialogComp()))

    /**
     * 挂载对话框
     *
     * 初始化并显示对话框
     *
     * @param props 对话框配置选项
     */
    public func _mounted(props: SilkDialogOptions) {
        if (props.onConfirm.isSome()) {
            let fn = props.onConfirm
            props.onConfirm = {
                =>
                fn.getOrThrow()()
                _controller.close()
            }
        } else {
            props.onConfirm = {
                => _controller.close()
            }
        }
        if (props.onCancel.isSome()) {
            let fn = props.onCancel
            props.onCancel = {
                =>
                fn.getOrThrow()()
                _controller.close()
            }
        } else {
            props.onCancel = {
                => _controller.close()
            }
        }
        _controller = CustomDialogController(
            CustomDialogControllerOptions(
                customStyle: true,
                alignment: DialogAlignment.Center,
                autoCancel: props.autoCancel
            )
        )
        _controller.bindView(this)
        _controller.setBuilder(
            {
                => // message: ObservedProperty("", props.message),
                let cjDialog = DialogComp(
                    this,
                    props: ObservedProperty("", props),
                    hasHeader: ObservedProperty("", false),
                    hasFooter: ObservedProperty("", false),
                    hasBody: ObservedProperty("", false)
                )
                CustomView.create(cjDialog)
                cjDialog.setController(_controller)
            }
        )
        _controller.open()
    }
    private func showHandler() {
        _controller.open()
        // this.show = true
    }

    private func closeHandler() {
        _controller.close()
        // this.show = false
    }
    // 显示隐藏
    // updateShow() {
    //   if (this.show) {
    //     this.showHandler()
    //     if (this.close_on_pop_state) {
    //       // 页面变化时关闭弹框
    //       this.getUIContext().getUIObserver().on('navDestinationSwitch', () => this.callback())
    //     }
    //   } else {
    //     this.closeHandler()
    //     if (this.close_on_pop_state) {
    //       // 页面变化时关闭弹框
    //       this.getUIContext().getUIObserver().off('navDestinationSwitch', () => this.callback())
    //     }
    //   }
    // }
    func build() {}
}

/**
 * 显示对话框
 *
 * 函数式调用方式显示对话框
 *
 * @param props 对话框配置选项
 */
public func ShowSilkDialog(props: SilkDialogOptions) {
    SilkDialogFn(Option<CustomView>.None)._mounted(props)
}

/**
 * 显示确认对话框
 *
 * 函数式调用方式显示带取消按钮的确认对话框
 *
 * @param props 对话框配置选项
 */
public func ShowSilkConfirmDialog(props: SilkDialogOptions) {
    props.showCancel = true
    SilkDialogFn(Option<CustomView>.None)._mounted(props)
}
