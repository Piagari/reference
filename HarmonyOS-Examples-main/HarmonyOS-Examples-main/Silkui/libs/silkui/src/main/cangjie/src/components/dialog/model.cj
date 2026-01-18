/**
 * Created on 2025/4/26
 *
 * SilkDialog 对话框组件
 *
 * 对话框用于展示重要信息或请求用户进行操作，支持多种样式和交互方式。
 *
 * @module silkui/components/dialog
 */
package silkui.components.dialog

internal import ohos.base.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.resource_manager.*
import cj_res_silkui.*
import silkui.SilkUIBorderOptions
import silkui.SilkUIPaddingOptions
import ohos.asset_store.ErrorCode
import ohos.component.WordBreak
import ohos.component.Offset
import silkui.components.loading.SilkLoadingType
import ohos.component.Alignment
import ohos.component.BorderRadiuses
import silkui.types.DefaultBuilder
import ohos.component.TransitionEffect
import ohos.ark_interop.JSPromise
import ohos.component.ShapeType
import ohos.component.LinearGradient
import ohos.component.GradientDirection
import silkui.macros.EnumExtend
import silkui.SilkUILinearGradientOptions
import silkui.ResourceColor
import silkui.ResourceStr
import silkui.utils.ResourceStrToString
import silkui.constants.getColorConstant
import silkui.constants.SilkColorKey
import silkui.constants.getDialogColorConstant
import silkui.constants.SilkDialogColorKey
import silkui.constants.getDialogSizeConstant
import silkui.constants.SilkDialogSizeKey
/**
 * 对话框风格
 *
 * 定义对话框的整体风格和按钮样式
 */
@EnumExtend
public enum SilkDialogTheme {
    | ROUND_BUTTON  // 圆角按钮风格，按钮为圆角样式
    | DEFAULT       // 默认风格，按钮为方形样式
    | CUSTOM        // 自定义风格，可完全自定义对话框样式
}

/**
 * 对话框内容对齐方式
 *
 * 定义对话框内容文本的对齐方式
 */
@EnumExtend
public enum SilkDialogMessageAlign {
    | LEFT    // 左对齐
    | RIGHT   // 右对齐
    | CENTER  // 居中对齐
}

/**
 * 对话框按钮样式配置
 *
 * 用于配置对话框确认和取消按钮的样式
 */
public struct SilkDialogButton {
    /**
     * 按钮高度
     */
    public let buttonHeight: ?Length

    /**
     * 按钮渐变色配置
     */
    public let linearGradient: ?SilkUILinearGradientOptions

    /**
     * 创建对话框按钮样式配置
     *
     * @param confirmColor 确认按钮文字颜色，默认为 None
     * @param cancelColor 取消按钮文字颜色，默认为 None
     * @param confirmBgColor 确认按钮背景颜色，默认为 None
     * @param cancelBgColor 取消按钮背景颜色，默认为 None
     * @param buttonHeight 按钮高度，默认为 None
     * @param linearGradient 按钮渐变色配置，默认为 None
     */
    public init (
        buttonHeight!: ?Length = Option.None,
        linearGradient!: ?SilkUILinearGradientOptions = Option.None
    ) {
        this.buttonHeight = buttonHeight
        this.linearGradient = linearGradient
    }
}
/**
 * 圆角按钮预设样式
 *
 * 用于圆角风格对话框的按钮样式
 */
public let RoundButton = SilkDialogButton(
    buttonHeight: getDialogSizeConstant(SilkDialogSizeKey.DIALOG_ROUND_BUTTON_HEIGHT),
    linearGradient: SilkUILinearGradientOptions(
        angle: 90.0,
        colors: [(Color(0xFFFF6034), 0.0), (Color(0xFFEE0A24), 1.0)]
    )
)

/**
 * 普通按钮预设样式
 *
 * 用于默认风格对话框的按钮样式
 */
public let NormalButton = SilkDialogButton(
    buttonHeight: getDialogSizeConstant(SilkDialogSizeKey.DIALOG_BUTTON_HEIGHT)
)
/**
 * 对话框配置选项
 *
 * 用于配置对话框的各种属性，包括内容、样式、按钮等
 */
