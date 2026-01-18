/**
 * Created on 2025/4/25
 *
 * SilkLoading 加载组件
 *
 * 加载组件用于展示加载状态，提示用户等待，支持多种样式。
 *
 * ## 基础用法
 * ```
 * SilkLoading(loadingType: SilkLoadingType.CIRCULAR)
 * ```
 *
 * ## 自定义颜色
 * ```
 * SilkLoading(loadingType: SilkLoadingType.CIRCULAR, color: Color(0, 0, 255, alpha: 1))
 * ```
 *
 * ## 加载类型
 * 支持 `CIRCULAR`（环形）和 `SPINNER`（菊花）两种类型。
 * ```
 * SilkLoading(loadingType: SilkLoadingType.SPINNER)
 * ```
 *
 * ## 加载文案
 * ```
 * SilkLoading(loadingType: SilkLoadingType.CIRCULAR, text: "加载中...")
 * ```
 *
 * ## 垂直排列
 * ```
 * SilkLoading(loadingType: SilkLoadingType.CIRCULAR, text: "加载中...", vertical: true)
 * ```
 *
 * @module silkui/components/loading
 */
package silkui.components.loading

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.state_macro_manage.*
import std.math.ceil
import cj_res_silkui.*
import silkui.utils.ValueAnimator
import silkui.utils.ICurve
import silkui.utils.Curves
import ohos.animator.AnimatorFill
import ohos.prompt_action.PromptAction
import silkui.ResourceColor
import silkui.ResourceStr
import silkui.utils.ResourceColorToColor
import silkui.utils.ResourceStrToString
import silkui.constants.SilkLoadingSizeKey
import silkui.constants.SilkLoadingColorKey
import silkui.constants.getLoadingSizeConstant
import silkui.constants.getLoadingColorConstant

/**
 * 加载组件
 *
 * 用于展示加载状态，提示用户等待，支持多种样式
 */
@Component
public class SilkLoading {
    /**
     * 加载图标类型
     * 默认为环形加载图标
     */
    public var loadingType: SilkLoadingType = SilkLoadingType.CIRCULAR

    /**
     * 加载图标颜色
     * 默认使用预设颜色
     */
    public var color: ResourceColor = getLoadingColorConstant(SilkLoadingColorKey.LOADING_SPINNER_COLOR)

    /**
     * 自定义图标
     * 默认为None
     */
    public var icon: ?ResourceStr = Option.None

    /**
     * 加载图标大小
     * 默认使用预设大小
     */
    public var size: Length = getLoadingSizeConstant(SilkLoadingSizeKey.LOADING_SPINNER_SIZE)

    /**
     * 文字大小
     * 默认使用预设大小
     */
    public var textSize: Length = getLoadingSizeConstant(SilkLoadingSizeKey.LOADING_TEXT_FONT_SIZE)

    /**
     * 加载文案
     * 默认为空字符串
     */
    public var text: ResourceStr = String.empty

    /**
     * 文字颜色
     * 默认使用预设颜色
     */
    public var textColor: ?ResourceColor = getLoadingColorConstant(SilkLoadingColorKey.LOADING_TEXT_COLOR)

    /**
     * 是否垂直排列图标和文字
     * 默认为false（水平排列）
     */
    public var vertical: Bool = false

    /**
     * 实际使用的文字颜色
     * 根据color和textColor计算得出
     */
    private var fontColorValue: ?ResourceColor = Option.None
    /**
     * 环形加载图标的虚线数组
     * 用于控制环形加载图标的虚线效果
     */
    @State
    var dasharray: Array<Float64> = [1.0, 200.0]

    /**
     * 环形加载图标的虚线偏移量
     * 用于控制环形加载图标的虚线动画
     */
    @State
    var dashOffset: Float64 = 0.0

    /**
     * 环形加载图标的旋转角度
     * 用于控制环形加载图标的旋转动画
     */
    @State
    var angle: Float32 = 0.0

    /**
     * 菊花加载图标的旋转角度
     * 用于控制菊花加载图标的旋转动画
     */
    @State
    var angleSpinner: Float32 = 0.0

    /**
     * 加载图标的宽度
     * 用于计算菊花加载图标的中心点
     */
    @State
    var loadWidth: Float64 = 0.0

    /**
     * 环形加载图标的虚线动画控制器
     */
    private var animator: ?ValueAnimator = Option.None

    /**
     * 环形加载图标的旋转动画控制器
     */
    private var animatorCircle: ?ValueAnimator = Option.None

