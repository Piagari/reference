/**
 * Created on 2025/4/27
 *
 * SilkButton 按钮组件
 *
 * 按钮用于触发一个操作，如提交表单。
 *
 * @module silkui/components/button
 */
package silkui.components.button

internal import ohos.base.*
import ohos.state_macro_manage.*
import ohos.resource_manager.*
import ohos.component.FontWeight
import std.collection.HashMap
import cj_res_silkui.*
import ohos.base.CJResource
import silkui.macros.EnumExtend
import silkui.SilkUILinearGradientOptions
import silkui.components.loading.SilkLoadingType
import silkui.ResourceStr
import silkui.ResourceColor

/**
 * 按钮类型
 *
 * 按钮支持多种类型，每种类型对应不同的样式
 */
@EnumExtend
public enum SilkButtonType {
    | PRIMARY  // 主要按钮，用于强调页面主要操作
    | SUCCESS  // 成功按钮，用于表示成功或积极的操作
    | WARNING  // 警告按钮，用于提醒用户需要注意的操作
    | DANGER   // 危险按钮，用于表示危险或不可逆的操作
    | DEFAULT  // 默认按钮，用于一般操作
}

/**
 * 按钮尺寸
 *
 * 按钮支持多种尺寸，适应不同的场景需求
 */
@EnumExtend
public enum SilkButtonSize {
    | LARGE   // 大型按钮，通常用于页面主要操作，高度为50vp
    | SMALL   // 小型按钮，用于较小区域，高度为32vp
    | MINI    // 迷你按钮，用于极小区域，高度为24vp
    | NORMAL  // 普通按钮，默认尺寸，高度为44vp
}

/**
 * 按钮图标位置
 *
 * 定义按钮中图标相对于文字的位置
 */
@EnumExtend
public enum SilkButtonIconPosition {
    | LEFT   // 图标位于文字左侧
    | RIGHT  // 图标位于文字右侧
}

/**
 * 按钮配置选项
 *
 * 用于配置按钮的各种属性，包括类型、尺寸、颜色、图标等
 */
public struct SilkButtonOptions {
    /**
     * 按钮类型
     * 可选值为 PRIMARY、SUCCESS、WARNING、DANGER、DEFAULT
     * 默认值为 DEFAULT
     */
    public let buttonType: SilkButtonType

    /**
     * 按钮尺寸
     * 可选值为 LARGE、SMALL、MINI、NORMAL
     * 默认值为 NORMAL
     */
    public let size: SilkButtonSize

    /**
     * 按钮文字内容
     * 支持字符串或资源引用
     */
    public let text: ResourceStr

    /**
     * 按钮文字颜色
     * 可以是颜色值或资源引用
     * 如果不设置，将根据按钮类型自动选择合适的颜色
     */
    public let textColor: ?ResourceColor

    /**
     * 按钮背景颜色
     * 可以是颜色值或资源引用
     * 如果不设置，将根据按钮类型自动选择合适的颜色
     */
    public let color: ?ResourceColor

    /**
     * 按钮渐变色配置
     * 设置后可以实现渐变背景效果
     */
    public let linearGradient: ?SilkUILinearGradientOptions

    /**
     * 按钮图标名称
     * 可以是图标名称或图片链接
     */
    public let icon: ResourceStr

    /**
     * 图标字体库名称
     * 默认值为 "silk-icon"
     */
    public let iconPrefix: ResourceStr

    /**
     * 图标位置
     * 可选值为 LEFT、RIGHT
     * 默认值为 LEFT
     */
    public let iconPosition: SilkButtonIconPosition

    /**
     * 是否为朴素按钮
     * 朴素按钮的文字颜色与按钮颜色相同，背景为白色
     * 默认值为 false
     */
    public let plain: Bool

    /**
     * 是否为方形按钮
     * 方形按钮的圆角为0
     * 默认值为 false
     */
    public let square: Bool

    /**
     * 是否为圆形按钮
     * 圆形按钮的圆角为999vp
     * 默认值为 false
     */
    public let round: Bool

    /**
     * 是否使用细边框
     * 设置为 true 时，边框宽度为 0.5px
     * 默认值为 false
     */
    public let hairLine: Bool

    /**
     * 按钮宽度
     * 不设置时，大型按钮宽度为100%，其他尺寸按内容自适应
     */
    public let width: ?Length

    /**
     * 按钮高度
     * 不设置时，根据按钮尺寸自动设置高度
     */
    public let height: ?Length

    /**
     * 加载状态下的提示文字
     */
    public let loadingText: ResourceStr

    /**
     * 加载图标类型
     * 默认值为 CIRCULAR
     */
    public let loadingType: SilkLoadingType

    /**
     * 加载图标大小
     * 默认值为 20vp
     */
    public let loadingSize: Length

    /**
     * 是否有边框
     * 设置为 false 时，按钮将没有边框
     * 默认值为 true
     */
    public let hasBorder: Bool

    /**
     * 创建按钮配置选项
     *
     * @param buttonType 按钮类型，默认为 DEFAULT
     * @param size 按钮尺寸，默认为 NORMAL
     * @param text 按钮文字内容，默认为空字符串
     * @param textColor 按钮文字颜色，默认为 None
     * @param color 按钮背景颜色，默认为 None
     * @param linearGradient 按钮渐变色配置，默认为 None
     * @param icon 按钮图标名称，默认为空字符串
     * @param iconPrefix 图标字体库名称，默认为 "silk-icon"
     * @param iconPosition 图标位置，默认为 LEFT
     * @param plain 是否为朴素按钮，默认为 false
     * @param square 是否为方形按钮，默认为 false
     * @param round 是否为圆形按钮，默认为 false
     * @param hairLine 是否使用细边框，默认为 false
     * @param width 按钮宽度，默认为 None
     * @param height 按钮高度，默认为 None
     * @param loadingText 加载状态下的提示文字，默认为空字符串
     * @param loadingType 加载图标类型，默认为 CIRCULAR
     * @param loadingSize 加载图标大小，默认为 20vp
     */
    public init (
        buttonType!: SilkButtonType = SilkButtonType.DEFAULT,
        size!: SilkButtonSize = SilkButtonSize.NORMAL,
        text!: ResourceStr = String.empty,
        textColor!: ?ResourceColor = Option.None,
        color!: ?ResourceColor = Option.None,
        linearGradient!: ?SilkUILinearGradientOptions = Option.None,
        icon!: ResourceStr = String.empty,
        iconPrefix!: ResourceStr = @r(app.string.icon_name),
        iconPosition!: SilkButtonIconPosition = SilkButtonIconPosition.LEFT,
        plain!: Bool = false,
        square!: Bool = false,
        round!: Bool = false,
        hairLine!: Bool = false,
        width!: ?Length = Option.None,
        height!: ?Length = Option.None,
        loadingText!: ?ResourceStr = String.empty,
        loadingType!: SilkLoadingType = SilkLoadingType.CIRCULAR,
        loadingSize!: Length = Length(20, unitType: LengthType.vp),
        hasBorder!: Bool = true
    ) {
        this.buttonType = buttonType
        this.size = size
        this.text = text
        this.textColor = textColor
        this.color = color
        this.linearGradient = linearGradient
        this.icon = icon
        this.iconPrefix = iconPrefix
        this.iconPosition = iconPosition
        this.plain = plain
        this.square = square
        this.round = round
        this.hairLine = hairLine
        this.width = width
        this.height = height
        this.loadingText = loadingText ?? String.empty
        this.loadingType = loadingType
        this.loadingSize = loadingSize
        this.hasBorder = hasBorder
    }
}