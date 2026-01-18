/**
 * Created on 2025/5/9
 *
 * SilkCalendar 日历组件模型定义
 *
 * 定义了日历组件使用的各种模型和枚举，包括：
 * - SilkCalendarType：日历类型枚举，定义了单选、多选、范围选择三种模式
 * - SilkCalendarPosition：日历位置枚举，定义了底部、顶部、左侧、右侧四种位置
 * - SilkCalendarDay：日期类型，用于表示日历中的日期
 * - SilkCalendarOptions：日历配置选项，用于配置日历组件的各种属性
 *
 * 这些模型和枚举为日历组件提供了丰富的配置选项，可以满足各种日期选择场景的需求。
 *
 * @module silkui/components/calendar
 */
package silkui.components.calendar
import silkui.macros.EnumExtend
import ohos.state_macro_manage.Observed
import ohos.state_macro_manage.Publish
import ohos.base.*
import ohos.resource_manager.*
import silkui.ResourceStr
import silkui.ResourceColor
import silkui.constants.getCalendarSizeConstant
import silkui.constants.SilkCalendarSizeKey
import std.collection.ArrayList
import std.time.DateTime
import std.time.DateTimeFormat
import silkui.constants.SilkCellSizeKey
import silkui.constants.getCalendarColorConstant
import silkui.constants.SilkCalendarColorKey

/**
 * 日历切换模式枚举
 *
 * 定义了日历的显示模式，包括：
 * - NONE：平铺展示所有月份，不展示切换按钮
 * - MONTH：支持按月切换，展示上个月/下个月按钮
 * - YEAR_MONTH：支持按年切换，也支持按月切换，展示上一年/下一年，上个月/下个月按钮
 *
 * 在MONTH和YEAR_MONTH模式下，如果不传递选择范围（minDate和maxDate），则所有日期都可选。
 * 切换按钮的可用性也会根据是否设置了minDate和maxDate来决定。
 *
 * 使用示例：
 * ```
 * // 月份切换模式
 * SilkCalendar(
 *   props: SilkCalendarOptions(
 *     mode: SilkCalendarMode.MONTH, // 月份切换模式
 *     typeValue: SilkCalendarType.SINGLE
 *   )
 * )
 *
 * // 年月切换模式
 * SilkCalendar(
 *   props: SilkCalendarOptions(
 *     mode: SilkCalendarMode.YEAR_MONTH, // 年月切换模式
 *     typeValue: SilkCalendarType.RANGE
 *   )
 * )
 * ```
 */
@EnumExtend
public enum SilkCalendarMode {
	| NONE       // 平铺展示模式，不显示切换按钮
    | MONTH      // 月份切换模式，显示月份切换按钮
    | YEAR_MONTH // 年月切换模式，可以切换年份和月份
}

/**
 * 日历类型枚举
 *
 * 定义了日历的选择类型，包括：
 * - SINGLE：单选模式，只能选择一个日期
 * - MULTIPLE：多选模式，可以选择多个日期
 * - RANGE：范围选择模式，可以选择一个日期范围
 *
 * 使用示例：
 * ```
 * SilkCalendar(
 *   props: SilkCalendarOptions(
 *     typeValue: SilkCalendarType.SINGLE // 单选模式
 *   )
 * )
 * ```
 */
@EnumExtend
public enum SilkCalendarType {
    | SINGLE   // 单选模式
    | MULTIPLE // 多选模式
    | RANGE    // 范围选择模式
}

/**
 * 日历位置枚举
 *
 * 定义了日历的显示位置，包括：
 * - BOTTOM：底部弹出，日历从底部弹出
 * - TOP：顶部弹出，日历从顶部弹出
 * - LEFT：左侧弹出，日历从左侧弹出
 * - RIGHT：右侧弹出，日历从右侧弹出
 *
 * 当position不为BOTTOM时，日历会以平铺的方式展示，而不是弹出层的方式。
 *
 * 使用示例：
 * ```
 * // 弹出层方式
 * SilkCalendar(
 *   props: SilkCalendarOptions(
 *     position: SilkCalendarPosition.BOTTOM
 *   )
 * )
 *
 * // 平铺方式
 * SilkCalendar(
 *   props: SilkCalendarOptions(
 *     position: SilkCalendarPosition.TOP
 *   )
 * )
 * ```
 */
@EnumExtend
public enum SilkCalendarPosition {
    | BOTTOM   // 底部弹出
    | TOP      // 顶部弹出
    | LEFT     // 左侧弹出
    | RIGHT    // 右侧弹出
}

