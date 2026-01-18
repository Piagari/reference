/**
 * Created on 2025/7/17
 *
 * SilkPicker 选择器组件
 *
 * 选择器组件用于从一组选项中选择一个或多个值，支持单列和多列选择。
 * 参考 Vant Picker 组件设计，提供丰富的配置选项和交互功能。
 *
 * ## 基础用法
 * ```
 * let options = [
 *     SilkPickerOption(text: "选项1", value: "1"),
 *     SilkPickerOption(text: "选项2", value: "2"),
 *     SilkPickerOption(text: "选项3", value: "3")
 * ]
 * let columns = [SilkPickerColumn(options: options)]
 * SilkPicker(columns: columns)
 * ```
 *
 * ## 多列选择
 * ```
 * let columns = [
 *     SilkPickerColumn(options: cityOptions, title: "城市"),
 *     SilkPickerColumn(options: areaOptions, title: "区域")
 * ]
 * SilkPicker(columns: columns)
 * ```
 *
 * ## 自定义配置
 * ```
 * let options = SilkPickerOptions(
 *     title: "请选择",
 *     confirmButtonText: "确定",
 *     cancelButtonText: "取消"
 * )
 * SilkPicker(columns: columns, options: options)
 *     .confirm { values, indexes =>
 *         // 处理确认事件
 *     }
 *     .cancel {
 *         // 处理取消事件
 *     }
 *     .change { values, indexes, columnIndex =>
 *         // 处理选项变化事件
 *     }
 * ```
 *
 * @module silkui/components/picker
 */
package silkui.components.picker

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.state_macro_manage.*
import cj_res_silkui.*
import silkui.constants.getPickerGradientConstant
import silkui.constants.SilkPickerGradientKey
import silkui.constants.getPickerColorConstant
import silkui.constants.SilkPickerColorKey
import silkui.constants.getPickerSizeConstant
import silkui.constants.SilkPickerSizeKey
import silkui.ResourceStr
import std.collection.ArrayList
import silkui.utils.ResourceStrToString
import silkui.utils.ResourceColorToColor
import silkui.utils.SilkUILog
import std.time.DateTime
import std.math.abs
import std.math.max
import std.math.min
import std.math.round
import ohos.prompt_action.PromptAction
import std.collection.map
import std.collection.collectArray
import silkui.components.loading.SilkLoading
import silkui.types.DefaultBuilder

/**
 * 触摸状态数据结构
 * 1:1复刻Vant的触摸状态管理
 */
public class PickerTouchState {
    public var startY: Float64 = 0.0
    public var currentY: Float64 = 0.0
    public var startTime: Int64 = 0
    public var isDragging: Bool = false
    public var velocity: Float64 = 0.0
    public var lastMoveTime: Int64 = 0
    public var lastMoveY: Float64 = 0.0

    // Vant风格的滚动状态
    public var offset: Float64 = 0.0 // 当前滚动偏移量
    public var duration: Int32 = 0 // 动画持续时间
    public var isAnimating: Bool = false // 是否正在动画
    public var momentumStartY: Float64 = 0.0 // 惯性滚动起始位置
    public var momentumTimeStamp: Int64 = 0 // 惯性滚动时间戳
}

/**
 * SilkPicker 选择器组件
 *
 * 提供单列或多列选择功能，支持自定义样式和交互回调
 */
@Component
public class SilkPicker {
    /**
     * 选择器列配置
     */
    @State
    var columns: ObservedArrayList<SilkPickerColumn> = ObservedArrayList<SilkPickerColumn>()

    /**
     * 选择器配置选项
     */
    @Prop
    var options: SilkPickerOptions

    @BuilderParam
    var empty: () -> Unit = DefaultBuilder
    /**
     * 确认按钮点击回调
     *
     * @param values 当前选中的值数组
     * @param indexes 当前选中的索引数组
     */
    public var confirm: (values: Array<String>, indexs: Array<Int32>) -> Unit = {_, _ =>}

    /**
     * 取消按钮点击回调
     */
    public var cancel: () -> Unit = {=>}

    /**
     * 选项改变回调
     *
     * @param values 当前选中的值数组
     * @param indexes 当前选中的索引数组
     * @param columnIndex 改变的列索引
     */
    public var change: (values: Array<String>, indexes: Array<Int32>, columnIndex: Int64) -> Unit = {_, _, _ =>}

    /**
     * 当前选中的索引数组
     */
    @State
    var selectedIndexes: ObservedArrayList<Int32> = ObservedArrayList<Int32>()

    @State
    var selectedValues: ObservedArrayList<ResourceStr> = ObservedArrayList<ResourceStr>()
    /**
     * 每列的3D变换偏移量（基于选项索引）
     */
    @State
    var transformOffsets: ObservedArrayList<Float64> = ObservedArrayList<Float64>()

    /**
     * 触摸状态管理
     */
    @State
    var touchStates: ObservedArrayList<PickerTouchState> = ObservedArrayList<PickerTouchState>()

    /**
     * 动画控制器数组，用于控制每列的动画
     */
    @State
    var animationControllers: ObservedArrayList<Bool> = ObservedArrayList<Bool>()

    /**
     * 每列的触摸容器引用，用于处理触摸事件
     */
    @State
    var touchContainerRefs: ObservedArrayList<Bool> = ObservedArrayList<Bool>()

    /**
     * 每列当前的实际偏移位置（用于动画和触摸计算）
     */
    @State
    var currentOffsets: ObservedArrayList<Float64> = ObservedArrayList<Float64>()

    /**
     * 是否为级联模式
     * 根据初始数据结构自动判断
     */
    @State
    var isCascadeMode: Bool = false
    /**
     * 创建选择器组件
     *
     * @param columns 选择器列配置
     * @param options 选择器配置选项，默认为空配置
     */
    protected override func aboutToAppear() {
        // 检测是否为级联模式
        this.detectCascadeMode()

        // 处理级联选择，构建完整的columns结构（仅在级联模式下）
        if (isCascadeMode) {
            this.buildCascadeColumns()
        } else {
            // 非级联模式：如果没有预设选中值，为多列选择器设置默认选中值
            if (selectedValues.size == 0 && columns.size > 1) {
                this.buildDefaultMultiColumnValues()
            }
        }

        // 初始化选中索引
        this.initializeSelectedIndexes()

        // 初始化变换状态和触摸状态
        // 先清空现有状态数组
        transformOffsets = ObservedArrayList<Float64>()
        touchStates = ObservedArrayList<PickerTouchState>()
        animationControllers = ObservedArrayList<Bool>()
        touchContainerRefs = ObservedArrayList<Bool>()
        currentOffsets = ObservedArrayList<Float64>()

        // 为每列初始化状态
        for (i in 0..columns.size) {
            // 根据选中索引计算正确的变换偏移量
            let selectedIndex = if (i < selectedIndexes.size) {
                Int64(selectedIndexes[i])
            } else {
                0
            }
            let offset = Float64(selectedIndex) * options.itemHeight.value
            
            transformOffsets.append(offset)
            
            // 创建触摸状态并设置正确的偏移量
            let touchState = PickerTouchState()
            touchState.offset = offset
            touchStates.append(touchState)
            
            animationControllers.append(false)
            touchContainerRefs.append(false)
            currentOffsets.append(offset)
        }
    }

