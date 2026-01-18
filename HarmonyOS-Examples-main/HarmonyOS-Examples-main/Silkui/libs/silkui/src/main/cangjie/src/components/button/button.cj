/**
 * Created on 2025/4/27
 *
 * SilkButton 按钮组件
 *
 * 按钮用于触发一个操作，如提交表单。
 *
 * ## 基础用法
 * ```
 * SilkButton(props: SilkButtonOptions(text: "按钮"))
 * ```
 *
 * ## 按钮类型
 * 支持 `default`、`primary`、`success`、`warning`、`danger` 五种类型，默认为 `default`。
 * ```
 * SilkButton(props: SilkButtonOptions(text: "主要按钮", buttonType: SilkButtonType.PRIMARY))
 * SilkButton(props: SilkButtonOptions(text: "成功按钮", buttonType: SilkButtonType.SUCCESS))
 * SilkButton(props: SilkButtonOptions(text: "警告按钮", buttonType: SilkButtonType.WARNING))
 * SilkButton(props: SilkButtonOptions(text: "危险按钮", buttonType: SilkButtonType.DANGER))
 * ```
 *
 * ## 朴素按钮
 * 通过 `plain` 属性将按钮设置为朴素按钮，朴素按钮的文字为按钮颜色，背景为白色。
 * ```
 * SilkButton(props: SilkButtonOptions(text: "朴素按钮", plain: true))
 * SilkButton(props: SilkButtonOptions(text: "主要按钮", buttonType: SilkButtonType.PRIMARY, plain: true))
 * ```
 *
 * ## 按钮尺寸
 * 支持 `large`、`normal`、`small`、`mini` 四种尺寸，默认为 `normal`。
 * ```
 * SilkButton(props: SilkButtonOptions(text: "大号按钮", size: SilkButtonSize.LARGE))
 * SilkButton(props: SilkButtonOptions(text: "普通按钮", size: SilkButtonSize.NORMAL))
 * SilkButton(props: SilkButtonOptions(text: "小型按钮", size: SilkButtonSize.SMALL))
 * SilkButton(props: SilkButtonOptions(text: "迷你按钮", size: SilkButtonSize.MINI))
 * ```
 *
 * ## 自定义颜色
 * 通过 `color` 属性可以自定义按钮的颜色。
 * ```
 * SilkButton(props: SilkButtonOptions(text: "自定义颜色", color: Color(255, 0, 0, alpha: 1.0)))
 * ```
 *
 * ## 加载状态
 * 通过 `loading` 属性设置按钮为加载状态，加载状态下默认会禁用按钮。
 * ```
 * SilkButtonLoading(props: SilkButtonOptions(text: "加载中..."), loading: true)
 * ```
 *
 * @module silkui/components/button
 */
package silkui.components.button

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.Resource
import ohos.state_macro_manage.*
import cj_res_silkui.*
import silkui.types.DefaultBuilder
import silkui.components.icon.SilkIcon
import silkui.SilkUIPaddingOptions
import silkui.constants.SilkButtonColorKey
import silkui.constants.SilkButtonSizeKey
import silkui.constants.SilkButtonIntKey
import silkui.constants.getButtonColorConstant
import silkui.constants.getButtonSizeConstant
import silkui.constants.getButtonIntConstant
import silkui.constants.SilkSizeKey
import silkui.constants.getSizeConstant
import silkui.components.loading.SilkLoading
import silkui.SilkUILinearGradientOptions
import silkui.ResourceColor
import silkui.utils.ResourceColorToColor
import silkui.ResourceStr
import silkui.utils.ResourceStrToString
import net.http.ClientBuilder

/**
 * 基础按钮组件
 *
 * 用于触发一个操作，如提交表单
 */
@Component
public class SilkButton {
    /**
     * 按钮配置选项
     */
    @Prop
    var props: SilkButtonOptions

    /**
     * 点击事件回调函数
     */
    public var click: (e: ClickEvent) -> Unit = {_=>}

    /**
     * 自定义按钮内容
     *
     * 可以通过此参数自定义按钮的文本内容
     */
    @BuilderParam
    var Default: () -> Unit = DefaultBuilder
    var hasDefault: Bool = false