/**
 * 日期类型
 *
 * 用于表示日历中的日期，包含了日期的各种状态信息，如：
 * - 日期对象
 * - 日期文本
 * - 底部提示文本
 * - 顶部提示文本
 * - 是否为当前月份
 * - 是否为今天
 * - 是否被选中
 * - 是否被禁用
 *
 * 这个结构体主要用于在日历组件中渲染日期单元格，也可以通过Day插槽自定义日期单元格的内容。
 *
 * 使用示例：
 * ```
 * // 自定义日期内容
 * @Builder
 * func CustomDayBuilder(day: SilkCalendarDay) {
 *   Column() {
 *     Text(day.text)
 *       .fontSize(16.vp)
 *       .fontColor(if (day.isSelected) {
 *         Color.WHITE
 *       } else if (day.isToday) {
 *         Color.RED
 *       } else {
 *         Color.BLACK
 *       })
 *   }
 * }
 * ```
 */

/**
 * 日历日期类型
 *
 * 用于表示日期在选择范围中的位置和状态，包括：
 * - NORMAL: 普通日期，未被选中
 * - SELECTED: 选中的日期（单选模式）
 * - START: 范围选择的开始日期
 * - MIDDLE: 范围选择中的中间日期
 * - END: 范围选择的结束日期
 * - DISABLED: 禁用的日期，不可选择
 * - START_END: 范围选择的开始和结束日期（当开始和结束是同一天时）
 * - MULTIPLE_SELECTED: 选中的日期（多选模式）
 * - MULTIPLE_MIDDLE: 多选模式中的中间日期
 * - PLACEHOLDER: 占位符日期，通常是非当前月份的日期
 */
@EnumExtend
public enum SilkCalendarDayType {
    | NORMAL           // 普通日期，未被选中
    | SELECTED         // 选中的日期（单选模式）
    | START            // 范围选择的开始日期
    | MIDDLE           // 范围选择中的中间日期
    | END              // 范围选择的结束日期
    | DISABLED         // 禁用的日期，不可选择
    | START_END        // 范围选择的开始和结束日期（当开始和结束是同一天时）
    | MULTIPLE_SELECTED // 选中的日期（多选模式）
    | MULTIPLE_MIDDLE  // 多选模式中的中间日期
    | PLACEHOLDER      // 占位符日期，通常是非当前月份的日期
}


/**
 * 日历日期类
 *
 * 用于表示日历中的一个日期，包含日期的各种状态信息，如：
 * - 日期类型：普通、选中、开始日期、结束日期、中间日期、占位符等
 * - 日期对象：包含年、月、日等信息
 * - 日期文本：显示在日期格子中的文本
 * - 底部提示文本：显示在日期下方的提示文本，如"开始"、"结束"等
 * - 顶部提示文本：显示在日期上方的提示文本
 * - 是否被禁用：禁用的日期不可选择
 * - 是否为当前月份的日期：非当前月份的日期通常显示为灰色
 *
 * 这个类的属性大多使用@Publish修饰，以便在UI中响应属性变化。
 */
@Observed
public class SilkCalendarDay {
    /**
     * 日期类型
     * 表示日期在选择范围中的位置和状态
     * 如普通、选中、开始日期、结束日期、中间日期、占位符等
     */
    @Publish public var typeValue: SilkCalendarDayType = SilkCalendarDayType.NORMAL

    /**
     * 日期对象
     * 包含年、月、日等信息
     */
    public var date: DateTime

    /**
     * 日期文本
     * 显示在日期格子中的文本，通常为日期的天数
     */
    @Publish public var text: String

    /**
     * 底部提示文本
     * 显示在日期下方的提示文本，如"开始"、"结束"等
     * 在范围选择模式下特别有用
     */
    @Publish public var bottomInfo: ?String = Option<String>.None

    /**
     * 顶部提示文本
     * 显示在日期上方的提示文本
     */
    @Publish public var topInfo: ?String = Option<String>.None

    /**
     * 是否被禁用
     * 禁用的日期不可选择，通常显示为灰色
     */
    @Publish public var isDisabled: Bool = false

    /**
     * 是否为当前月份的日期
     * 非当前月份的日期通常显示为灰色或半透明
     */
    @Publish public var isCurrentMonth: Bool = true

}

