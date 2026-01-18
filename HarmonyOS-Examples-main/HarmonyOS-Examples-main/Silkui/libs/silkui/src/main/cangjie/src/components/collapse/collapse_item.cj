/**
 * Created on 2025/4/23
 *
 * SilkCollapseItem 折叠面板项组件
 *
 * 折叠面板项是折叠面板的子组件，用于展示可折叠/展开的内容区域。
 *
 * ## 基础用法
 * ```
 * SilkCollapseItem(props: SilkCollapseOptions(title: "标题"), active: true) {
 *   Text("内容")
 * }
 * ```
 *
 * ## 禁用状态
 * 通过 `disabled` 属性可以禁用折叠面板项。
 * ```
 * SilkCollapseItem(props: SilkCollapseOptions(title: "标题", disabled: true)) {
 *   Text("内容")
 * }
 * ```
 *
 * ## 自定义标题
 * 可以使用 `SilkCollapseItemCustomTitle` 自定义标题内容。
 * ```
 * SilkCollapseItemCustomTitle(props: SilkCollapseOptions()) {
 *   Title: {
 *     Row() {
 *       Text("自定义标题")
 *       Image("icon.png")
 *     }
 *   }
 *   Content: {
 *     Text("内容")
 *   }
 * }
 * ```
 *
 * @module silkui/components/collapse/collapse_item
 */
package silkui.components.collapse

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.state_macro_manage.*
import ohos.image.Component
import crypto.crypto.SecureRandom
import silkui.*
import silkui.types.DefaultBuilder
import silkui.utils.ResourceStrToString
import silkui.utils.ResourceColorToColor
import silkui.components.icon.SilkIcon
import silkui.constants.SilkCellColorKey
import silkui.constants.getCellColorConstant
import silkui.constants.SilkCollapseColorKey
import silkui.constants.getCollapseColorConstant
import silkui.constants.SilkCellSizeKey
import silkui.constants.getCellSizeConstant
import silkui.components.cell.SilkCell
import silkui.components.cell.SilkCellOptions
import silkui.components.cell.SilkCellArrowDirection

/**
 * 折叠面板项组件
 *
 * 折叠面板的子组件，用于展示可折叠/展开的内容区域
 */
@Component
public class SilkCollapseItem {
    /**
     * 唯一标识符
     *
     * 用于在折叠面板控制器中标识此面板项
     */
    let name: String = SecureRandom().nextInt64().toString()

    /**
     * 是否默认展开
     *
     * 设置为true时，面板项会在初始化时展开
     */
    @Prop
    var active: Bool

    /**
     * 内边距配置
     *
     * 从父组件SilkCollapse中获取的内边距配置
     */
    @Consume
    var paddingValue: SilkUIPaddingOptions

    /**
     * 折叠面板控制器
     *
     * 从父组件SilkCollapse中获取的控制器，用于管理展开/折叠状态
     */
    @Consume
    @Watch[getCollapseStatus]
    var silkCollapseController: SilkCollapseController

    /**
     * 内容构建器
     *
     * 用于构建折叠面板项的内容区域
     */
    @BuilderParam
    var Content: () -> Unit = DefaultBuilder

    /**
     * 折叠面板项配置选项
     */
    @Prop
    var props: SilkCollapseOptions

    /**
     * 当前展开/折叠状态
     *
     * true表示展开，false表示折叠
     */
    @State
    var collapseStatus: Bool = false

    /**
     * 获取当前折叠状态
     *
     * 从折叠面板控制器中获取当前面板项的展开/折叠状态
     */
    func getCollapseStatus() {
        if (props.disabled) {
            // 禁用状态下强制折叠
            collapseStatus = false
        } else {
            // 从控制器中获取当前状态
            collapseStatus = silkCollapseController.activeNames.get().contains(name)
        }
        cellProps.arrowDirection = if (collapseStatus) {
            SilkCellArrowDirection.UP
        } else {
            SilkCellArrowDirection.DOWN
        }
    }
    @State
    var cellProps: SilkCellOptions = SilkCellOptions(isLink: true)
    @State
    var heightValue: ?Length = Option.None
    /**
     * 组件即将出现时的生命周期方法
     *
     * 初始化折叠面板项
     */
    protected override func aboutToAppear() {
        // 先将name注入到controller中
        this.silkCollapseController.add(name)

        // 如果设置了默认展开，则通知控制器展开此面板项
        if (active) {
            silkCollapseController.change(name)
        }

        // 获取初始状态
        getCollapseStatus()
        cellProps.title = props.title
        cellProps.value = props.value
    }
    /**
     * 构建组件UI
     *
     * 渲染折叠面板项的标题栏和内容区域
     */
    func build() {
        Column() {
            Column() {
                SilkCell(
                    props: cellProps,
                    click: {_ => clickHandle()}
                )
            }
                .opacity(if (props.disabled) {
                    0.4
                } else {
                    1.0
                })
                .onAreaChange({_: Area, area: Area => heightValue = Length(area.height, unitType: LengthType.px)})
            Column() {
                Content()
            }
                .width(100.percent)
                .justifyContent(FlexAlign.Start)
                .alignItems(HorizontalAlign.Start)
                .backgroundColor(
                    ResourceColorToColor(
                        getCollapseColorConstant(SilkCollapseColorKey.COLLAPSE_ITEM_CONTENT_BACKGROUND)))
                .padding(top: paddingValue.top, right: paddingValue.right, bottom: paddingValue.bottom,
                    left: paddingValue.left)
        }
            .width(100.percent)
            .height<Length>(if (collapseStatus) { Option.None } else { heightValue })
            .clip(true)
            .backgroundColor(ResourceColorToColor(getCellColorConstant(SilkCellColorKey.CELL_BACKGROUND)))
            .animationStart(
                AnimateParam(
                    curve: Curve.EaseInOut,
                    duration: 300
                )
            )
    }

