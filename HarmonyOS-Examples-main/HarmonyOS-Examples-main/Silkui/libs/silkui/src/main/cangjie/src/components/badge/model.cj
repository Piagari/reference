/**
 * Created on 2025/5/5
 *
 * SilkBadge 徽标组件
 *
 * 徽标用于展示数字、文本或红点标记，通常用于消息提醒、数量显示等场景。
 *
 * @module silkui/components/badge
 */
package silkui.components.badge
import silkui.ResourceColor
import ohos.base.Length
import ohos.base.LengthType
import silkui.constants.getBadgeColorConstant
import silkui.constants.SilkBadgeColorKey
import silkui.constants.getBadgeSizeConstant
import silkui.constants.SilkBadgeSizeKey
import silkui.SilkUIPaddingOptions
import silkui.constants.getBadgePaddingConstant
import silkui.constants.SilkBadgePaddingKey
import ohos.component.FontWeight
import silkui.constants.__SilkBadgeWeight
import silkui.SilkUIBorderOptions
import ohos.component.BorderStyle
import silkui.constants.getColorConstant
import silkui.constants.SilkColorKey
import silkui.constants.getSizeConstant
import silkui.constants.SilkSizeKey
import silkui.constants.getBadgeIntConstant
import silkui.constants.SilkBadgeIntKey
import silkui.macros.EnumExtend

/**
 * 徽标位置
 *
 * 定义徽标相对于其容器的位置
 */
@EnumExtend
public enum SilkBadgePosition {
    | TOP_LEFT     // 左上角
    | TOP_RIGHT    // 右上角
    | BOTTOM_LEFT  // 左下角
    | BOTTOM_RIGHT // 右下角
}

/**
 * 徽标配置选项
 *
 * 用于配置徽标的各种属性，包括内容、颜色、位置、样式等
 */
public struct SilkBadgeOptions {
    /**
     * 徽标内容
     * 可以是数字或文本
     */
    public let content: String

    /**
     * 徽标文字颜色
     */
    public let color: ResourceColor

    /**
     * 是否显示为小红点
     * 设置为 true 时，忽略 content 内容，显示一个小红点
     * 默认值为 false
     */
    public let dot: Bool

    /**
     * 最大数值
     * 当数值超过最大值时，会显示 {max}+
     */
    public let max: ?Int64

    /**
     * 徽标偏移量
     * 用于微调徽标位置
     */
    public let offset: Length

    /**
     * 当数值为 0 时是否显示徽标
     * 默认值为 true
     */
    public let show_zero: Bool

    /**
     * 徽标位置
     * 默认值为 TOP_RIGHT
     */
    public let position: SilkBadgePosition

    /**
     * 徽标背景颜色
     */
    public let backgroundColor: ResourceColor

    /**
     * 徽标文字大小
     */
    public let fontSize: Length

    /**
     * 徽标内边距
     */
    public let padding: SilkUIPaddingOptions

    /**
     * 徽标尺寸
     * 当设置为小红点时使用
     */
    public let size: Length

    /**
     * 徽标文字字重
     */
    public let fontWeight: FontWeight

    /**
     * 徽标边框配置
     */
    public let border: SilkUIBorderOptions

    /**
     * 徽标圆角大小
     */
    public let radius: Length

    /**
     * 创建徽标配置选项
     *
     * @param content 徽标内容，默认为空字符串
     * @param color 徽标文字颜色，默认为预设颜色
     * @param dot 是否显示为小红点，默认为 false
     * @param max 最大数值，默认为 None
     * @param offset 徽标偏移量，默认为 0vp
     * @param show_zero 当数值为 0 时是否显示徽标，默认为 true
     * @param position 徽标位置，默认为 TOP_RIGHT
     * @param backgroundColor 徽标背景颜色，默认为预设颜色
     * @param fontSize 徽标文字大小，默认为预设大小
     * @param padding 徽标内边距，默认为预设内边距
     * @param size 徽标尺寸，默认为预设尺寸
     * @param fontWeight 徽标文字字重，默认为预设字重
     * @param border 徽标边框配置，默认为预设边框
     * @param radius 徽标圆角大小，默认为最大圆角
     */
    public init (
        content!: String = String.empty,
        color!: ResourceColor = getBadgeColorConstant(SilkBadgeColorKey.BADGE_COLOR),
        dot!: Bool = false,
        max!: ?Int64 = Option.None,
        offset!: Length = Length(0, unitType: LengthType.vp),
        show_zero!: Bool = true,
        position!: SilkBadgePosition = SilkBadgePosition.TOP_RIGHT,
        backgroundColor!: ResourceColor = getBadgeColorConstant(SilkBadgeColorKey.BADGE_BACKGROUND),
        fontSize!: Length = getBadgeSizeConstant(SilkBadgeSizeKey.BADGE_FONT_SIZE),
        padding!: SilkUIPaddingOptions = getBadgePaddingConstant(SilkBadgePaddingKey.PADDING),
        size!: Length = getBadgeSizeConstant(SilkBadgeSizeKey.BADGE_SIZE),
        fontWeight!: FontWeight = __SilkBadgeWeight,
        border!: SilkUIBorderOptions = SilkUIBorderOptions(
            width: getBadgeIntConstant(SilkBadgeIntKey.BORDER_WIDTH),
            style: BorderStyle.Solid,
            color: getColorConstant(SilkColorKey.BACKGROUND_2)
        ),
        radius!: Length = getSizeConstant(SilkSizeKey.RADIUS_MAX)
    ) {
        this.content = content
        this.color = color
        this.dot = dot
        this.max = max
        this.offset = offset
        this.show_zero = show_zero
        this.position = position
        this.backgroundColor = backgroundColor
        this.fontSize = fontSize
        this.padding = padding
        this.size = size
        this.fontWeight = fontWeight
        this.border = border
        this.radius = radius
    }
}