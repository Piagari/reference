/**
 * Created on 2025/7/8
 *
 * SilkActionSheet 动作面板组件
 *
 * 动作面板组件用于在页面底部弹出一个选择面板，包含多个选项供用户选择。
 * 支持自定义标题、描述、取消按钮等功能。
 *
 * @module silkui/components/action_sheet
 */
package silkui.components.action_sheet
import silkui.macros.EnumExtend
import std.overflow.ThrowingOp
import ohos.component.TranslateOptions
import ohos.base.*
import ohos.resource_manager.*
import silkui.ResourceColor
import silkui.ResourceStr
import silkui.SilkUIPaddingOptions
import silkui.constants.getActionSheetColorConstant
import silkui.constants.SilkActionSheetColorKey
import silkui.constants.getActionSheetSizeConstant
import silkui.constants.SilkActionSheetSizeKey
import silkui.constants.getActionSheetPercentConstant
import silkui.constants.SilkActionSheetPercentKey
import silkui.constants.getColorConstant
import silkui.constants.SilkColorKey

/**
 * 动作面板选项
 *
 * 定义动作面板中的单个选项配置
 */
public struct SilkActionSheetAction {
    /**
     * 选项名称
     */
    public let name: ResourceStr

    /**
     * 选项子标题
     * 默认为空字符串
     */
    public let subname: ?ResourceStr

    /**
     * 选项颜色
     * 默认使用预设颜色
     */
    public let color: ResourceColor

    /**
     * 显示的图标名称或图片链接
     * 等同于 Icon 组件的 name 属性
     * 默认为None
     */
    public let icon: ?ResourceStr

    /**
     * 是否为禁用状态
     * 默认为 false
     */
    public let disabled: Bool

    /**
     * 是否显示加载状态
     * 默认为 false
     */
    public let loading: Bool

    /**
     * 选项点击回调
     * 默认为 None
     */
    public let callback: Option<() -> Unit>

    /**
     * 创建动作面板选项
     *
     * @param name 选项名称
     * @param subname 选项子标题，默认为空字符串
     * @param color 选项颜色，默认使用预设颜色
     * @param disabled 是否为禁用状态，默认为 false
     * @param loading 是否显示加载状态，默认为 false
     * @param callback 选项点击回调，默认为 None
     */
    public init (
        name!: ResourceStr,
        subname!: ?ResourceStr = Option<ResourceStr>.None,
        color!: ResourceColor = getActionSheetColorConstant(SilkActionSheetColorKey.ACTION_SHEET_ITEM_TEXT_COLOR),
        icon!: ?ResourceStr = Option.None,
        disabled!: Bool = false,
        loading!: Bool = false,
        callback!: Option<() -> Unit> = Option.None
    ) {
        this.name = name
        this.subname = subname
        this.color = color
        this.icon = icon
        this.disabled = disabled
        this.loading = loading
        this.callback = callback
    }
}

/**
 * 动作面板配置选项
 *
 * 用于配置动作面板的各种属性，包括选项列表、标题、样式、交互等
 */
public struct SilkActionSheetOptions {

    /**
     * 面板选项列表
     * 默认为空数组
     */
    public let actions: Array<SilkActionSheetAction>

    /**
     * 顶部标题
     * 默认为空字符串
     */
    public let title: ?ResourceStr

    /**
     * 取消按钮文字
     * 默认为空字符串
     */
    public let cancelText: ?ResourceStr

    /**
     * 选项上方的描述信息
     * 默认为空字符串
     */
    public let description: ?ResourceStr

    /**
     * 是否显示关闭图标
     * 默认为 true
     */
    public let closeable: Bool

    /**
     * 关闭图标名称或图片链接
     * 等同于 Icon 组件的 name 属性
     * 默认为 "cross"
     */
    public let closeIcon: ResourceStr

    /**
     * 动画时长，单位秒
     * 设置为 0 可以禁用动画
     * 默认为 0.3
     */
    public let duration: Int32