    /**
     * 菊花加载图标的旋转动画控制器
     */
    private var animatorSpinner: ?ValueAnimator = Option.None
    /**
     * 组件即将出现时的生命周期方法
     *
     * 初始化文字颜色和动画控制器
     */
    protected override func aboutToAppear() {
        // 确定文字颜色
        if (color is CJResource && (color as CJResource).getOrThrow().id != @r(app.color.gray_5).id) {
            // 如果图标颜色不是默认灰色，使用图标颜色作为文字颜色
            fontColorValue = color
        } else if (textColor.isSome()) {
            // 如果指定了文字颜色，使用指定的文字颜色
            fontColorValue = textColor.getOrThrow()
        } else {
            // 否则使用默认文字颜色
            fontColorValue = @r(app.color.text_color_2)
        }

        // 根据加载图标类型初始化不同的动画控制器
        if (loadingType == SilkLoadingType.CIRCULAR) {
            // 环形加载图标需要两个动画控制器：虚线动画和旋转动画
            animator = Some(ValueAnimator())
            animator?.duration = 1500
            animator?.loops = -1
            animator?.onUpdate = {
                value => update(value)
            }
            animatorCircle = ValueAnimator()
            animatorCircle?.duration = 2000
            animatorCircle?.onUpdate = {
                value => updateColumn(value)
            }
        } else {
            // 菊花加载图标只需要一个旋转动画控制器
            animatorSpinner = ValueAnimator()
            animatorSpinner?.startValue = 0.0
            animatorSpinner?.endValue = 12.0
            animatorSpinner?.duration = 800
            animatorSpinner?.easing = "steps(12, end)"
            animatorSpinner?.onUpdate = {
                value => updateSpinner(value)
            }
        }
    }
    /**
     * 缓动曲线
     * 用于环形加载图标的动画效果
     */
    private var icu: ICurve = Curves.initCurve(Curve.EaseInOut)

    /**
     * 更新环形加载图标的虚线动画
     *
     * @param value 动画进度值（0-1）
     */
    private func update(value: Float64) {
        if (value * 1500.0 < 750.0) {
            // 动画第一阶段：虚线长度增加
            dasharray = [icu.interpolate(value) * 89.0 * 2.0 + 1.0, 200.0 - icu.interpolate(value) * 50.0 * 2.0]
            dashOffset = -icu.interpolate(value * 2.0) * 40.0
        } else if (value * 1500.0 < 1500.0) {
            // 动画第二阶段：虚线偏移
            dasharray = [90.0, 150.0]
            dashOffset = -40.0 - icu.interpolate(value - 1.0 / 2.0) * 80.0 * 2.0
        } else {
            // 动画结束，重置状态
            dasharray = [1.0, 200.0]
            dashOffset = 0.0
        }
    }

    /**
     * 更新环形加载图标的旋转动画
     *
     * @param value 动画进度值（0-1）
     */
    private func updateColumn(value: Float64) {
        // 根据动画进度计算旋转角度（0-360度）
        angle = Float32(value * 360.0)
    }

    /**
     * 更新菊花加载图标的旋转动画
     *
     * @param value 动画进度值（0-12）
     */
    private func updateSpinner(value: Float64) {
        // 根据动画进度计算旋转角度（每步30度，总共12步）
        angleSpinner = Float32(ceil(value) * 30.0)
    }

    /**
     * 组件即将消失时的生命周期方法
     *
     * 停止所有动画并释放资源
     */
    protected override func aboutToDisappear() {
        // 停止环形加载图标的虚线动画
        animator?.stop()
        animator = Option.None

        // 停止环形加载图标的旋转动画
        animatorCircle?.stop()
        animatorCircle = Option.None

        // 停止菊花加载图标的旋转动画
        animatorSpinner?.stop()
        animatorSpinner = Option.None
    }

