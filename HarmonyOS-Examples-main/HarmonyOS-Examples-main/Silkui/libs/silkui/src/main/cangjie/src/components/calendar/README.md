# Calendar 日历

### 介绍

日历组件用于选择日期或日期区间，支持单选、多选、范围选择等模式。

### 引入

```js
import silkui.components.calendar.{
    SilkCalendar, SilkCalendarOptions, SilkCalendarType, SilkCalendarPosition, SilkCalendarDay, SilkCalendarMode
}
```

## 代码演示

### 基础用法

日历组件默认采用单选模式，可以通过 `show` 方法显示日历。

```js
@
Builder
func
BasicCalendarContent()
{
    @
    State
    var visible
    :
    Bool = false

    Column()
    {
        Button
        ("显示日历")
        {
            visible = true
        }

        SilkCalendar(
            props:
        SilkCalendarOptions(
            typeValue:
        SilkCalendarType.SINGLE
        )
        ,
        visible: visible,
        confirm:
        {
            date, _, _ =>
            visible = false
            if (date.isSome()) {
                PromptAction.showToast(message:
                "选择的日期：" + date.getOrThrow().toString()
                )
            }
        }
        ,
        cancel: {
            =>
            visible = false
        }
        )
    }
}
```

### 选择多个日期

将 `typeValue` 设置为 `MULTIPLE` 来开启多选模式，此时 `confirm` 事件返回的 `dates` 为数组结构，数组包含了所有选中的日期。

```js
@
Builder
func
MultipleCalendarContent()
{
    @
    State
    var visible
    :
    Bool = false

    Column()
    {
        Button
        ("选择多个日期")
        {
            visible = true
        }

        SilkCalendar(
            props:
        SilkCalendarOptions(
            typeValue:
        SilkCalendarType.MULTIPLE
        )
        ,
        visible: visible,
        confirm:
        {
            _, dates, _ =>
            visible = false
            PromptAction.showToast(message:
            "选择了 " + dates.size().toString() + " 个日期"
            )
        }
        ,
        cancel: {
            =>
            visible = false
        }
        )
    }
}
```

### 选择日期区间

将 `typeValue` 设置为 `RANGE` 来开启范围选择模式，此时 `confirm` 事件返回的 `range` 为数组结构，数组第一项为开始时间，第二项为结束时间。

```js
@
Builder
func
RangeCalendarContent()
{
    @
    State
    var visible
    :
    Bool = false

    Column()
    {
        Button
        ("选择日期区间")
        {
            visible = true
        }

        SilkCalendar(
            props:
        SilkCalendarOptions(
            typeValue:
        SilkCalendarType.RANGE
        )
        ,
        visible: visible,
        confirm:
        {
            _, _, range =>
            visible = false
            if (range.isSome()) {
                let(start, end) = range.getOrThrow()
                PromptAction.showToast(message:
                "选择的日期区间：" + start.toString() + " 至 " + end.toString()
                )
            }
        }
        ,
        cancel: {
            =>
            visible = false
        }
        )
    }
}
```

### 快捷选择

将 `closeOnClickDay` 设置为 `true` 可以在点击日期时立即关闭日历并触发 `confirm` 事件。

```js
@
Builder
func
QuickSelectCalendarContent()
{
    @
    State
    var visible
    :
    Bool = false

    Column()
    {
        Button
        ("快捷选择")
        {
            visible = true
        }

        SilkCalendar(
            props:
        SilkCalendarOptions(
            typeValue:
        SilkCalendarType.SINGLE,
        closeOnClickDay:
        true
        )
        ,
        visible: visible,
        confirm:
        {
            date, _, _ =>
            if(date.isSome())
            {
                PromptAction.showToast(message:
                "选择的日期：" + date.getOrThrow().toString()
                )
            }
        }
        ,
        cancel: {
            =>
            visible = false
        }
        )
    }
}
```

### 自定义颜色

通过 `updateCalendarColorConstant` 方法可以自定义日历的颜色。