    /**
     * 是否显示圆角
     * 默认为 true
     */
    public let round: Bool

    /**
     * 是否显示遮罩层
     * 默认为 true
     */
    public let overlay: Bool

    /**
     * 自定义遮罩层颜色
     * 默认使用预设颜色
     */
    public let overlayColor: ResourceColor

    /**
     * 是否锁定背景滚动
     * 默认为 true
     */
    public let lockScroll: Bool

    /**
     * 是否在页面回退时自动关闭
     * 默认为 true
     */
    public let closeOnPopState: Bool

    /**
     * 是否在点击选项后关闭
     * 默认为 false
     */
    public let closeOnClickAction: Bool

    /**
     * 是否在点击遮罩层后关闭
     * 默认为 true
     */
    public let closeOnClickOverlay: Bool

    /**
     * 是否开启底部安全区适配
     * 默认为 true
     */
    public let safeAreaInsetBottom: Bool

    /**
     * 关闭前的回调函数，返回 false 可阻止关闭，支持返回 Promise
     * 默认为 None
     */
    public let beforeClose: Option<(action: String) -> Future<Bool>>

    /**
     * 创建动作面板配置选项
     *
     * @param actions 面板选项列表，默认为空数组
     * @param title 顶部标题，默认为空字符串
     * @param cancelText 取消按钮文字，默认为空字符串
     * @param description 选项上方的描述信息，默认为空字符串
     * @param closeable 是否显示关闭图标，title不为空时 默认为 true
     * @param closeIcon 关闭图标名称或图片链接，默认为 "cross"
     * @param duration 动画时长，单位秒，默认为 0.3
     * @param round 是否显示圆角，默认为 true
     * @param overlay 是否显示遮罩层，默认为 true
     * @param overlayColor 自定义遮罩层亚瑟，默认使用预设颜色
     * @param lockScroll 是否锁定背景滚动，默认为 true
     * @param closeOnPopState 是否在页面回退时自动关闭，默认为 true
     * @param closeOnClickAction 是否在点击选项后关闭，默认为 false
     * @param closeOnClickOverlay 是否在点击遮罩层后关闭，默认为 true
     * @param safeAreaInsetBottom 是否开启底部安全区适配，默认为 true
     * @param beforeClose 关闭前的回调函数，默认为 None
     */
    public init (
        actions!: Array<SilkActionSheetAction> = Array<SilkActionSheetAction>(),
        title!: ?ResourceStr = None,
        cancelText!: ?ResourceStr = None,
        description!: ?ResourceStr = None,
        closeable!: ?Bool = None,
        closeIcon!: ResourceStr = "cross",
        duration!: Int32 = 300,
        round!: Bool = true,
        overlay!: Bool = true,
        overlayColor!: ResourceColor = getColorConstant(SilkColorKey.OVERALAY_BACKGROUND),
        lockScroll!: Bool = true,
        closeOnPopState!: Bool = true,
        closeOnClickAction!: Bool = false,
        closeOnClickOverlay!: Bool = true,
        safeAreaInsetBottom!: Bool = true,
        beforeClose!: Option<(action: String) -> Future<Bool>> = None
    ) {
        this.actions = actions
        this.title = title
        this.cancelText = cancelText
        this.description = description
        this.closeable = if (closeable.isSome()) { closeable.getOrThrow() } else if (title.isSome()) { true } else { false }
        this.closeIcon = closeIcon
        this.duration = duration
        this.round = round
        this.overlay = overlay
        this.overlayColor = overlayColor
        this.lockScroll = lockScroll
        this.closeOnPopState = closeOnPopState
        this.closeOnClickAction = closeOnClickAction
        this.closeOnClickOverlay = closeOnClickOverlay
        this.safeAreaInsetBottom = safeAreaInsetBottom
        this.beforeClose = beforeClose
    }
}