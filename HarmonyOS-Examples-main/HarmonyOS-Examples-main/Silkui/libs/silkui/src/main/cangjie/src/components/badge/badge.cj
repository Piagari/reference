/**
 * Created on 2025/5/5
 *
 * SilkBadge 徽标组件
 *
 * 徽标用于展示数字、文本或红点标记，通常用于消息提醒、数量显示等场景。
 *
 * ## 基础用法
 * ```
 * SilkBadge(props: SilkBadgeOptions(content: "5"))
 * ```
 *
 * ## 最大值
 * 设置 `max` 属性后，当数值超过最大值时，会显示 `{max}+`。
 * ```
 * SilkBadge(props: SilkBadgeOptions(content: "99", max: 99))
 * ```
 *
 * ## 自定义颜色
 * 通过 `color` 和 `backgroundColor` 属性设置徽标的颜色。
 * ```
 * SilkBadge(props: SilkBadgeOptions(content: "5", color: Color(255, 255, 255, alpha: 1), backgroundColor: Color(255, 0, 0, alpha: 1)))
 * ```
 *
 * ## 小红点
 * 设置 `dot` 属性后，徽标会显示为一个小红点，忽略 `content` 的内容。
 * ```
 * SilkBadge(props: SilkBadgeOptions(dot: true))
 * ```
 *
 * ## 自定义位置
 * 通过 `position` 属性设置徽标的位置，支持 `TOP_LEFT`、`TOP_RIGHT`、`BOTTOM_LEFT`、`BOTTOM_RIGHT` 四个位置。
 * ```
 * SilkBadge(props: SilkBadgeOptions(content: "5", position: SilkBadgePosition.TOP_LEFT))
 * ```
 *
 * @module silkui/components/badge
 */
package silkui.components.badge

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.Resource
import ohos.state_macro_manage.*
import cj_res_silkui.*
import silkui.constants.getBadgeSizeConstant
import silkui.constants.SilkBadgeSizeKey
import silkui.utils.ResourceColorToColor
import silkui.constants.getColorConstant
import silkui.constants.SilkColorKey
import silkui.constants.getBadgeIntConstant
import silkui.constants.SilkBadgeIntKey
import silkui.types.DefaultBuilder
import silkui.utils.StringToInt64
import silkui.constants.getSizeConstant
import silkui.SilkUIPaddingOptions
import ohos.prompt_action.PromptAction

/**
 * 徽标偏移量结构体
 *
 * 用于计算徽标相对于其容器的偏移位置
 */
struct SilkBadgeOffset {
    /**
     * X轴偏移量
     */
    var x: Float64 = 0.0

    /**
     * Y轴偏移量
     */
    var y: Float64 = 0.0

    /**
     * 创建徽标偏移量
     *
     * @param x X轴偏移量，默认为0.0
     * @param y Y轴偏移量，默认为0.0
     */
    public init (x!: Float64 = 0.0, y!: Float64 = 0.0) {
        this.x = x
        this.y = y
    }
}

/**
 * 徽标组件
 *
 * 用于展示数字、文本或红点标记，通常用于消息提醒、数量显示等场景
 */
@Component
public class SilkBadge {
    /**
     * 徽标渲染宽度
     * 用于计算偏移量
     */
    @State
    var renderSizeW: Float64 = 0.0

    /**
     * 徽标渲染高度
     * 用于计算偏移量
     */
    @State
    var renderSizeH: Float64 = 0.0

    /**
     * 徽标配置选项
     */
    @Prop
    var props: SilkBadgeOptions

    /**
     * 自定义子内容
     *
     * 可以通过此参数自定义徽标所附加的内容
     */
    @BuilderParam
    var Children: () -> Unit = DefaultBuilder

    /**
     * 是否有自定义子内容
     */
    var hasChildren: Bool = false

    /**
     * 自定义徽标内容
     *
     * 可以通过此参数自定义徽标的显示内容
     */
    @BuilderParam
    var Content: () -> Unit = DefaultBuilder

    /**
     * 是否有自定义徽标内容
     */
    var hasContent: Bool = false