    /**
     * 检测是否为级联模式
     * 通过检查第一列是否有children来判断
     */
    private func detectCascadeMode() {
        isCascadeMode = false

        // 检查第一列是否存在且有选项
        if (columns.size > 0 && columns[0].options.size > 0) {
            // 检查第一列中是否有任何选项包含children
            for (option in columns[0].options) {
                if (option.children.size > 0) {
                    isCascadeMode = true
                    break
                }
            }
        }

        // 如果有多个预设值，也可能是级联模式
        if (!isCascadeMode && selectedValues.size > 1 && columns.size == 1) {
            isCascadeMode = true
        }

        SilkUILog.info(
            "Picker模式检测: isCascadeMode = ${isCascadeMode}, columns.size = ${columns.size}, selectedValues.size = ${selectedValues.size}"
        )
    }

    /**
     * 构建默认的级联列结构
     * 当没有预设选中值时，基于每层第一个选项构建完整的级联结构
     */
    private func buildDefaultCascadeColumns() {
        if (columns.size == 0 || columns[0].options.size == 0) {
            SilkUILog.info("buildDefaultCascadeColumns: 第一列为空，无法构建级联")
            return
        }

        SilkUILog.info("构建默认级联结构，第一列选项数量: ${columns[0].options.size}")

        let newColumns = ArrayList<SilkPickerColumn>()
        newColumns.append(columns[0]) // 保留第一列

        var currentOptions = columns[0].options
        var levelIndex = 0

        // 自动构建后续级联层级（最多支持5层，避免无限递归）
        while (levelIndex < 5 && currentOptions.size > 0) {
            // 默认选择第一个选项
            let firstOption = currentOptions[0]

            SilkUILog.info(
                "级联层级${levelIndex}: 选择 '${ResourceStrToString(firstOption.text)}', children数量: ${firstOption.children.size}"
            )

            if (firstOption.children.size > 0) {
                // 构建下一级列
                let nextColumn = SilkPickerColumn(firstOption.children)
                newColumns.append(nextColumn)
                currentOptions = firstOption.children
                levelIndex += 1
            } else {
                // 没有更多子级，停止构建
                break
            }
        }

        SilkUILog.info("默认级联构建完成: 总列数 = ${newColumns.size}")

        // 更新columns数组 - 响应式更新
        columns.clear()
        for (column in newColumns) {
            columns.append(column)
        }

        SilkUILog.info("默认级联columns更新完成：新数组长度=${columns.size}")

        // 构建对应的默认选中值数组
        this.buildDefaultSelectedValues()
    }

    /**
     * 构建默认选中值数组
     * 基于当前columns结构，每列都选择第一个选项
     */
    private func buildDefaultSelectedValues() {
        let defaultValues = ArrayList<ResourceStr>()

        // 简化逻辑：直接遍历每一列，选择第一个选项
        for (i in 0..columns.size) {
            if (columns[i].options.size > 0) {
                let firstOption = columns[i].options[0]
                defaultValues.append(firstOption.value)
                SilkUILog.info("默认选中值[${i}]: ${ResourceStrToString(firstOption.value)}")
            }
        }

        // 更新selectedValues
        selectedValues = ObservedArrayList(defaultValues.toArray())

        SilkUILog.info("默认选中值构建完成: ${selectedValues.size} 个值")
    }

    /**
     * 为非级联的多列选择器构建默认选中值
     * 每列都选择第一个选项
     */
    private func buildDefaultMultiColumnValues() {
        let defaultValues = ArrayList<ResourceStr>()

        for (i in 0..columns.size) {
            if (columns[i].options.size > 0) {
                let firstOption = columns[i].options[0]
                defaultValues.append(firstOption.value)
                SilkUILog.info("多列默认选中值[${i}]: ${ResourceStrToString(firstOption.value)}")
            }
        }

        // 更新selectedValues
        selectedValues = ObservedArrayList(defaultValues.toArray())

        SilkUILog.info("多列默认选中值构建完成: ${selectedValues.size} 个值")
    }

    /**
     * 构建级联列结构
     * 根据选中值动态构建后续的级联列
     */
    private func buildCascadeColumns() {
        // 如果没有预设选中值，需要基于默认选择构建完整的级联结构
        if (selectedValues.size == 0) {
            this.buildDefaultCascadeColumns()
            return
        }

        if (selectedValues.size <= 1) {
            // 没有级联或只有一列，保持原有columns
            return
        }

        // 重新构建columns以支持级联
        let newColumns = ArrayList<SilkPickerColumn>()
        newColumns.append(columns[0]) // 第一列保持不变

        var currentOptions = columns[0].options

        // 处理级联关系，构建后续列
        for (levelIndex in 1..selectedValues.size) {
            if (levelIndex >= selectedValues.size) {
                break
            }

            // 获取上一级选中的值
            let previousValue = ResourceStrToString(selectedValues[levelIndex - 1])

            // 在当前选项中找到匹配的项
            var foundOption: ?SilkPickerOption = Option.None
            for (option in currentOptions) {
                if (ResourceStrToString(option.value) == previousValue) {
                    foundOption = Option.Some(option)
                    break
                }
            }

            // 如果找到匹配项且有children，构建下一列
            match (foundOption) {
                case Some(option) =>
                    if (option.children.size > 0) {
                        let nextColumn = SilkPickerColumn(option.children)
                        newColumns.append(nextColumn)
                        currentOptions = option.children
                    } else {
                        // 没有children，停止构建
                        break
                    }
                case None =>
                    // 没有找到匹配项，停止构建
                    break
            }
        }

        // 更新columns数组 - 响应式更新
        columns.clear()
        for (column in newColumns) {
            columns.append(column)
        }

        SilkUILog.info("级联构建columns更新完成：新数组长度=${columns.size}")
    }

    /**
     * 初始化选中索引
     */
    private func initializeSelectedIndexes() {
        // 清空现有的选中索引
        selectedIndexes = ObservedArrayList<Int32>()

        for (i in 0..columns.size) {
            // 根据初始化时传入的选中的value 初始化索引
            if (selectedValues.size == 0) {
                // 没有预设值，选择第一个可用的（非禁用）选项
                let availableIndex = this.findNextAvailableOption(i, 0)
                selectedIndexes.append(availableIndex)
                SilkUILog.info("初始化索引[${i}]: 选择第一个可用选项${availableIndex}")
            } else {
                let targetValue = if (i < selectedValues.size) {
                    ResourceStrToString(selectedValues[i])
                } else {
                    ""
                }

                // 使用传统循环查找指定值的索引
                var foundIndex = Int32(0)
                for (j in 0..columns[i].options.size) {
                    if (ResourceStrToString(columns[i].options[j].value) == targetValue) {
                        foundIndex = Int32(j)
                        break
                    }
                }

                // 检查找到的选项是否被禁用，如果禁用则寻找附近的可用选项
                if (foundIndex < Int32(columns[i].options.size) && columns[i].options[Int64(foundIndex)].disabled) {
                    foundIndex = this.findNextAvailableOption(i, foundIndex)
                    SilkUILog.info("初始化索引[${i}]: 目标选项被禁用，选择可用选项${foundIndex}")
                }

                selectedIndexes.append(foundIndex)
                SilkUILog.info("初始化索引[${i}]: 找到值'${targetValue}'对应索引${foundIndex}")
            }
        }

        SilkUILog.info("索引初始化完成: ${selectedIndexes.size} 个索引, columns数量: ${columns.size}")
    }