    func build() {
        if (vertical) {
            Column() {
                if (loadingType == SilkLoadingType.CIRCULAR) {
                    Column() {
                        if (icon.isSome()) {
                            if (icon.getOrThrow() is String) {
                                Image(ResourceStrToString(icon.getOrThrow())).width(100.percent).height(100.percent).fillColor(ResourceColorToColor(color))
                            } else if (icon.getOrThrow() is CJResource) {
                                Image((icon.getOrThrow() as CJResource).getOrThrow()).width(100.percent).height(100.percent).fillColor(ResourceColorToColor(color))
                            }
                        } else {
                                Circle()
                                .width(100.percent)
                                .height(100.percent)
                                .fill(Color.TRANSPARENT)
                                .strokeWidth(3)
                                .strokeLineCap(LineCapStyle.Round)
                                .stroke(ResourceColorToColor(color))
                                .strokeDashArray(dasharray)
                                .strokeDashOffset(dashOffset)
                                .onAppear({=> animator?.start()})
                        }
                    }
                        .width(size)
                        .aspectRatio(1)
                        .rotate(angle)
                        .onAppear({=> animatorCircle?.start()})
                } else {
                    Stack(Alignment.Top) {
                        if (icon.isSome()) {
                            if (icon.getOrThrow() is String) {
                                Image(ResourceStrToString(icon.getOrThrow())).width(100.percent).height(100.percent).fillColor(ResourceColorToColor(color))
                            } else if (icon.getOrThrow() is CJResource) {
                                Image((icon.getOrThrow() as CJResource).getOrThrow()).width(100.percent).height(100.percent).fillColor(ResourceColorToColor(color))
                            }

                        } else {
                            ForEach(
                                Array<Int8>(12, item: 0),
                                itemGeneratorFunc: {
                                    _: Int8, index: Int64 =>
                                        Row()
                                        .width(2)
                                        .height(25.percent)
                                        .rotate(
                                            x: 0.0,
                                            y: 0.0,
                                            z: 1.0,
                                            angle: Float32(index * 30),
                                            centerX: 50.percent,
                                            centerY: (loadWidth / 2.0).vp
                                        )
                                        .backgroundColor(ResourceColorToColor(color))
                                        .opacity(1.0 - 0.0625 * Float64(index))
                                }
                            )
                        }
                    }
                        .width(size)
                        .aspectRatio(1)
                        .rotate(angleSpinner)
                        .onAreaChange(
                            {
                                _: Area, area: Area =>
                                // TODO 此处需注意 文档显示area.width单位是vp 实际为px 所以此处进行转换。如果官网调整 这里徐亚调整
                                loadWidth = px2vp(Length(area.width, unitType: LengthType.px))
                                    .getOrThrow()
                                    .value
                            })
                        .onAppear({=> animatorSpinner?.start()})
                }
                if (!ResourceStrToString(text).isEmpty() && ResourceStrToString(text) != "") {
                        Text(ResourceStrToString(text))
                        .fontSize(textSize)
                        .fontColor(ResourceColorToColor(fontColorValue ?? @r(app.color.text_color_2)))
                        .margin(
                            left: if (vertical) {
                                0
                            } else {
                                8
                            },
                            top: if (vertical) {
                                8
                            } else {
                                0
                            }
                        )

                }
            }
        } else {
            Row() {
                if (loadingType == SilkLoadingType.CIRCULAR) {
                    Column() {
                        if (icon.isSome()) {
                            if (icon.getOrThrow() is String) {
                                Image(ResourceStrToString(icon.getOrThrow())).width(100.percent).height(100.percent).fillColor(ResourceColorToColor(color))
                            } else if (icon.getOrThrow() is CJResource) {
                                Image((icon.getOrThrow() as CJResource).getOrThrow()).width(100.percent).height(100.percent).fillColor(ResourceColorToColor(color))
                            }

                        } else {
                                Circle()
                                .width(100.percent)
                                .height(100.percent)
                                .fill(Color.TRANSPARENT)
                                .strokeWidth(3)
                                .strokeLineCap(LineCapStyle.Round)
                                .stroke(ResourceColorToColor(color))
                                .strokeDashArray(dasharray)
                                .strokeDashOffset(dashOffset)
                                .onAppear({=> animator?.start()})

                        }
                    }
                        .width(size)
                        .aspectRatio(1)
                        .rotate(angle)
                        .onAppear({=> animatorCircle?.start()})
                } else {
                    Stack(Alignment.Top) {
                        if (icon.isSome()) {
                            if (icon.getOrThrow() is String) {
                                Image(ResourceStrToString(icon.getOrThrow())).width(100.percent).height(100.percent).fillColor(ResourceColorToColor(color))
                            } else if (icon.getOrThrow() is CJResource) {
                                Image((icon.getOrThrow() as CJResource).getOrThrow()).width(100.percent).height(100.percent).fillColor(ResourceColorToColor(color))
                            }

                        } else {
                            ForEach(
                                Array<Int8>(12, item: 0),
                                itemGeneratorFunc: {
                                    _: Int8, index: Int64 =>
                                        Row()
                                        .width(2)
                                        .height(25.percent)
                                        .rotate(
                                            x: 0.0,
                                            y: 0.0,
                                            z: 1.0,
                                            angle: Float32(index * 30),
                                            centerX: 50.percent,
                                            centerY: (loadWidth / 2.0).vp
                                        )
                                        .backgroundColor(ResourceColorToColor(color))
                                        .opacity(1.0 - 0.0625 * Float64(index))
                                    }

                            )
                        }
                    }
                        .width(size)
                        .aspectRatio(1)
                        .rotate(angleSpinner)
                        .onAreaChange(
                            {
                                _: Area, area: Area =>
                                // TODO 此处需注意 文档显示area.width单位是vp 实际为px 所以此处进行转换。如果官网调整 这里徐亚调整
                                loadWidth = px2vp(Length(area.width, unitType: LengthType.px))
                                    .getOrThrow()
                                    .value
                            })
                        .onAppear({=> animatorSpinner?.start()})
                }
                if (!ResourceStrToString(text).isEmpty() && ResourceStrToString(text).size > 0) {
                        Text(ResourceStrToString(text))
                        .fontSize(textSize)
                        .fontColor(ResourceColorToColor(fontColorValue ?? @r(app.color.text_color_2)))
                        .margin(
                            left: if (vertical) {
                                0
                            } else {
                                8
                            },
                            top: if (vertical) {
                                8
                            } else {
                                0
                            }
                        )
                }
            }
        }
    }
}
