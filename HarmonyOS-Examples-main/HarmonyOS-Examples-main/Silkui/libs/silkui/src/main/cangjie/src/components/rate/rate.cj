/**
 * Created on 2025/5/15
 *
 * SilkRate 评分组件
 *
 * 评分组件，用于对事物进行评级操作，常用于评价场景。
 *
 * ## 基础用法
 * ```
 * SilkRate(props: SilkRateOptions())
 * ```
 *
 * ## 自定义图标
 * ```
 * SilkRate(props: SilkRateOptions(
 *   icon: "like",
 *   voidIcon: "like-o"
 * ))
 * ```
 *
 * ## 自定义样式
 * ```
 * SilkRate(props: SilkRateOptions(
 *   color: @r(app.color.primary_color),
 *   size: 25.vp
 * ))
 * ```
 *
 * ## 半星评分
 * ```
 * SilkRate(props: SilkRateOptions(
 *   value: 2.5,
 *   allowHalf: true
 * ))
 * ```
 *
 * ## 只读状态
 * ```
 * SilkRate(props: SilkRateOptions(
 *   value: 3.0,
 *   readonly: true
 * ))
 * ```
 *
 * ## 双向绑定
 * ```
 * @State
 * var score: Float64 = 3.0
 *
 * SilkRate(
 *   props: SilkRateOptions(),
 *   value: $score,
 *   change: {value => score = value}
 * )
 * ```
 *
 * @module silkui/components/rate
 */
package silkui.components.rate

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.state_macro_manage.*
import cj_res_silkui.*
import silkui.components.icon.SilkIcon
import silkui.ResourceColor
import silkui.ResourceStr
import silkui.utils.ResourceStrToString
import silkui.utils.ResourceColorToColor
import silkui.constants.getRateIntConstant
import silkui.constants.SilkRateIntKey
import std.collection.ArrayList


/**
 * 评分组件
 *
 * 用于对事物进行评级操作，常用于评价场景
 * 支持自定义图标、颜色、尺寸、半星、只读和禁用状态等功能
 */
@Component
public class SilkRate {
    /**
     * 评分配置选项
     */
    @Prop
    var props: SilkRateOptions

    /**
     * 当前评分值
     */
    @Link
    @Watch[valueChange]
    var value: Float64

    @State
    var __list: ObservedArrayList<Float64> = ObservedArrayList<Float64>()
    /**
     * 评分变化事件回调函数
     *
     * @param value 当前评分值
     * @param fromInit 是否来自初始化，默认为false
     */
    public var change: (value: Float64) -> Unit = {_ =>}

    /**
     * 组件即将出现时的生命周期方法
     */
    protected override func aboutToAppear() {
        updateStarList(fromInit: true)
    }

    /**
     * 更新星星列表状态
     *
     * @param fromInit 是否来自初始化，默认为false
     */
    private func updateStarList(fromInit!: Bool = false) {
        if (props.allowHalf) {
            for (i in 0..props.count) {
                if (value >= Float64(i)) {
                    if (value < Float64(i) + 1.0) {
                        if (__list.size < props.count) {
                            __list.append(value - Float64(Int64(value)))
                        } else {
                            __list[i] = value - Float64(Int64(value))
                        }
                    } else {
                        if (__list.size < props.count) {
                            __list.append(1.0)
                        } else {
                            __list[i] = 1.0
                        }
                    }
                } else {
                    if (__list.size < props.count) {
                        __list.append(0.0)
                    } else {
                        __list[i] = 0.0
                    }
                }
            }
        } else {
            for (i in 0..props.count) {
                if (value >= Float64(i) + 1.0) {
                    if (__list.size < props.count) {
                        __list.append(1.0)
                    } else {
                        __list[i] = 1.0
                    }
                } else {
                    if (__list.size < props.count) {
                        __list.append(0.0)
                    } else {
                        __list[i] = 0.0
                    }
                }
            }
        }

        // 调用变化回调，如果不是来自初始化则触发
        if (!fromInit) {
            change(value)
        }
    }

    /**
     * 处理评分点击事件
     *
     * @param index 点击的星星索引
     * @param v 当前值
     * @param e 点击事件
     */
    private func handleClick(index: Int64, v: Float64, e: ClickEvent) {
        if (props.disabled || props.readonly) {
            return
        }

        // 判断是否允许半选
        if(props.allowHalf) {
            // 判断点击位置到元素左侧距离是否超过一半宽度
            let point = e.x
            let w = e.target.getOrThrow().area.width

            // 处理清除功能
            if (props.clearable && index == 0) {
                if ((point <= w / 2.0 && value == 0.5) || (point > w / 2.0 && value == 1.0)) {
                    value = 0.0
                    return
                }
            }

            if (point > w / 2.0) {
                value = Float64(index + 1)
            } else {
                value = Float64(index) + 0.5
            }

        } else {
            // 处理清除功能
            if (props.clearable && value == Float64(index + 1) && index == 0) {
                value = 0.0
                return
            }
            value = Float64(index + 1)
        }
        // valueChange 会通过 @Watch 自动触发，更新 __list
    }