    /**
     * 查找下一个可用的（非禁用）选项
     * @param columnIndex 列索引
     * @param startIndex 开始查找的索引
     * @return 可用选项的索引，如果没有可用选项则返回0
     */
    private func findNextAvailableOption(columnIndex: Int64, startIndex: Int32): Int32 {
        if (columnIndex >= columns.size || columns[columnIndex].options.size == 0) {
            return 0
        }

        let options = columns[columnIndex].options
        let startIdx = Int64(startIndex)

        // 从startIndex开始向后查找
        for (i in startIdx..options.size) {
            if (!options[i].disabled) {
                return Int32(i)
            }
        }

        // 如果向后没找到，从startIndex开始向前查找
        for (i in 0..startIdx) {
            if (!options[startIdx - i - 1].disabled) {
                return Int32(startIdx - i - 1)
            }
        }

        // 如果所有选项都被禁用，返回第一个选项
        SilkUILog.warn("列${columnIndex}所有选项都被禁用，返回索引0")
        return 0
    }

    /**
     * 构建选择器UI
     */
    func build() {
        Column() {
            // 工具栏
            if (options.toolbarPosition) {
                this.buildToolbar()
            }

            // 选择器内容区域
            if (options.loading) {
                this.buildLoadingContent()
            } else {
                this.buildPickerContent()
            }

            // 底部工具栏
            if (!options.toolbarPosition) {
                this.buildToolbar()
            }
        }
            .width(100.percent)
            .backgroundColor(ResourceColorToColor(getPickerColorConstant(SilkPickerColorKey.PICKER_BACKGROUND)))
    }

    /**
     * 构建工具栏
     */
    @Builder
    private func buildToolbar() {
        Row() {
            // 取消按钮
            Text(ResourceStrToString(options.cancelButtonText))
                .fontSize(getPickerSizeConstant(SilkPickerSizeKey.PICKER_ACTION_FONT_SIZE))
                .fontColor(ResourceColorToColor(getPickerColorConstant(SilkPickerColorKey.PICKER_CANCEL_ACTION_COLOR)))
                .padding(
                    top: getPickerSizeConstant(SilkPickerSizeKey.PICKER_ACTION_PADDING_TOP),
                    right: getPickerSizeConstant(SilkPickerSizeKey.PICKER_ACTION_PADDING_RIGHT),
                    bottom: getPickerSizeConstant(SilkPickerSizeKey.PICKER_ACTION_PADDING_BOTTOM),
                    left: getPickerSizeConstant(SilkPickerSizeKey.PICKER_ACTION_PADDING_LEFT)
                )
                .onClick {_ => handleCancel()}

            Blank()

            // 标题
            if (!ResourceStrToString(options.title).isEmpty()) {
                Text(ResourceStrToString(options.title))
                    .fontSize(getPickerSizeConstant(SilkPickerSizeKey.PICKER_TITLE_FONT_SIZE))
                    .fontColor(
                        ResourceColorToColor(getPickerColorConstant(SilkPickerColorKey.PICKER_OPTION_TEXT_COLOR)))
                    .fontWeight(FontWeight.Medium)
            }

            Blank()

            // 确认按钮
            Text(ResourceStrToString(options.confirmButtonText))
                .fontSize(getPickerSizeConstant(SilkPickerSizeKey.PICKER_ACTION_FONT_SIZE))
                .fontColor(ResourceColorToColor(getPickerColorConstant(SilkPickerColorKey.PICKER_CONFIRM_ACTION_COLOR)))
                .padding(
                    top: getPickerSizeConstant(SilkPickerSizeKey.PICKER_ACTION_PADDING_TOP),
                    right: getPickerSizeConstant(SilkPickerSizeKey.PICKER_ACTION_PADDING_RIGHT),
                    bottom: getPickerSizeConstant(SilkPickerSizeKey.PICKER_ACTION_PADDING_BOTTOM),
                    left: getPickerSizeConstant(SilkPickerSizeKey.PICKER_ACTION_PADDING_LEFT)
                )
                .onClick {_ => handleConfirm()}
        }
            .width(100.percent)
            .height(getPickerSizeConstant(SilkPickerSizeKey.PICKER_TOOLBAR_HEIGHT))
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
    }

    /**
     * 构建加载状态内容
     */
    @Builder
    private func buildLoadingContent() {
        Column() {
            // 加载指示器
            SilkLoading()
        }
            .width(100.percent)
            .height(
                Length(options.itemHeight.value * Float64(options.visibleItemCount),
                    unitType: options.itemHeight.unitType))
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .backgroundColor(ResourceColorToColor(getPickerColorConstant(SilkPickerColorKey.PICKER_LOADING_MASK_COLOR)))
    }

    /**
     * 构建选择器内容 - 基于3D变换实现，保持三层结构
     */
    @Builder
    private func buildPickerContent() {
        if (columns.isEmpty()) {
            empty()
        } else {
            Stack() {
                // 第一层：数据展示层 - 负责显示内容和3D变换效果
                Row() {
                    ForEach(
                        columns,
                        itemGeneratorFunc: {
                            _: SilkPickerColumn, index: Int64 => buildDataColumn(index)
                        },
                        keyGeneratorFunc: {
                            column: SilkPickerColumn, index: Int64 => "${index}_${column.options.size}"
                        }
                    )
                }.width(100.percent).height(100.percent)

                // 第二层：遮罩层 - 提供视觉效果，不拦截触摸事件
                PickerMask(h: options.itemHeight)

                // 第三层：透明触摸层 - 负责处理触摸事件并同步到数据层
                Row() {
                    ForEach(
                        columns,
                        itemGeneratorFunc: {
                            _: SilkPickerColumn, index: Int64 => buildTouchColumn(index)
                        },
                        keyGeneratorFunc: {
                            column: SilkPickerColumn, index: Int64 => "${index}_${column.options.size}"
                        }
                    )
                }.width(100.percent).height(100.percent).backgroundColor(Color.TRANSPARENT)
            }
                .width(100.percent)
                .height(
                    Length(options.itemHeight.value * Float64(options.visibleItemCount),
                        unitType: options.itemHeight.unitType))
        }
    }

