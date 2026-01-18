/**
 * Created on 2025/4/23
 *
 * SilkCell 单元格组件
 *
 * 单元格为列表中的单个展示项，可以包含标题、内容、图标等元素，常用于展示列表信息、链接或表单等。
 *
 * ## 基础用法
 * ```
 * SilkCell(props: SilkCellOptions(title: "单元格", value: "内容"))
 * ```
 *
 * ## 单元格大小
 * 支持 `Large` 和 `Normal` 两种尺寸，默认为 `Normal`。
 * ```
 * SilkCell(props: SilkCellOptions(title: "单元格", value: "内容", size: SilkCellSize.Large))
 * ```
 *
 * ## 展示图标
 * 通过 `icon` 属性在单元格左侧展示图标。
 * ```
 * SilkCell(props: SilkCellOptions(title: "单元格", value: "内容", icon: "user"))
 * ```
 *
 * ## 展示箭头
 * 设置 `isLink` 属性后会在单元格右侧显示箭头，并且可以通过 `arrowDirection` 属性控制箭头方向。
 * ```
 * SilkCell(props: SilkCellOptions(title: "单元格", isLink: true))
 * SilkCell(props: SilkCellOptions(title: "单元格", isLink: true, arrowDirection: SilkCellArrowDirection.DOWN))
 * ```
 *
 * ## 垂直居中
 * 通过 `center` 属性可以让单元格垂直居中对齐。
 * ```
 * SilkCell(props: SilkCellOptions(title: "单元格", value: "内容", center: true))
 * ```
 *
 * @module silkui/components/cell
 */
package silkui.components.cell

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.state_macro_manage.*
import cj_res_silkui.*
import silkui.SilkUIBorderOptions
import silkui.SilkUIPaddingOptions
import silkui.types.*
import silkui.utils.ResourceStrToString
import silkui.utils.ResourceColorToColor
import silkui.utils.ResourceStrToString
import silkui.ResourceColor
import silkui.components.icon.SilkIcon
import silkui.constants.SilkCellColorKey
import silkui.constants.SilkCellSizeKey
import silkui.constants.SilkSizeKey
import silkui.constants.getCellColorConstant
import silkui.constants.getCellSizeConstant
import silkui.constants.getSizeConstant

/**
 * 单元格组件
 *
 * 用于展示列表中的单个项目，可以包含标题、内容、图标等元素
 */
@Component
public class SilkCell {
    /**
     * 自定义标题内容
     *
     * 可以通过此参数自定义单元格的标题部分
     */
    @BuilderParam
    var Title: () -> Unit = DefaultBuilder

    /**
     * 是否有自定义标题内容
     *
     * 用于判断是否需要渲染自定义标题内容
     */
    var hasTitle: Bool = false

    /**
     * 自定义右侧内容
     *
     * 可以通过此参数自定义单元格的右侧内容部分
     */
    @BuilderParam
    var Value: () -> Unit = DefaultBuilder;
    /**
     * 是否有自定义右侧内容
     *
     * 用于判断是否需要渲染自定义右侧内容
     */
    var hasValue: Bool = false

    /**
     * 自定义描述内容
     *
     * 可以通过此参数自定义单元格的描述部分
     */
    @BuilderParam
    var Label: () -> Unit = DefaultBuilder;
    /**
     * 是否有自定义描述内容
     *
     * 用于判断是否需要渲染自定义描述内容
     */
    var hasLabel: Bool = false

    /**
     * 自定义左侧图标
     *
     * 可以通过此参数自定义单元格的左侧图标
     */
    @BuilderParam
    var Icon: () -> Unit = DefaultBuilder;
    /**
     * 是否有自定义左侧图标
     *
     * 用于判断是否需要渲染自定义左侧图标
     */
    var hasIcon: Bool = false

    /**
     * 自定义右侧图标
     *
     * 可以通过此参数自定义单元格的右侧图标
     */
    @BuilderParam
    var RightIcon: () -> Unit = DefaultBuilder;
    /**
     * 是否有自定义右侧图标
     *
     * 用于判断是否需要渲染自定义右侧图标
     */
    var hasRightIcon: Bool = false

    //    @BuilderParam
    //    var customExtra: () -> Unit = DefaultBuilder;

    //    let paddingValue: SilkUIPaddingOptions = SilkUIPaddingOptions();

    /**
     * 单元格配置选项
     */
    @Prop
    var props: SilkCellOptions