```js
@
Builder
func
CustomColorCalendarContent()
{
    @
    State
    var visible
    :
    Bool = false

    // 自定义颜色
    updateCalendarColorConstant(SilkCalendarColorKey.CALENDAR_DAY_SELECTED_BACKGROUND, Color(0, 170, 0, alpha:
    1.0
    )
    )

    Column()
    {
        Button
        ("自定义颜色")
        {
            visible = true
        }

        SilkCalendar(
            props:
        SilkCalendarOptions(
            typeValue:
        SilkCalendarType.SINGLE
        )
        ,
        visible: visible,
        confirm:
        {
            date, _, _ =>
            visible = false
            if (date.isSome()) {
                PromptAction.showToast(message:
                "选择的日期：" + date.getOrThrow().toString()
                )
            }
        }
        ,
        cancel: {
            =>
            visible = false
        }
        )
    }
}
```

### 自定义日期范围

通过 `minDate` 和 `maxDate` 定义日历的范围。

```js
@
Builder
func
CustomRangeCalendarContent()
{
    @
    State
    var visible
    :
    Bool = false

    Column()
    {
        Button
        ("自定义日期范围")
        {
            visible = true
        }

        SilkCalendar(
            props:
        SilkCalendarOptions(
            typeValue:
        SilkCalendarType.SINGLE,
        minDate:
        Date.now(),
        maxDate:
        Date.now().addMonths(3)
        )
        ,
        visible: visible,
        confirm:
        {
            date, _, _ =>
            visible = false
            if (date.isSome()) {
                PromptAction.showToast(message:
                "选择的日期：" + date.getOrThrow().toString()
                )
            }
        }
        ,
        cancel: {
            =>
            visible = false
        }
        )
    }
}
```

### 自定义按钮文字

通过 `confirmText` 自定义按钮文字，通过 `confirmColor` 自定义按钮颜色。

```js
@
Builder
func
CustomButtonCalendarContent()
{
    @
    State
    var visible
    :
    Bool = false

    Column()
    {
        Button
        ("自定义按钮文字")
        {
            visible = true
        }

        SilkCalendar(
            props:
        SilkCalendarOptions(
            typeValue:
        SilkCalendarType.SINGLE,
        confirmText:
        "完成",
        confirmColor:
        Color(0, 170, 0, alpha:
        1.0
        )
        )
        ,
        visible: visible,
        confirm:
        {
            date, _, _ =>
            visible = false
            if (date.isSome()) {
                PromptAction.showToast(message:
                "选择的日期：" + date.getOrThrow().toString()
                )
            }
        }
        ,
        cancel: {
            =>
            visible = false
        }
        )
    }
}
```

### 自定义日期文本

通过传入 `formatter` 函数来对日历上每一格的内容进行格式化。

```js
@
Builder
func
CustomDayCalendarContent()
{
    @
    State
    var visible
    :
    Bool = false

    Column()
    {
        Button
        ("自定义日期文本")
        {
            visible = true
        }

        SilkCalendar(
            props:
        SilkCalendarOptions(
            typeValue:
        SilkCalendarType.SINGLE,
        formatter:
        {
            date =>
            if(date.getDay() % 10 == 1)
            {
                return date.getDay().toString() + "st"
            }
            else
            if (date.getDay() % 10 == 2) {
                return date.getDay().toString() + "nd"
            } else if (date.getDay() % 10 == 3) {
                return date.getDay().toString() + "rd"
            } else {
                return date.getDay().toString() + "th"
            }
        }
        )
        ,
        visible: visible,
        confirm:
        {
            date, _, _ =>
            visible = false
            if (date.isSome()) {
                PromptAction.showToast(message:
                "选择的日期：" + date.getOrThrow().toString()
                )
            }
        }
        ,
        cancel: {
            =>
            visible = false
        }
        )
    }
}
```

### 自定义日期内容

通过 `Day` 插槽可以自定义日期内容。