    /**
     * 自定义图标内容
     *
     * 可以通过此参数自定义按钮的图标
     */
    @BuilderParam
    var Icon: () -> Unit = DefaultBuilder
    var hasIcon: Bool = false

    func build() {
        Button() {
            Row() {
                if (hasIcon) {
                    Icon()
                } else {
                    if (!ResourceStrToString(props.icon).isEmpty() && ResourceStrToString(props.icon).size > 0) {
                        SilkIcon(name: props.icon, family: props.iconPrefix, fontSize: getIconSize(props),
                            fontColor: ResourceColorToColor(getColor(props)))
                    }
                }
                if (hasDefault) {
                    Default()
                } else {
                    Text(ResourceStrToString(props.text))
                        .fontSize(getFontSize(props))
                        .lineHeight(getLineHeight(props))
                        .textAlign(TextAlign.Center)
                        .fontColor(ResourceColorToColor(getColor(props)))
                        .padding(
                            left: if (ResourceStrToString(props.icon).isEmpty() || ResourceStrToString(props.icon).size > 0) {
                                0.vp
                            } else {
                                getSizeConstant(SilkSizeKey.PADDING_BASE)
                            })
                }
            }
            .width<Length>(
                    if (props.width.isSome()) {
                        props.width.getOrThrow()
                    } else if (props.size == SilkButtonSize.LARGE) {
                        100.percent
                    } else {
                        None<Length>
                    })
                .height(getHeight(props))
                .direction(getDirection(props))
                .padding(top: getPadding(props).top, bottom: getPadding(props).bottom, left: getPadding(props).left,
                    right: getPadding(props).right)
                .linearGradient(angle: getLinearGradient(props).angle, direction: getLinearGradient(props).direction,
                    colors: getLinearGradient(props).colors, repeating: getLinearGradient(props).repeating)
                .alignItems(VerticalAlign.Center)
                .justifyContent(FlexAlign.Center)
        }
            .shape(ShapeType.Normal)
            .padding(0)
            .borderRadius(getRadius(props))
        .clip(true)
            .backgroundColor(ResourceColorToColor(getBackground(props)))
            .borderWidth(getBorderWidth(props))
            .borderStyle(BorderStyle.Solid)
            .borderColor(ResourceColorToColor(getBorderColor(props)))
            .onClick {e => click(e)}
    }
}

/**
 * 带加载状态的按钮组件
 *
 * 可以显示加载状态的按钮，加载状态下默认会禁用按钮
 */
@Component
public class SilkButtonLoading {
    /**
     * 按钮配置选项
     */
    @Prop
    var props: SilkButtonOptions

    /**
     * 是否处于加载状态
     *
     * 当为 true 时，按钮将显示加载指示器并禁用点击
     */
    @Link
    var loading: Bool = false

    /**
     * 点击事件回调函数
     */
    public var click: (e: ClickEvent) -> Unit = {_=>}

    /**
     * 自定义颜色
     */
    public var color: Option<Color> = Option.None

    /**
     * 自定义按钮内容
     *
     * 可以通过此参数自定义按钮的文本内容
     */
    @BuilderParam
    var Default: () -> Unit = DefaultBuilder
    var hasDefault: Bool = false

    /**
     * 自定义图标内容
     *
     * 可以通过此参数自定义按钮的图标
     */
    @BuilderParam
    var Icon: () -> Unit = DefaultBuilder
    var hasIcon: Bool = false

    /**
     * 自定义加载状态内容
     *
     * 可以通过此参数自定义按钮的加载状态显示
     */
    @BuilderParam
    var Loading: () -> Unit = DefaultBuilder
    var hasLoading: Bool = false