public class SilkDialogOptions {
    /**
     * 对话框标题
     * 默认为空字符串
     */
    public let title: ResourceStr

    /**
     * 标题字体大小
     * 默认为预设大小
     */
    public let titleSize: Length

    /**
     * 标题字体颜色
     * 默认为预设颜色
     */
    public let titleColor: ResourceColor

    /**
     * 对话框内容
     * 默认为空字符串
     */
    public let message: ResourceStr

    /**
     * 内容字体大小
     * 默认为预设大小
     */
    public let messageSize: Length

    /**
     * 内容字体颜色
     * 默认为预设颜色
     */
    public let messageColor: ResourceColor

    /**
     * 内容对齐方式
     * 默认为居中对齐
     */
    public let messageAlign: TextAlign

    /**
     * 内容行高
     * 默认为20vp
     */
    public let messageLineHeight: Length

    /**
     * 对话框宽度
     * 默认为屏幕宽度的80%
     */
    public let widthValue: Length

    /**
     * 对话框圆角大小
     * 默认为预设大小
     */
    public let round: Length

    /**
     * 对话框背景颜色
     * 默认为预设颜色
     */
    public let bgcColor: ResourceColor

    /**
     * 对话框风格
     * 默认为DEFAULT
     */
    public let theme: SilkDialogTheme
    /**
     * 是否显示确认按钮
     * 默认为true
     */
    public let showConfirm: Bool
    /**
     * 是否显示取消按钮
     * 默认为false
     */
    public var showCancel: Bool
    public let confirmText: ResourceStr // 确认按钮文字 默认为“确定”
    public let cancelText: ResourceStr // 取消按钮文字 默认为“取消”
    public let confirmColor: ?ResourceColor // 确认按钮文本颜色
    public let confirmBgColor: ?ResourceColor // 确认按钮背景色
    public let cancelColor: ?ResourceColor // 取消按钮文本颜色
    public let cancelBgColor: ?ResourceColor // 取消按钮背景色
    public let confirmFontSize: ?Length // 确认按钮文字大小
    public let cancelFontSize: ?Length // 取消按钮文字大小
    public let buttonHeight: Length // 按钮高度
    public let hasDivider: Bool // 是否有分割线
    public let showOverlay: Bool // 是否展示遮罩
    public let autoCancel: Bool // 自动关闭
    public let overlayColor: ResourceColor // 遮罩颜色
    public let closeOnPopstate: Bool // 页面切换时是否关闭弹框
    public let transition: ?TransitionEffect // 变换动画
    public let beforeClose: Option<(action:String) -> Future<Bool>>
    public var onConfirm: Option<() -> Unit>
    public var onCancel: Option<() -> Unit>
    public let headerPadding: SilkUIPaddingOptions // 顶部边距
    public var contentPadding: SilkUIPaddingOptions // 内容区边距
    public let bottomPadding: ?SilkUIPaddingOptions // 底部边距
    public let linearGradient: ?SilkUILinearGradientOptions

