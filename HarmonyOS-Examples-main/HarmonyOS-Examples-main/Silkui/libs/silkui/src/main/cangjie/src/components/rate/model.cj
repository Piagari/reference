/**
 * Created on 2025/5/15
 *
 * SilkRate 评分组件模型定义
 *
 * 定义了评分组件使用的各种模型和枚举，包括配置选项结构体
 *
 * @module silkui/components/rate
 */
package silkui.components.rate
import silkui.macros.EnumExtend
import ohos.base.*
import ohos.resource_manager.*
import silkui.ResourceStr
import silkui.ResourceColor
import silkui.constants.getRateColorConstant
import silkui.constants.SilkRateColorKey
import silkui.constants.getRateSizeConstant
import silkui.constants.SilkRateSizeKey
import silkui.constants.getRateIntConstant
import silkui.constants.SilkRateIntKey

/**
 * 评分组件配置选项
 *
 * 用于配置评分组件的各种属性，包括数量、颜色、尺寸等
 */
public struct SilkRateOptions {
    /**
     * 图标总数
     *
     * 默认值为5
     */
    public let count: Int64

    /**
     * 是否允许半选
     *
     * 默认值为false
     */
    public let allowHalf: Bool

    /**
     * 是否为只读状态，只读状态下无法修改评分
     *
     * 默认值为false
     */
    public let readonly: Bool

    /**
     * 是否可清空
     *
     * 默认值为false
     */
    public let clearable: Bool

    /**
     * 是否禁用评分
     *
     * 默认值为false
     */
    public let disabled: Bool

    /**
     * 是否可以通过滑动手势选择评分
     *
     * 默认值为true
     */
    public let touchable: Bool

    /**
     * 选中时的图标名称
     *
     * 默认值为"star"
     */
    public let icon: ResourceStr

    /**
     * 未选中时的图标名称
     *
     * 默认值为"star-o"
     */
    public let voidIcon: ResourceStr

    /**
     * 选中时的图标颜色
     */
    public let color: ResourceColor

    /**
     * 未选中时的图标颜色
     */
    public let voidColor: ResourceColor

    /**
     * 禁用时的图标颜色
     */
    public let disabledColor: ResourceColor

    /**
     * 图标大小，默认单位为vp
     */
    public let size: Length

    /**
     * 图标间距，默认单位为vp
     */
    public let gutter: Length

    /**
     * 构造函数
     *
     * @param count 图标总数
     * @param allowHalf 是否允许半选
     * @param readonly 是否为只读状态
     * @param clearable 是否可清空
     * @param disabled 是否禁用评分
     * @param touchable 是否可以通过滑动手势选择评分
     * @param icon 选中时的图标名称
     * @param voidIcon 未选中时的图标名称
     * @param color 选中时的图标颜色
     * @param voidColor 未选中时的图标颜色
     * @param disabledColor 禁用时的图标颜色
     * @param size 图标大小
     * @param gutter 图标间距
     */
    public init(
        count!: Int64 = getRateIntConstant(SilkRateIntKey.RATE_COUNT),
        allowHalf!: Bool = false,
        readonly!: Bool = false,
        clearable!: Bool = false,
        disabled!: Bool = false,
        touchable!: Bool = true,
        icon!: ResourceStr = "star",
        voidIcon!: ResourceStr = "star-o",
        color!: ResourceColor = getRateColorConstant(SilkRateColorKey.RATE_ICON_FULL_COLOR),
        voidColor!: ResourceColor = getRateColorConstant(SilkRateColorKey.RATE_ICON_VOID_COLOR),
        disabledColor!: ResourceColor = getRateColorConstant(SilkRateColorKey.RATE_ICON_DISABLED_COLOR),
        size!: Length = getRateSizeConstant(SilkRateSizeKey.RATE_ICON_SIZE),
        gutter!: Length = getRateSizeConstant(SilkRateSizeKey.RATE_ICON_GUTTER)
    ) {
        this.count = count
        this.allowHalf = allowHalf
        this.readonly = readonly
        this.clearable = clearable
        this.disabled = disabled
        this.touchable = touchable
        this.icon = icon
        this.voidIcon = voidIcon
        this.color = color
        this.voidColor = voidColor
        this.disabledColor = disabledColor
        this.size = size
        this.gutter = gutter
    }
}