    func build() {
        Button() {
            Row() {
                if (loading) {
                    if (hasLoading) {
                        Loading()
                    } else {
                        SilkLoading(
                            loadingType: props.loadingType,
                            size: props.loadingSize,
                            text: ResourceStrToString(props.loadingText),
                            color: ResourceColorToColor(getColor(props)),
                            textColor: ResourceColorToColor(getColor(props))
                        )
                    }
                } else {
                    if (hasIcon) {
                        Icon()
                    } else {
                        if (!ResourceStrToString(props.icon).isEmpty() && ResourceStrToString(props.icon).size > 0) {
                            SilkIcon(name: props.icon, family: props.iconPrefix, fontSize: getIconSize(props),
                                fontColor: ResourceColorToColor(getColor(props)))
                        }
                    }
                    if (hasDefault) {
                        Default()
                    } else {
                        Text(ResourceStrToString(props.text))
                            .fontSize(getFontSize(props))
                            .lineHeight(getLineHeight(props))
                            .textAlign(TextAlign.Center)
                            .fontColor(ResourceColorToColor(ResourceColorToColor(getColor(props))))
                            .padding(
                                left: if (ResourceStrToString(props.icon).isEmpty() || ResourceStrToString(props.icon).size > 0) {
                                    0.vp
                                } else {
                                    getSizeConstant(SilkSizeKey.PADDING_BASE)
                                })
                    }
                }
            }
                .width<Length>(
                    if (props.width.isSome()) {
                        props.width.getOrThrow()
                    } else if (props.size == SilkButtonSize.LARGE) {
                        100.percent
                    } else {
                        None<Length>
                    })
                .height(getHeight(props))
                .direction(getDirection(props))
                .padding(top: getPadding(props).top, bottom: getPadding(props).bottom, left: getPadding(props).left,
                    right: getPadding(props).right)
                .linearGradient(angle: getLinearGradient(props).angle, direction: getLinearGradient(props).direction,
                    colors: getLinearGradient(props).colors, repeating: getLinearGradient(props).repeating)
                .alignItems(VerticalAlign.Center)
                .justifyContent(FlexAlign.Center)
        }
            .shape(ShapeType.Normal)
            .padding(0)
        .clip(true)
            .borderRadius(getRadius(props))
            .backgroundColor(ResourceColorToColor(getBackground(props)))
            .borderWidth(getBorderWidth(props))
            .borderStyle(BorderStyle.Solid)
            .borderColor(ResourceColorToColor(getBorderColor(props)))
            .enabled(!loading)
            .onClick { e =>
                if (loading) {
                    return;
                }
                click(e)
            }
    }
}

/**
 * 可禁用的按钮组件
 *
 * 可以设置为禁用状态的按钮，禁用状态下按钮不可点击
 */
@Component
public class SilkButtonDisabled {
    /**
     * 按钮配置选项
     */
    @Prop
    var props: SilkButtonOptions

    /**
     * 是否禁用按钮
     *
     * 当为 true 时，按钮将被禁用且不可点击
     */
    @Prop
    var disabled: Bool

    /**
     * 点击事件回调函数
     */
    public var click: (e: ClickEvent) -> Unit = {_=>}

    /**
     * 自定义颜色
     */
    public var color: Option<Color> = Option.None

    /**
     * 自定义按钮内容
     *
     * 可以通过此参数自定义按钮的文本内容
     */
    @BuilderParam
    var Default: () -> Unit = DefaultBuilder
    var hasDefault: Bool = false

    /**
     * 自定义图标内容
     *
     * 可以通过此参数自定义按钮的图标
     */
    @BuilderParam
    var Icon: () -> Unit = DefaultBuilder
    var hasIcon: Bool = false