    public init (
        title!: ResourceStr = String.empty,
        titleSize!: Length = getDialogSizeConstant(SilkDialogSizeKey.DIALOG_FONT_SIZE),
        titleColor!: ResourceColor = getColorConstant(SilkColorKey.TEXT_COLOR),
        message!: ResourceStr = String.empty,
        messageSize!: Length = getDialogSizeConstant(SilkDialogSizeKey.DIALOG_FONT_SIZE),
        messageColor!: ResourceColor = getDialogColorConstant(SilkDialogColorKey.DIALOG_HAS_TITLE_MESSAGE_TEXT_COLOR),
        messageAlign!: TextAlign = TextAlign.Center,
        messageLineHeight!: Length = getDialogSizeConstant(SilkDialogSizeKey.DIALOG_MESSAGE_LINE_HEIGHT),
        widthValue!: Length = getDialogSizeConstant(SilkDialogSizeKey.DIALOG_WIDTH),
        round!: Length = getDialogSizeConstant(SilkDialogSizeKey.DIALOG_RADIUS),
        bgcColor!: ResourceColor = getDialogColorConstant(SilkDialogColorKey.DIALOG_BACKGROUND),
        theme!: SilkDialogTheme = SilkDialogTheme.DEFAULT,
        showConfirm!: Bool = true,
        showCancel!: Bool = false,
        confirmText!: ResourceStr = "确定",
        cancelText!: ResourceStr = "取消",
        confirmColor!: ?ResourceColor = Option.None,
        confirmBgColor!: ?ResourceColor = Option.None,
        cancelColor!: ?ResourceColor = Option.None,
        cancelBgColor!: ?ResourceColor = Option.None,
        confirmFontSize!: ?Length = Option.None,
        cancelFontSize!: ?Length = Option.None,
        buttonHeight!: ?Length = Option.None,
        hasDivider!: Bool = true,
        showOverlay!: Bool = true,
        autoCancel!: Bool = true,
        overlayColor!: ResourceColor = getColorConstant(SilkColorKey.OVERALAY_BACKGROUND),
        closeOnPopstate!: Bool = true,
        transition!: ?TransitionEffect = Option.None,
        beforeClose!: Option<(action:String) -> Future<Bool>> = Option.None,
        confirm!: Option<() -> Unit> = Option.None,
        cancel!: Option<() -> Unit> = Option.None,
        headerPadding!: SilkUIPaddingOptions = SilkUIPaddingOptions(top: getDialogSizeConstant(SilkDialogSizeKey.DIALOG_HEADER_PADDING_TOP)),
        contentPadding!: ?SilkUIPaddingOptions = Option.None,
        bottomPadding!: ?SilkUIPaddingOptions = Option.None,
        linearGradient!: ?SilkUILinearGradientOptions = Option.None
    ) {
        this.title = title
        this.titleSize = titleSize
        this.titleColor = titleColor
        this.message = message
        this.messageSize = messageSize
        this.messageColor = messageColor
        this.messageAlign = messageAlign
        this.messageLineHeight = messageLineHeight
        this.widthValue = widthValue
        this.round = round
        this.bgcColor = bgcColor
        this.theme = theme
        this.showConfirm = showConfirm
        this.showCancel = showCancel
        this.confirmText = confirmText
        this.cancelText = cancelText
        this.confirmFontSize = confirmFontSize
        this.cancelFontSize = cancelFontSize
        this.hasDivider = hasDivider
        this.showOverlay = showOverlay
        this.autoCancel = autoCancel
        this.overlayColor = overlayColor
        this.closeOnPopstate = closeOnPopstate
        this.transition = transition
        this.beforeClose = beforeClose
        this.onConfirm = confirm
        this.onCancel = cancel
        this.headerPadding = headerPadding
        this.bottomPadding = bottomPadding
        this.cancelBgColor  = cancelBgColor
        this.cancelColor = cancelColor
        this.confirmBgColor = confirmBgColor
        this.confirmColor = confirmColor ?? if (linearGradient.isNone()) {
            getDialogColorConstant(SilkDialogColorKey.DIALOG_CONFIRM_BUTTON_TEXT_COLOR)
        } else {
            getColorConstant(SilkColorKey.WHITE)
        }
        this.contentPadding = contentPadding ?? (if (ResourceStrToString(title).isEmpty() || ResourceStrToString(title).size == 0){
                SilkUIPaddingOptions(top: 26.vp, left: 24.vp, right: 24.vp, bottom: 26.vp)
            } else {
                SilkUIPaddingOptions(top: 8.vp, left: 24.vp, right: 24.vp, bottom: 16.vp)
            })

        this.buttonHeight = buttonHeight ?? (if (theme == SilkDialogTheme.ROUND_BUTTON) {
            RoundButton.buttonHeight ?? 36.vp
        } else {
            NormalButton.buttonHeight ?? 48.vp
        })
        this.linearGradient = linearGradient ?? (if (theme == SilkDialogTheme.ROUND_BUTTON) {
            RoundButton.linearGradient
        } else {
            NormalButton.linearGradient
        })
    }
}

