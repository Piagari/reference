/**
 * Created on 2025/5/9
 *
 * SilkCalendar 日历组件
 *
 * 日历组件用于日期选择，支持单选、多选、范围选择等模式。
 * 该组件提供了丰富的配置选项，可以满足各种日期选择场景的需求。
 *
 * 主要特性：
 * 1. 支持单选、多选、范围选择三种模式
 * 2. 支持自定义日期范围
 * 3. 支持自定义日期格式化
 * 4. 支持自定义日期过滤
 * 5. 支持自定义日期内容
 * 6. 支持自定义标题和底部内容
 * 7. 支持弹出层和平铺两种展示方式
 * 8. 支持主题定制
 *
 * ## 基础用法
 * ```
 * SilkCalendar(
 *   props: SilkCalendarOptions(
 *     typeValue: SilkCalendarType.SINGLE
 *   )
 * )
 * ```
 *
 * ## 范围选择
 * ```
 * SilkCalendar(
 *   props: SilkCalendarOptions(
 *     typeValue: SilkCalendarType.RANGE
 *   )
 * )
 * ```
 *
 * ## 多选模式
 * ```
 * SilkCalendar(
 *   props: SilkCalendarOptions(
 *     typeValue: SilkCalendarType.MULTIPLE
 *   )
 * )
 * ```
 *
 * ## 自定义日期范围
 * ```
 * SilkCalendar(
 *   props: SilkCalendarOptions(
 *     typeValue: SilkCalendarType.SINGLE,
 *     minDate: DateTime.now(),
 *     maxDate: DateTime.now().addMonths(3)
 *   )
 * )
 * ```
 *
 * @module silkui/components/calendar
 */
package silkui.components.calendar

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.state_macro_manage.*
import cj_res_silkui.*
import silkui.types.DefaultBuilder
import silkui.ResourceStr
import silkui.ResourceColor
import silkui.utils.ResourceStrToString
import silkui.utils.ResourceColorToColor
import silkui.components.icon.SilkIcon
import silkui.components.button.SilkButton
import silkui.components.button.SilkButtonOptions
import silkui.components.button.SilkButtonType
import silkui.components.popup.SilkPopup
import silkui.components.popup.SilkPopupOptions
import silkui.components.popup.SilkPopupPosition
import silkui.constants.getCalendarColorConstant
import silkui.constants.SilkCalendarColorKey
import silkui.constants.getCalendarSizeConstant
import silkui.constants.SilkCalendarSizeKey
import std.collection.ArrayList
import std.time.DateTime
import std.time.DateTimeFormat
import silkui.components.button.SilkButtonSize
import silkui.constants.getSizeConstant
import silkui.constants.SilkSizeKey
import ohos.prompt_action.PromptAction
import std.collection.HashMap
import silkui.constants.__SilkFontWeight
import silkui.constants.getColorConstant
import silkui.constants.SilkColorKey

@Builder
func DefaultDay(v: SilkCalendarDay) {
}
/**
 * 日历组件
 *
 * 日历组件用于日期选择，支持单选、多选、范围选择等模式。
 *
 * 该组件提供了以下功能：
 * - 单选模式：选择单个日期
 * - 多选模式：选择多个日期
 * - 范围选择模式：选择日期范围
 * - 自定义日期范围：设置可选择的最小和最大日期
 * - 自定义日期格式化：自定义日期的显示文本
 * - 自定义日期过滤：自定义禁用的日期
 * - 自定义日期内容：通过Day插槽自定义日期单元格的内容
 * - 自定义标题：通过Title插槽自定义标题内容
 * - 自定义底部内容：通过Footer插槽自定义底部内容
 * - 弹出层和平铺两种展示方式：通过position属性控制
 *
 * 使用示例：
 * ```
 * // 基础用法
 * SilkCalendar(
 *   props: SilkCalendarOptions(
 *     typeValue: SilkCalendarType.SINGLE
 *   ),
 *   visible: visible,
 *   confirm: { date, _, _ =>
 *     visible = false
 *     if (date.isSome()) {
 *       PromptAction.showToast(message: "选择的日期：" + date.getOrThrow().toString())
 *     }
 *   },
 *   cancel: { => visible = false }
 * )
 * ```
 */

/**
 * 月份数据类
 *
 * 用于存储单个月份的数据，包括月份日期和该月份的所有日期数据
 */
@Observed
public class MonthData {
    /**
     * 月份日期
     */
    var month: DateTime

    /**
     * 该月份的所有日期数据
     */
    @Publish
    var days: ObservedArray<SilkCalendarDay> = ObservedArray<SilkCalendarDay>()
}

@Component
public class SilkCalendar {
    /**
     * 日历配置选项
     */
    @Prop
    public var props: SilkCalendarOptions

    /**
     * 自定义日期内容构建器
     *
     * 用于自定义日期单元格的内容
     */
    @BuilderParam
    var Day: (SilkCalendarDay) -> Unit = DefaultDay

    /**
     * 自定义标题构建器
     *
     * 用于自定义日历标题
     */
    @BuilderParam
    var Title: () -> Unit = DefaultBuilder

    /**
     * 自定义底部内容构建器
     *
     * 用于自定义日历底部内容
     */
    @BuilderParam
    var Footer: () -> Unit = DefaultBuilder

    /**
     * 当前显示的月份
     */
    @State
    var currentMonth: DateTime = DateTime.now()

    /**
     * 当前选中的日期（单选模式）
     */
    @State
    var selectedDate: ?DateTime = Option.None

    /**
     * 当前选中的日期数组（多选模式）
     */
    @State
    var selectedDates: ArrayList<DateTime> = ArrayList<DateTime>()

    /**
     * 当前选中的日期范围（范围选择模式）
     */
    @State
    var selectedRange: ?(DateTime, DateTime) = Option.None

    /**
     * 临时选中的开始日期（范围选择模式）
     */
    @State
    var tempRangeStart: ?DateTime = Option.None

    /**
     * 是否显示日历
     */
    @Link
    var visible: Bool = false

    /**
     * 周几的文本
     */
    private let weekdays: Array<String> = ["日", "一", "二", "三", "四", "五", "六"]

    /**
     * 点击日期事件回调
     */
    public var select: (date: DateTime) -> Unit = {_ =>}

    /**
     * 点击确认按钮事件回调
     */
    public var confirm: (date: ?DateTime, dates: ArrayList<DateTime>, range: ?(DateTime, DateTime)) -> Unit = {
        _, _, _ =>
    }

    /**
     * 点击取消按钮事件回调
     */
    public var cancel: () -> Unit = {=>}

    /**
     * 月份变化事件回调
     */
    public var monthChange: (month: DateTime) -> Unit = {_ =>}

    private var heightArr: Array<Length> = Array<Length>()