    /**
     * 构建数据展示列 - 负责显示内容和3D变换效果
     */
    @Builder
    private func buildDataColumn(columnIndex: Int64) {
        if (columnIndex < columns.size) {
            Column() {
                Column() {
                    ForEach(
                        columns[columnIndex].options,
                        itemGeneratorFunc: {
                            option: SilkPickerOption, index: Int64 => buildPickerOption(option, columnIndex, index)
                        },
                        keyGeneratorFunc: {
                            option: SilkPickerOption, index: Int64 => "${columnIndex}_${index}_${ResourceStrToString(option.value)}"
                        }
                    )
                }
                    .width(100.percent)
                    .translate(
                        x: 0.vp,
                        y: Length(-transformOffsets[columnIndex], unitType: LengthType.vp),
                        z: 0.vp
                    )
                    .animationStart(
                        if (animationControllers[columnIndex]) {
                            AnimateParam(
                                duration: 300,
                                curve: Curve.EaseOut
                            )
                        } else {
                            AnimateParam(duration: 0)
                        })
                    .animationEnd()
                    .padding(
                        top: Length(options.itemHeight.value * Float64(options.visibleItemCount - 1) / 2.0,
                            unitType: options.itemHeight.unitType),
                        bottom: Length(options.itemHeight.value * Float64(options.visibleItemCount - 1) / 2.0,
                            unitType: options.itemHeight.unitType)
                    )
            }.layoutWeight(1).height(100.percent).clip(true) // 裁剪超出部分
        }
    }

    /**
     * 构建透明触摸列 - 负责处理触摸事件并与数据层同步变换
     */
    @Builder
    private func buildTouchColumn(columnIndex: Int64) {
        if (columnIndex < columns.size) {
            Column() {
                Column() {
                    ForEach(
                        columns[columnIndex].options,
                        itemGeneratorFunc: {
                            option: SilkPickerOption, index: Int64 => buildTouchOption(option, columnIndex, index)
                        },
                        keyGeneratorFunc: {
                            option: SilkPickerOption, index: Int64 => "${columnIndex}_${index}_${ResourceStrToString(option.value)}"
                        }
                    )
                }
                    .width(100.percent)
                    .translate(
                        x: 0.vp,
                        y: Length(-transformOffsets[columnIndex], unitType: LengthType.vp),
                        z: 0.vp
                    )
                    .animationStart(
                        if (animationControllers[columnIndex]) {
                            AnimateParam(
                                duration: 300,
                                curve: Curve.EaseOut
                            )
                        } else {
                            AnimateParam(duration: 0)
                        })
                    .animationEnd()
                    .padding(
                        top: Length(options.itemHeight.value * Float64(options.visibleItemCount - 1) / 2.0,
                            unitType: options.itemHeight.unitType),
                        bottom: Length(options.itemHeight.value * Float64(options.visibleItemCount - 1) / 2.0,
                            unitType: options.itemHeight.unitType)
                    )
            }
                .onTouch {
                    event => handleTouch(event, columnIndex)
                }
                .layoutWeight(1)
                .height(100.percent)
                .backgroundColor(Color.TRANSPARENT)
                .clip(true) // 裁剪超出部分，与数据层保持一致
        }
    }

    /**
     * 计算选项的3D效果参数
     */
    private func calculateOptionEffects(columnIndex: Int64, optionIndex: Int64): (Float32, Float32) {
        // 基于选中索引计算距离中心的距离
        let selectedIndex = Int64(selectedIndexes[columnIndex])
        let distanceFromSelected = abs(optionIndex - selectedIndex)

        // 距离选中项越近，缩放越大；距离越远，缩放越小
        let opacity = max(0.4, 1.0 - Float32(distanceFromSelected) * 0.2)
        let scale = max(0.7, 1.0 - Float32(distanceFromSelected) * 0.1) // 选中项=1.0，距离1=0.9，距离2=0.8

        return (opacity, scale)
    }

    /**
     * 构建选择器选项 - 包含3D效果
     */
    @Builder
    private func buildPickerOption(option: SilkPickerOption, columnIndex: Int64, optionIndex: Int64) {
        Text(ResourceStrToString(option.text))
            .fontSize(getPickerSizeConstant(SilkPickerSizeKey.PICKER_OPTION_FONT_SIZE))
            .fontColor(
                ResourceColorToColor(
                    if (option.disabled) {
                        Color(170, 170, 170, alpha: 1.0) // 灰色表示禁用状态
                    } else {
                        getPickerColorConstant(SilkPickerColorKey.PICKER_OPTION_TEXT_COLOR)
                    }))
            .width(100.percent)
            .height(options.itemHeight)
            .textAlign(TextAlign.Center)
            .scale(
                x: this.calculateOptionEffects(columnIndex, optionIndex)[1],
                y: this.calculateOptionEffects(columnIndex, optionIndex)[1]
            )
            .padding(
                top: getPickerSizeConstant(SilkPickerSizeKey.PICKER_OPTION_PADDING_TOP),
                right: getPickerSizeConstant(SilkPickerSizeKey.PICKER_OPTION_PADDING_RIGHT),
                bottom: getPickerSizeConstant(SilkPickerSizeKey.PICKER_OPTION_PADDING_BOTTOM),
                left: getPickerSizeConstant(SilkPickerSizeKey.PICKER_OPTION_PADDING_LEFT)
            )
        // 数据层不处理点击事件，由触摸层处理
    }

    /**
     * 构建透明触摸选项 - 与数据层保持相同结构但完全透明
     */
    @Builder
    private func buildTouchOption(option: SilkPickerOption, columnIndex: Int64, optionIndex: Int64) {
        // 创建与数据层相同结构的透明元素
        Text("")
            .width(100.percent)
            .height(options.itemHeight)
            .backgroundColor(Color.TRANSPARENT)
            .padding(
                top: getPickerSizeConstant(SilkPickerSizeKey.PICKER_OPTION_PADDING_TOP),
                right: getPickerSizeConstant(SilkPickerSizeKey.PICKER_OPTION_PADDING_RIGHT),
                bottom: getPickerSizeConstant(SilkPickerSizeKey.PICKER_OPTION_PADDING_BOTTOM),
                left: getPickerSizeConstant(SilkPickerSizeKey.PICKER_OPTION_PADDING_LEFT)
            )
            .onClick {
                _ => if (!option.disabled && !options.readonly) {
                    handleOptionClick(columnIndex, optionIndex)
                }
            }
    }

    /**
     * 处理选项变化
     */
    private func handleOptionChange(columnIndex: Int64, optionIndex: Int64) {
        if (columnIndex >= 0 && columnIndex < selectedIndexes.size) {
            selectedIndexes[columnIndex] = Int32(optionIndex)

            // 触发变化回调
            let values = this.getCurrentSelectedValues()
            this.change(values |> map({item => ResourceStrToString(item)}) |> collectArray,
                selectedIndexes.get().toArray(), columnIndex)
        }
    }