/**
 * 日历配置选项
 *
 * 用于配置日历组件的各种属性，包括：
 * - 日历类型：单选、多选、范围选择
 * - 日历标题和副标题
 * - 确认按钮文本和颜色
 * - 是否显示确认按钮、标题、副标题、周几、月份导航按钮、今天标记
 * - 是否为只读状态
 * - 周起始日
 * - 最小日期和最大日期
 * - 默认选中的日期、日期数组、日期范围
 * - 日期格式化函数和过滤函数
 * - 是否允许选择同一天
 * - 最多可选天数和最少可选天数
 * - 日期行高
 * - 弹出位置
 * - 是否圆角、是否显示阴影
 * - 是否可以通过点击遮罩层关闭
 * - 是否在点击日期后自动关闭
 *
 * 这些配置选项为日历组件提供了丰富的定制能力，可以满足各种日期选择场景的需求。
 *
 * 使用示例：
 * ```
 * SilkCalendar(
 *   props: SilkCalendarOptions(
 *     typeValue: SilkCalendarType.SINGLE,
 *     title: "选择日期",
 *     minDate: DateTime.now(),
 *     maxDate: DateTime.now().addMonths(3),
 *     closeOnClickDay: true
 *   )
 * )
 * ```
 */
public struct SilkCalendarOptions {
    /**
     * 日历切换模式
     * 默认为平铺 none
     */
    public var mode: SilkCalendarMode
    /**
     * 日历类型
     * 默认为单选模式
     */
    public let typeValue: SilkCalendarType

    /**
     * 日历标题
     * 默认为"日期选择"
     */
    public let title: ResourceStr

    /**
     * 日历副标题
     * 默认为空
     */
    public let subtitle: ResourceStr

    /**
     * 确认按钮文本
     * 默认为"确定"
     */
    public let confirmText: ResourceStr

    /**
     * 自定义颜色
     * 默认为主题色
     */
    public let color: ResourceColor

    /**
     * 是否显示确认按钮
     * 默认为true
     */
    public let showConfirm: Bool

    /**
     * 是否只读
     * 默认为false
     */
    public let readonly: Bool

    /**
     * 是否显示标题
     * 默认为true
     */
    public let showTitle: Bool

    /**
     * 是否显示副标题
     * 默认为true
     */
    public let showSubtitle: Bool

    /**
     * 是否显示周几
     * 默认为true
     */
    public let showWeekday: Bool

    /**
     * 是否显示月份导航按钮
     * 默认为true
     */
    public let showMonthTitle: Bool

    /**
     * 是否显示月份背景水印
     * 默认为true
     */
    public let showMark: Bool

    /**
     * 周起始日
     * 0表示周日，1表示周一，默认为0
     */
    public let firstDayOfWeek: Int64

    /**
     * 最小日期
     * 默认为当前日期的前六个月
     */
    public let minDate: ?DateTime

    /**
     * 最大日期
     * 默认为当前日期的后六个月
     */
    public let maxDate: ?DateTime

    /**
     * 默认选中的日期
     * 单选模式下为DateTime，多选模式下为DateTime数组，范围选择模式下为[开始日期, 结束日期]
     */
    public let defaultDate: ?DateTime

    /**
     * 默认选中的日期数组
     * 多选模式下使用
     */
    public let defaultDates: ?ArrayList<DateTime>

    /**
     * 默认选中的日期范围
     * 范围选择模式下使用
     */
    public let defaultDateRange: ?(DateTime, DateTime)

    /**
     * 日期格式化函数
     * 用于自定义日期文本
     */
    public let formatter: Option<(SilkCalendarDay) -> SilkCalendarDay>

    /**
     * 日期过滤函数
     * 用于自定义禁用日期
     */
    public let filter: (DateTime) -> Bool

    /**
     * 是否允许选择同一天
     * 范围选择模式下使用
     * 默认为false
     */
    public let allowSameDay: Bool

    /**
     * 最多可选天数
     * 多选模式下使用
     * 默认为无限制
     */
    public let maxRange: ?Int32

    /**
     * 最少可选天数
     * 范围选择模式下使用
     * 默认为1
     */
    public let minRange: Int32

    /**
     * 日期行高
     * 默认为64vp
     */
    public let rowHeight: Length

    /**
     * 弹出位置
     * 默认为底部弹出
     */
    public let position: SilkCalendarPosition

    /**
     * 是否圆角
     * 默认为true
     */
    public let round: Bool

    /**
     * 圆角大小
     * 当round为true时生效
     * 默认使用预设大小
     */
    public let roundValue: Length

    /**
     * 是否显示阴影
     * 默认为true
     */
    public let shadow: Bool

    /**
     * 是否可以通过点击遮罩层关闭
     * 默认为true
     */
    public let closeOnClickOverlay: Bool

    /**
    * 平铺
    * 默认true
    */
    public let poppable: Bool