    func build() {
        Button() {
            Row() {
                if (hasIcon) {
                    Icon()
                } else {
                    if (!ResourceStrToString(props.icon).isEmpty() && ResourceStrToString(props.icon).size > 0) {
                        SilkIcon(name: props.icon, family: props.iconPrefix, fontSize: getIconSize(props),
                            fontColor: ResourceColorToColor(getColor(props)))
                    }
                }
                if (hasDefault) {
                    Default()
                } else {
                    Text(ResourceStrToString(props.text))
                        .fontSize(getFontSize(props))
                        .lineHeight(getLineHeight(props))
                        .textAlign(TextAlign.Center)
                        .fontColor(ResourceColorToColor(ResourceColorToColor(getColor(props))))
                        .padding(
                            left: if (ResourceStrToString(props.icon).isEmpty() || ResourceStrToString(props.icon).size > 0) {
                                0.vp
                            } else {
                                getSizeConstant(SilkSizeKey.PADDING_BASE)
                            })
                }
            }
                .width<Length>(
                    if (props.width.isSome()) {
                        props.width.getOrThrow()
                    } else if (props.size == SilkButtonSize.LARGE) {
                        100.percent
                    } else {
                        None<Length>
                    })
                .height(getHeight(props))
                .borderRadius(getRadius(props))
                .backgroundColor(ResourceColorToColor(getBackground(props)))
                .borderWidth(getBorderWidth(props))
                .borderStyle(BorderStyle.Solid)
                .borderColor(ResourceColorToColor(getBorderColor(props)))
                .direction(getDirection(props))
                .padding(top: getPadding(props).top, bottom: getPadding(props).bottom, left: getPadding(props).left,
                    right: getPadding(props).right)
                .linearGradient(angle: getLinearGradient(props).angle, direction: getLinearGradient(props).direction,
                    colors: getLinearGradient(props).colors, repeating: getLinearGradient(props).repeating)
                .alignItems(VerticalAlign.Center)
                .justifyContent(FlexAlign.Center)
        }
            .shape(ShapeType.Normal)
            .padding(0)
        .clip(true)
            .borderRadius(getRadius(props))
            .backgroundColor(ResourceColorToColor(getBackground(props)))
            .borderWidth(getBorderWidth(props))
            .borderStyle(BorderStyle.Solid)
            .borderColor(ResourceColorToColor(getBorderColor(props)))
            .enabled(disabled)
            .onClick {
            e =>
                if (disabled) {
                    return;
                }
                click(e)
            }
    }
}

/**
 * 全功能按钮组件
 *
 * 同时支持加载状态和禁用状态的按钮组件
 */
@Component
public class SilkButtonAll {
    /**
     * 按钮配置选项
     */
    @Prop
    var props: SilkButtonOptions

    /**
     * 是否处于加载状态
     *
     * 当为 true 时，按钮将显示加载指示器并禁用点击
     */
    @Link
    var loading: Bool = false

    /**
     * 是否禁用按钮
     *
     * 当为 true 时，按钮将被禁用且不可点击
     */
    @Link
    var disabled: Bool = true

    /**
     * 点击事件回调函数
     */
    public var click: (e: ClickEvent) -> Unit = {_=>}

    /**
     * 自定义颜色
     */
    public var color: Option<Color> = Option.None

    /**
     * 自定义按钮内容
     *
     * 可以通过此参数自定义按钮的文本内容
     */
    @BuilderParam
    var Default: () -> Unit = DefaultBuilder
    var hasDefault: Bool = false

    /**
     * 自定义图标内容
     *
     * 可以通过此参数自定义按钮的图标
     */
    @BuilderParam
    var Icon: () -> Unit = DefaultBuilder
    var hasIcon: Bool = false

    /**
     * 自定义加载状态内容
     *
     * 可以通过此参数自定义按钮的加载状态显示
     */
    @BuilderParam
    var Loading: () -> Unit = DefaultBuilder
    var hasLoading: Bool = false