    /**
     * 处理选项点击 - 滚动到指定元素
     */
    private func handleOptionClick(columnIndex: Int64, optionIndex: Int64) {
        if (columnIndex >= 0 && columnIndex < selectedIndexes.size && !options.readonly) {
            // 计算目标滚动位置
            let targetOffset = Float64(optionIndex) * options.itemHeight.value

            // 更新触摸状态的偏移量
            touchStates[columnIndex].offset = targetOffset

            // 使用动画滚动到目标位置
            this.animateToOffset(columnIndex, targetOffset)

            // 更新选中索引
            selectedIndexes[columnIndex] = Int32(optionIndex)

            SilkUILog.info("======更新：${selectedIndexes.get().toString()}")

            // 触发变化回调
            let values = this.getCurrentSelectedValues()
            this.change(values |> map({item => ResourceStrToString(item)}) |> collectArray,
                selectedIndexes.get().toArray(), columnIndex)
        }
    }

    /**
     * 处理确认按钮点击
     */
    private func handleConfirm() {
        let values = this.getCurrentSelectedValues()
        this.confirm(values |> map({item => ResourceStrToString(item)}) |> collectArray, selectedIndexes
            .get()
            .toArray())
    }

    /**
     * 处理取消按钮点击
     */
    private func handleCancel() {
        this.cancel()
    }

    /**
     * 获取当前选中的值数组（内部使用）
     */
    private func getCurrentSelectedValues(): Array<ResourceStr> {
        let values = ArrayList<ResourceStr>()
        for (i in 0..selectedIndexes.size) {
            if (i < columns.size && Int64(selectedIndexes[i]) < columns[i].options.size) {
                values.append(columns[i].options[Int64(selectedIndexes[i])].value)
            }
        }
        return values.toArray();
    }

    /**
     * 设置选中的索引
     */
    public func setSelectedIndexes(indexes: Array<Int32>) {
        selectedIndexes = ObservedArrayList(indexes)
    }

    /**
     * 获取选中的索引
     */
    public func getSelectedIndexes(): Array<Int32> {
        return selectedIndexes.get().toArray()
    }

    /**
     * 设置选中的值数组
     * 用于初始化或动态设置选中状态
     */
    public func setSelectedValues(values: Array<ResourceStr>) {
        selectedValues = ObservedArrayList(values)

        // 重新检测级联模式
        this.detectCascadeMode()

        // 重新构建级联结构和初始化索引（仅在级联模式下）
        if (isCascadeMode) {
            this.buildCascadeColumns()
        }
        this.initializeSelectedIndexes()

        // 重新初始化状态数组
        this.reinitializeAllColumnsState()
    }

    /**
     * 获取选中的值数组
     */
    public func getSelectedValues(): Array<ResourceStr> {
        let values = ArrayList<ResourceStr>()
        for (i in 0..selectedIndexes.size) {
            if (i < columns.size && Int64(selectedIndexes[i]) < columns[i].options.size) {
                values.append(columns[i].options[Int64(selectedIndexes[i])].value)
            }
        }
        return values.toArray()
    }

    /**
     * 重新初始化所有列的状态
     * 当动态改变columns结构时使用
     */
    private func reinitializeAllColumnsState() {
        // 清空所有状态数组
        transformOffsets = ObservedArrayList<Float64>()
        touchStates = ObservedArrayList<PickerTouchState>()
        animationControllers = ObservedArrayList<Bool>()
        touchContainerRefs = ObservedArrayList<Bool>()
        currentOffsets = ObservedArrayList<Float64>()

        // 重新初始化所有列的状态
        for (i in 0..columns.size) {
            // 根据选中索引计算正确的变换偏移量
            let selectedIndex = if (i < selectedIndexes.size) {
                Int64(selectedIndexes[i])
            } else {
                0
            }
            let offset = Float64(selectedIndex) * options.itemHeight.value
            
            transformOffsets.append(offset)
            
            // 创建触摸状态并设置正确的偏移量
            let touchState = PickerTouchState()
            touchState.offset = offset
            touchStates.append(touchState)
            
            animationControllers.append(false)
            touchContainerRefs.append(false)
            currentOffsets.append(offset)
        }
    }

    /**
     * 处理触摸事件
     * 1:1复刻Vant的触摸事件处理逻辑
     */
    private func handleTouch(event: TouchEvent, columnIndex: Int64): Unit {
        try {
            if (columnIndex >= touchStates.size || options.readonly) {
                return;
            }

            let currentTime = DateTime.now().toUnixTimeStamp().toMilliseconds()
            let touchY = event.touches[0].screenY
            if (columnIndex < 0 || columnIndex >= touchStates.size) {
                return;
            }

            let touchState = touchStates[columnIndex]

            match (event.eventType) {
                case TouchType.Down => this.onTouchStart(touchState, touchY, currentTime, columnIndex)

                case TouchType.Move => this.onTouchMove(touchState, touchY, currentTime, columnIndex)

                case TouchType.Up => this.onTouchEnd(touchState, touchY, currentTime, columnIndex)

                case _ => this.onTouchCancel(touchState, columnIndex)
            }
        } catch (name: Exception) {
            SilkUILog.error("======err==" + name.toString())
        }

        return;
    }

    /**
     * 触摸开始处理 - Vant风格
     */
    private func onTouchStart(touchState: PickerTouchState, touchY: Float64, currentTime: Int64, columnIndex: Int64) {
        // 停止当前动画
        touchState.isAnimating = false

        // 初始化触摸状态
        touchState.startY = touchY
        touchState.currentY = touchY
        touchState.startTime = currentTime
        touchState.isDragging = false
        touchState.lastMoveTime = currentTime
        touchState.lastMoveY = touchY
        touchState.velocity = 0.0
        touchState.momentumStartY = touchY
        touchState.momentumTimeStamp = currentTime
    }

    /**
     * 触摸移动处理 - Vant风格
     */
    private func onTouchMove(touchState: PickerTouchState, touchY: Float64, currentTime: Int64, columnIndex: Int64) {
        let deltaY = touchY - touchState.startY
        let timeDelta = currentTime - touchState.lastMoveTime

        // 判断是否开始拖拽
        if (!touchState.isDragging && abs(deltaY) > 5.0) {
            touchState.isDragging = true
        }

        if (touchState.isDragging) {
            // Vant风格的阻尼效果
            let dampedDelta = this.applyDamping(deltaY, columnIndex)

            // 更新3D变换位置
            let newOffset = touchState.offset - dampedDelta
            this.setTransformOffset(columnIndex, newOffset, false)

            // 计算速度 - 使用Vant的速度计算方法
            if (timeDelta > 0) {
                let moveDelta = touchY - touchState.lastMoveY
                touchState.velocity = moveDelta / Float64(timeDelta)
            }

            // 更新惯性滚动参考点
            if (currentTime - touchState.momentumTimeStamp > 300) {
                touchState.momentumStartY = touchY
                touchState.momentumTimeStamp = currentTime
            }

            // 更新触摸状态
            touchState.currentY = touchY
            touchState.lastMoveTime = currentTime
            touchState.lastMoveY = touchY
            touchState.startY = touchY // 重置起始点，避免累积误差
        }
    }