```js
// 自定义日期构建器
@
Builder
func
CustomDayBuilder(day:
SilkCalendarDay
)
{
    Column()
    {
        Text(day.text)
            .fontSize(16.
        vp
        )
        .
        fontColor(if(day.isSelected)
        {
            Color.WHITE
        }
        else
        if (day.isToday) {
            Color.RED
        } else {
            Color.BLACK
        }
        )

        if (day.isToday) {
            Text("今")
                .fontSize(12.
            vp
            )
            .
            fontColor(Color.RED)
        }
    }
    .
    width(100.
    percent / 7
    )
    .
    height(100.
    percent
    )
    .
    justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor(if(day.isSelected)
    {
        Color.BLUE
    }
    else
    {
        Color.TRANSPARENT
    }
    )
    .
    borderRadius(4.
    vp
    )
    .
    opacity(if(day.isDisabled || !day.isCurrentMonth)
    {
        0.5
    }
    else
    {
        1.0
    }
    )
}

@
Builder
func
CustomDayContentCalendarContent()
{
    @
    State
    var visible
    :
    Bool = false

    Column()
    {
        Button
        ("自定义日期内容")
        {
            visible = true
        }

        SilkCalendar(
            props:
        SilkCalendarOptions(
            typeValue:
        SilkCalendarType.SINGLE
        )
        ,
        visible: visible,
        Day:
        CustomDayBuilder,
        hasDay:
        true,
        confirm:
        {
            date, _, _ =>
            visible = false
            if (date.isSome()) {
                PromptAction.showToast(message:
                "选择的日期：" + date.getOrThrow().toString()
                )
            }
        }
        ,
        cancel: {
            =>
            visible = false
        }
        )
    }
}
```

### 平铺展示

将日历组件直接平铺在页面中，而不是以弹出层的形式展示。

```js
@Builder
func InlineCalendarContent() {
  SilkCalendar(
    props: SilkCalendarOptions(
      typeValue: SilkCalendarType.SINGLE,
      position: SilkCalendarPosition.TOP // 使用非BOTTOM的位置值可以平铺展示
    ),
    select: { date =>
      PromptAction.showToast(message: "选择的日期：" + date.toString())
    }
  )
}
```

### 切换模式

通过 `mode` 属性可以设置日历的切换模式，支持平铺展示、月份切换、年月切换三种模式。

```js
@Builder
func CalendarModeContent() {
  Column() {
    // 平铺展示模式，不显示切换按钮
    SilkCalendar(
      props: SilkCalendarOptions(
        typeValue: SilkCalendarType.SINGLE,
        position: SilkCalendarPosition.TOP,
        mode: SilkCalendarMode.NONE // 平铺展示模式
      )
    )

    // 月份切换模式，显示上个月/下个月切换按钮
    SilkCalendar(
      props: SilkCalendarOptions(
        typeValue: SilkCalendarType.SINGLE,
        position: SilkCalendarPosition.TOP,
        mode: SilkCalendarMode.MONTH // 月份切换模式
      )
    )

    // 年月切换模式，可以切换年份和月份
    SilkCalendar(
      props: SilkCalendarOptions(
        typeValue: SilkCalendarType.SINGLE,
        position: SilkCalendarPosition.TOP,
        mode: SilkCalendarMode.YEAR_MONTH // 年月切换模式
      )
    )
  }
}
```

### 月份切换模式

月份切换模式下，可以通过点击左右箭头切换月份，适合需要查看不同月份日期的场景。

```js
@Builder
func MonthModeCalendarContent() {
  @State var visible: Bool = false
  @State var currentMonth: String = "当前月份"

  Column() {
    Button("月份切换模式") {
      visible = true
    }

    Text(currentMonth)
      .fontSize(14.vp)
      .margin(16.vp)

    SilkCalendar(
      props: SilkCalendarOptions(
        typeValue: SilkCalendarType.SINGLE,
        mode: SilkCalendarMode.MONTH // 月份切换模式
      ),
      visible: visible,
      monthChange: { month =>
        currentMonth = month.year.toString() + "年" + month.monthValue.toString() + "月"
      },
      confirm: { date, _, _ =>
        visible = false
        if (date.isSome()) {
          PromptAction.showToast(message: "选择的日期：" + date.getOrThrow().toString())
        }
      },
      cancel: { =>
        visible = false
      }
    )
  }
}
```

### 年月切换模式

年月切换模式下，可以同时切换年份和月份，适合需要快速跳转到特定年月的场景。