    /**
     * 点击事件回调
     */
    var click: Option<(ClickEvent) -> Unit> = Option.None
    protected func aboutToAppear() {
    }
    func build() {
        Column() {
            Row() {
                Column() {
                    if (hasTitle) {
                        Title()
                    } else {
                        Row() {
                            Column() {
                                if (hasIcon) {
                                    Icon()
                                } else if (props.icon.isSome()) {
                                    SilkIcon(
                                        name: props.icon.getOrThrow(),
                                        fontSize: getCellSizeConstant(SilkCellSizeKey.CELL_ICON_SIZE),
                                        fontColor: getCellColorConstant(SilkCellColorKey.CELL_TEXT_COLOR),
                                        lineHeight: getCellSizeConstant(SilkCellSizeKey.CELL_LINE_HEIGHT)
                                    )
                                }
                            }.margin(right: getSizeConstant(SilkSizeKey.PADDING_BASE))
                            Text(ResourceStrToString(props.title))
                                .fontSize(
                                    match (props.size) {
                                        case SilkCellSize.Large => getCellSizeConstant(
                                            SilkCellSizeKey.CELL_LARGE_TITLE_FONT_SIZE)
                                        case SilkCellSize.Normal => getCellSizeConstant(SilkCellSizeKey.CELL_FONT_SIZE)
                                    })
                                .fontColor(ResourceColorToColor(props.titleColor))
                                .lineHeight(getCellSizeConstant(SilkCellSizeKey.CELL_LINE_HEIGHT))
                        }.alignItems(VerticalAlign.Center)
                    }
                    Column() {
                        if (hasLabel) {
                            Label()
                        } else if (props.label.isSome()) {
                            Text(ResourceStrToString(props.label))
                                .fontSize(
                                    match (props.size) {
                                        case SilkCellSize.Large => getCellSizeConstant(
                                            SilkCellSizeKey.CELL_LARGE_LABEL_FONT_SIZE)
                                        case SilkCellSize.Normal => getCellSizeConstant(
                                            SilkCellSizeKey.CELL_LABEL_FONT_SIZE)
                                    })
                                .fontColor(
                                    ResourceColorToColor(getCellColorConstant(SilkCellColorKey.CELL_LABEL_COLOR)))
                        }
                    }.margin(
                        top: if (hasLabel || props.label.isSome()) {
                            getCellSizeConstant(SilkCellSizeKey.CELL_LABEL_MARGIN_TOP)
                        } else {
                            0.vp
                        })
                }.alignItems(HorizontalAlign.Start)
                Blank()
                Row() {
                    if (hasValue) {
                        Value()
                    } else if (props.value.isSome()) {
                        Text(ResourceStrToString(props.value))
                            .fontSize(getCellSizeConstant(SilkCellSizeKey.CELL_FONT_SIZE))
                            .fontColor(ResourceColorToColor(props.valueColor))
                            .lineHeight(getCellSizeConstant(SilkCellSizeKey.CELL_LINE_HEIGHT))
                    }
                    if (hasRightIcon) {
                        RightIcon()
                    } else if (props.isLink) {
                        Stack() {
                            Column() {
                                SilkIcon(
                                    name: "arrow",
                                    fontSize: getCellSizeConstant(SilkCellSizeKey.CELL_ICON_SIZE),
                                    fontColor: getCellColorConstant(SilkCellColorKey.CELL_RIGHT_ICON_COLOR),
                                    lineHeight: getCellSizeConstant(SilkCellSizeKey.CELL_LINE_HEIGHT),
                                )
                            }
                                .width(getCellSizeConstant(SilkCellSizeKey.CELL_LINE_HEIGHT))
                                .height(getCellSizeConstant(SilkCellSizeKey.CELL_LINE_HEIGHT))
                                .clip(true)
                                .rotate(x: 0.0, y: 0.0, z: 1.0, angle: this.getRotate(), centerX: 50.percent,
                                    centerY: 50.percent)
                        }
                            .width(getCellSizeConstant(SilkCellSizeKey.CELL_LINE_HEIGHT))
                            .margin(left: getSizeConstant(SilkSizeKey.PADDING_BASE))
                            .height(getCellSizeConstant(SilkCellSizeKey.CELL_LINE_HEIGHT))
                            .clip(true)
                    }
                }.alignItems(VerticalAlign.Center).clip(true)
            }
                .width(100.percent)
                .borderWidth(getBorderWidth())
                .borderColor(ResourceColorToColor(getBorderColor()))
                .borderStyle(getBorderStyle())
                .padding(top: getPadding().top, bottom: getPadding().bottom)
                .alignItems(if (props.center) {
                    VerticalAlign.Center
                } else {
                    VerticalAlign.Top
                })
        }
            .backgroundColor(ResourceColorToColor(props.backgroundColor))
            .padding(left: getPadding().left, right: getPadding().right)
            .onClick({
                e => if (click.isSome()) {
                    click.getOrThrow()(e)
                }
            })
    }