    /**
     * 获取星星的图标宽度
     *
     * @param value 星星值
     * @return 星星图标宽度
     */
    private func getIconWidth(value: Float64): Length {
        if (value == 0.0) {
            return Length(0, unitType: LengthType.vp)
        }

        // 获取小数部分数值
        let fraction: Float64 = value - Float64(Int64(value))

        if (fraction == 0.0) {
            return Length(100.0, unitType: LengthType.percent)
        }

        return Length(fraction * 100.0, unitType: LengthType.percent)
    }

    /**
     * 获取星星的颜色
     *
     * @param value 星星值
     * @return 星星颜色
     */
    private func getColor(value: Float64): ResourceColor {
        if (props.disabled) {
            return props.disabledColor
        }
        return props.color
    }

    /**
     * 获取星星的外边距
     *
     * @param index 星星索引
     * @return 星星右侧外边距
     */
    private func getItemMargin(index: Int64): Length {
        if (index < props.count - 1) {
            return props.gutter
        } else {
            return Length(0, unitType: LengthType.vp)
        }
    }

    /**
     * 值变化监听函数
     */
    private func valueChange() {
        updateStarList()
    }

    @State
    var itemWidth: Float64 = 0.0

    private var orginValue: Float64 = 0.0

    /**
     * 触摸开始事件处理
     */
    private func touchStart(e: TouchEvent) {
        orginValue = value
    }

    /**
     * 触摸移动事件处理
     */
    private func touchMove(e: TouchEvent) {
        let touch = e.touches[0]
        let offsetX = touch.x
        let rowWidth = e.target.area.width

        // 超出范围不计算
        if (offsetX < 0.0 || offsetX > rowWidth) {
            return
        }

        let gutter = (rowWidth - Float64(props.count) * itemWidth) / Float64(props.count - 1)
        let index = Int64((offsetX / (itemWidth + gutter)))

        // 防止索引越界
        if (index >= props.count) {
            return
        }

        if(props.allowHalf) {
            // 判断点击位置到元素左侧距离是否超过一半宽度
            let point = if (index == 0) { offsetX } else { offsetX - Float64(index) * (itemWidth + gutter) }

            if (point > itemWidth / 2.0) {
                value = Float64(index + 1)
            } else {
                value = Float64(index) + 0.5
            }
        } else {
            value = Float64(index + 1)
        }
    }

    /**
     * 触摸结束事件处理
     */
    private func touchEnd(e: TouchEvent) {
        // 触摸结束时触发回调
        change(value)
    }

    /**
     * 触摸重置
     */
    private func touchReset() {
        value = orginValue
    }

    /**
     * 构建组件UI
     */
    public func build() {
        Row() {
            ForEach(
                __list,
                itemGeneratorFunc: {
                    value: Float64, index: Int64 =>
                        Stack(Alignment.Start) {
                            SilkIcon(
                                name: props.voidIcon,
                                fontSize: props.size,
                                lineHeight: props.size,
                                fontColor: props.voidColor
                            )
                            Column() {
                                SilkIcon(
                                    name: props.icon,
                                    fontSize: props.size,
                                    lineHeight: props.size,
                                    fontColor: getColor(value)
                                )
                            }
                            .width(getIconWidth(value))
                            .height(100.percent)
                            .clip(true)
                        }
                        .width(props.size)
                        .height(props.size)
                        .onClick({e => handleClick(index,value, e)})
                        .margin(right: getItemMargin(index))
                        .onAreaChange{
                            _: Area, area: Area =>
                                itemWidth = px2vp(Length(area.width, unitType: LengthType.px)).getOrThrow().value
                        }
                }
            )
        }
        // 监听手指滑动事件
        .onTouch {
            e: TouchEvent =>
                if (props.disabled || props.readonly) {
                    return
                }
                // 多指不触发
                if(e.touches.size != 1) {
                    return
                }

                match (e.eventType) {
                    case TouchType.Down => touchStart(e)
                    case TouchType.Move => touchMove(e)
                    case TouchType.Up => touchEnd(e)
                    case _ => touchReset()
                }
        }
    }
}

