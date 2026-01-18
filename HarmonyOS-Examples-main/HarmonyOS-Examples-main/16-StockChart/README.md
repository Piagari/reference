# 股市图表

>**made by** 林子淇

本项目是 HarmonyOS 官方 [股票行情走势 ArkTS 示例](https://developer.huawei.com/consumer/cn/doc/architecture-guides/stock_chart_x-0000002264336070) 的仓颉语言重写版本。旨在演示如何利用仓颉语言的特性，结合 `Canvas` 组件，构建一个动态、高性能的数据可视化图表场景。

该示例包含两种核心图表类型：

1. **分时图**：模拟实时数据流，**动态展示**股票在单个交易日内的价格走势和成交量。
2. **日K线图**：支持**手势平移**，动态加载和渲染大量历史K线数据，并**智能标注**可视范围内的最高点和最低点。

## 效果预览

<img src="./example.gif" width="30%">

## 实现思路

项目整体遵循了经典的 **MVVM (Model-View-ViewModel)** 架构模式，确保了UI、状态和业务逻辑的清晰分离。

### 1. 状态管理与更新

针对开发中出现的**声明式UI**（如 `Numbers` 类）和**命令式UI**（`Canvas` 组件的绘制逻辑），`ViewModel` 采用了不同的状态更新策略。

- **声明式UI的自动更新 (`@Observed` + `@Publish`)**

    **声明式UI**的核心思想是：开发者只需**描述**在特定状态下，UI应该是什么样子，而无需关心状态变化后UI如何过渡到新样貌。框架会自动处理这一切。

    项目中的 `Numbers.cj` 组件是典型的声明式UI。它的更新流程如下：

    1. **状态定义**: `TimeLineViewModel` 使用 `@Observed` 宏声明为可观察对象。其内部用于展示顶部数字的 `displayNumberData` 属性，则使用 `@Publish` 宏进行标记。这意味着任何对 `displayNumberData` 的重新赋值都将被UI框架侦听。
    2. **状态绑定**: `Numbers` 组件通过 `@LocalStorageLink` 绑定到 `timeLineViewModel` 实例，并直接在其 `build` 方法中使用 `viewModel.displayNumberData` 来构建 `Text` 组件。
    3. **自动更新**: 当 `TimeLineViewModel` 中的业务逻辑更新 `viewModel.displayNumberData` 时，仓颉的UI框架会自动检测到这一变化。框架会智能地重新渲染 `Numbers` 组件中所有依赖该数据的 `Text` 元素，将界面更新为最新状态。开发者**无需编写任何手动刷新UI的代码**。

```cangjie
// entry/src/main/cangjie/viewmodels/TimeLineViewModel.cj
@Observed
public class TimeLineViewModel {
    // @Publish 标记此状态的变更需要通知UI
    @Publish public var displayNumberData: DisplayNumberData = DisplayNumberData()
    
    private func updateDisplayNumbers(point: TimeLineDataPoint) {
        // ... 计算新数据
        let data = DisplayNumberData(...)
        
        // 重新赋值，自动触发UI更新
        displayNumberData = data 
    }
}

// entry/src/main/cangjie/views/Numbers.cj
@Component
public class Numbers {
    // 绑定到 ViewModel
    @LocalStorageLink['timeLineViewModel']
    var viewModel: TimeLineViewModel = TimeLineViewModel()

    func build() {
        // UI直接消费状态，无需关心如何更新
        mainData(viewModel.displayNumberData)
    }
}
```

- **命令式UI的手动更新 (回调机制)**

    **命令式UI**则要求开发者**发出明确的指令**来一步步地操作和修改UI元素。`Canvas` 绘图就是典型的命令式场景，因为你必须精确地告诉 `CanvasRenderingContext2D` 在哪里开始画线（`moveTo`）、画到哪里（`lineTo`）、用什么颜色（`strokeStyle`）等。

    框架本身无法理解数据点和K线之间的逻辑关系，因此不能自动绘制。为此，项目设计了一套基于回调函数的手动更新机制：

    1. **注册回调**: 在 `TimeLineView.cj` 或 `KLineView.cj` 的生命周期方法（如 `aboutToAppear`）中，视图组件将自身的绘图函数（如 `drawAllCharts`）作为一个**回调**，注册到 `ViewModel` 中。
    2. **状态更新**: ViewModel 内部的数据发生变化（例如，定时器推送了新的分时数据点，或用户滑动K线图导致可视范围变化）。
    3. **手动触发**: 在数据处理完毕后，ViewModel 会调用 `triggerRedraw()` 方法。该方法会遍历并执行所有已注册的回调函数。
    4. **执行绘制指令**: 回调函数的执行，使得视图组件开始运行其绘图逻辑。它从 ViewModel 获取最新的状态数据，然后向 `Canvas` 发出绘图指令，从而将最新的数据状态手动渲染到画布上。

```cangjie
// entry/src/main/cangjie/viewmodels/TimeLineViewModel.cj
public class TimeLineViewModel {
    private let onChartDataChange: HashMap<String, ()->Unit> = HashMap<String, ()->Unit>()
    
    // 提供注册回调的接口
    public func addRedrawCallback(str: String, callback: () -> Unit) {
        onChartDataChange[str] = callback
    }

    private func triggerRedraw() {
        // 手动触发所有注册的回调
        for ((_, callback) in onChartDataChange) {
            callback()
        }
    }

    private func processNewPoint(point: TimeLineDataPoint) {
        // ...
        triggerRedraw() // 触发重绘
    }
}

// entry/src/main/cangjie/views/TimeLineView.cj
@Component
public class TimeLineView {
    @LocalStorageLink['timeLineViewModel']
    var viewModel: TimeLineViewModel = TimeLineViewModel()

    protected override func aboutToAppear() {
        // 将自己的绘图方法注册为回调
        viewModel.addRedrawCallback("timeline_and_volume") {
            drawAllCharts() // 执行具体的、命令式的绘图逻辑
        }
    }
    // ...
}
```

### 2. 分时图的实时更新

分时图的动态效果的核心在于 `TimeLineViewModel` 如何模拟实时数据并驱动UI刷新。以下说明分时图的**数据流向**：

1. **初始化与加载**: `Content.cj` 在 `aboutToAppear` 生命周期中，初始化 `TimeLineViewModel` 并调用其 `startUpdating()` 方法。该方法会启动一个 `Timer`，用于定时触发数据更新。
2. **数据点推送**: `Timer` 每次触发时，会调用 `updateChartData()` 方法。此方法取出下一个数据点，并将其追加到用于渲染的 `renderContext.displayData` 数组中。
3. **状态计算**: 在添加新数据点后，ViewModel 会立即重新计算各项状态。
4. **触发重绘**: 所有状态计算完毕后，调用 `triggerRedraw()` 方法。该方法会遍历所有已注册的重绘回调函数并执行它们。
5. **Canvas渲染**: `TimeLineView` 的绘图函数被调用，它命令 `TimeLineRenderer` 使用 ViewModel 中最新的 `renderContext` 在 `Canvas` 上重绘整个图表，从而在视觉上呈现出数据点逐个增加的动画效果。

```cangjie
// entry/src/main/cangjie/viewmodels/TimeLineViewModel.cj
@Observed
public class TimeLineViewModel {
    private func startTimer() {
        updateTimer = Some(Timer.repeat(Duration.second * 2, Duration.second * 2, { =>
            launch {
                updateChartData() // 定时器触发数据更新
            }
        }))
    }

    private func updateChartData() {
        // ...
        processNewPoint(nextPoint) // 推送新的数据点
        // ...
    }
    
    private func processNewPoint(point: TimeLineDataPoint) {
        // ...
        
        // 计算新状态
        updateDisplayNumbers(point)
        calculateBoundaries()
        calculateVolumeMax()
        
        // 触发重绘
        triggerRedraw()
    }

    private func triggerRedraw() {
        for ((_, callback) in onChartDataChange) {
            callback() // 调用回调函数
        }
    }
}
```

### 3. 日K线图

日K线图的挑战在于处理超出屏幕范围的大量数据时的交互体验。本示例通过“按需计算和渲染”的策略，实现了流畅的平移和精准的动态标注。以下说明日K线图的数据流向：

1. **交互起点**: 用户在 `KLineView` 组件内的 `Scroll` 容器上水平滑动。`onScroll` 事件被触发，将水平滚动的偏移量 `offset.xOffset` 传递给 `kLineViewModel.updateVisibleRange()` 方法。
2. **ViewModel处理**
    - **计算可视范围**: ViewModel 根据累计的滚动偏移量 `scrollOffset` 和每个数据点的固定间距 `pointSpacing`，计算出**当前屏幕可视区域**对应的数据在总数据数组中的起始索引 `startIndex`。
    - **动态统计**: ViewModel 调用 `calculateVisibleStats()`，遍历当前可视范围内的 K 线数据，找出最高价、最低价和最大成交量。这确保了 Y 轴的缩放始终与屏幕所见内容匹配。
    - **准备渲染数据**: 调用 `prepareVisibleDrawData()`，它会创建一个只包含可视范围内数据点的临时列表（`visibleCandles`, `visibleBars`），供渲染器直接使用。
    - **触发重绘**: 调用 `triggerRedraw()`，通知 `KLineView` 更新。
3. **Canvas渲染 (`KLineRenderer`)**:
    - 渲染器接收到更新后的 `renderContext`。它遍历已过滤好的 `visibleCandles` 和 `visibleBars` 列表来绘制K线和成交量柱。
    - **动态标注**: 在绘制最高/最低价标注时（`drawPriceAnnotations`），它直接使用 `renderContext` 中已计算好的索引，从原始数据数组中获取精确的价格，并结合当前滚动偏移量 `scrollOffset` 计算出标注线和文字在画布上的准确位置，实现**标注跟手滑动**的效果。

```cangjie
// entry/src/main/cangjie/viewmodels/KLineViewModel.cj
public class KLineViewModel {
    // 接收滚动偏移，更新可视范围
    public func updateVisibleRange(offsetX: Float64, isInitial!: Bool = false) {        
        // 计算可视范围的起始索引
        updateScrollIndex(offsetX)
        
        // 在可视范围内计算统计数据
        calculateVisibleStats()
        
        // 准备渲染数据
        prepareVisibleDrawData()
        
        // 触发重绘
        triggerRedraw()
    }
}
```

## 工程目录

```
├── entry/src/main/cangjie
│   ├── main_ability.cj
│   ├── ability_stage.cj
│   ├── index.cj
│   ├── constants                       // 常量
│   │   ├── DataConstants.cj
│   │   └── StyleConstants.cj
│   ├── models                          // 数据模型
│   │   ├── ChartData.cj
│   │   ├── ChartDimensions.cj
│   │   ├── ChartDrawParams.cj
│   │   └── DisplayNumberData.cj
│   ├── services                        // 从JSON加载并处理数据
│   │   └── ChartDataService.cj 
│   ├── viewmodels                      // 视图模型
│   │   ├── KLineViewModel.cj           // 日K线图的状态管理
│   │   └── TimeLineViewModel.cj        // 分时图的核心状态管理和业务逻辑
│   └── views                           // UI组件
│       ├── Content.cj
│       ├── Numbers.cj                  // 顶部关键指标（价格、涨跌幅等）组件
│       ├── Quotes.cj
│       ├── StyleExtensions.cj          // UI组件及Canvas的样式扩展方法
│       ├── Title.cj
│       ├── ChartDrawingHelper.cj       // Canvas 绘制辅助类 (网格、坐标轴)
│       ├── KLineRenderer.cj
│       ├── KLineView.cj
│       ├── TimeLineRenderer.cj
│       └── TimeLineView.cj
└── entry/src/main/resources            // 应用资源目录（包含模拟数据JSON文件）
```