    /**
     * 创建日历配置选项
     *
     * @param mode 日历切换模式，默认为平铺 none
     * @param typeValue 日历类型，默认为单选模式
     * @param title 日历标题，默认为"日期选择"
     * @param subtitle 日历副标题，默认为空
     * @param confirmText 确认按钮文本，默认为"确定"
     * @param color 确认按钮颜色，默认为主题色
     * @param showConfirm 是否显示确认按钮，默认为true
     * @param readonly 是否只读，默认为false
     * @param showTitle 是否显示标题，默认为true
     * @param showSubtitle 是否显示副标题，默认为true
     * @param showWeekday 是否显示周几，默认为true
     * @param showMonthTitle 是否显示月份导航按钮，默认为true
     * @param showMark 是否显示月份背景水印，默认为true
     * @param firstDayOfWeek 周起始日，0表示周日，1表示周一，默认为0
     * @param minDate 最小日期，切换模式为none时 默认为当前日期
     * @param maxDate 最大日期，默认为none
     * @param defaultDate 默认选中的日期，单选模式下使用
     * @param defaultDates 默认选中的日期数组，多选模式下使用
     * @param defaultDateRange 默认选中的日期范围，范围选择模式下使用
     * @param formatter 日期格式化函数，用于自定义日期文本
     * @param filter 日期过滤函数，用于自定义禁用日期
     * @param allowSameDay 是否允许选择同一天，范围选择模式下使用，默认为false
     * @param maxRange 最多可选天数，多选模式下使用，默认为无限制
     * @param minRange 最少可选天数，范围选择模式下使用，默认为1
     * @param rowHeight 日期行高，默认为64vp
     * @param position 弹出位置，默认为底部弹出
     * @param round 是否圆角，默认为true
     * @param roundValue 圆角大小，当round为true时生效，默认使用预设大小
     * @param shadow 是否显示阴影，默认为true
     * @param closeOnClickOverlay 是否可以通过点击遮罩层关闭，默认为true
      * @param poppable 平铺
     */
    public init(
        mode!: SilkCalendarMode = SilkCalendarMode.NONE,
        typeValue!: SilkCalendarType = SilkCalendarType.SINGLE,
        title!: ResourceStr = "日期选择",
        subtitle!: ResourceStr = "",
        confirmText!: ResourceStr = "确定",
        color!: ResourceColor = getCalendarColorConstant(SilkCalendarColorKey.CALENDAR_DAY_SELECTED_BACKGROUND),
        showConfirm!: Bool = true,
        readonly!: Bool = false,
        showTitle!: Bool = true,
        showSubtitle!: Bool = true,
        showWeekday!: Bool = true,
        showMonthTitle!: Bool = true,
        showMark!: Bool = true,
        firstDayOfWeek!: Int64 = 0,
        minDate!: ?DateTime = Option.None,
        maxDate!: ?DateTime = Option.None,
        defaultDate!: ?DateTime = Option.None,
        defaultDates!: ?ArrayList<DateTime> = Option.None,
        defaultDateRange!: ?(DateTime, DateTime) = Option.None,
        formatter!: Option<(SilkCalendarDay) -> SilkCalendarDay> = Option.None,
        filter!: (DateTime) -> Bool = { _ => true },
        allowSameDay!: Bool = false,
        maxRange!: ?Int32 = Option.None,
        minRange!: Int32 = 1,
        rowHeight!: Length = getCalendarSizeConstant(SilkCalendarSizeKey.CALENDAR_DAY_HEIGHT),
        position!: SilkCalendarPosition = SilkCalendarPosition.BOTTOM,
        round!: Bool = true,
        roundValue!: Length = 16.vp,
        shadow!: Bool = true,
        closeOnClickOverlay!: Bool = true,
        poppable!: Bool = true
    ) {
        this.mode = mode
        this.typeValue = typeValue
        this.title = title
        this.subtitle = subtitle
        this.confirmText = confirmText
        this.color = color
        this.showConfirm = showConfirm
        this.readonly = readonly
        this.showTitle = showTitle
        this.showSubtitle = showSubtitle
        this.showWeekday = showWeekday
        this.showMonthTitle = showMonthTitle
        this.showMark = showMark
        this.firstDayOfWeek = firstDayOfWeek
        // 不再根据模式自动设置最小日期为当前日期
        // 如果没有指定最小日期，则保持为 None
        this.minDate = minDate
        this.maxDate = maxDate
        this.defaultDate = defaultDate
        this.defaultDates = defaultDates
        this.defaultDateRange = defaultDateRange
        this.formatter = formatter
        this.filter = filter
        this.allowSameDay = allowSameDay
        this.maxRange = maxRange
        this.minRange = minRange
        this.rowHeight = rowHeight
        this.position = position
        this.round = round
        this.roundValue = roundValue
        this.shadow = shadow
        this.closeOnClickOverlay = closeOnClickOverlay
        this.poppable = poppable
    }
}