    /**
     * 触摸结束处理 - Vant风格
     */
    private func onTouchEnd(touchState: PickerTouchState, touchY: Float64, currentTime: Int64, columnIndex: Int64) {
        if (touchState.isDragging) {
            // 计算最终速度
            let duration = currentTime - touchState.momentumTimeStamp
            let distance = touchY - touchState.momentumStartY

            if (duration > 0 && duration < 300) {
                touchState.velocity = distance / Float64(duration)
            }

            // 执行惯性滚动
            this.momentum(columnIndex)
        } else {
            // 点击选择
            this.handleTapSelect(columnIndex, touchY)
        }

        // 重置拖拽状态
        touchState.isDragging = false
    }

    /**
     * 触摸取消处理
     */
    private func onTouchCancel(touchState: PickerTouchState, columnIndex: Int64) {
        touchState.isDragging = false
        touchState.isAnimating = false
    }

    /**
     * 处理惯性滚动
     */
    private func handleInertiaScroll(columnIndex: Int64) {
        let velocity = touchStates[columnIndex].velocity
        let currentOffset = currentOffsets[columnIndex]

        // 计算惯性滚动的目标位置
        let inertiaDistance = velocity * 200.0 // 惯性系数
        let targetOffset = currentOffset + inertiaDistance

        // 对齐到最近的选项
        let itemHeight = options.itemHeight.value
        let targetIndex = round(targetOffset / itemHeight)
        let alignedOffset = targetIndex * itemHeight

        // 限制在有效范围内
        let maxIndex = Float64(columns[columnIndex].options.size - 1)
        let finalIndex = max(0.0, min(targetIndex, maxIndex))
        let finalOffset = finalIndex * itemHeight

        // 执行动画滚动到目标位置
        this.animateToOffset(columnIndex, finalOffset)
    }

    /**
     * 处理点击选择
     */
    private func handleTapSelect(columnIndex: Int64, touchY: Float64) {
        // 检查除法分母
        if (options.itemHeight.value <= 0.0) {
            SilkUILog.error("handleTapSelect: itemHeight无效")
            return
        }

        // 计算点击位置对应的选项索引
        let containerHeight = options.itemHeight.value * Float64(options.visibleItemCount)
        let centerY = containerHeight / 2.0
        let offsetFromCenter = touchY - centerY

        let currentSelectedIndex = Int64(round(currentOffsets[columnIndex] / options.itemHeight.value))
        let offsetIndex = Int64(round(offsetFromCenter / options.itemHeight.value))
        let clickedIndex = currentSelectedIndex + offsetIndex

        if (clickedIndex >= 0 && clickedIndex < columns[columnIndex].options.size) {
            // 检查点击的选项是否被禁用
            var targetIndex = clickedIndex
            if (columns[columnIndex].options[clickedIndex].disabled) {
                // 选项被禁用，寻找附近的可用选项
                targetIndex = Int64(this.findNextAvailableOption(columnIndex, Int32(clickedIndex)))
                SilkUILog.info("handleTapSelect: 点击的索引${clickedIndex}被禁用，选择可用选项${targetIndex}")
            }

            let targetOffset = Float64(targetIndex) * options.itemHeight.value
            this.animateToOffset(columnIndex, targetOffset)
        }
    }

    /**
     * 动画变换到指定位置
     */
    private func animateToOffset(columnIndex: Int64, targetOffset: Float64) {
        // 使用带动画的3D变换
        this.setTransformOffset(columnIndex, targetOffset, true)
    }

    /**
     * Vant风格的阻尼效果
     * 当滚动超出边界时应用阻尼
     */
    private func applyDamping(delta: Float64, columnIndex: Int64): Float64 {
        let currentOffset = touchStates[columnIndex].offset
        let maxOffset = Float64(columns[columnIndex].options.size - 1) * options.itemHeight.value

        // 检查是否超出边界
        let newOffset = currentOffset - delta

        if (newOffset < 0.0) {
            // 超出顶部边界，应用阻尼
            let overscroll = abs(newOffset)
            let damping = 1.0 / (overscroll / options.itemHeight.value + 1.0)
            return delta * damping
        } else if (newOffset > maxOffset) {
            // 超出底部边界，应用阻尼
            let overscroll = newOffset - maxOffset
            let damping = 1.0 / (overscroll / options.itemHeight.value + 1.0)
            return delta * damping
        }

        return delta
    }

    /**
     * 设置3D变换偏移量
     */
    private func setTransformOffset(columnIndex: Int64, offset: Float64, withAnimation: Bool) {
        // 限制偏移量在有效范围内
        let clampedOffset = this.clampOffset(offset, columnIndex)

        // 更新触摸状态中的偏移量
        touchStates[columnIndex].offset = clampedOffset

        // 设置动画控制器
        animationControllers[columnIndex] = withAnimation

        // 更新3D变换偏移量
        transformOffsets[columnIndex] = clampedOffset

        // 更新当前偏移量
        currentOffsets[columnIndex] = clampedOffset

        // 计算并更新选中索引
        this.updateSelectedIndex(columnIndex, clampedOffset)
    }

    /**
     * 更新选中索引
     */
    private func updateSelectedIndex(columnIndex: Int64, offset: Float64) {
        // 安全检查：确保columnIndex有效
        if (columnIndex < 0 || columnIndex >= columns.size) {
            SilkUILog.info("updateSelectedIndex：columnIndex超出范围 ${columnIndex}")
            return
        }

        // 安全检查：确保选项数组不为空
        if (columns[columnIndex].options.size == 0) {
            SilkUILog.info("updateSelectedIndex：列${columnIndex}选项为空")
            return
        }

        let itemHeight = options.itemHeight.value

        // 检查除法分母
        if (itemHeight <= 0.0) {
            SilkUILog.error("updateSelectedIndex: itemHeight无效")
            return
        }

        let selectedIndex = Int64(round(offset / itemHeight))
        let clampedIndex = max(0, min(selectedIndex, Int64(columns[columnIndex].options.size - 1)))

        // 安全检查：确保selectedIndexes数组有效
        if (columnIndex >= selectedIndexes.size) {
            SilkUILog.info("updateSelectedIndex：selectedIndexes数组太小")
            return
        }

        // 检查计算出的索引对应的选项是否被禁用
        var finalIndex = clampedIndex
        if (clampedIndex < columns[columnIndex].options.size && columns[columnIndex].options[clampedIndex].disabled) {
            // 选项被禁用，寻找附近的可用选项
            finalIndex = Int64(this.findNextAvailableOption(columnIndex, Int32(clampedIndex)))
            SilkUILog.info("updateSelectedIndex: 索引${clampedIndex}选项被禁用，选择可用选项${finalIndex}")

            // 更新偏移量到可用选项的位置
            let availableOffset = Float64(finalIndex) * itemHeight
            transformOffsets[columnIndex] = availableOffset
            currentOffsets[columnIndex] = availableOffset
            touchStates[columnIndex].offset = availableOffset
        }

        if (finalIndex != Int64(selectedIndexes[columnIndex])) {
            selectedIndexes[columnIndex] = Int32(finalIndex)

            // 处理级联更新：当某一列的选择改变时，重新构建后续列
            this.handleCascadeUpdate(columnIndex, finalIndex)

            // 触发变化回调
            let values = this.getCurrentSelectedValues()
            this.change(values |> map({item => ResourceStrToString(item)}) |> collectArray,
                selectedIndexes.get().toArray(), columnIndex)
        }
    }

