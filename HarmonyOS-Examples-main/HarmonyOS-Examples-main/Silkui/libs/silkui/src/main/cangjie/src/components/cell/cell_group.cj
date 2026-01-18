/**
 * Created on 2025/4/21
 *
 * SilkCellGroup 单元格分组组件
 *
 * 单元格分组用于将多个单元格组合在一起，可以设置分组标题、圆角样式等。
 *
 * ## 基础用法
 * ```
 * SilkCellGroup(props: SilkCellGroupOptions()) {
 *   SilkCell(props: SilkCellOptions(title: "单元格1"))
 *   SilkCell(props: SilkCellOptions(title: "单元格2"))
 * }
 * ```
 *
 * ## 分组标题
 * ```
 * SilkCellGroup(props: SilkCellGroupOptions(title: "分组标题")) {
 *   SilkCell(props: SilkCellOptions(title: "单元格1"))
 *   SilkCell(props: SilkCellOptions(title: "单元格2"))
 * }
 * ```
 *
 * ## 卡片风格
 * 设置 `inset` 属性后，单元格分组会展示为圆角卡片风格。
 * ```
 * SilkCellGroup(props: SilkCellGroupOptions(title: "卡片风格", inset: true)) {
 *   SilkCell(props: SilkCellOptions(title: "单元格1"))
 *   SilkCell(props: SilkCellOptions(title: "单元格2"))
 * }
 * ```
 *
 * @module silkui/components/cell/cell_group
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
import crypto.crypto.PaddingMode
import silkui.types.*
import silkui.utils.ResourceStrToString
import silkui.utils.ResourceColorToColor
import silkui.constants.SilkCellColorKey
import silkui.constants.SilkCellSizeKey
import silkui.constants.getCellColorConstant
import silkui.constants.getCellSizeConstant

/**
 * 单元格分组组件
 *
 * 用于将多个单元格组合在一起，可以设置分组标题、圆角样式等
 */
@Component
public class SilkCellGroup {
    /**
     * 单元格分组配置选项
     *
     * 包含标题、样式、边框等配置
     */
    var props: SilkCellGroupOptions = SilkCellGroupOptions()

    /**
     * 子组件构建器
     *
     * 用于包含多个单元格组件
     */
    @BuilderParam
    var Childrens: () -> Unit = DefaultBuilder
    public var _Childrens: Option<(CustomView) -> ViewBuilder> = Option.None
    /**
     * 构建组件UI
     *
     * 根据配置选项渲染单元格分组
     */
    func build() {
        Column() {
            Column() {
                // 如果有标题，则显示标题
                if (!(ResourceStrToString(props.title)).isEmpty() || ResourceStrToString(props.title) != "") {
                    Text(ResourceStrToString(props.title))
                        .fontSize(getCellSizeConstant(SilkCellSizeKey.CELL_GROUP_TITLE_FONT_SIZE))
                        .fontColor(ResourceColorToColor(getCellColorConstant(SilkCellColorKey.CELL_GROUP_TITLE_COLOR)))
                        .padding(
                            top: props.padding.top,
                            right: props.padding.right,
                            bottom: props.padding.bottom,
                            left: props.padding.left
                        )
                }
                // 渲染子组件（单元格）
                if (_Childrens.isSome()) {
                    _Childrens.getOrThrow()()
                } else {
                    Childrens()
                }
            }
                .alignItems(HorizontalAlign.Start)
                .width(100.percent)
                // 根据inset属性设置圆角
                .borderRadius(if (props.inset) {
                    props.radius  // 卡片风格使用配置的圆角
                } else {
                    0  // 普通风格不使用圆角
                })
                .clip(true)
        }
            .width(100.percent)
            // 根据inset属性设置外边距
            .padding(left: if (props.inset) {
                props.marginValue  // 卡片风格使用配置的外边距
            } else {
                0.vp  // 普通风格不使用外边距
            }, right: if (props.inset) {
                props.marginValue  // 卡片风格使用配置的外边距
            } else {
                0.vp  // 普通风格不使用外边距
            })
    }
}