    /**
     * 组件初始化
     */
    protected override func aboutToAppear() {
        let today = DateTime.now()

        // 初始化选中日期
        if (props.typeValue == SilkCalendarType.SINGLE) {
            if (props.defaultDate.isSome()) {
                // 如果有默认日期，使用默认日期
                selectedDate = props.defaultDate
            } else if (props.minDate.isSome() && props.maxDate.isSome()) {
                // 如果设置了日期范围且没有默认日期，则默认选中最大日期
                selectedDate = Option.Some(props.maxDate.getOrThrow())
            } else {
                // 如果没有指定范围或默认日期，默认选中今天
                selectedDate = Option.Some(today)
                // 注意：不需要在这里调用 updateDateSelection，因为 initMonthsData 会创建所有日期，
                // 并且 createDay 方法会根据 selectedDate 自动设置选中状态
            }
        } else if (props.typeValue == SilkCalendarType.MULTIPLE) {
            selectedDates = props.defaultDates ?? ArrayList([today])
        } else if (props.typeValue == SilkCalendarType.RANGE) {
            selectedRange = props.defaultDateRange ?? (today, today.addDays(1))
        }

        // 初始化当前月份
        if (props.typeValue == SilkCalendarType.SINGLE && selectedDate.isSome()) {
            currentMonth = selectedDate.getOrThrow()
        } else if (props.typeValue == SilkCalendarType.MULTIPLE && !selectedDates.isEmpty()) {
            currentMonth = selectedDates.get(0).getOrThrow()
        } else if (props.typeValue == SilkCalendarType.RANGE && selectedRange.isSome()) {
            currentMonth = selectedRange.getOrThrow()[0]
        } else if (props.minDate.isSome() && props.maxDate.isSome()) {
            // 如果设置了自定义日期范围，则使用最大日期所在的月份作为当前月份
            // 创建一个新的DateTime对象，只保留年和月
            currentMonth = DateTime.of(year: props.maxDate.getOrThrow().year,
                month: props.maxDate.getOrThrow().monthValue, dayOfMonth: 1)
        } else if (props.minDate.isSome()) {
            // 如果只设置了最小日期，则使用最小日期作为当前月份
            currentMonth = props.minDate.getOrThrow()
        } else {
            currentMonth = today
        }

        // 确保月份数据已初始化
        initMonthsData()
        AppLog.info("======数据长度：${monthsData.size}")
        // 初始化元素高度数组
        heightArr = Array<Length>(monthsData.size, item: 0.vp)

        // 初始化显示在标题上的月份
        if (displayTitleMonth.year == 1970) {
            if (monthsData.size > 0) {
                displayTitleMonth = monthsData[0].month
            } else {
                displayTitleMonth = currentMonth
            }
        }
    }

    /**
     * 获取当前月份的日期数组
     *
     * 该方法会生成一个包含当前月份所有日期的数组，同时还会包含上个月和下个月的部分日期，
     * 以填充日历的第一行和最后一行。
     *
     * 生成的日期数组会包含以下信息：
     * - 日期对象
     * - 是否为当前月份
     * - 是否为今天
     * - 是否被选中
     * - 是否被禁用
     * - 日期文本
     * - 底部提示文本
     * - 顶部提示文本
     *
     * @return 当前月份的日期数组，包含上个月和下个月的部分日期
     */
    private func getMonthDays(): ArrayList<SilkCalendarDay> {
        return getMonthDaysForDate(currentMonth)
    }

    /**
     * 创建日期对象
     *
     * 该方法会根据传入的日期和是否为当前月份，创建一个SilkCalendarDay对象。
     * 创建过程中会进行以下处理：
     * 1. 判断是否为今天
     * 2. 判断是否被禁用（小于最小日期、大于最大日期或被过滤函数过滤）
     * 3. 判断是否被选中（根据不同的选择模式进行判断）
     * 4. 格式化日期文本
     *
     * @param date 日期对象，表示要创建的日期
     * @param isCurrentMonth 是否为当前月份，用于区分当前月份和上/下个月的日期
     * @return 创建的SilkCalendarDay对象，包含日期的各种状态信息
     */
    private func createDay(date: DateTime, isCurrentMonth: Bool): SilkCalendarDay {
        let today = DateTime.now()
        AppLog.info(
            "当前日期-年：${today.year} 月：${today.monthValue} 日：${today.dayOfMonth} 周几：${today.dayOfWeek}")
        let isToday = date.year == today.year && date.monthValue == today.monthValue && date.dayOfMonth == today
            .dayOfMonth

        // 检查日期是否在指定范围内
        // 只有当日期小于最小日期或大于最大日期，或者被过滤函数过滤时，才禁用日期
        var isDisabled = false

        // 当mode为month或yearmonth时，如果不传递选择范围，则所有日期都可选
        let isSwitchMode = props.mode == SilkCalendarMode.MONTH || props.mode == SilkCalendarMode.YEAR_MONTH

        if (!isSwitchMode) {
            // 检查是否小于最小日期
            if (props.minDate.isSome() && date < props.minDate.getOrThrow()) {
                isDisabled = true
                AppLog.info("日期 ${date} 小于最小日期 ${props.minDate.getOrThrow()}, 禁用")
            }

            // 检查是否是今天之前的日期（不包括今天）
            let isBeforeToday = date.year < today.year || (date.year == today.year && date.monthValue < today.monthValue) ||
                (date.year == today.year && date.monthValue == today.monthValue && date.dayOfMonth < today.dayOfMonth)

            // 只有在没有指定日期范围时，才禁用今天之前的日期
            let hasCustomRange = props.minDate.isSome() && props.maxDate.isSome()

            // 如果没有指定日期范围，且是今天之前的日期（不包括今天），则禁用
            if (!hasCustomRange && isBeforeToday && !isToday) {
                isDisabled = true
                AppLog.info("日期 ${date} 是今天之前的日期, 禁用")
            }

            // 检查是否大于最大日期
            if (props.maxDate.isSome() && date > props.maxDate.getOrThrow()) {
                isDisabled = true
                AppLog.info("日期 ${date} 大于最大日期 ${props.maxDate}, 禁用")
            }
        } else {
            // 在切换模式下，只有当明确设置了minDate和maxDate时才进行范围检查
            if (props.minDate.isSome() && date < props.minDate.getOrThrow()) {
                isDisabled = true
            }

            if (props.maxDate.isSome() && date > props.maxDate.getOrThrow()) {
                isDisabled = true
            }
        }

        // 检查是否被过滤函数过滤（无论什么模式都应用过滤函数）
        if (!props.filter(date)) {
            isDisabled = true
            AppLog.info("日期 ${date} 被过滤函数过滤, 禁用")
        }

        // 不再禁用今天之前的日期
        // 让用户可以选择任何在minDate和maxDate范围内的日期

        AppLog.info("日期 ${date} 是否禁用: ${isDisabled}")

        // 确定日期类型
        var dayType = SilkCalendarDayType.NORMAL
        // 标识
        var dayTopInfo: String = String.empty

        var dayBottomInfo: String = String.empty

        if (isDisabled) {
            dayType = SilkCalendarDayType.DISABLED
        } else if (props.typeValue == SilkCalendarType.SINGLE) {
            if (selectedDate.isSome() && isSameDay(date, selectedDate.getOrThrow())) {
                dayType = SilkCalendarDayType.SELECTED
            }
        } else if (props.typeValue == SilkCalendarType.MULTIPLE) {
            // 使用循环检查日期是否在选中列表中
            for (i in 0..selectedDates.size) {
                let d = selectedDates.get(i).getOrThrow()
                if (isSameDay(date, d)) {
                    dayType = SilkCalendarDayType.MULTIPLE_SELECTED
                    break
                }
            }
        } else if (props.typeValue == SilkCalendarType.RANGE) {
            if (selectedRange.isSome()) {
                let (start, end) = selectedRange.getOrThrow()

                if (isSameDay(date, start) && isSameDay(date, end)) {
                    // 开始和结束是同一天
                    dayType = SilkCalendarDayType.START_END
                } else if (isSameDay(date, start)) {
                    // 开始日期
                    dayType = SilkCalendarDayType.START
                    dayBottomInfo = "开始"
                } else if (isSameDay(date, end)) {
                    // 结束日期
                    dayType = SilkCalendarDayType.END
                    dayBottomInfo = "结束"
                } else if (date > start && date < end) {
                    // 中间日期
                    dayType = SilkCalendarDayType.MIDDLE
                }
            } else if (tempRangeStart.isSome() && isSameDay(date, tempRangeStart.getOrThrow())) {
                // 临时选择的开始日期
                dayType = SilkCalendarDayType.START
            }
        }

        // 如果不是当前月份，则设置为占位符
        if (!isCurrentMonth) {
            dayType = SilkCalendarDayType.PLACEHOLDER
        }

        let day = SilkCalendarDay(
            typeValue: dayType,
            date: date,
            text: date.dayOfMonth.toString(),
            bottomInfo: dayBottomInfo,
            topInfo: dayTopInfo,
            isDisabled: isDisabled,
        )

        day.isCurrentMonth = isCurrentMonth

        if (props.formatter.isSome()) {
            return props.formatter.getOrThrow()(day)
        } else {
            return day
        }
    }