    /**
     * 处理级联更新
     * 当某一列的选择改变时，重新构建并更新后续的级联列
     */
    private func handleCascadeUpdate(columnIndex: Int64, selectedIndex: Int64) {
        // 只有在级联模式下才执行级联更新逻辑
        if (!isCascadeMode) {
            SilkUILog.info("非级联模式，跳过级联更新逻辑")
            return
        }

        // 安全检查：确保columnIndex有效
        if (columnIndex < 0 || columnIndex >= columns.size) {
            SilkUILog.info("级联更新：columnIndex超出范围 ${columnIndex}")
            return
        }

        // 安全检查：确保selectedIndex有效
        if (selectedIndex < 0 || selectedIndex >= columns[columnIndex].options.size) {
            SilkUILog.info("级联更新：selectedIndex超出范围 ${selectedIndex}")
            return
        }

        // 只有当不是最后一列时才需要处理级联
        if (columnIndex >= columns.size - 1) {
            return
        }

        // 获取当前选中的选项
        let currentOption = columns[columnIndex].options[selectedIndex]

        SilkUILog.info("级联更新：列${columnIndex}选择了${selectedIndex}，children数量=${currentOption.children.size}")

        // 检查是否有children
        if (currentOption.children.size > 0) {
            // 重新构建后续的列
            this.rebuildCascadeColumns(columnIndex, currentOption.children)
        } else {
            // 当前选项没有children，移除后续所有列
            this.removeCascadeColumns(columnIndex + 1)
        }
    }

    /**
     * 重新构建级联列
     * 从指定列开始重新构建后续的级联结构
     */
    private func rebuildCascadeColumns(fromIndex: Int64, childrenOptions: Array<SilkPickerOption>) {
        SilkUILog.info("重新构建级联列：fromIndex=${fromIndex}, childrenOptions数量=${childrenOptions.size}")

        // 安全检查
        if (fromIndex < 0 || fromIndex >= columns.size) {
            SilkUILog.info("rebuildCascadeColumns：fromIndex超出范围")
            return
        }

        if (childrenOptions.size == 0) {
            SilkUILog.info("rebuildCascadeColumns：childrenOptions为空，移除后续列")
            this.removeCascadeColumns(fromIndex + 1)
            return
        }

        // 创建新的columns数组，保留fromIndex之前的列
        let newColumns = ArrayList<SilkPickerColumn>()
        for (i in 0..(fromIndex + 1)) {
            newColumns.append(columns[i])
        }

        // 添加新的级联列
        let nextColumn = SilkPickerColumn(childrenOptions)
        newColumns.append(nextColumn)

        // 如果有更多级联，继续构建（基于第一个选项的children）
        var currentOptions = childrenOptions
        var levelIndex = fromIndex + 2
        while (levelIndex < selectedValues.size && currentOptions.size > 0) {
            // 默认选择第一个选项
            let firstOption = currentOptions[0]
            if (firstOption.children.size > 0) {
                let cascadeColumn = SilkPickerColumn(firstOption.children)
                newColumns.append(cascadeColumn)
                currentOptions = firstOption.children
                levelIndex += 1
            } else {
                break
            }
        }

        SilkUILog.info("级联重建完成：旧列数=${columns.size}，新列数=${newColumns.size}")

        // 批量更新：先更新columns，再同步所有状态
        let oldColumnsSize = columns.size

        // 响应式更新columns
        columns.clear()
        for (column in newColumns) {
            columns.append(column)
        }

        SilkUILog.info("columns更新完成：新数组长度=${columns.size}")

        // 调整selectedIndexes数组大小
        this.adjustSelectedIndexes(fromIndex + 1)

        // 重新初始化后续列的状态
        this.reinitializeColumnsState(fromIndex + 1)

        SilkUILog.info("级联状态同步完成：selectedIndexes数量=${selectedIndexes.size}")
    }

    /**
     * 移除级联列
     * 移除指定索引之后的所有列
     */
    private func removeCascadeColumns(fromIndex: Int64) {
        SilkUILog.info("移除级联列：fromIndex=${fromIndex}, 当前列数=${columns.size}")

        if (fromIndex >= columns.size) {
            SilkUILog.info("removeCascadeColumns：fromIndex超出范围，无需移除")
            return
        }

        if (fromIndex <= 0) {
            SilkUILog.info("removeCascadeColumns：fromIndex过小，保护第一列")
            return
        }

        // 创建新的columns数组，只保留fromIndex之前的列
        let newColumns = ArrayList<SilkPickerColumn>()
        for (i in 0..fromIndex) {
            newColumns.append(columns[i])
        }

        let oldColumnsSize = columns.size

        // 响应式更新columns
        columns.clear()
        for (column in newColumns) {
            columns.append(column)
        }

        SilkUILog.info("移除columns更新完成：新数组长度=${columns.size}")

        // 调整selectedIndexes数组大小
        this.adjustSelectedIndexes(fromIndex)

        // 重新初始化状态数组
        this.reinitializeColumnsState(fromIndex)

        SilkUILog.info("级联列移除完成：旧列数=${oldColumnsSize}，新列数=${columns.size}")
    }

    /**
     * 调整选中索引数组大小
     */
    private func adjustSelectedIndexes(newSize: Int64) {
        SilkUILog.info(
            "调整selectedIndexes：旧大小=${selectedIndexes.size}，新大小=${newSize}，columns大小=${columns.size}")

        // 确保newSize不小于0
        let safeNewSize = max(0, newSize)

        // 移除多余的索引
        while (selectedIndexes.size > safeNewSize) {
            selectedIndexes.remove(selectedIndexes.size - 1)
        }

        // 确保所有新增的列都有默认索引0
        while (selectedIndexes.size < columns.size) {
            selectedIndexes.append(0)
        }

        SilkUILog.info("selectedIndexes调整完成：最终大小=${selectedIndexes.size}")
    }

