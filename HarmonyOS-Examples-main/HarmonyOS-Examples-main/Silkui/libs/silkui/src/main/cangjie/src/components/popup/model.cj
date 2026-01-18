/**
 * Created on 2025/5/5
 *
 * SilkPopup 弹出层组件
 *
 * 弹出层组件用于在页面中弹出一个浮层，可以包含各种内容，如消息提示、选择器等。
 *
 * @module silkui/components/popup
 */
package silkui.components.popup
import silkui.macros.EnumExtend
import std.overflow.ThrowingOp
import ohos.component.TranslateOptions
import ohos.base.*
import ohos.resource_manager.*
import silkui.ResourceColor
import silkui.ResourceStr
import silkui.constants.getPopupColorConstant
import silkui.constants.SilkPopupColorKey
import silkui.constants.getPopupSizeConstant
import silkui.constants.SilkPopupSizeKey
import silkui.constants.getPopupNumberConstant
import silkui.constants.SilkPopupNumberKey

/**
 * 弹出层位置枚举
 *
 * 定义弹出层在屏幕中的显示位置
 */
@EnumExtend
public enum SilkPopupPosition {
    | TOP     // 顶部弹出
    | BOTTOM  // 底部弹出
    | LEFT    // 左侧弹出
    | RIGHT   // 右侧弹出
    | CENTER  // 中间弹出
}

/**
 * 弹出层关闭图标位置枚举
 *
 * 定义关闭图标在弹出层中的位置
 */
@EnumExtend
public enum SilkPopupClosePosition {
    | TOP_LEFT      // 左上角
    | TOP_RIGHT     // 右上角
    | BOTTOM_LEFT   // 左下角
    | BOTTOM_RIGHT  // 右下角
}

/**
 * 约束尺寸选项
 *
 * 用于限制轻提示的最小和最大尺寸
 */
struct ConstraintSizeOptions {
    /**
     * 最小宽度
     * 默认为 0vp
     */
    public var minWidth: Length = 0.0.vp

    /**
     * 最小高度
     * 默认为 0vp
     */
    public var minHeight: Length = 0.0.vp

    /**
     * 最大宽度
     * 默认为 0vp
     */
    public var maxWidth: Length = 0.0.vp

    /**
     * 最大高度
     * 默认为 0vp
     */
    public var maxHeight: Length = 0.0.vp

    /**
     * 创建约束尺寸选项
     *
     * @param minWidth 最小宽度，默认为 0vp
     * @param minHeight 最小高度，默认为 0vp
     * @param maxWidth 最大宽度，默认为 0vp
     * @param maxHeight 最大高度，默认为 0vp
     */
    public init (
        minWidth!: Length = 0.0.vp,
        minHeight!: Length = 0.0.vp,
        maxWidth!: Length = 0.0.vp,
        maxHeight!: Length = 0.0.vp
    ) {
        this.minWidth = minWidth
        this.minHeight = minHeight
        this.maxWidth = maxWidth
        this.maxHeight = maxHeight
    }
}


/**
 * 弹出层配置选项
 *
 * 用于配置弹出层的各种属性，包括位置、样式、交互等
 */
public struct SilkPopupOptions {
    /**
     * 是否显示遮罩层
     * 默认为 true
     */
    public let overlay: Bool

    /**
     * 弹出位置
     * 默认为 CENTER
     */
    public let position: SilkPopupPosition

    /**
     * 遮罩层颜色
     * 默认使用预设颜色
     */
    public let overlayColor: ResourceColor

    /**
     * 动画持续时间（毫秒）
     * 默认为 300
     */
    public let duration: Int32

    /**
     * 是否使用圆角
     * 默认为 false
     */
    public let round: Bool

    /**
     * 圆角大小
     * 当round为true时生效
     * 默认使用预设大小
     */
    public let roundValue: Length

    /**
     * 页面切换时是否关闭弹窗
     * 默认为 true
     */
    public let closeOnPopState: Bool

    /**
     * 点击遮罩层时是否关闭弹窗
     * 默认为 true
     */
    public let closeOnClickOverlay: Bool

    /**
     * 是否显示关闭图标
     * 默认为 false
     */
    public let showClose: Bool

    /**
     * 关闭图标
     * 默认为 "cross"
     */
    public let closeIcon: ResourceStr

    /**
     * 关闭图标位置
     * 默认为 TOP_RIGHT
     */
    public let closePosition: SilkPopupClosePosition

    /**
     * 弹出层宽度
     * 默认根据内容自适应
     */
    public let widthValue: Length

    /**
     * 是否开启顶部安全区适配
     * 默认为 false
     */
    public let safeTop: Bool

    /**
     * 是否开启底部安全区适配
     * 默认为 false
     */
    public let safeBottom: Bool

    /**
     * 创建弹出层配置选项
     *
     * @param overlay 是否显示遮罩层，默认为 true
     * @param position 弹出位置，默认为 CENTER
     * @param overlayColor 遮罩层颜色，默认使用预设颜色
     * @param duration 动画持续时间（毫秒），默认为 300
     * @param round 是否使用圆角，默认为 false
     * @param roundValue 圆角大小，当round为true时生效，默认使用预设大小
     * @param closeOnPopState 页面切换时是否关闭弹窗，默认为 true
     * @param closeOnClickOverlay 点击遮罩层时是否关闭弹窗，默认为 true
     * @param showClose 是否显示关闭图标，默认为 false
     * @param closeIcon 关闭图标，默认为 "cross"
     * @param closePosition 关闭图标位置，默认为 TOP_RIGHT
     * @param widthValue 弹出层宽度，默认根据内容自适应
     * @param safeTop 是否开启顶部安全区适配，默认为 false
     * @param safeBottom 是否开启底部安全区适配，默认为 false
     */
    public init (
        overlay!: Bool = true,
        position!: SilkPopupPosition = SilkPopupPosition.CENTER,
        overlayColor!: ResourceColor = getPopupColorConstant(SilkPopupColorKey.POPUP_OVERLAY_BACKGROUND),
        duration!: Int32 = Int32(getPopupNumberConstant(SilkPopupNumberKey.POPUP_TRANSITION)),
        round!: Bool = false,
        roundValue!: Length = getPopupSizeConstant(SilkPopupSizeKey.POPUP_ROUND_RADIUS),
        closeOnPopState!: Bool = true,
        closeOnClickOverlay!: Bool = true,
        showClose!: Bool = false,
        closeIcon!: ResourceStr = "cross",
        closePosition!: SilkPopupClosePosition = SilkPopupClosePosition.TOP_RIGHT,
        widthValue!: Length = 70.percent,
        safeTop!: Bool = false,
        safeBottom!: Bool = false
    ) {
        this.overlay = overlay
        this.position = position
        this.overlayColor = overlayColor
        this.duration = duration
        this.round = round
        this.roundValue = roundValue
        this.closeOnPopState = closeOnPopState
        this.closeOnClickOverlay = closeOnClickOverlay
        this.showClose = showClose
        this.closeIcon = closeIcon
        this.closePosition = closePosition
        this.widthValue = widthValue
        this.safeTop = safeTop
        this.safeBottom = safeBottom
    }
}