    /**
     * 获取指定月份的天数
     *
     * 该方法会根据传入的年份和月份，计算该月份的天数。
     * 计算过程会考虑闰年的情况：
     * - 2月：闰年29天，平年28天
     * - 4、6、9、11月：30天
     * - 其他月份：31天
     *
     * 闰年的判断规则：
     * 1. 能被4整除但不能被100整除的年份是闰年
     * 2. 能被400整除的年份是闰年
     *
     * @param year 年份，如2025
     * @param month 月份，范围为1-12，1表示1月，12表示12月
     * @return 该月份的天数，范围为28-31
     */
    private func getDaysInMonth(year: Int32, month: Int32): Int32 {
        if (month == 2) {
            // 闰年2月有29天
            if (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) {
                return 29
            } else {
                return 28
            }
        } else if (month == 4 || month == 6 || month == 9 || month == 11) {
            return 30
        } else {
            return 31
        }
    }

    /**
     * 判断两个日期是否为同一天
     *
     * 该方法会比较两个日期的年、月、日是否相同，如果都相同则认为是同一天。
     * 这个方法在以下场景中使用：
     * 1. 判断日期是否为今天
     * 2. 判断日期是否被选中
     * 3. 判断日期范围的起止日期
     *
     * 注意：该方法只比较年、月、日，不比较时、分、秒。
     *
     * @param date1 第一个日期对象
     * @param date2 第二个日期对象
     * @return 如果两个日期的年、月、日都相同，则返回true；否则返回false
     */
    private func isSameDay(date1: DateTime, date2: DateTime): Bool {
        return date1.year == date2.year && date1.monthValue == date2.monthValue && date1.dayOfMonth == date2.dayOfMonth
    }

    /**
     * 处理日期点击事件
     *
     * 该方法会根据日历的选择模式（单选、多选、范围选择）处理日期点击事件。
     *
     * 单选模式：
     * - 选中点击的日期
     * - 触发select事件
     * - 如果closeOnClickDay为true，则关闭日历并触发confirm事件
     *
     * 多选模式：
     * - 如果日期已选中，则取消选中
     * - 如果日期未选中，则添加选中（如果未超过最大可选天数）
     * - 触发select事件
     * - 如果closeOnClickDay为true，则关闭日历并触发confirm事件
     *
     * 范围选择模式：
     * - 如果未选择开始日期，则选择开始日期
     * - 如果已选择开始日期，则选择结束日期
     *   - 如果结束日期早于开始日期，则交换两个日期
     *   - 检查日期范围是否符合要求（最小范围、最大范围、是否允许选择同一天）
     * - 触发select事件
     * - 如果closeOnClickDay为true，则关闭日历并触发confirm事件
     *
     * @param day 被点击的日期对象，包含日期的各种状态信息
     */
    private func handleDayClick(day: SilkCalendarDay) {
        if (day.isDisabled || props.readonly) {
            return
        }
        let date = day.date

        if (props.typeValue == SilkCalendarType.SINGLE) {
            // 先清除所有选中状态
            updateDateSelection(selectedDate ?? DateTime.now(), false, updateAll: true)

            // 设置新的选中状态
            selectedDate = Option.Some(date)

            // 强制更新所有月份数据，确保选中状态正确
            for (i in 0..monthsData.size) {
                let monthData = monthsData[i]
                for (j in 0..monthData.days.size) {
                    let day = monthData.days[j]

                    // 只处理非占位符的日期
                    if (day.typeValue != SilkCalendarDayType.PLACEHOLDER) {
                        if (isSameDay(day.date, date)) {
                            day.typeValue = SilkCalendarDayType.SELECTED
                        } else if (!day.isDisabled) {
                            day.typeValue = SilkCalendarDayType.NORMAL
                        }
                    }
                }
            }

            select(date)

            if (!props.showConfirm) {
                visible = false
                selectedTopHeight = 0.vp
                offsetTopList = 0.vp
                confirm(selectedDate, ArrayList<DateTime>(), Option.None)
            }
        } else if (props.typeValue == SilkCalendarType.MULTIPLE) {
            // 检查是否已经选中
            var index = -1
            for (i in 0..selectedDates.size) {
                let d = selectedDates.get(i).getOrThrow()
                if (isSameDay(d, date)) {
                    index = i
                    break
                }
            }

            if (index >= 0) {
                // 已选中，取消选中
                selectedDates.remove(index)
                updateDateSelection(date, false)
            } else {
                // 未选中，添加选中
                // 检查是否超过最大可选天数
                if (props.maxRange.isSome() && Int32(selectedDates.size) >= props.maxRange.getOrThrow()) {
                    return
                }

                selectedDates.append(date)
                updateDateSelection(date, true)
            }

            select(date)

            if (!props.showConfirm) {
                visible = false
                selectedTopHeight = 0.vp
                offsetTopList = 0.vp
                confirm(Option.None, selectedDates, Option.None)
            }
        } else if (props.typeValue == SilkCalendarType.RANGE) {
            if (tempRangeStart.isNone()) {
                // 清除之前的选择范围
                if (selectedRange.isSome()) {
                    let (rangeStart, rangeEnd) = selectedRange.getOrThrow()

                    // 计算范围内的所有日期并清除选中状态
                    var currentDate = rangeStart
                    while (currentDate <= rangeEnd) {
                        updateDateSelection(currentDate, false)
                        currentDate = currentDate.addDays(1)
                    }

                    selectedRange = Option.None
                }

                // 选择开始日期
                tempRangeStart = Option.Some(date)
                updateDateSelection(date, true)
                select(date)
            } else {
                // 选择结束日期
                let start = tempRangeStart.getOrThrow()

                // 如果结束日期早于开始日期，交换两个日期
                let (rangeStart, rangeEnd) = if (date < start) {
                    (date, start)
                } else {
                    // 检查日期范围是否符合要求
                    let days = (date.toUnixTimeStamp().toMilliseconds() - start.toUnixTimeStamp().toMilliseconds()) / (24 *
                        60 * 60 * 1000)

                    if (days < Int64(props.minRange)) {
                        // 日期范围太小
                        return
                    }

                    if (props.maxRange.isSome() && days > Int64(props.maxRange.getOrThrow())) {
                        // 日期范围太大
                        return
                    }

                    // 如果选择了同一天，且不允许选择同一天
                    if (isSameDay(date, start) && !props.allowSameDay) {
                        return
                    }

                    (start, date)
                }

                selectedRange = Option.Some((rangeStart, rangeEnd))

                // 设置范围内所有日期的选中状态
                var currentDate = rangeStart
                while (currentDate <= rangeEnd) {
                    updateDateSelection(currentDate, true)
                    currentDate = currentDate.addDays(1)
                }

                tempRangeStart = Option.None
                select(date)

                if (!props.showConfirm) {
                    visible = false
                    selectedTopHeight = 0.vp
                    offsetTopList = 0.vp
                    confirm(Option.None, ArrayList<DateTime>(), selectedRange)
                }
            }
        }
    }

    /**
     * 处理月份变化事件
     *
     * @param offset 月份偏移量
     */
    private func handleMonthChange(offset: Int64) {
        let newMonth = currentMonth.addMonths(offset)
        AppLog.info("======执行了切换月份======年${newMonth.year}==${newMonth.monthValue}")
        currentMonth = newMonth
        monthChange(currentMonth)

        // 清空现有数据
        monthsData.clear()

        // 重新生成当前月份的数据
        let days = ArrayList<SilkCalendarDay>()
        let monthDays = getMonthDaysForDate(newMonth)

        // 将ArrayList转换为ObservedArray
        for (j in 0..monthDays.size) {
            days.append(monthDays.get(j).getOrThrow())
        }

        let monthData = MonthData(month: newMonth, days: ObservedArray(days.toArray()))
        monthsData.append(monthData)
        currentMonthIndex = 0

        // 更新显示在标题上的月份
        displayTitleMonth = newMonth
    }