    /**
     * 重新初始化列状态
     * 重新初始化变换状态、触摸状态等从指定索引开始的列
     */
    private func reinitializeColumnsState(fromIndex: Int64) {
        // 调整状态数组大小以匹配新的columns数量
        while (transformOffsets.size > columns.size) {
            transformOffsets.remove(transformOffsets.size - 1)
            touchStates.remove(touchStates.size - 1)
            animationControllers.remove(animationControllers.size - 1)
            touchContainerRefs.remove(touchContainerRefs.size - 1)
            currentOffsets.remove(currentOffsets.size - 1)
        }

        // 为新增的列添加默认状态
        while (transformOffsets.size < columns.size) {
            let columnIndex = Int64(transformOffsets.size)
            
            // 根据选中索引计算正确的变换偏移量
            let selectedIndex = if (columnIndex < selectedIndexes.size) {
                Int64(selectedIndexes[columnIndex])
            } else {
                0
            }
            let offset = Float64(selectedIndex) * options.itemHeight.value
            
            transformOffsets.append(offset)
            
            // 创建触摸状态并设置正确的偏移量
            let touchState = PickerTouchState()
            touchState.offset = offset
            touchStates.append(touchState)
            
            animationControllers.append(false)
            touchContainerRefs.append(false)
            currentOffsets.append(offset)
        }
    }

    /**
     * Vant风格的惯性滚动
     */
    private func momentum(columnIndex: Int64) {
        let touchState = touchStates[columnIndex]
        let velocity = touchState.velocity
        let currentOffset = touchState.offset

        // Vant的惯性滚动参数
        let deceleration = 0.0006 // 减速度
        let swipeTime = 2500 // 最大滑动时间
        let itemHeight = options.itemHeight.value

        // 检查除法分母
        if (abs(velocity) < 0.001 || itemHeight <= 0.0) {
            SilkUILog.error("momentum: velocity过小或itemHeight无效，跳过惯性滚动")
            return
        }

        // 计算惯性滚动距离
        let duration = abs(velocity) / deceleration
        let distance = velocity * duration / 2.0

        // 计算目标位置
        let targetOffset = currentOffset + distance
        let targetIndex = round(targetOffset / itemHeight)

        // 限制在有效范围内
        let maxIndex = Float64(columns[columnIndex].options.size - 1)
        let clampedIndex = max(0.0, min(targetIndex, maxIndex))

        // 检查目标选项是否被禁用，如果禁用则寻找可用选项
        var finalIndex = clampedIndex
        if (Int64(clampedIndex) < columns[columnIndex].options.size && columns[columnIndex]
            .options[Int64(clampedIndex)]
            .disabled) {
            let availableIndex = this.findNextAvailableOption(columnIndex, Int32(clampedIndex))
            finalIndex = Float64(availableIndex)
            SilkUILog.info("momentum: 目标索引${Int64(clampedIndex)}被禁用，选择可用选项${availableIndex}")
        }

        let finalOffset = finalIndex * itemHeight

        // 计算实际动画时间
        let actualDistance = abs(finalOffset - currentOffset)
        let velocityAbs = abs(velocity)
        let actualDurationFloat = actualDistance / velocityAbs * 2.0

        let safeDuration = min(max(actualDurationFloat, 300.0), Float64(swipeTime))
        let actualDuration = Int32(safeDuration)

        // 设置动画状态
        touchState.isAnimating = true
        touchState.duration = actualDuration

        // 执行动画
        this.animateToPosition(columnIndex, finalOffset, touchState.duration)
    }

    /**
     * 执行动画到指定位置
     */
    private func animateToPosition(columnIndex: Int64, targetOffset: Float64, duration: Int32) {
        let touchState = touchStates[columnIndex]

        // 使用3D变换动画到目标位置
        this.setTransformOffset(columnIndex, targetOffset, true)

        // 动画完成后重置状态
        touchState.isAnimating = false
    }

    /**
     * 获取当前列的最大偏移量
     */
    private func getMaxOffset(columnIndex: Int64): Float64 {
        if (columnIndex >= 0 && columnIndex < columns.size && columns[columnIndex].options.size > 0) {
            return Float64(columns[columnIndex].options.size - 1) * options.itemHeight.value
        }
        return 0.0
    }

    /**
     * 限制偏移量在有效范围内
     */
    private func clampOffset(offset: Float64, columnIndex: Int64): Float64 {
        let maxOffset = this.getMaxOffset(columnIndex)
        return max(0.0, min(offset, maxOffset))
    }
}

/**
 * 选择器遮罩组件
 *
 * 用于在选择器上方显示渐变遮罩，突出显示当前选中项
 */
@Component
class PickerMask {
    /**
     * 选项高度
     */
    var h: Length = 44.vp

    /**
     * 构建遮罩UI
     */
    func build() {
        Column() {
            // 顶部渐变遮罩
            Column()
                .width(100.percent)
                .layoutWeight(1)
                .linearGradient(
                    angle: getPickerGradientConstant(SilkPickerGradientKey.PICKER_MASK_GRADIENT_TOP).angle,
                    colors: getPickerGradientConstant(SilkPickerGradientKey.PICKER_MASK_GRADIENT_TOP).colors
                )

            // 中间选中区域（透明）
            Column().width(100.percent).height(h).backgroundColor(Color.TRANSPARENT)

            // 底部渐变遮罩
            Column()
                .width(100.percent)
                .layoutWeight(1)
                .linearGradient(
                    angle: getPickerGradientConstant(SilkPickerGradientKey.PICKER_MASK_GRADIENT_BOTTOM).angle,
                    colors: getPickerGradientConstant(SilkPickerGradientKey.PICKER_MASK_GRADIENT_BOTTOM).colors
                )
        }.width(100.percent).height(100.percent)
    }
}

/**
 * SilkPickerLink 选择器组件双向绑定
 *
 * 提供单列或多列选择功能，支持自定义样式和交互回调
 */
@Component
public class SilkPickerLink {
    @Link
    var values: ObservedArrayList<String>
    /**
     * 选择器列配置
     */
    @State
    var columns: ObservedArrayList<SilkPickerColumn> = ObservedArrayList<SilkPickerColumn>()

    /**
     * 选择器配置选项
     */
    @Prop
    var options: SilkPickerOptions
    @BuilderParam
    var empty: () -> Unit = DefaultBuilder
    /**
     * 确认按钮点击回调
     *
     * @param values 当前选中的值数组
     * @param indexes 当前选中的索引数组
     */
    public var confirm: (values: Array<String>, indexs: Array<Int32>) -> Unit = {_, _ =>}

    /**
     * 取消按钮点击回调
     */
    public var cancel: () -> Unit = {=>}

    /**
     * 选项改变回调
     *
     * @param values 当前选中的值数组
     * @param indexes 当前选中的索引数组
     * @param columnIndex 改变的列索引
     */
    public var change: (values: Array<String>, indexes: Array<Int32>, columnIndex: Int64) -> Unit = {_, _, _ =>}

    private func _chagne(values: Array<String>, indexes: Array<Int32>, columnIndex: Int64) {
        change(values, indexes, columnIndex)
        // 更新values数据
        this.values = ObservedArrayList(values)
    }

    /**
     * 构建选择器UI
     */
    func build() {
        Column() {
            SilkPicker(
                columns: columns,
                options: options,
                confirm: confirm,
                empty: empty,
                change: {v, i, c => _chagne(v, i, c)},
                cancel: cancel
            )
        }.width(100.percent)
    }
}
