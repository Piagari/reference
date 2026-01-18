/**
 * Created on 2025/4/23
 *
 * SilkCell 单元格组件
 *
 * 单元格为列表中的单个展示项，可以包含标题、内容、图标等元素，常用于展示列表信息、链接或表单等。
 *
 * @module silkui/components/cell
 */
package silkui.components.cell
internal import ohos.base.*
import ohos.state_macro_manage.*
import ohos.resource_manager.*
import cj_res_silkui.*
import silkui.SilkUIBorderOptions
import silkui.SilkUIPaddingOptions
import silkui.ResourceStr
import silkui.ResourceColor
import silkui.macros.EnumExtend
import silkui.constants.SilkCellColorKey
import silkui.constants.SilkCellSizeKey
import silkui.constants.SilkCellPaddingKey
import silkui.constants.getCellColorConstant
import silkui.constants.getCellSizeConstant
import silkui.constants.getCellPaddingConstant

/**
 * 单元格尺寸
 *
 * 定义单元格的大小规格
 */
@EnumExtend
public enum SilkCellSize {
    | Large   // 大型单元格
    | Normal  // 标准单元格
}

/**
 * 单元格箭头方向
 *
 * 定义单元格右侧箭头图标的朝向
 */
public enum SilkCellArrowDirection {
    | UP     // 向上箭头
    | DOWN   // 向下箭头
    | LEFT   // 向左箭头
    | RIGHT  // 向右箭头
}


/**
 * 单元格配置选项
 *
 * 用于配置单元格的各种属性，包括标题、内容、样式等
 */
@Observed
public class SilkCellOptions {
    /**
     * 单元格标题
     * 默认为空字符串
     */
    @Publish public var title: ResourceStr = String.empty

    /**
     * 单元格右侧内容
     * 默认为 None
     */
    @Publish public var value: ?ResourceStr = Option.None

    /**
     * 标题文字颜色
     * 默认使用预设颜色
     */
    @Publish public var titleColor: ResourceColor = getCellColorConstant(SilkCellColorKey.CELL_TEXT_COLOR)

    /**
     * 右侧内容文字颜色
     * 默认使用预设颜色
     */
    @Publish public var valueColor: ResourceColor = getCellColorConstant(SilkCellColorKey.CELL_VALUE_COLOR)

    /**
     * 单元格背景颜色
     * 默认使用预设颜色
     */
    @Publish public var backgroundColor: ResourceColor = getCellColorConstant(SilkCellColorKey.CELL_BACKGROUND)

    /**
     * 单元格高度
     * 默认为 44.0
     */
    @Publish public var height: Float64 = 44.0

    /**
     * 标题下方的描述信息
     * 默认为 None
     */
    @Publish public var label: ?ResourceStr = Option.None

    /**
     * 单元格大小
     * 默认为 Normal
     */
    @Publish public var size: SilkCellSize = SilkCellSize.Normal

    /**
     * 左侧图标
     * 默认为 None
     */
    @Publish public var icon: ?ResourceStr = Option.None

    /**
     * 是否可点击
     * 默认为 false
     */
    @Publish public var clickable: Bool = false

    /**
     * 是否显示右侧箭头并开启点击反馈
     * 默认为 false
     */
    @Publish public var isLink: Bool = false

    /**
     * 是否显示表单必填星号
     * 默认为 false
     */
    @Publish public var required: Bool = false

    /**
     * 是否使内容垂直居中
     * 默认为 false
     */
    @Publish public var center: Bool = false

    /**
     * 是否显示内边框
     * 默认为 true
     */
    @Publish public var border: Bool = true

    /**
     * 自定义边框样式
     * 默认为 None
     */
    @Publish public var customBorder: ?SilkUIBorderOptions = Option.None

    /**
     * 内容区域内边距
     * 默认为 None
     */
    @Publish public var padding: ?SilkUIPaddingOptions = Option.None

    /**
     * 箭头方向
     * 默认为 RIGHT
     */
    @Publish public var arrowDirection: ?SilkCellArrowDirection = SilkCellArrowDirection.RIGHT
}

/**
 * 单元格分组配置选项
 *
 * 用于配置单元格分组的各种属性，包括标题、样式等
 */
@Observed
public class SilkCellGroupOptions {
    /**
     * 分组标题
     * 默认为空字符串
     */
    @Publish public var title: ResourceStr = String.empty

    /**
     * 是否展示为圆角卡片风格
     * 默认为 false
     */
    @Publish public var inset: Bool = false

    /**
     * 是否显示外边框
     * 默认为 true
     */
    @Publish public var hasBorder: Bool = true

    /**
     * 自定义边框样式
     * 默认为 None
     */
    @Publish public var customBorder: ?SilkUIBorderOptions = Option.None

    /**
     * 外边距值
     * 默认使用预设边距
     */
    @Publish public var marginValue: Length = getCellPaddingConstant(SilkCellPaddingKey.CELL_GROUP_INSET_PADDING).left

    /**
     * 内边距
     * 默认使用预设内边距
     */
    @Publish public var padding: SilkUIPaddingOptions = getCellPaddingConstant(SilkCellPaddingKey.CELL_GROUP_TITLE_PADDING)

    /**
     * 圆角大小
     * 默认为 8
     */
    @Publish public var radius: Int64 = 8
}