    /**
     * 处理年份变化事件
     *
     * @param offset 年份偏移量
     */
    private func handleYearChange(offset: Int64) {
        let newMonth = currentMonth.addYears(offset)
        currentMonth = newMonth
        monthChange(currentMonth)

        // 清空现有数据
        monthsData.clear()

        // 重新生成当前月份的数据
        let days = ArrayList<SilkCalendarDay>()
        let monthDays = getMonthDaysForDate(newMonth)

        // 将ArrayList转换为ObservedArray
        for (j in 0..monthDays.size) {
            days.append(monthDays.get(j).getOrThrow())
        }

        let monthData = MonthData(month: newMonth, days: ObservedArray(days.toArray()))
        monthsData.append(monthData)
        currentMonthIndex = 0

        // 更新显示在标题上的月份
        displayTitleMonth = newMonth
    }

    /**
     * 处理确认按钮点击事件
     */
    private func handleConfirm() {
        visible = false
        selectedTopHeight = 0.vp
        offsetTopList = 0.vp
        confirm(selectedDate, selectedDates, selectedRange)
    }

    /**
     * 处理取消按钮点击事件
     */
    private func handleCancel() {
        visible = false
        selectedTopHeight = 0.vp
        offsetTopList = 0.vp
        cancel()
    }

    /**
     * 显示日历
     */
    public func show() {
        // 确保月份数据已初始化
        if (monthsData.isEmpty()) {
            updateMonthData(currentMonth)
        }

        // 确保显示在标题上的月份被正确初始化
        if (displayTitleMonth.year == 1970) {
            if (monthsData.size > 0) {
                displayTitleMonth = monthsData[0].month
            } else {
                displayTitleMonth = currentMonth
            }
        }

        visible = true
    }

    /**
     * 隐藏日历
     */
    public func hide() {
        visible = false
        selectedTopHeight = 0.vp
        offsetTopList = 0.vp
    }

    /**
     * 重置选中状态
     */
    public func reset() {
        selectedDate = Option.None
        selectedDates = ArrayList<DateTime>()
        selectedRange = Option.None
        tempRangeStart = Option.None
    }