    /**
     * 处理点击事件
     *
     * 当点击标题栏时切换展开/折叠状态
     */
    func clickHandle() {
        // 只有在非禁用且非只读状态下才响应点击
        if (!props.disabled && !props.isReadonly) {
            silkCollapseController.change(name)
        }
    }
}

/**
 * 折叠面板项标题构建器
 *
 * 用于构建折叠面板项的标题文本
 *
 * @param title 标题文本，默认为"标题"
 */
@Builder
func SilkCollapseItemTitle(title: Option<String>) {
    Text(title ?? "标题")
        .fontSize(getCellSizeConstant(SilkCellSizeKey.CELL_FONT_SIZE))
        .fontColor(ResourceColorToColor(getCellColorConstant(SilkCellColorKey.CELL_TEXT_COLOR)))
        .lineHeight(getCellSizeConstant(SilkCellSizeKey.CELL_LINE_HEIGHT))
        .maxLines(1)
        .textOverflow(TextOverflow.Ellipsis)
        .layoutWeight(1)
}

/**
 * 折叠面板项默认标题构建器
 *
 * 用于构建默认的折叠面板项标题
 */
@Builder
func SilkCollapseItemDefaultTitle() {
    SilkCollapseItemTitle("标题")
}

/**
 * 自定义标题的折叠面板项组件
 *
 * 允许使用自定义内容作为折叠面板项的标题
 */
@Component
public class SilkCollapseItemCustomTitle {
    /**
     * 唯一标识符
     *
     * 用于在折叠面板控制器中标识此面板项
     */
    let name: String = SecureRandom().nextUInt64().toString()

    /**
     * 是否默认展开
     *
     * 设置为true时，面板项会在初始化时展开
     */
    @Prop
    var active: Bool

    /**
     * 内边距配置
     *
     * 从父组件SilkCollapse中获取的内边距配置
     */
    @Consume
    var paddingValue: SilkUIPaddingOptions

    /**
     * 折叠面板控制器
     *
     * 从父组件SilkCollapse中获取的控制器，用于管理展开/折叠状态
     */
    @Consume
    @Watch[getCollapseStatus]
    var silkCollapseController: SilkCollapseController

    /**
     * 内容构建器
     *
     * 用于构建折叠面板项的内容区域
     */
    @BuilderParam
    var Content: () -> Unit = DefaultBuilder

    /**
     * 标题构建器
     *
     * 用于构建自定义的折叠面板项标题
     */
    @BuilderParam
    var Title: () -> Unit = SilkCollapseItemDefaultTitle

    /**
     * 折叠面板项配置选项
     */
    @Prop
    var props: SilkCollapseOptions

    /**
     * 当前展开/折叠状态
     *
     * true表示展开，false表示折叠
     */
    @State
    var collapseStatus: Bool = false

    func getCollapseStatus() {
        if (props.disabled) {
            collapseStatus = false
        } else {
            collapseStatus = silkCollapseController.activeNames.get().contains(name)
        }
        cellProps.arrowDirection = if (collapseStatus) {
            SilkCellArrowDirection.UP
        } else {
            SilkCellArrowDirection.DOWN
        }
    }
    @State
    var cellProps: SilkCellOptions = SilkCellOptions(isLink: true)

    @State
    var heightValue: ?Length = Option.None
    protected override func aboutToAppear() {
        // 先将name注入到controller中
        this.silkCollapseController.add(name)
        if (active) {
            silkCollapseController.change(name)
        }
        getCollapseStatus()
        cellProps.title = props.title
        cellProps.value = props.value
    }
    func build() {
        Column() {
            Column() {
                SilkCell(
                    Title: Title,
                    hasTitle: true,
                    props: cellProps,
                    click: {_ => clickHandle()}
                )
            }
                .opacity(if (props.disabled) {
                    0.4
                } else {
                    1.0
                })
                .onAreaChange({_: Area, area: Area => heightValue = Length(area.height, unitType: LengthType.px)})
            Column() {
                Content()
            }
                .width(100.percent)
                .justifyContent(FlexAlign.Start)
                .alignItems(HorizontalAlign.Start)
                .backgroundColor(
                    ResourceColorToColor(
                        getCollapseColorConstant(SilkCollapseColorKey.COLLAPSE_ITEM_CONTENT_BACKGROUND)))
                .padding(top: paddingValue.top, right: paddingValue.right, bottom: paddingValue.bottom,
                    left: paddingValue.left)
        }
            .width(100.percent)
            .height<Length>(if (collapseStatus) { Option.None } else { heightValue })
            .clip(true)
            .backgroundColor(ResourceColorToColor(getCellColorConstant(SilkCellColorKey.CELL_BACKGROUND)))
            .animationStart(
                AnimateParam(
                    curve: Curve.EaseInOut,
                    duration: 300
                )
            )
    }

    func clickHandle() {
        if (!props.disabled && !props.isReadonly) {
            silkCollapseController.change(name)
        }
    }
}