    func build() {
        Button() {
            Row() {
                if (loading) {
                    if (hasLoading) {
                        Loading()
                    } else {
                        SilkLoading(
                            loadingType: props.loadingType,
                            size: props.loadingSize,
                            text: props.loadingText,
                            color: ResourceColorToColor(getColor(props)),
                            textColor: ResourceColorToColor(getColor(props))
                        )
                    }
                } else {
                    if (hasIcon) {
                        Icon()
                    } else {
                        if (!ResourceStrToString(props.icon).isEmpty() && ResourceStrToString(props.icon).size > 0) {
                            SilkIcon(name: props.icon, family: props.iconPrefix, fontSize: getIconSize(props),
                                fontColor: ResourceColorToColor(getColor(props)))
                        }
                    }
                    if (hasDefault) {
                        Default()
                    } else {
                        Text(ResourceStrToString(props.text))
                            .fontSize(getFontSize(props))
                            .lineHeight(getLineHeight(props))
                            .textAlign(TextAlign.Center)
                            .fontColor(ResourceColorToColor(getColor(props)))
                            .padding(
                                left: if (ResourceStrToString(props.icon).isEmpty() || ResourceStrToString(props.icon).size > 0) {
                                    0.vp
                                } else {
                                    getSizeConstant(SilkSizeKey.PADDING_BASE)
                                })
                    }
                }
            }
                .width<Length>(
                    if (props.width.isSome()) {
                        props.width.getOrThrow()
                    } else if (props.size == SilkButtonSize.LARGE) {
                        100.percent
                    } else {
                        None<Length>
                    })
                .height(getHeight(props))
                .borderRadius(getRadius(props))
                .backgroundColor(ResourceColorToColor(getBackground(props)))
                .borderWidth(getBorderWidth(props))
                .borderStyle(BorderStyle.Solid)
                .borderColor(ResourceColorToColor(getBorderColor(props)))
                .direction(getDirection(props))
                .padding(top: getPadding(props).top, bottom: getPadding(props).bottom, left: getPadding(props).left,
                    right: getPadding(props).right)
                .linearGradient(angle: getLinearGradient(props).angle, direction: getLinearGradient(props).direction,
                    colors: getLinearGradient(props).colors, repeating: getLinearGradient(props).repeating)
                .alignItems(VerticalAlign.Center)
                .justifyContent(FlexAlign.Center)
        }
            .shape(ShapeType.Normal)
            .padding(0)
        .clip(true)
            .borderRadius(getRadius(props))
            .backgroundColor(ResourceColorToColor(getBackground(props)))
            .borderWidth(getBorderWidth(props))
            .borderStyle(BorderStyle.Solid)
            .borderColor(ResourceColorToColor(getBorderColor(props)))
            .enabled(!loading || disabled)
            .onClick {
            e =>
                if (disabled) {
                    return;
                }
                if (loading) {
                    return;
                }
                click(e)
            }
    }
}

/**
 * 获取按钮图标大小
 *
 * 根据按钮字体大小和图标比例计算图标大小
 *
 * @param props 按钮配置选项
 * @return 图标大小
 */
func getIconSize(props: SilkButtonOptions): Length {
    let origin = getFontSize(props)
    return Length(origin.value * getButtonIntConstant(SilkButtonIntKey.BUTTON_ICON_SIZE),
        unitType: LengthType.vp)
}

/**
 * 获取按钮字体大小
 *
 * 根据按钮尺寸获取对应的字体大小
 *
 * @param props 按钮配置选项
 * @return 字体大小
 */
func getFontSize(props: SilkButtonOptions): Length {
    match (props.size) {
        case SilkButtonSize.NORMAL => getButtonSizeConstant(SilkButtonSizeKey.BUTTON_NORMAL_FONT_SIZE)
        case SilkButtonSize.SMALL => getButtonSizeConstant(SilkButtonSizeKey.BUTTON_SMALL_FONT_SIZE)
        case SilkButtonSize.MINI => getButtonSizeConstant(SilkButtonSizeKey.BUTTON_MINI_FONT_SIZE)
        case SilkButtonSize.LARGE => getButtonSizeConstant(SilkButtonSizeKey.BUTTON_DEFAULT_FONT_SIZE)
    }
}

/**
 * 获取按钮文字行高
 *
 * 根据按钮字体大小和行高比例计算行高
 *
 * @param props 按钮配置选项
 * @return 行高
 */
func getLineHeight(props: SilkButtonOptions): Length {
    let origin = getFontSize(props)
    return Length(origin.value * getButtonIntConstant(SilkButtonIntKey.BUTTON_DEFAULT_LINE_HEIGHT),
        unitType: LengthType.vp)
}

/**
 * 获取按钮圆角大小
 *
 * 根据按钮是否为方形或圆形获取对应的圆角大小
 *
 * @param props 按钮配置选项
 * @return 圆角大小
 */
func getRadius(props: SilkButtonOptions): Length {
    if (props.square) {
        return 0.vp
    } else if (props.round) {
        return getButtonSizeConstant(SilkButtonSizeKey.BUTTON_ROUND_RADIUS)
    } else {
        return getButtonSizeConstant(SilkButtonSizeKey.BUTTON_RADIUS)
    }
}

/**
 * 获取按钮内容排列方向
 *
 * 根据图标位置设置内容排列方向
 *
 * @param props 按钮配置选项
 * @return 内容排列方向
 */
func getDirection(props: SilkButtonOptions) {
    match (props.iconPosition) {
        case SilkButtonIconPosition.RIGHT => Direction.Rtl
        case _ => Direction.Auto
    }
}