    /**
     * 渲染标题
     */
    @Builder
    private func renderTitle() {
        if (props.showTitle) {
            if (hasTitle) {
                Title()
            } else {
                Row() {
                    Text(ResourceStrToString(props.title))
                        .fontSize(getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_HEADER_TITLE_FONT_SIZE))
                        .fontColor(ResourceColorToColor(getColorConstant(SilkColorKey.TEXT_COLOR)))
                        .fontWeight(__SilkFontWeight)
                        .lineHeight(getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_HEADER_TITLE_HEIGHT))
                }
                    .width(100.percent)
                    .height(getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_HEADER_TITLE_HEIGHT))
                    .justifyContent(FlexAlign.Center)
            }
        }
    }

    /**
     * 渲染月份导航
     */
    @Builder
    private func renderMonthTitle() {
        // 在平铺模式下不显示月份导航，因为每个月份都会显示自己的标题
        if (props.showMonthTitle) {
            Row() {
                Row() {
                    if (props.mode == SilkCalendarMode.YEAR_MONTH) {
                        // 显示左箭头（上个月）
                        Row() {
                            SilkIcon(
                                name: "arrow-double-left",
                                fontSize: getCalendarSizeConstant(
                                    SilkCalendarSizeKey.CALENDAR_HEADER_SUBTITLE_FONT_SIZE),
                                fontColor: if (!props.minDate.isSome() || (props.minDate.isSome() &&
                                    currentMonth.addYears(-1) >= props.minDate.getOrThrow())) {
                                    getCalendarColorConstant(SilkCalendarColorKey.CALENDAR_HEADER_ACTION_COLOR)
                                } else {
                                    getCalendarColorConstant(SilkCalendarColorKey.CALENDAR_HEADER_ACTION_DISABLED_COLOR)
                                }
                            )
                        }
                            .constraintSize(
                                minWidth: getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_HEADER_ACTION_WIDTH))
                            .justifyContent(FlexAlign.Center)
                            .onClick({_ => handleYearChange(-1)})
                            .enabled(
                                !props.minDate.isSome() || (props.minDate.isSome() && currentMonth.addYears(-1) >=
                                    props.minDate.getOrThrow()))
                    }
                    if (props.mode != SilkCalendarMode.NONE) {
                        // 显示左箭头（上个月）
                        Row() {
                            SilkIcon(
                                name: "arrow-left",
                                fontSize: getCalendarSizeConstant(
                                    SilkCalendarSizeKey.CALENDAR_HEADER_SUBTITLE_FONT_SIZE),
                                fontColor: if (!props.minDate.isSome() || (props.minDate.isSome() &&
                                    currentMonth.addMonths(-1) >= props.minDate.getOrThrow())) {
                                    getCalendarColorConstant(SilkCalendarColorKey.CALENDAR_HEADER_ACTION_COLOR)
                                } else {
                                    getCalendarColorConstant(SilkCalendarColorKey.CALENDAR_HEADER_ACTION_DISABLED_COLOR)
                                }
                            )
                        }
                            .constraintSize(
                                minWidth: getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_HEADER_ACTION_WIDTH))
                            .justifyContent(FlexAlign.Center)
                            .onClick({_ => handleMonthChange(-1)})
                            .enabled(
                                props.mode == SilkCalendarMode.MONTH || props.mode == SilkCalendarMode.YEAR_MONTH ||
                                    !props.minDate.isSome() || (props.minDate.isSome() && currentMonth.addMonths(-1) >=
                                    props.minDate.getOrThrow()))
                    }
                }.justifyContent(FlexAlign.Start).alignItems(VerticalAlign.Center)
                // 年月显示
                Text("${displayTitleMonth.year}年${displayTitleMonth.monthValue}月")
                    .fontSize(getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_HEADER_SUBTITLE_FONT_SIZE))
                    .fontColor(ResourceColorToColor(getColorConstant(SilkColorKey.TEXT_COLOR)))
                    .fontWeight(__SilkFontWeight)
                    .lineHeight(getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_HEADER_TITLE_HEIGHT))
                    .layoutWeight(1)
                    .textAlign(TextAlign.Center)
                Row() {
                    if (props.mode != SilkCalendarMode.NONE) {
                        // 显示右箭头（上个月）
                        Row() {
                            SilkIcon(
                                name: "arrow",
                                fontSize: getCalendarSizeConstant(
                                    SilkCalendarSizeKey.CALENDAR_HEADER_SUBTITLE_FONT_SIZE),
                                fontColor: if (!props.maxDate.isSome() || (props.maxDate.isSome() &&
                                    currentMonth.addMonths(1) <= props.maxDate.getOrThrow())) {
                                    getCalendarColorConstant(SilkCalendarColorKey.CALENDAR_HEADER_ACTION_COLOR)
                                } else {
                                    getCalendarColorConstant(SilkCalendarColorKey.CALENDAR_HEADER_ACTION_DISABLED_COLOR)
                                }
                            )
                        }
                            .constraintSize(
                                minWidth: getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_HEADER_ACTION_WIDTH))
                            .justifyContent(FlexAlign.Center)
                            .onClick({_ => handleMonthChange(1)})
                            .enabled(
                                props.mode == SilkCalendarMode.MONTH || props.mode == SilkCalendarMode.YEAR_MONTH ||
                                    !props.maxDate.isSome() || (props.maxDate.isSome() && currentMonth.addMonths(1) <=
                                    props.maxDate.getOrThrow()))
                    }
                    if (props.mode == SilkCalendarMode.YEAR_MONTH) {
                        // 显示左箭头（上个月）
                        Row() {
                            SilkIcon(
                                name: "arrow-double-right",
                                fontSize: getCalendarSizeConstant(
                                    SilkCalendarSizeKey.CALENDAR_HEADER_SUBTITLE_FONT_SIZE),
                                fontColor: if (!props.maxDate.isSome() || (props.maxDate.isSome() &&
                                    currentMonth.addMonths(1) <= props.maxDate.getOrThrow())) {
                                    getCalendarColorConstant(SilkCalendarColorKey.CALENDAR_HEADER_ACTION_COLOR)
                                } else {
                                    getCalendarColorConstant(SilkCalendarColorKey.CALENDAR_HEADER_ACTION_DISABLED_COLOR)
                                }
                            )
                        }
                            .constraintSize(
                                minWidth: getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_HEADER_ACTION_WIDTH))
                            .justifyContent(FlexAlign.Center)
                            .onClick({_ => handleYearChange(1)})
                            .enabled(
                                !props.maxDate.isSome() || (props.maxDate.isSome() && currentMonth.addYears(1) <=
                                    props.maxDate.getOrThrow()))
                    }
                }.justifyContent(FlexAlign.End).alignItems(VerticalAlign.Center)
            }
                .width(100.percent)
                .padding(left: getSizeConstant(SilkSizeKey.PADDING_BASE),
                    right: getSizeConstant(SilkSizeKey.PADDING_BASE))
                .alignItems(VerticalAlign.Center)
                .height(getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_TITLE_HEIGHT))
        }
    }

    /**
     * 渲染星期栏
     */
    @Builder
    private func renderWeekdays() {
        if (props.showWeekday) {
            Row() {
                // 根据firstDayOfWeek调整星期显示顺序
                ForEach(
                    Array<Int8>(7, item: 0),
                    itemGeneratorFunc: {
                        _: Int8, index: Int64 => Text(weekdays[(index + props.firstDayOfWeek) % 7])
                            .fontSize(getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_WEEKDAY_FONT_SIZE))
                            .fontColor(
                                ResourceColorToColor(
                                    getCalendarColorConstant(SilkCalendarColorKey.CALENDAR_WEEKDAY_TEXT_COLOR)))
                            .textAlign(TextAlign.Center)
                            .lineHeight(getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_WEEKDAY_HEIGHT))
                            .width(Length(100 / 7, unitType: LengthType.percent))
                    }
                )
            }.width(100.percent).height(getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_WEEKDAY_HEIGHT))
        }
    }

    @Builder
    private func renderHeader() {
        Column() {
            renderTitle()
            renderMonthTitle()
            renderWeekdays()
        }.width(100.percent).margin(bottom: 10.px).shadow(radius: 10, color: Color(0x297d7e80), offsetY: 2)
    }

    /**
     * 存储多个月份的日期数据
     */
    @State
    @Watch[change]
    var monthsData: ObservedArrayList<MonthData> = ObservedArrayList<MonthData>()
    private func change() {
        AppLog.info("======change")
    }
    /**
     * 当前显示的月份索引
     */
    @State
    var currentMonthIndex: Int64 = 0

    /**
     * 当前显示在标题上的月份
     */
    @State
    var displayTitleMonth: DateTime = DateTime.now()

    /**
     * 初始化月份数据
     */
    private func initMonthsData() {
        if (monthsData.isEmpty()) {
            // 在平铺模式下，加载多个月份的数据
            if (props.mode == SilkCalendarMode.NONE) {
                // 平铺模式下，一次性加载多个月份的数据
                // 判断是否有指定日期范围
                let hasCustomRange = props.minDate.isSome() && props.maxDate.isSome()

                if (props.poppable) {
                    // 如果没有指定范围，从当前月份开始，加载7个月的数据（当前月份及之后的6个月）
                    // 如果指定了范围，则加载范围内的月份
                    let monthCount = if (hasCustomRange) {
                        // 计算范围内的月份数
                        let minDate = props.minDate.getOrThrow()
                        let maxDate = props.maxDate.getOrThrow()
                        let monthDiff = (maxDate.year - minDate.year) * 12 + (maxDate.monthValue - minDate.monthValue) +
                            1
                        Int64(monthDiff)
                    } else {
                        AppLog.info("======执行这里")
                        7 // 默认加载7个月
                    }

                    let startMonth = if (hasCustomRange) {
                        // 从最小日期所在月份开始
                        let minDate = props.minDate.getOrThrow()
                        DateTime.of(year: minDate.year, month: minDate.monthValue, dayOfMonth: 1)
                    } else {
                        // 从当前月份开始
                        currentMonth
                    }

                    for (i in 0..monthCount) {
                        let month = startMonth.addMonths(i)
                        AppLog.info("======month: ${month.monthValue},===最大值${props.maxDate?.monthValue}")
                        // 确保月份不超过最大日期props.maxDate.isNone() || month <= props.maxDate.getOrThrow()
                        if (props.maxDate.isNone() || month <= props.maxDate.getOrThrow()) {
                            let days = ArrayList<SilkCalendarDay>()
                            let monthDays = getMonthDaysForDate(month)

                            // 将ArrayList转换为ObservedArray
                            for (j in 0..monthDays.size) {
                                days.append(monthDays.get(j).getOrThrow())
                            }

                            let monthData = MonthData(month: month, days: ObservedArray(days.toArray()))
                            monthsData.append(monthData)
                        }
                    }
                } else {
                    // 如果没有指定范围，从当前月份开始，加载11个月的数据（当前月份及之后的10个月）
                    // 如果指定了范围，则加载范围内的月份
                    let monthCount = if (hasCustomRange) {
                        // 计算范围内的月份数
                        let minDate = props.minDate.getOrThrow()
                        let maxDate = props.maxDate.getOrThrow()
                        let monthDiff = (maxDate.year - minDate.year) * 12 + (maxDate.monthValue - minDate.monthValue) +
                            1
                        Int64(monthDiff)
                    } else {
                        11 // 默认加载11个月
                    }

                    let startMonth = if (hasCustomRange) {
                        // 从最小日期所在月份开始
                        let minDate = props.minDate.getOrThrow()
                        DateTime.of(year: minDate.year, month: minDate.monthValue, dayOfMonth: 1)
                    } else {
                        // 从当前月份开始
                        currentMonth
                    }

                    for (i in 0..monthCount) {
                        let month = startMonth.addMonths(i)
                        // 确保月份不超过最大日期
                        if (props.maxDate.isNone() || month <= props.maxDate.getOrThrow()) {
                            let days = ArrayList<SilkCalendarDay>()
                            let monthDays = getMonthDaysForDate(month)

                            // 将ArrayList转换为ObservedArray
                            for (j in 0..monthDays.size) {
                                days.append(monthDays.get(j).getOrThrow())
                            }

                            let monthData = MonthData(month: month, days: ObservedArray(days.toArray()))
                            monthsData.append(monthData)
                        }
                    }
                }
            } else {
                // 非平铺模式，只加载当前月份
                let days = ArrayList<SilkCalendarDay>()
                let monthDays = getMonthDaysForDate(currentMonth)

                // 将ArrayList转换为ObservedArray
                for (j in 0..monthDays.size) {
                    days.append(monthDays.get(j).getOrThrow())
                }

                let monthData = MonthData(month: currentMonth, days: ObservedArray(days.toArray()))
                monthsData.append(monthData)
            }
        }
    }

    /**
     * 获取指定日期所在月份的日期数组
     */
    private func getMonthDaysForDate(date: DateTime): ArrayList<SilkCalendarDay> {
        let days = ArrayList<SilkCalendarDay>()

        // 获取当前月份的第一天
        let firstDay = DateTime.of(year: date.year, month: date.monthValue, dayOfMonth: 1)

        // 获取当前月份的天数
        let daysInMonth = getDaysInMonth(Int32(date.year), Int32(date.monthValue))

        // 获取当前月份第一天是周几
        let firstDayOfWeek = firstDay.dayOfWeek.value()

        // 添加空白占位符，用于填充第一行前面的空白
        let count = (firstDayOfWeek - props.firstDayOfWeek + 7) % 7

        for (i in 0..count) {
            // 创建一个空的日期对象作为占位符
            let emptyDay = SilkCalendarDay(
                typeValue: SilkCalendarDayType.PLACEHOLDER,
                date: DateTime.now(), // 日期不重要，因为不会显示
                text: "",
                bottomInfo: Option.None,
                topInfo: Option.None,
                isDisabled: true
            )
            days.append(emptyDay)
        }

        // 添加当前月份的日期
        for (i in 1..=daysInMonth) {
            let date = DateTime.of(year: date.year, month: date.monthValue, dayOfMonth: Int64(i))
            days.append(createDay(date, true))
        }

        // 计算需要添加的空白占位符数量，用于填充最后一行
        let remainingDays = 7 - (days.size % 7)
        if (remainingDays < 7) {
            // 添加空白占位符
            for (i in 1..=remainingDays) {
                // 创建一个空的日期对象作为占位符
                let emptyDay = SilkCalendarDay(
                    typeValue: SilkCalendarDayType.PLACEHOLDER,
                    date: DateTime.now(), // 日期不重要，因为不会显示
                    text: "",
                    bottomInfo: Option.None,
                    topInfo: Option.None,
                    isDisabled: true
                )
                days.append(emptyDay)
            }
        }

        return days
    }

    /**
     * 判断是否需要渲染月份标题
     *
     * 在以下情况不渲染月份标题：
     * 1. 在列表视图中不渲染月份标题
     * 2. 当指定了日期范围，并且范围属于同一个月内时不渲染月份标题
     * 3. 当poppable为false时，不展示第一个月份的月份标题
     *
     * @param monthData 月份数据
     * @return 是否需要渲染月份标题
     */
    private func shouldRenderMonthTitle(monthData: MonthData): Bool {
        // 判断是否是列表视图
        //        let isListView = true // 假设当前是列表视图

        // 判断是否是同一个月内的日期范围
        let isDefaultMaxDate = props.maxDate == DateTime.now().addMonths(6)
        let isSameMonthRange = props.minDate.isSome() && props.maxDate.isSome() && !isDefaultMaxDate && isSameMonth(
            props.minDate.getOrThrow(), props.maxDate.getOrThrow())

        // 判断是否是第一个月份且(poppable为false 或者是快捷选择)
        let isFirstMonthAndNotPoppable = (!props.poppable || !props.showConfirm) && monthsData.size > 0 && isSameMonth(
            monthsData[0].month, monthData.month)

        // 如果是列表视图或者是同一个月内的日期范围或者是第一个月份且poppable为false，则不渲染月份标题
        return !isSameMonthRange && !isFirstMonthAndNotPoppable && props.mode == SilkCalendarMode.NONE
    }

    private var selectedTopHeight: Length = 0.vp
    /**
     * 渲染单个月份
     */
    @Builder
    private func renderMonth(monthData: MonthData) {
        Column() {
            // 如果需要渲染月份标题，则渲染
            if (shouldRenderMonthTitle(monthData)) {
                // 月份标题
                Text(formatYearMonth(monthData.month))
                    .fontSize(getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_MONTH_TITLE_FONT_SIZE))
                    .fontColor(ResourceColorToColor(getColorConstant(SilkColorKey.TEXT_COLOR)))
                    .height(getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_HEADER_TITLE_HEIGHT))
                    .lineHeight(getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_HEADER_TITLE_HEIGHT))
                    .fontWeight(__SilkFontWeight)
            }

            // 日期网格
            Stack() {
                if (props.showMark) {
                    Text(monthData.month.monthValue.toString())
                        .fontSize(getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_MONTH_MARK_FONT_SIZE))
                        .fontColor(
                            ResourceColorToColor(
                                getCalendarColorConstant(SilkCalendarColorKey.CALENDAR_MONTH_MARK_COLOR)))
                }
                Grid() {
                    // 按每行7个日期进行分组
                    ForEach(
                        monthData.days,
                        itemGeneratorFunc: {
                            day: SilkCalendarDay, rowIndex: Int64 => GridItem() {
                                Row() {
                                    renderDay(day)
                                }
                                    .width(100.percent)
                                    .height(props.rowHeight)
                                    .onAreaChange(
                                        {
                                            _, area => if ((day.typeValue == SilkCalendarDayType.SELECTED ||
                                                day.typeValue == SilkCalendarDayType.START || day.typeValue == SilkCalendarDayType
                                                .END || day.typeValue == SilkCalendarDayType.START_END ||
                                                day.typeValue == SilkCalendarDayType.MULTIPLE_SELECTED) && visible &&
                                                selectedTopHeight.value == 0.0) {
                                                selectedTopHeight = Length(area.globalPosition.y,
                                                    unitType: LengthType.px)
                                                if (offsetTopList.value > 0.0) {
                                                    scrollController.scrollTo(
                                                        xOffset: 0.vp,
                                                        yOffset: Length(selectedTopHeight.value - offsetTopList.value,
                                                            unitType: LengthType.px)
                                                    )
                                                }
                                            }
                                        })
                            }.layoutWeight(1)
                        }
                    )
                }.columnsTemplate("1fr 1fr 1fr 1fr 1fr 1fr 1fr")
            }
        }.margin(bottom: 16.vp)
    }

    private var offsetY: Float64 = 0.0
    private var offsetTopList: Length = 0.vp
    private let scrollController: Scroller = Scroller()
    /**
     * 渲染日期网格
     */
    @Builder
    private func renderDays() {
        // 确保月份数据已初始化
        //        initMonthsData()

        List(scroller: scrollController) {
            ForEach(
                monthsData,
                itemGeneratorFunc: {
                    data: MonthData, index: Int64 => ListItem() {
                        renderMonth(data)
                    }.onAreaChange(
                        {
                            _, area => heightArr[index] = px2vp(Length(area.height, unitType: LengthType.px))
                                .getOrThrow()
                        })
                },
                keyGeneratorFunc: {
                    data: MonthData, index: Int64 => "${data.month.year}-${data.month.monthValue}-${index}"
                }
            )
        }
            .width(100.percent)
            .height(
                if (props.poppable && props.position == SilkCalendarPosition.RIGHT || props.position == SilkCalendarPosition
                    .LEFT) {
                    None
                } else {
                    Length(props.rowHeight.value * 5.0, unitType: props.rowHeight.unitType)
                })
            .scrollBar(BarState.Off)
            .edgeEffect(EdgeEffect.None)
            .onAreaChange(
                {
                    _, area: Area => if (visible && offsetTopList.value == 0.0) {
                        AppLog.info("======执行222==${area.globalPosition.y}");
                        offsetTopList = Length(area.globalPosition.y, unitType: LengthType.px)
                        if (selectedTopHeight.value > 0.0) {
                            scrollController.scrollTo(xOffset: 0.vp,
                                yOffset: Length(selectedTopHeight.value - offsetTopList.value, unitType: LengthType.px))
                        }
                    }
                })
            .onScroll(
                {
                    offset, state =>
                    // 计算当前可见的月份
                    // 计算总偏移
                    offsetY += offset

                    // 计算当前显示的月份索引
                    var hsum = 0.0
                    var visibleMonthIndex = 0
                    for (i in 0..heightArr.size) {
                        hsum += heightArr[i].value
                        if (offsetY < hsum) {
                            visibleMonthIndex = i
                            break;
                        }
                    }
                    // 检查是否需要更新标题
                    if (visibleMonthIndex >= 0 && visibleMonthIndex < monthsData.size &&
                        !isSameMonth(displayTitleMonth, monthsData[visibleMonthIndex].month)) {
                        // 更新标题月份
                        displayTitleMonth = monthsData[visibleMonthIndex].month
                    }
                }
            )
    }

    private func getTextFontColor(day: SilkCalendarDay) {
        if (day.isDisabled) {
            ResourceColorToColor(getCalendarColorConstant(SilkCalendarColorKey.CALENDAR_DAY_DISABLED_TEXT_COLOR))
        } else if (day.typeValue == SilkCalendarDayType.SELECTED || day.typeValue == SilkCalendarDayType.START ||
            day.typeValue == SilkCalendarDayType.END || day.typeValue == SilkCalendarDayType.START_END ||
            day.typeValue == SilkCalendarDayType.MULTIPLE_SELECTED) {
            ResourceColorToColor(getCalendarColorConstant(SilkCalendarColorKey.CALENDAR_DAY_SELECTED_TEXT_COLOR))
        } else {
            ResourceColorToColor(getCalendarColorConstant(SilkCalendarColorKey.CALENDAR_DAY_TEXT_COLOR))
        }
    }

    private func getMiddleBackgroundColor() {
        let originalColor = ResourceColorToColor(props.color)
        let originalColorValue = originalColor.toUInt32()

        // 提取RGB值
        let red = UInt8((originalColorValue >> 16) & 0xFF)
        let green = UInt8((originalColorValue >> 8) & 0xFF)
        let blue = UInt8(originalColorValue & 0xFF)

        // 创建新的半透明颜色
        Color(red, green, blue, alpha: 0.1)
    }

    /**
     * 渲染单个日期
     *
     * @param day 日期对象
     */
    @Builder
    private func renderDay(day: SilkCalendarDay) {
        if (hasDay) {
            Day(day)
        } else if (day.typeValue == SilkCalendarDayType.PLACEHOLDER) {
            // 对于占位符日期（上个月和下个月的日期），只渲染一个空白区域
            Column() {
            // 不显示任何内容
            }.width(100.percent).height(100.percent).backgroundColor(Color.TRANSPARENT)
        } else {
            RelativeContainer() {
                if (day.topInfo.isSome()) {
                    Text(day.topInfo.getOrThrow())
                        .fontSize(getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_INFO_FONT_SIZE))
                        .lineHeight(getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_INFO_LINE_HEIGHT))
                        .fontColor(getTextFontColor(day))
                        .id("daytop")
                        .alignRules(
                            AlignRuleOption(
                                top: VerticalAnchor("__container__", VerticalAlign.Top),
                                middle: HorizontalAnchor("__container__", HorizontalAlign.Center)
                            )
                        )
                        .offset(x: 0.vp, y: 6.vp)
                }

                Text(day.text)
                    .fontSize(getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_DAY_FONT_SIZE))
                    .fontColor(getTextFontColor(day))
                    .id("dayText")
                    .alignRules(
                        AlignRuleOption(
                            center: VerticalAnchor("__container__", VerticalAlign.Center),
                            middle: HorizontalAnchor("__container__", HorizontalAlign.Center)
                        )
                    )

                if (day.bottomInfo.isSome()) {
                    Text(day.bottomInfo.getOrThrow())
                        .fontSize(getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_INFO_FONT_SIZE))
                        .lineHeight(getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_INFO_LINE_HEIGHT))
                        .fontColor(getTextFontColor(day))
                        .id("daybottom")
                        .alignRules(
                            AlignRuleOption(
                                bottom: VerticalAnchor("__container__", VerticalAlign.Bottom),
                                middle: HorizontalAnchor("__container__", HorizontalAlign.Center)
                            )
                        )
                        .offset(x: 0.vp, y: Length(-6, unitType: LengthType.vp))
                }
            }
                .width(100.percent)
                .height(100.percent)
                .backgroundColor(
                    if (day.typeValue == SilkCalendarDayType.SELECTED || day.typeValue == SilkCalendarDayType.START ||
                        day.typeValue == SilkCalendarDayType.END || day.typeValue == SilkCalendarDayType.START_END ||
                        day.typeValue == SilkCalendarDayType.MULTIPLE_SELECTED) {
                        ResourceColorToColor(props.color)
                    } else if (day.typeValue == SilkCalendarDayType.MIDDLE) {
                        // 范围选择中间日期使用浅色背景
                        getMiddleBackgroundColor()
                    } else {
                        Color.TRANSPARENT
                    })
                .margin(bottom: getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_DAY_MARGIN_BOTTOM))
                .borderRadius(getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_DAY_RADIUS))
                .onClick({_ => handleDayClick(day)})
        }
    }

    /**
     * 渲染底部按钮
     */
    @Builder
    private func renderFooter() {
        if (!props.poppable) {
        } else if (hasFooter) {
            Footer()
        } else if (props.showConfirm) {
            Row() {
                SilkButton(
                    props: SilkButtonOptions(
                        buttonType: SilkButtonType.PRIMARY,
                        text: props.confirmText,
                        color: props.color,
                        size: SilkButtonSize.LARGE,
                        round: true
                    ),
                    click: {_ => handleConfirm()}
                )
            }
                .width(100.percent)
                .padding(16.vp)
                .justifyContent(FlexAlign.Center)
                .padding(left: getSizeConstant(SilkSizeKey.PADDING_MD), right: getSizeConstant(SilkSizeKey.PADDING_MD),
                    bottom: 30.vp)
        }
    }

    /**
     * 更新月份数据
     *
     * 该方法会根据当前月份更新monthsData，而不是清空重新加载。
     * 如果当前月份已经在monthsData中，则不做任何操作。
     * 如果当前月份不在monthsData中，则添加该月份的数据。
     *
     * @param newMonth 新的当前月份
     */
    private func updateMonthData(newMonth: DateTime) {
        // 检查当前月份是否已经在monthsData中
        var monthExists = false
        for (i in 0..monthsData.size) {
            if (isSameMonth(monthsData[i].month, newMonth)) {
                monthExists = true
                currentMonthIndex = i
                // 更新显示在标题上的月份
                displayTitleMonth = newMonth
                break
            }
        }

        // 如果当前月份不在monthsData中，则添加该月份的数据
        if (!monthExists) {
            // 在平铺模式下，一次性加载多个月份的数据
            if (props.mode == SilkCalendarMode.NONE) {
                // 清空现有数据
                monthsData.clear()

                // 判断是否有指定日期范围
                let hasCustomRange = props.minDate.isSome() && props.maxDate.isSome()

                // 加载新的月份数据
                if (props.poppable) {
                    // 如果没有指定范围，从当前月份开始，加载7个月的数据（当前月份及之后的6个月）
                    // 如果指定了范围，则加载范围内的月份
                    let monthCount = if (hasCustomRange) {
                        // 计算范围内的月份数
                        let minDate = props.minDate.getOrThrow()
                        let maxDate = props.maxDate.getOrThrow()
                        let monthDiff = (maxDate.year - minDate.year) * 12 + (maxDate.monthValue - minDate.monthValue) +
                            1
                        Int64(monthDiff)
                    } else {
                        7 // 默认加载7个月
                    }

                    let startMonth = if (hasCustomRange) {
                        // 从最小日期所在月份开始
                        let minDate = props.minDate.getOrThrow()
                        DateTime.of(year: minDate.year, month: minDate.monthValue, dayOfMonth: 1)
                    } else {
                        // 从当前月份开始
                        newMonth
                    }

                    for (i in 0..monthCount) {
                        let month = startMonth.addMonths(i)
                        // 确保月份不超过最大日期
                        if (props.maxDate.isNone() || month <= props.maxDate.getOrThrow()) {
                            let days = ArrayList<SilkCalendarDay>()
                            let monthDays = getMonthDaysForDate(month)

                            // 将ArrayList转换为ObservedArray
                            for (j in 0..monthDays.size) {
                                days.append(monthDays.get(j).getOrThrow())
                            }

                            let monthData = MonthData(month: month, days: ObservedArray(days.toArray()))
                            monthsData.append(monthData)
                        }
                    }
                } else {
                    // 如果没有指定范围，从当前月份开始，加载11个月的数据（当前月份及之后的10个月）
                    // 如果指定了范围，则加载范围内的月份
                    let monthCount = if (hasCustomRange) {
                        // 计算范围内的月份数
                        let minDate = props.minDate.getOrThrow()
                        let maxDate = props.maxDate.getOrThrow()
                        let monthDiff = (maxDate.year - minDate.year) * 12 + (maxDate.monthValue - minDate.monthValue) +
                            1
                        Int64(monthDiff)
                    } else {
                        11 // 默认加载11个月
                    }

                    let startMonth = if (hasCustomRange) {
                        // 从最小日期所在月份开始
                        let minDate = props.minDate.getOrThrow()
                        DateTime.of(year: minDate.year, month: minDate.monthValue, dayOfMonth: 1)
                    } else {
                        // 从当前月份开始
                        newMonth
                    }

                    for (i in 0..monthCount) {
                        let month = startMonth.addMonths(i)
                        // 确保月份不超过最大日期
                        if (props.maxDate.isNone() || month <= props.maxDate.getOrThrow()) {
                            let days = ArrayList<SilkCalendarDay>()
                            let monthDays = getMonthDaysForDate(month)

                            // 将ArrayList转换为ObservedArray
                            for (j in 0..monthDays.size) {
                                days.append(monthDays.get(j).getOrThrow())
                            }

                            let monthData = MonthData(month: month, days: ObservedArray(days.toArray()))
                            monthsData.append(monthData)
                        }
                    }
                }
                currentMonthIndex = 0
            } else {
                // 非平铺模式，只加载当前月份
                let days = ArrayList<SilkCalendarDay>()
                let monthDays = getMonthDaysForDate(newMonth)

                // 将ArrayList转换为ObservedArray
                for (j in 0..monthDays.size) {
                    days.append(monthDays.get(j).getOrThrow())
                }

                let monthData = MonthData(month: newMonth, days: ObservedArray(days.toArray()))

                // 清空现有数据
                monthsData.clear()
                monthsData.append(monthData)
                currentMonthIndex = 0
            }

            // 更新显示在标题上的月份
            if (monthsData.size > 0) {
                displayTitleMonth = monthsData[0].month
            } else {
                displayTitleMonth = newMonth
            }
        }
    }

    /**
     * 判断两个日期是否为同一个月
     *
     * @param date1 第一个日期
     * @param date2 第二个日期
     * @return 如果两个日期的年份和月份都相同，则返回true；否则返回false
     */
    private func isSameMonth(date1: DateTime, date2: DateTime): Bool {
        return date1.year == date2.year && date1.monthValue == date2.monthValue
    }

    /**
     * 更新日期选中状态
     *
     * 该方法会在monthsData中查找指定日期，并更新其选中状态。
     * 如果找到多个匹配的日期（例如在多选模式下），可以选择更新所有匹配的日期或仅更新第一个匹配的日期。
     *
     * @param date 要更新的日期
     * @param isSelected 是否选中
     * @param updateAll 是否更新所有匹配的日期，默认为false，仅更新第一个匹配的日期
     * @return 是否找到并更新了日期
     */
    private func updateDateSelection(date: DateTime, isSelected: Bool, updateAll!: Bool = false): Bool {
        var found = false

        // 遍历所有月份
        for (i in 0..monthsData.size) {
            let monthData = monthsData[i]

            // 遍历该月份的所有日期
            for (j in 0..monthData.days.size) {
                let day = monthData.days[j]

                // 检查是否是同一天，并且不是占位符
                if (day.typeValue != SilkCalendarDayType.PLACEHOLDER && isSameDay(day.date, date)) {
                    // 更新选中状态
                    if (isSelected) {
                        // 根据选择模式设置不同的类型
                        if (props.typeValue == SilkCalendarType.SINGLE) {
                            day.typeValue = SilkCalendarDayType.SELECTED
                        } else if (props.typeValue == SilkCalendarType.MULTIPLE) {
                            day.typeValue = SilkCalendarDayType.MULTIPLE_SELECTED
                        } else if (props.typeValue == SilkCalendarType.RANGE) {
                            // 范围选择模式下，需要根据日期在范围中的位置设置不同的类型
                            if (selectedRange.isSome()) {
                                let (start, end) = selectedRange.getOrThrow()

                                if (isSameDay(date, start) && isSameDay(date, end)) {
                                    day.typeValue = SilkCalendarDayType.START_END
                                    day.bottomInfo = "开始/结束"
                                } else if (isSameDay(date, start)) {
                                    day.typeValue = SilkCalendarDayType.START
                                    day.bottomInfo = "开始"
                                } else if (isSameDay(date, end)) {
                                    day.typeValue = SilkCalendarDayType.END
                                    day.bottomInfo = "结束"
                                } else {
                                    day.typeValue = SilkCalendarDayType.MIDDLE
                                    day.bottomInfo = ""
                                }
                            } else if (tempRangeStart.isSome() && isSameDay(date, tempRangeStart.getOrThrow())) {
                                day.typeValue = SilkCalendarDayType.START
                                day.bottomInfo = "开始"
                            }
                        }
                    } else {
                        // 取消选中状态
                        if (!day.isCurrentMonth) {
                            day.typeValue = SilkCalendarDayType.PLACEHOLDER
                        } else {
                            day.typeValue = SilkCalendarDayType.NORMAL
                        }
                        // 清除底部信息
                        day.bottomInfo = ""
                    }
                    found = true

                    // 如果不需要更新所有匹配的日期，找到一个就返回
                    if (!updateAll) {
                        return true
                    }
                }
            }
        }

        return found
    }

    /**
     * 格式化年月
     *
     * 该方法将日期对象格式化为"年月"格式的字符串，如"2025年5月"。
     * 这个方法主要用于显示日历的月份标题。
     *
     * 格式化规则：
     * - 年份：直接显示年份数字，如"2025"
     * - 月份：直接显示月份数字，如"5"
     * - 最终格式：年份 + "年" + 月份 + "月"，如"2025年5月"
     *
     * @param date 要格式化的日期对象
     * @return 格式化后的年月字符串，如"2025年5月"
     */
    private func formatYearMonth(date: DateTime): String {
        return date.year.toString() + "年" + date.monthValue.toString() + "月"
    }

    /**
     * 构建弹出层内容
     */
    @Builder
    private func popupContentBuilder() {
        Column() {
            renderHeader()
            renderDays()
            renderFooter()
        }
            .width(100.percent)
            .height<Length>(
                if (props.position == SilkCalendarPosition.RIGHT || props.position == SilkCalendarPosition.LEFT) {
                    100.percent
                } else {
                    None
                })
            //            .height(getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_POPUP_HEIGHT))
            .backgroundColor(ResourceColorToColor(getCalendarColorConstant(SilkCalendarColorKey.CALENDAR_BACKGROUND)))
    }

    /**
     * 构建组件UI
     */
    func build() {
        if (!props.poppable) {
            // 内联模式
            Column() {
                renderHeader()
                renderDays()
                renderFooter()
            }
                .width(100.percent)
                .backgroundColor(
                    ResourceColorToColor(getCalendarColorConstant(SilkCalendarColorKey.CALENDAR_BACKGROUND)))
                //            .borderRadius(if (props.round) { 8.vp } else { 0.vp })
                .borderRadius(0)
        } else {
            // 弹出层模式
            SilkPopup(
                show: visible,
                props: SilkPopupOptions(
                    showClose: true,
                    position: match (props.position) {
                        case SilkCalendarPosition.BOTTOM => SilkPopupPosition.BOTTOM
                        case SilkCalendarPosition.TOP => SilkPopupPosition.TOP
                        case SilkCalendarPosition.LEFT => SilkPopupPosition.LEFT
                        case SilkCalendarPosition.RIGHT => SilkPopupPosition.RIGHT
                    },
                    widthValue: 100.percent,
                    round: props.round,
                    closeOnClickOverlay: props.closeOnClickOverlay,
                ),
                close: handleCancel,
                _Children: {_ => popupContentBuilder(this)}
            )
        }
    }
    @State
    var testD: String = "hello"
    @Builder
    private func renderTest() {
        Column() {
            Text(testD)
        }.height(300).onClick({_ => testD = "hello world"})
    }

    /**
     * 是否有自定义标题
     */
    public var hasTitle: Bool = false

    /**
     * 是否有自定义日期内容
     */
    public var hasDay: Bool = false

    /**
     * 是否有自定义底部内容
     */
    public var hasFooter: Bool = false
}
