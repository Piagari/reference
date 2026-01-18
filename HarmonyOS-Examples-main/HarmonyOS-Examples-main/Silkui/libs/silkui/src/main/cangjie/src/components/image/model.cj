/**
 * Created on 2025/5/9
 *
 * SilkImage 图片组件模型定义
 *
 * 定义了图片组件使用的各种模型和枚举
 *
 * @module silkui/components/image
 */
package silkui.components.image
import silkui.macros.EnumExtend
import ohos.base.*
import ohos.resource_manager.*
import silkui.ResourceStr
import silkui.ResourceColor
import silkui.constants.getImageSizeConstant
import silkui.constants.SilkImageSizeKey

/**
 * 图片填充模式枚举
 *
 * 定义了图片的填充模式，等同于CSS的object-fit属性
 */
@EnumExtend
public enum SilkImageFit {
    | CONTAIN   // 保持宽高缩放图片，使图片的长边能完全显示出来
    | COVER     // 保持宽高缩放图片，使图片的短边能完全显示出来，裁剪长边
    | FILL      // 拉伸图片，使图片填满元素
    | NONE      // 保持图片原有尺寸
    | SCALE_DOWN // 取 NONE 或 CONTAIN 中较小的一个
}

/**
 * 图片位置枚举
 *
 * 定义了图片的位置，等同于CSS的object-position属性
 */
@EnumExtend
public enum SilkImagePosition {
    | TOP       // 顶部对齐
    | RIGHT     // 右侧对齐
    | BOTTOM    // 底部对齐
    | LEFT      // 左侧对齐
    | CENTER    // 居中对齐
}

/**
 * 图片配置选项
 *
 * 用于配置图片组件的各种属性
 */
public struct SilkImageOptions {
    /**
     * 图片填充模式
     * 默认为FILL
     */
    public let fit: SilkImageFit

    /**
     * 图片位置
     * 默认为CENTER
     */
    public let position: SilkImagePosition

    /**
     * 替代文本
     */
    public let alt: ResourceStr

    /**
     * 宽度
     */
    public let width: ?Length

    /**
     * 高度
     */
    public let height: ?Length

    /**
     * 圆角大小
     * 默认为0
     */
    public let radius: Length

    /**
     * 是否显示为圆形
     * 默认为false
     */
    public let round: Bool

    /**
     * 是否将根节点设置为块级元素
     * 默认为false
     */
    public let block: Bool

    /**
     * 是否展示图片加载失败提示
     * 默认为true
     */
    public let showError: Bool

    /**
     * 是否展示图片加载中提示
     * 默认为true
     */
    public let showLoading: Bool

    /**
     * 失败时提示的图标名称或图片链接
     * 默认为"photo-fail"
     */
    public let errorIcon: ResourceStr

    /**
     * 加载时提示的图标名称或图片链接
     * 默认为"photo"
     */
    public let loadingIcon: ResourceStr

    /**
     * 加载图标和失败图标的大小
     * 默认为32px
     */
    public let iconSize: Length

    /**
     * 图标类名前缀
     * 默认为"silk-icon"
     */
    public let iconPrefix: ResourceStr

    /**
     * 创建图片配置选项
     *
     * @param fit 图片填充模式，默认为FILL
     * @param position 图片位置，默认为CENTER
     * @param alt 替代文本，默认为空字符串
     * @param width 宽度，默认为None
     * @param height 高度，默认为None
     * @param radius 圆角大小，默认为0
     * @param round 是否显示为圆形，默认为false
     * @param block 是否将根节点设置为块级元素，默认为false
     * @param showError 是否展示图片加载失败提示，默认为true
     * @param showLoading 是否展示图片加载中提示，默认为true
     * @param errorIcon 失败时提示的图标名称或图片链接，默认为"photo-fail"
     * @param loadingIcon 加载时提示的图标名称或图片链接，默认为"photo"
     * @param iconSize 加载图标和失败图标的大小，默认为32px
     * @param iconPrefix 图标类名前缀，默认为"silk-icon"
     */
    public init(
        fit!: SilkImageFit = SilkImageFit.FILL,
        position!: SilkImagePosition = SilkImagePosition.CENTER,
        alt!: ResourceStr = "",
        width!: ?Length = Option.None,
        height!: ?Length = Option.None,
        radius!: Length = getImageSizeConstant(SilkImageSizeKey.IMAGE_RADIUS),
        round!: Bool = false,
        block!: Bool = false,
        showError!: Bool = true,
        showLoading!: Bool = true,
        errorIcon!: ResourceStr = "photo-fail",
        loadingIcon!: ResourceStr = "photo",
        iconSize!: Length = getImageSizeConstant(SilkImageSizeKey.IMAGE_LOADING_ICON_SIZE),
        iconPrefix!: ResourceStr = "silk-icon"
    ) {
        this.fit = fit
        this.position = position
        this.alt = alt
        this.width = width
        this.height = height
        this.radius = radius
        this.round = round
        this.block = block
        this.showError = showError
        this.showLoading = showLoading
        this.errorIcon = errorIcon
        this.loadingIcon = loadingIcon
        this.iconSize = iconSize
        this.iconPrefix = iconPrefix
    }
}