/**
 * 获取按钮内边距
 *
 * 根据按钮尺寸获取对应的内边距
 *
 * @param props 按钮配置选项
 * @return 内边距配置
 */
func getPadding(props: SilkButtonOptions) {
    match (props.size) {
        case SilkButtonSize.NORMAL => SilkUIPaddingOptions(
            top: getButtonSizeConstant(SilkButtonSizeKey.BUTTON_NORMAL_PADDING_TOP),
            bottom: getButtonSizeConstant(SilkButtonSizeKey.BUTTON_NORMAL_PADDING_BOTTOM),
            left: getButtonSizeConstant(SilkButtonSizeKey.BUTTON_NORMAL_PADDING_LEFT),
            right: getButtonSizeConstant(SilkButtonSizeKey.BUTTON_NORMAL_PADDING_RIGHT)
        )
        case SilkButtonSize.SMALL => SilkUIPaddingOptions(
            top: getButtonSizeConstant(SilkButtonSizeKey.BUTTON_SMALL_PADDING_TOP),
            bottom: getButtonSizeConstant(SilkButtonSizeKey.BUTTON_SMALL_PADDING_BOTTOM),
            left: getButtonSizeConstant(SilkButtonSizeKey.BUTTON_SMALL_PADDING_LEFT),
            right: getButtonSizeConstant(SilkButtonSizeKey.BUTTON_SMALL_PADDING_RIGHT)
        )
        case SilkButtonSize.MINI => SilkUIPaddingOptions(
            top: getButtonSizeConstant(SilkButtonSizeKey.BUTTON_MINI_PADDING_TOP),
            bottom: getButtonSizeConstant(SilkButtonSizeKey.BUTTON_MINI_PADDING_BOTTOM),
            left: getButtonSizeConstant(SilkButtonSizeKey.BUTTON_MINI_PADDING_LEFT),
            right: getButtonSizeConstant(SilkButtonSizeKey.BUTTON_MINI_PADDING_RIGHT)
        )
        case SilkButtonSize.LARGE => SilkUIPaddingOptions(0.vp)
    }
}

/**
 * 获取按钮文字颜色
 *
 * 根据按钮类型、是否为朴素按钮等属性获取对应的文字颜色
 *
 * @param props 按钮配置选项
 * @return 文字颜色
 */
func getColor(props: SilkButtonOptions) {
    if (props.textColor.isSome()) {
        return props.textColor.getOrThrow()
    }
    if (props.plain) {
        if (props.color.isSome()) {
            return props.color.getOrThrow()
        }
        match (props.buttonType) {
            case SilkButtonType.PRIMARY => getButtonColorConstant(SilkButtonColorKey.BUTTON_PRIMARY_BACKGROUND)
            case SilkButtonType.SUCCESS => getButtonColorConstant(SilkButtonColorKey.BUTTON_SUCCESS_BACKGROUND)
            case SilkButtonType.DEFAULT => getButtonColorConstant(SilkButtonColorKey.BUTTON_DEFAULT_BACKGROUND)
            case SilkButtonType.DANGER => getButtonColorConstant(SilkButtonColorKey.BUTTON_DANGER_BACKGROUND)
            case SilkButtonType.WARNING => getButtonColorConstant(SilkButtonColorKey.BUTTON_WARNING_BACKGROUND)
        }
    } else {
        if (props.color.isSome()) {
            return Color.WHITE
        }
        if (props.linearGradient.isSome()) {
            return Color.WHITE
        }
        match (props.buttonType) {
            case SilkButtonType.PRIMARY => getButtonColorConstant(SilkButtonColorKey.BUTTON_PRIMARY_COLOR)
            case SilkButtonType.SUCCESS => getButtonColorConstant(SilkButtonColorKey.BUTTON_SUCCESS_COLOR)
            case SilkButtonType.DEFAULT => getButtonColorConstant(SilkButtonColorKey.BUTTON_DEFAULT_COLOR)
            case SilkButtonType.DANGER => getButtonColorConstant(SilkButtonColorKey.BUTTON_DANGER_COLOR)
            case SilkButtonType.WARNING => getButtonColorConstant(SilkButtonColorKey.BUTTON_WARNING_COLOR)
        }
    }
}