    /**
     * 获取边框宽度
     *
     * 根据配置选项决定使用的边框宽度
     *
     * @return 边框宽度配置
     */
    private func getBorderWidth(): EdgeWidths {
        if (props.border) {
            // 使用默认边框，只有底部有1px宽度
            return EdgeWidths(left: 0.vp, right: 0.vp, top: 0.vp, bottom: 1.0.vp)
        } else {
            // 使用自定义边框或无边框
            return match (props.customBorder) {
                case Some(v) => EdgeWidths(left: v.width.vp, right: v.width.vp, top: v.width.vp, bottom: v.width.vp)
                case _ => EdgeWidths(left: 0.vp, right: 0.vp, top: 0.vp, bottom: 0.vp)
            }
        }
    }
    /**
     * 获取边框颜色
     *
     * 根据配置选项决定使用的边框颜色
     *
     * @return 边框颜色
     */
    private func getBorderColor(): ResourceColor {
        if (props.border) {
            // 使用默认边框颜色
            return getCellColorConstant(SilkCellColorKey.CELL_BORDER_COLOR)
        } else {
            // 使用自定义边框颜色或默认颜色
            return match (props.customBorder) {
                case Some(v) => v.color
                case _ => getCellColorConstant(SilkCellColorKey.CELL_BORDER_COLOR)
            }
        }
    }
    /**
     * 获取边框样式
     *
     * 根据配置选项决定使用的边框样式
     *
     * @return 边框样式
     */
    private func getBorderStyle() {
        if (props.border) {
            // 使用默认实线边框样式
            return BorderStyle.Solid
        } else {
            // 使用自定义边框样式或默认样式
            return match (props.customBorder) {
                case Some(v) => v.style
                case _ => BorderStyle.Solid
            }
        }
    }
    /**
     * 获取箭头旋转角度
     *
     * 根据箭头方向计算旋转角度
     *
     * @return 旋转角度（度）
     */
    private func getRotate(): Float32 {
        match (props.arrowDirection) {
            case Some(v) => match (v) {
                case SilkCellArrowDirection.UP => 270.0 // 向上箭头
                case SilkCellArrowDirection.DOWN => 90.0 // 向下箭头
                case SilkCellArrowDirection.LEFT => 180.0 // 向左箭头
                case SilkCellArrowDirection.RIGHT => 0.0 // 向右箭头
                case _ => 0.0
            }
            case _ => 0.0
        };
    }
    /**
     * 获取内边距
     *
     * 根据单元格大小和配置选项决定使用的内边距
     *
     * @return 内边距配置
     */
    private func getPadding() {
        // 如果有自定义内边距，优先使用
        if (props.padding.isSome()) {
            return props.padding.getOrThrow()
        }

        // 根据单元格大小使用不同的预设内边距
        if (props.size == SilkCellSize.Large) {
            // 大型单元格内边距
            SilkUIPaddingOptions(
                top: getCellSizeConstant(SilkCellSizeKey.CELL_LARGE_VERTICAL_PADDING),
                right: getCellSizeConstant(SilkCellSizeKey.CELL_HORIZONTAL_PADDING),
                bottom: getCellSizeConstant(SilkCellSizeKey.CELL_LARGE_VERTICAL_PADDING),
                left: getCellSizeConstant(SilkCellSizeKey.CELL_HORIZONTAL_PADDING)
            )
        } else {
            // 标准单元格内边距
            SilkUIPaddingOptions(
                top: getCellSizeConstant(SilkCellSizeKey.CELL_VERTICAL_PADDING),
                right: getCellSizeConstant(SilkCellSizeKey.CELL_HORIZONTAL_PADDING),
                bottom: getCellSizeConstant(SilkCellSizeKey.CELL_VERTICAL_PADDING),
                left: getCellSizeConstant(SilkCellSizeKey.CELL_HORIZONTAL_PADDING)
            )
        }
    }
    /**
     * 点击事件处理方法
     *
     * 可以被子类重写以处理点击事件
     */
    public func onClick() {
        // 默认实现为空，可由子类重写
    }
}