    func build () {
        Stack(match (props.position) {
        	case SilkBadgePosition.TOP_LEFT => Alignment.TopStart
            case SilkBadgePosition.TOP_RIGHT => Alignment.TopEnd
            case SilkBadgePosition.BOTTOM_LEFT => Alignment.BottomStart
            case SilkBadgePosition.BOTTOM_RIGHT => Alignment.BottomEnd
        }) {
            if (hasChildren) {
                Children()
            }
                if (hasContent) {
                    Row() {
                        Content()
                    }.padding(
                    top: getPadding().top,
                    right: getPadding().right,
                    bottom: getPadding().bottom,
                    left: getPadding().left
                )
                .backgroundColor(ResourceColorToColor(props.backgroundColor))
                .borderRadius(props.radius)
                .constraintSize(
                minWidth: if (props.dot) { 0.vp } else { getBadgeSizeConstant(SilkBadgeSizeKey.BADGE_SIZE)}
            )
            .onAreaChange({ _: Area, area: Area =>
                renderSizeH = px2vp(Length(area.height, unitType: LengthType.px))
                                    .getOrThrow()
                                    .value
                renderSizeW = px2vp(Length(area.width, unitType: LengthType.px))
                                    .getOrThrow()
                                    .value
                })
            .offset(
                x: getOffset().x,
                    y: getOffset().y
                )
                } else if (!getContent().isEmpty() || props.dot) {
                Text(if (props.dot) { "" } else { getContent() })
            .width<Length>(if (props.dot) { getBadgeSizeConstant(SilkBadgeSizeKey.BADGE_DOT_SIZE)} else { Option.None})
            .height<Length>(if (props.dot) { getBadgeSizeConstant(SilkBadgeSizeKey.BADGE_DOT_SIZE)} else { Option.None})
                .fontWeight(props.fontWeight)
                .fontColor(ResourceColorToColor(props.color))
                .fontSize(props.fontSize)
                .textAlign(TextAlign.Center)
                .lineHeight(getLineHeight())
                .padding(
                    top: getPadding().top,
                    right: getPadding().right,
                    bottom: getPadding().bottom,
                    left: getPadding().left
                )
                .backgroundColor(ResourceColorToColor(props.backgroundColor))
                .borderRadius(props.radius)
                .constraintSize(
                minWidth: if (props.dot) { 0.vp } else { getBadgeSizeConstant(SilkBadgeSizeKey.BADGE_SIZE)}
            )
            .onAreaChange({ _: Area, area: Area =>
                renderSizeH = px2vp(Length(area.height, unitType: LengthType.px))
                                    .getOrThrow()
                                    .value
                renderSizeW = px2vp(Length(area.width, unitType: LengthType.px))
                                    .getOrThrow()
                                    .value
                })
            .offset(
                x: getOffset().x,
                    y: getOffset().y
                )
                }


        }
    }

    /**
     * 获取徽标显示内容
     *
     * 根据配置选项处理徽标内容，包括最大值限制、小红点模式等
     *
     * @return 处理后的徽标显示内容
     */
    private func getContent () {
        // 如果内容为空，返回空字符串
        if (props.content.isEmpty()) {
            return String.empty
        }

        // 尝试将内容转换为数字
        let result = StringToInt64(props.content)

        // 如果不是数字，直接返回原内容
        if (result.isNone()) {
            return props.content
        }

        // 如果没有设置最大值，直接返回数字
        if (props.max.isNone()) {
            return result.getOrThrow().toString()
        }

        // 如果数字超过最大值，显示最大值+
        if (result.getOrThrow() > props.max.getOrThrow()) {
            return props.max.getOrThrow().toString() + "+"
        }

        // 如果数字为0且设置为show_zero为false
        if (result.getOrThrow() == 0 && !props.show_zero) {
                return String.empty
        }

        // 返回数字字符串
        return result.getOrThrow().toString()
    }

    /**
     * 获取徽标内边距
     *
     * 根据徽标内容和小红点模式决定使用的内边距
     *
     * @return 徽标内边距配置
     */
    private func getPadding (): SilkUIPaddingOptions {
        // 如果内容为空且为小红点模式，使用零内边距
        if (getContent().isEmpty() && props.dot) {
            return SilkUIPaddingOptions(
                top: 0.vp,
                right: 0.vp,
                bottom: 0.vp,
                left: 0.vp
            )
        } else {
            // 否则使用配置的内边距
            return props.padding
        }
    }
    /**
     * 获取徽标偏移量
     *
     * 根据徽标位置计算偏移量
     *
     * @return 徽标偏移量
     */
    private func getOffset (): SilkBadgeOffset {
        match (props.position) {
        	case SilkBadgePosition.TOP_RIGHT => SilkBadgeOffset(x: renderSizeW / 2.0, y: -renderSizeH / 2.0)
            case SilkBadgePosition.TOP_LEFT => SilkBadgeOffset(x: -renderSizeW / 2.0, y: -renderSizeH / 2.0)
            case SilkBadgePosition.BOTTOM_RIGHT => SilkBadgeOffset(x: renderSizeW / 2.0, y: renderSizeH / 2.0)
            case SilkBadgePosition.BOTTOM_LEFT => SilkBadgeOffset(x: -renderSizeW / 2.0, y: renderSizeH / 2.0)
        }
    }

    /**
     * 获取徽标文本行高
     *
     * 根据字体大小计算行高
     *
     * @return 徽标文本行高
     */
    private func getLineHeight () {
        let lineHeight = getBadgeIntConstant(SilkBadgeIntKey.LINE_HEIGHT)
        return Length(lineHeight * props.fontSize.value , unitType: props.fontSize.unitType)
    }
}