/**
 * 获取按钮背景颜色
 *
 * 根据按钮类型、是否为朴素按钮等属性获取对应的背景颜色
 *
 * @param props 按钮配置选项
 * @return 背景颜色
 */
func getBackground(props: SilkButtonOptions) {
    if (props.plain) {
        return getButtonColorConstant(SilkButtonColorKey.BUTTON_PLAIN_BACKGROUND)
    }
    if (props.linearGradient.isSome()) {
        return Color.TRANSPARENT
    }
    if (props.color.isSome()) {
        return props.color.getOrThrow()
    }
    match (props.buttonType) {
        case SilkButtonType.PRIMARY => getButtonColorConstant(SilkButtonColorKey.BUTTON_PRIMARY_BACKGROUND)
        case SilkButtonType.SUCCESS => getButtonColorConstant(SilkButtonColorKey.BUTTON_SUCCESS_BACKGROUND)
        case SilkButtonType.DEFAULT => getButtonColorConstant(SilkButtonColorKey.BUTTON_DEFAULT_BACKGROUND)
        case SilkButtonType.DANGER => getButtonColorConstant(SilkButtonColorKey.BUTTON_DANGER_BACKGROUND)
        case SilkButtonType.WARNING => getButtonColorConstant(SilkButtonColorKey.BUTTON_WARNING_BACKGROUND)
    }
}

/**
 * 获取按钮边框颜色
 *
 * 根据按钮类型获取对应的边框颜色
 *
 * @param props 按钮配置选项
 * @return 边框颜色
 */
func getBorderColor(props: SilkButtonOptions) {
    if (props.color.isSome()) {
        props.color.getOrThrow()
    } else {
        match (props.buttonType) {
        case SilkButtonType.PRIMARY => getButtonColorConstant(SilkButtonColorKey.BUTTON_PRIMARY_BORDER_COLOR)
        case SilkButtonType.SUCCESS => getButtonColorConstant(SilkButtonColorKey.BUTTON_SUCCESS_BORDER_COLOR)
        case SilkButtonType.DEFAULT => getButtonColorConstant(SilkButtonColorKey.BUTTON_DEFAULT_BORDER_COLOR)
        case SilkButtonType.DANGER => getButtonColorConstant(SilkButtonColorKey.BUTTON_DANGER_BORDER_COLOR)
        case SilkButtonType.WARNING => getButtonColorConstant(SilkButtonColorKey.BUTTON_WARNING_BORDER_COLOR)
        }
    }
}

/**
 * 获取按钮边框宽度
 *
 * 根据是否使用细边框获取对应的边框宽度
 *
 * @param props 按钮配置选项
 * @return 边框宽度
 */
func getBorderWidth(props: SilkButtonOptions) {
    if (!props.hasBorder) {
        return Length(0, unitType: LengthType.vp)
    }
    if (props.hairLine) {
        Length(1, unitType: LengthType.px)
    } else {
        getButtonSizeConstant(SilkButtonSizeKey.BUTTON_BORDER_WIDTH)
    }
}

/**
 * 获取按钮渐变色配置
 *
 * 返回按钮的渐变色配置，如果未设置则返回默认配置
 *
 * @param props 按钮配置选项
 * @return 渐变色配置
 */
func getLinearGradient(props: SilkButtonOptions): SilkUILinearGradientOptions {
    props.linearGradient ?? SilkUILinearGradientOptions()
}

/**
 * 获取按钮高度
 *
 * 根据按钮尺寸获取对应的高度
 *
 * @param props 按钮配置选项
 * @return 按钮高度
 */
func getHeight(props: SilkButtonOptions): Length {
    if (props.height.isSome()) {
        return props.height.getOrThrow()
    }
    match (props.size) {
        case SilkButtonSize.SMALL => getButtonSizeConstant(SilkButtonSizeKey.BUTTON_SMALL_HEIGHT)
        case SilkButtonSize.NORMAL => getButtonSizeConstant(SilkButtonSizeKey.BUTTON_DEFAULT_HEIGHT)
        case SilkButtonSize.LARGE => getButtonSizeConstant(SilkButtonSizeKey.BUTTON_LARGE_HEIGHT)
        case SilkButtonSize.MINI => getButtonSizeConstant(SilkButtonSizeKey.BUTTON_MINI_HEIGHT)
    }
}