```js
@Builder
func YearMonthModeCalendarContent() {
  @State var visible: Bool = false
  @State var currentMonth: String = "当前年月"

  Column() {
    Button("年月切换模式") {
      visible = true
    }

    Text(currentMonth)
      .fontSize(14.vp)
      .margin(16.vp)

    SilkCalendar(
      props: SilkCalendarOptions(
        typeValue: SilkCalendarType.SINGLE,
        mode: SilkCalendarMode.YEAR_MONTH // 年月切换模式
      ),
      visible: visible,
      monthChange: { month =>
        currentMonth = month.year.toString() + "年" + month.monthValue.toString() + "月"
      },
      confirm: { date, _, _ =>
        visible = false
        if (date.isSome()) {
          PromptAction.showToast(message: "选择的日期：" + date.getOrThrow().toString())
        }
      },
      cancel: { =>
        visible = false
      }
    )
  }
}
```

### 范围选择

将 `typeValue` 设置为 `RANGE` 来开启范围选择模式，此时可以选择一个日期范围，范围内的日期会以不同的样式显示。

```js
@Builder
func RangeCalendarContent() {
  @State var visible: Bool = false
  @State var rangeText: String = "请选择日期范围"

  Column() {
    Button("选择日期范围") {
      visible = true
    }

    Text(rangeText)
      .fontSize(14.vp)
      .margin(16.vp)

    SilkCalendar(
      props: SilkCalendarOptions(
        typeValue: SilkCalendarType.RANGE,
        mode: SilkCalendarMode.MONTH // 使用月份切换模式
      ),
      visible: visible,
      confirm: { _, _, range =>
        visible = false
        if (range.isSome()) {
          let (start, end) = range.getOrThrow()
          rangeText = "选择的日期区间：" + start.toString() + " 至 " + end.toString()
        }
      },
      cancel: { =>
        visible = false
      }
    )
  }
}

## API

### Props

| 参数        | 说明         | 类型                          | 默认值     | 装饰器             |
|-----------|------------|-----------------------------|---------|-----------------|
| props     | 日历配置选项     | `SilkCalendarOptions`       | -       | `@Prop`         |
| Day       | 自定义日期内容    | `(SilkCalendarDay) -> Unit` | -       | `@BuilderParam` |
| Title     | 自定义标题内容    | `() -> Unit`                | -       | `@BuilderParam` |
| Footer    | 自定义底部内容    | `() -> Unit`                | -       | `@BuilderParam` |
| visible   | 是否显示日历     | `Bool`                      | `false` | `@State`        |
| hasTitle  | 是否有自定义标题   | `Bool`                      | `false` | `var`           |
| hasDay    | 是否有自定义日期内容 | `Bool`                      | `false` | `var`           |
| hasFooter | 是否有自定义底部内容 | `Bool`                      | `false` | `var`           |

### SilkCalendarOptions

| 参数                  | 说明                                      | 类型                      | 默认值                                           | 反应性  |
|---------------------|-----------------------------------------|-------------------------|-----------------------------------------------|------|
| mode                | 切换模式，可选值为 `NONE`、`MONTH`、`YEAR_MONTH`  | `SilkCalendarMode`      | `NONE`                                        | 非响应式 |
| typeValue           | 选择类型，可选值为 `SINGLE`、`MULTIPLE`、`RANGE`   | `SilkCalendarType`      | `SINGLE`                                      | 非响应式 |
| title               | 日历标题                                    | `ResourceStr`           | `"日期选择"`                                      | 非响应式 |
| subtitle            | 日历副标题                                   | `ResourceStr`           | `""`                                          | 非响应式 |
| confirmText         | 确认按钮文本                                  | `ResourceStr`           | `"确定"`                                        | 非响应式 |
| confirmColor        | 确认按钮颜色                                  | `?ResourceColor`        | `None`                                        | 非响应式 |
| showConfirm         | 是否显示确认按钮                                | `Bool`                  | `true`                                        | 非响应式 |
| readonly            | 是否为只读状态                                 | `Bool`                  | `false`                                       | 非响应式 |
| showTitle           | 是否显示标题                                  | `Bool`                  | `true`                                        | 非响应式 |
| showSubtitle        | 是否显示副标题                                 | `Bool`                  | `true`                                        | 非响应式 |
| showWeekday         | 是否显示星期栏                                 | `Bool`                  | `true`                                        | 非响应式 |
| showMonthTitle      | 是否显示月份导航                                | `Bool`                  | `true`                                        | 非响应式 |
| showMark            | 是否显示今日标记                                | `Bool`                  | `true`                                        | 非响应式 |
| firstDayOfWeek      | 周起始日，0 表示周日，1 表示周一                      | `Int32`                 | `0`                                           | 非响应式 |
| minDate             | 可选择的最小日期                                | `DateTime`              | 当前日期的前六个月                                     | 非响应式 |
| maxDate             | 可选择的最大日期                                | `DateTime`              | 当前日期的后六个月                                     | 非响应式 |
| defaultDate         | 默认选中的日期，单选模式下使用                         | `?DateTime`             | `None`                                        | 非响应式 |
| defaultDates        | 默认选中的日期数组，多选模式下使用                       | `?ArrayList<DateTime>`  | `None`                                        | 非响应式 |
| defaultDateRange    | 默认选中的日期范围，范围选择模式下使用                     | `?(DateTime, DateTime)` | `None`                                        | 非响应式 |
| formatter           | 日期格式化函数                                 | `(DateTime) -> String`  | `{ date => date.getDayOfMonth().toString() }` | 非响应式 |
| filter              | 日期过滤函数                                  | `(DateTime) -> Bool`    | `{ _ => true }`                               | 非响应式 |
| allowSameDay        | 是否允许日期范围选择时选择同一天                        | `Bool`                  | `false`                                       | 非响应式 |
| maxRange            | 日期范围最多可选天数，多选模式下使用                      | `?Int32`                | `None`                                        | 非响应式 |
| minRange            | 日期范围最少可选天数，范围选择模式下使用                    | `Int32`                 | `1`                                           | 非响应式 |
| rowHeight           | 日期行高                                    | `Length`                | `64.vp`                                       | 非响应式 |
| position            | 弹出位置，可选值为 `BOTTOM`、`TOP`、`LEFT`、`RIGHT` | `SilkCalendarPosition`  | `BOTTOM`                                      | 非响应式 |
| round               | 是否显示圆角                                  | `Bool`                  | `true`                                        | 非响应式 |
| shadow              | 是否显示阴影                                  | `Bool`                  | `true`                                        | 非响应式 |
| closeOnClickOverlay | 是否在点击遮罩层后关闭                             | `Bool`                  | `true`                                        | 非响应式 |
| closeOnClickDay     | 是否在点击日期后自动关闭                            | `Bool`                  | `false`                                       | 非响应式 |

### SilkCalendarDay

| 参数             | 说明                                                | 类型                  | 反应性  | 装饰器      |
|----------------|---------------------------------------------------|---------------------|------|----------|
| date           | 日期对象                                              | `DateTime`          | 非响应式 | -        |
| text           | 日期文本                                              | `String`            | 响应式  | `@Publish` |
| bottomInfo     | 底部提示信息，如"开始"、"结束"等                                | `String`            | 响应式  | `@Publish` |
| topInfo        | 顶部提示信息                                            | `String`            | 响应式  | `@Publish` |
| typeValue      | 日期类型，表示日期在选择范围中的位置，如普通、选中、开始日期、结束日期、中间日期、占位符等 | `SilkCalendarDayType` | 响应式  | `@Publish` |
| isCurrentMonth | 是否为当前展示月份                                         | `Bool`              | 响应式  | `@Publish` |
| isDisabled     | 是否被禁用                                             | `Bool`              | 响应式  | `@Publish` |

### SilkCalendarDayType

| 值                | 说明                                |
|------------------|-----------------------------------|
| NORMAL           | 普通日期，未被选中                         |
| SELECTED         | 选中的日期（单选模式）                       |
| MULTIPLE_SELECTED | 选中的日期（多选模式）                       |
| START            | 范围选择的开始日期                         |
| END              | 范围选择的结束日期                         |
| START_END        | 范围选择的开始和结束日期（当开始和结束是同一天时）        |
| MIDDLE           | 范围选择中的中间日期                        |
| MULTIPLE_MIDDLE  | 多选模式中的中间日期                        |
| PLACEHOLDER      | 占位符日期，通常是非当前月份的日期                 |
| DISABLED         | 禁用的日期，不可选择                        |

### SilkCalendarMode

| 值          | 说明                |
|------------|-------------------|
| NONE       | 平铺展示模式，不显示切换按钮   |
| MONTH      | 月份切换模式，显示月份切换按钮  |
| YEAR_MONTH | 年月切换模式，可以切换年份和月份 |

### Events

| 事件名         | 说明        | 回调参数                                                                        |
|-------------|-----------|-----------------------------------------------------------------------------|
| select      | 点击日期时触发   | `date: DateTime`                                                            |
| confirm     | 点击确认按钮时触发 | `date: ?DateTime, dates: ArrayList<DateTime>, range: ?(DateTime, DateTime)` |
| cancel      | 点击取消按钮时触发 | -                                                                           |
| monthChange | 切换月份时触发   | `month: DateTime`                                                           |

### 方法

| 方法名   | 说明     | 参数 |
|-------|--------|----|
| show  | 显示日历   | -  |
| hide  | 隐藏日历   | -  |
| reset | 重置选中状态 | -  |

## 主题定制

### 样式变量

组件提供了以下变量，可用于自定义样式，使用方法请参考[主题定制](../theme)。

| 名称                                                 | 默认值                        | 说明           |
|----------------------------------------------------|----------------------------|--------------|
| --silk-calendar-background                         | `WHITE`                    | 日历背景色        |
| --silk-calendar-title-text-color                   | `TEXT_COLOR`               | 标题文字颜色       |
| --silk-calendar-subtitle-text-color                | `TEXT_COLOR_2`             | 副标题文字颜色      |
| --silk-calendar-weekday-text-color                 | `TEXT_COLOR_2`             | 星期栏文字颜色      |
| --silk-calendar-day-text-color                     | `TEXT_COLOR`               | 日期文字颜色       |
| --silk-calendar-day-disabled-text-color            | `GRAY_5`                   | 禁用日期文字颜色     |
| --silk-calendar-day-selected-text-color            | `WHITE`                    | 选中日期文字颜色     |
| --silk-calendar-day-selected-background            | `PRIMARY_COLOR`            | 选中日期背景色      |
| --silk-calendar-day-start-background               | `PRIMARY_COLOR`            | 范围选择的开始日期背景色 |
| --silk-calendar-day-end-background                 | `PRIMARY_COLOR`            | 范围选择的结束日期背景色 |
| --silk-calendar-day-start-end-background           | `PRIMARY_COLOR`            | 范围选择的起止日期背景色 |
| --silk-calendar-day-middle-background              | `rgba(245, 247, 255, 1.0)` | 范围选择的中间日期背景色 |
| --silk-calendar-day-multiple-selected-background   | `PRIMARY_COLOR`            | 多选模式选中日期背景色 |
| --silk-calendar-day-hover-background               | `rgba(245, 247, 255, 1.0)` | 日期悬停背景色      |
| --silk-calendar-confirm-button-text-color          | `WHITE`                    | 确认按钮文字颜色     |
| --silk-calendar-confirm-button-background          | `PRIMARY_COLOR`            | 确认按钮背景色      |
| --silk-calendar-confirm-button-disabled-text-color | `GRAY_5`                   | 禁用确认按钮文字颜色   |
| --silk-calendar-confirm-button-disabled-background | `GRAY_2`                   | 禁用确认按钮背景色    |
| --silk-calendar-today-text-color                   | `PRIMARY_COLOR`            | 今日文字颜色       |
| --silk-calendar-title-height                       | `44vp`                     | 标题高度         |
| --silk-calendar-title-font-size                    | `FONT_SIZE_LG`             | 标题字体大小       |
| --silk-calendar-weekday-height                     | `30vp`                     | 星期栏高度        |
| --silk-calendar-weekday-font-size                  | `FONT_SIZE_SM`             | 星期栏字体大小      |
| --silk-calendar-day-height                         | `64vp`                     | 日期行高         |
| --silk-calendar-day-font-size                      | `FONT_SIZE_MD`             | 日期字体大小       |
| --silk-calendar-day-radius                         | `4vp`                      | 日期圆角大小       |
| --silk-calendar-confirm-button-height              | `36vp`                     | 确认按钮高度       |
| --silk-calendar-confirm-button-font-size           | `FONT_SIZE_MD`             | 确认按钮字体大小     |
| --silk-calendar-confirm-button-margin              | `8vp`                      | 确认按钮外边距      |
| --silk-calendar-popup-height                       | `80%`                      | 弹出层高度        |
