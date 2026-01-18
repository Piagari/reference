/**
 * Created on 2025/4/24
 *
 * SilkToast 轻提示组件
 *
 * 轻提示组件用于在页面中间弹出提示，支持多种类型，包括文字提示、加载提示、成功/失败提示等。
 *
 * @module silkui/components/toast
 */
package silkui.components.toast

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
import silkui.macros.EnumExtend
import silkui.ResourceColor
import silkui.ResourceStr
import silkui.constants.SilkToastColorKey
import silkui.constants.SilkToastSizeKey
import silkui.constants.SilkToastPaddingKey
import silkui.constants.getToastColorConstant
import silkui.constants.getToastSizeConstant
import silkui.constants.getToastPaddingConstant

/**
 * 轻提示类型
 *
 * 定义轻提示的不同类型，每种类型对应不同的图标和样式
 */
@EnumExtend
public enum SilkToastType {
    | WARN     // 警告提示，通常显示黄色警告图标
    | ERROR    // 错误提示，通常显示红色错误图标
    | SUCCESS  // 成功提示，通常显示绿色成功图标
    | TOAST    // 普通文字提示，不显示图标
    | LOADING  // 加载提示，显示加载动画
}

/**
 * 轻提示样式
 *
 * 用于配置轻提示的样式，包括内边距、背景色、圆角等
 */
@Observed
public class SilkToastStyle {
    /**
     * 内边距
     * 默认为 None
     */
    @Publish public var padding: ?SilkUIPaddingOptions = Option.None

    /**
     * 背景颜色
     * 默认为预设颜色
     */
    @Publish public var backgroundColor: ResourceColor = getToastColorConstant(SilkToastColorKey.TOAST_BACKGROUND)

    /**
     * 圆角大小
     * 默认为 8
     */
    @Publish public var radius: Int64 = 8

    /**
     * 文字颜色
     * 默认为预设颜色
     */
    @Publish public var fillColor: ResourceColor = getToastColorConstant(SilkToastColorKey.TOAST_TEXT_COLOR)
}


/**
 * 轻提示位置
 *
 * 定义轻提示在屏幕中的显示位置
 */
public enum SilkToastPosition {
    | TOP     // 顶部显示
    | BOTTOM  // 底部显示
    | CENTER  // 中间显示
}

/**
 * 轻提示配置选项
 *
 * 用于配置轻提示的各种属性，包括内容、样式、行为等
 */
public class SilkToastOptions {
    /**
     * 提示文字内容
     * 默认为空字符串
     */
    public var message: ResourceStr = String.empty

    /**
     * 展示时长(毫秒)
     * 默认为3000ms
     */
    public var duration: Int64 = 3000

    /**
     * 是否显示图标
     * 默认为true
     */
    public var showIcon: Bool = true

    /**
     * 自定义图标
     * 默认为None
     */
    public var icon: ?ResourceStr = None

    /**
     * 图标大小
     * 默认为预设大小
     */
    public var iconSize: Length = getToastSizeConstant(SilkToastSizeKey.TOAST_ICON_SIZE)

    /**
     * 加载图标大小
     * 默认为预设大小
     */
    public var loadingSize: Length = getToastSizeConstant(SilkToastSizeKey.TOAST_ICON_SIZE)

    /**
     * 是否显示遮罩层
     * 默认为false
     */
    public var overlay: Bool = false

    /**
     * 加载图标类型
     * 默认为CIRCULAR
     */
    public var loadingType: SilkLoadingType = SilkLoadingType.CIRCULAR

    /**
     * 显示位置
     * 默认为CENTER
     */
    public var showPosition: SilkToastPosition = SilkToastPosition.CENTER

    /**
     * 文本换行方式
     * 默认为BreakAll
     */
    public var wordBreak: WordBreak = WordBreak.BreakAll

    /**
     * 是否禁止背景点击
     * 默认为false
     */
    public var forbidClick: Bool = false

    /**
     * 提示类型
     * 默认为TOAST
     */
    public var toastTyoe: SilkToastType = SilkToastType.TOAST

