/**
 * Created on 2025/7/9
 *
 * SilkPicker 选择器组件
 *
 * 选择器组件用于从一组选项中选择一个或多个值，支持单列和多列选择。
 * 支持自定义选项、加载状态、禁用状态等功能。
 *
 * @module silkui/components/picker
 */
package silkui.components.picker
import silkui.macros.EnumExtend
import std.overflow.ThrowingOp
import ohos.base.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.resource_manager.*
import silkui.ResourceColor
import silkui.ResourceStr
import silkui.constants.getPickerColorConstant
import silkui.constants.SilkPickerColorKey
import silkui.constants.getPickerSizeConstant
import silkui.constants.SilkPickerSizeKey
import silkui.constants.getPickerGradientConstant
import silkui.constants.SilkPickerGradientKey
import silkui.constants.getColorConstant
import silkui.constants.SilkColorKey

/**
 * 选择器选项
 *
 * 定义选择器中的单个选项配置
 */
public struct SilkPickerOption {
    /**
     * 选项文本
     */
    public let text: ResourceStr

    /**
     * 选项值
     */
    public let value: ResourceStr

    /**
     * 是否禁用
     * 默认为 false
     */
    public let disabled: Bool

    /**
     * 子选项列表（用于级联选择）
     * 默认为空数组
     */
    public let children: Array<SilkPickerOption>

    /**
     * 创建选择器选项
     *
     * @param text 选项文本
     * @param value 选项值，默认与text相同
     * @param disabled 是否禁用，默认为 false
     * @param children 子选项列表，默认为空数组
     */
    public init (
        text!: ResourceStr,
        value!: ResourceStr = text,
        disabled!: Bool = false,
        children!: Array<SilkPickerOption> = Array<SilkPickerOption>()
    ) {
        this.text = text
        this.value = value
        this.disabled = disabled
        this.children = children
    }
}

/**
 * 选择器列配置
 *
 * 定义选择器中单列的配置
 */
public struct SilkPickerColumn {
    /**
     * 列选项列表
     */
    public let options: Array<SilkPickerOption>

    /**
     * 创建选择器列配置
     *
     * @param options 列选项列表
     * @param defaultIndex 默认选中的选项索引，默认为 0
     * @param title 列标题，默认为空字符串
     */
    public init (
        options: Array<SilkPickerOption>
    ) {
        this.options = options
    }
}

/**
 * 选择器配置选项
 *
 * 用于配置选择器的各种属性，包括标题、按钮、样式等
 */
@Observed
public class SilkPickerOptions {
    /**
     * 选择器标题
     * 默认为空字符串
     */
    public var title: ResourceStr = String.empty

    /**
     * 确认按钮文字
     * 默认为 "确认"
     */
    public var confirmButtonText: ResourceStr = "确认"

    /**
     * 取消按钮文字
     * 默认为 "取消"
     */
    public var cancelButtonText: ResourceStr = "取消"

    /**
     * 工具栏位置
     * 默认为 true（顶部）
     */
    public var toolbarPosition: Bool = true

    /**
     * 是否显示加载状态
     * 默认为 false
     */
    @Publish public var loading: Bool = false

    /**
     * 加载提示文字
     * 默认为 "加载中..."
     */
    public var loadingText: ResourceStr = "加载中..."

    /**
     * 是否只读
     * 默认为 false
     */
    public var readonly: Bool = false

    /**
     * 选项高度
     * 默认为 44vp
     */
    public var itemHeight: Length = 44.vp

    /**
     * 可见选项数量
     * 默认为 6
     */
    public var visibleItemCount: Int32 = 6

    /**
     * 快速滑动时惯性滚动的时长，单位毫秒
     * 默认为 1000
     */
    public var swipeDuration: Int32 = 1000

}
