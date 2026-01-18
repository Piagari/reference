/**
 * Created on 2025/4/23
 *
 * SilkCollapse 折叠面板组件
 *
 * 折叠面板用于将内容区域折叠/展开，节省页面空间，常用于分组显示复杂内容。
 *
 * @module silkui/components/collapse
 */
package silkui.components.collapse
internal import ohos.base.*
import ohos.state_macro_manage.*
import ohos.resource_manager.*
import cj_res_silkui.*
import silkui.SilkUIBorderOptions
import silkui.SilkUIPaddingOptions
import silkui.ResourceStr

/**
 * 折叠面板配置选项
 *
 * 用于配置折叠面板的各种属性，包括标题、图标、样式等
 */
@Observed
public class SilkCollapseOptions {
    /**
     * 右侧箭头图标名称
     * 默认为 "arrow"
     */
    @Publish public var icon: ResourceStr = "arrow"

    /**
     * 面板标题
     * 默认为 "标题"
     */
    @Publish public var title: ResourceStr = "标题"

    /**
     * 面板右侧内容
     * 默认为空字符串
     */
    @Publish public var value: ResourceStr = String.empty

    /**
     * 是否显示右侧箭头图标
     * 默认为 true
     */
    @Publish public var showIcon: Bool = true

    /**
     * 是否禁用面板
     * 禁用时无法展开或收起
     * 默认为 false
     */
    @Publish public var disabled: Bool = false

    /**
     * 是否为只读状态
     * 默认为 false
     */
    @Publish public var isReadonly: Bool = false

    /**
     * 是否显示内边框
     * 默认为 false
     */
    @Publish public var border: Bool = false

    /**
     * 内边距配置
     * 默认为上下0，左右16vp
     */
    @Publish public var paddingValue: SilkUIPaddingOptions = SilkUIPaddingOptions(
        top: 0.0.vp,
        right: 16.0.vp,
        bottom: 0.0.vp,
        left: 16.0.vp
    )
}