    /**
     * 是否在点击时关闭
     * 默认为true
     */
    public var closeOnClick: Bool = true

    /**
     * 是否在点击遮罩层时关闭
     * 默认为false
     */
    public var closeOnClickOverlay: Bool = false

    /**
     * 关闭时的回调函数
     */
    public var onClose: Option<() -> Unit> = None

    /**
     * 打开时的回调函数
     */
    public var onOpened: Option<() -> Unit> = None

    /**
     * 偏移量
     * 默认为20%
     */
    public var offset: Length = 20.percent

    /**
     * 创建轻提示配置选项
     *
     * @param message 提示文字内容，默认为空字符串
     * @param duration 展示时长(毫秒)，默认为3000ms
     * @param showIcon 是否显示图标，默认为true
     * @param icon 自定义图标，默认为None
     * @param iconSize 图标大小，默认为预设大小
     * @param loadingSize 加载图标大小，默认为预设大小
     * @param overlay 是否显示遮罩层，默认为false
     * @param loadingType 加载图标类型，默认为CIRCULAR
     * @param showPosition 显示位置，默认为CENTER
     * @param wordBreak 文本换行方式，默认为BreakAll
     * @param forbidClick 是否禁止背景点击，默认为false
     * @param toastTyoe 提示类型，默认为TOAST
     * @param closeOnClick 是否在点击时关闭，默认为true
     * @param closeOnClickOverlay 是否在点击遮罩层时关闭，默认为false
     * @param onClose 关闭时的回调函数，默认为None
     * @param onOpened 打开时的回调函数，默认为None
     * @param offset 偏移量，默认为20%
     */
    public init (
        message!: ResourceStr = String.empty,
        duration!: Int64 = 3000,
        showIcon!: Bool = true,
        icon!: ?ResourceStr = None,
        iconSize!: Length = getToastSizeConstant(SilkToastSizeKey.TOAST_ICON_SIZE),
        loadingSize!: Length = getToastSizeConstant(SilkToastSizeKey.TOAST_ICON_SIZE),
        overlay!: Bool = false,
        loadingType!: SilkLoadingType = SilkLoadingType.CIRCULAR,
        showPosition!: SilkToastPosition =SilkToastPosition.CENTER,
        wordBreak!: WordBreak = WordBreak.BreakAll,
        forbidClick!: Bool = false,
        toastTyoe!: SilkToastType = SilkToastType.TOAST,
        closeOnClick!: Bool = true,
        closeOnClickOverlay!: Bool = false,
        onClose!: Option<() -> Unit> = None,
        onOpened!: Option<() -> Unit> = None,
        offset!: Length = 20.percent
    ) {
        this.message = message
        this.duration = duration
        this.showIcon = showIcon
        this.icon = icon
        this.iconSize = iconSize
        this.loadingSize = loadingSize
        this.overlay = overlay
        this.loadingType = loadingType
        this.showPosition = showPosition
        this.wordBreak = wordBreak
        this.forbidClick = forbidClick
        this.toastTyoe = toastTyoe
        this.closeOnClick = closeOnClick
        this.closeOnClickOverlay = closeOnClickOverlay
        this.onClose = onClose
        this.onOpened = onOpened
        this.offset = offset
    }
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
 * 文本提示的约束尺寸
 *
 * 用于限制文本类型轻提示的尺寸
 */
let CONSTRAINT_SIZE_TEXT: ConstraintSizeOptions = ConstraintSizeOptions(
    minWidth: 96.vp,
    maxWidth: 72.percent,
    minHeight: 0.vp,
    maxHeight: 70.percent
)

/**
 * 图片提示的约束尺寸
 *
 * 用于限制带图标类型轻提示的尺寸
 */
let CONSTRAINT_SIZE_IMAGE: ConstraintSizeOptions = ConstraintSizeOptions(
    minWidth: 96.vp,
    maxWidth: 72.percent,
    minHeight: 88.vp,
    maxHeight: 70.percent
)
