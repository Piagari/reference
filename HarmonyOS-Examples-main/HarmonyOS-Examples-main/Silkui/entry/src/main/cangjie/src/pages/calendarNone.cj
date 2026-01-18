/**
 * Created on 2025/5/14
 */
package ohos_app_cangjie_entry.pages
internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.resource_manager.*
import ohos.state_macro_manage.*
import cj_res_entry.*
import ohos_app_cangjie_entry.components.{Nav, Title}
import silkui.components.cell.*
import silkui.SilkUIPaddingOptions
import silkui.components.calendar.SilkCalendarPosition
import silkui.components.calendar.SilkCalendar
internal import silkui.components.calendar.SilkCalendarOptions
import silkui.components.button.SilkButton
import silkui.components.button.SilkButtonOptions
import silkui.components.button.SilkButtonType
import silkui.constants.updateCalendarColorConstant
import silkui.constants.SilkCalendarColorKey
import ohos.prompt_action.PromptAction
import std.collection.ArrayList
import std.time.DateTime
import std.time.DateTimeFormat
import silkui.components.calendar.SilkCalendarType
import silkui.components.calendar.SilkCalendarDayType

@Entry
@Component
class CalendarNonePage {

    // 单选模式日历可见性
    @State
    var visible1: Bool = false
    @State
    var option1: SilkCalendarOptions = SilkCalendarOptions(
    )

    // 多选模式日历可见性
    @State
    var visible2: Bool = false
    @State
    var option2: SilkCalendarOptions = SilkCalendarOptions(
        typeValue: SilkCalendarType.MULTIPLE
        )

    // 范围选择模式日历可见性
    @State
    var visible3: Bool = false
    @State
    var option3: SilkCalendarOptions = SilkCalendarOptions(
        typeValue: SilkCalendarType.RANGE
        )

    // 快捷选择日历可见性
    @State
    var visible4: Bool = false
    @State
    var option4: SilkCalendarOptions = SilkCalendarOptions(showConfirm: false)
    @State
    var visible5: Bool = false
    @State
    var option5: SilkCalendarOptions = SilkCalendarOptions(
        showConfirm: false,
        typeValue: SilkCalendarType.RANGE
        )

    // 自定义颜色日历可见性
    @State
    var visible6: Bool = false
    @State
    var option6: SilkCalendarOptions = SilkCalendarOptions(
        typeValue: SilkCalendarType.RANGE,
        color: Color(238, 10, 36, alpha: 1.0))
    // 自定义范围日历可见性
    @State
    var visible7: Bool = false
    @State
    var option7: SilkCalendarOptions = SilkCalendarOptions(
        minDate: DateTime.of(year: 2010, month: 1, dayOfMonth: 1),
        maxDate: DateTime.of(year: 2010, month: 1, dayOfMonth: 31)
    )
    // 自定义按钮日历可见性
    @State
    var visible8: Bool = false
    @State
    var option8: SilkCalendarOptions = SilkCalendarOptions(
        typeValue: SilkCalendarType.RANGE,
        confirmText: "完成",
    )
    // 自定义日期文本日历可见性
    @State
    var visible9: Bool = false
    @State
    var option9: SilkCalendarOptions = SilkCalendarOptions(
        typeValue: SilkCalendarType.RANGE,
        formatter: {
            day =>
            let month = day.date.monthValue
            let date = day.date.dayOfMonth
            if (month == 5) {
                if (date == 1) {
                    day.topInfo = '劳动节'
                } else if (date == 4) {
                    day.topInfo = '青年节'
                } else if (date == 11) {
                    day.text = '今天'
                }
            }

            if (day.typeValue == SilkCalendarDayType.START) {
                day.bottomInfo = '入住'
            } else if (day.typeValue == SilkCalendarDayType.END) {
                day.bottomInfo = '离店'
            }
            return day
        }
    )
    // 自定义日期内容日历可见性
    @State
    var visible10: Bool = false
    @State
    var option10: SilkCalendarOptions = SilkCalendarOptions(
        position: SilkCalendarPosition.RIGHT
        )
    @State
    var visible11: Bool = false
    @State
    var option11: SilkCalendarOptions = SilkCalendarOptions(
        typeValue: SilkCalendarType.RANGE,
        maxRange: 3
    )
    @State
    var visible12: Bool = false
    @State
    var option12: SilkCalendarOptions = SilkCalendarOptions(
        firstDayOfWeek: 1
    )
    @State
    var option13: SilkCalendarOptions = SilkCalendarOptions(
        poppable: false,
        position: SilkCalendarPosition.TOP
    )


    @Builder
    func fn2() {
        SilkCell(
            props: SilkCellOptions(title: "选择单个日期", isLink: true),
            click: {_ => visible1 = true}
        )
        SilkCell(
            props: SilkCellOptions(title: "选择多个日期", isLink: true),
            click: {_ => visible2 = true}
        )
        SilkCell(
            props: SilkCellOptions(title: "选择日期区间", isLink: true),
            click: {_ => visible3 = true}
        )
    }
    @Builder
    func fn3() {
        SilkCell(
            props: SilkCellOptions(title: "选择单个日期", isLink: true),
            click: {_ => visible4 = true}
        )
        SilkCell(
            props: SilkCellOptions(title: "选择日期区间", isLink: true),
            click: {_ => visible5 = true}
        )
    }
    @Builder
    func fn4() {
        SilkCell(
            props: SilkCellOptions(title: "自定义颜色", isLink: true),
            click: {_ => visible6 = true}
        )
        SilkCell(
            props: SilkCellOptions(title: "自定义日期范围", isLink: true),
            click: {_ => visible7 = true}
        )
        SilkCell(
            props: SilkCellOptions(title: "自定义按钮文字", isLink: true),
            click: {_ => visible8 = true}
        )
        SilkCell(
            props: SilkCellOptions(title: "自定义日期文案", isLink: true),
            click: {_ => visible9 = true}
        )
        SilkCell(
            props: SilkCellOptions(title: "自定义弹出位置", isLink: true),
            click: {_ => visible10 = true}
        )
        SilkCell(
            props: SilkCellOptions(title: "日期区间最大范围", isLink: true),
            click: {_ => visible11 = true}
        )
        SilkCell(
            props: SilkCellOptions(title: "自定义周起始日", isLink: true),
            click: {_ => visible12 = true}
        )
    }

    func build() {
        Column() {
            Nav("Calendar")
            Scroll() {
                Column() {

                    Title("基础用法")
                    SilkCellGroup(
                        props: SilkCellGroupOptions(inset: true),
                        Childrens: fn2
                    )

                    Title("快捷选择")
                    SilkCellGroup(
                        props: SilkCellGroupOptions(inset: true),
                        Childrens: fn3
                    )

                    Title("自定义日历")
                    SilkCellGroup(
                        props: SilkCellGroupOptions(inset: true),
                        Childrens: fn4
                    )

                    Title("平铺展示")
                    SilkCalendar(
                        visible: true,
                        props: option13,
                        select: {
                            date => PromptAction.showToast(message: "选择的日期：" + date.toString())
                        }
                    )

                    // 基础 单个
                    SilkCalendar(
                        props: option1,
                        visible: visible1,
                        confirm: {
                            date, _, _ =>
                            visible1 = false
                            if (date.isSome()) {
                                PromptAction.showToast(message: "选择的日期：" + date.getOrThrow().toString())
                            }
                        },
                        cancel: {=> visible1 = false}
                    )
                    // 基础 多个
                    SilkCalendar(
                        props: option2,
                        visible: visible2,
                        confirm: {
                            _, dates, _ =>
                            visible2 = false
                            PromptAction.showToast(message: "选择了 " + dates.size.toString() + " 个日期")
                        },
                        cancel: {=> visible2 = false}
                    )
                    // 基础 范围
                    SilkCalendar(
                        props: option3,
                        visible: visible3,
                        confirm: {
                            _, _, range =>
                            visible3 = false
                            if (range.isSome()) {
                                let (start, end) = range.getOrThrow()
                                PromptAction.showToast(
                                    message: "选择的日期区间：" + start.toString() + " 至 " + end.toString())
                            }
                        },
                        cancel: {=> visible3 = false}
                    )
                    // 快捷 单个
                    SilkCalendar(
                        props: option4,
                        visible: visible4,
                        confirm: {
                            date, _, _ => if (date.isSome()) {
                                PromptAction.showToast(message: "选择的日期：" + date.getOrThrow().toString())
                            }
                        },
                        cancel: {=> visible4 = false}
                    )
                    // 快捷 范围
                    SilkCalendar(
                        props: option5,
                        visible: visible5,
                        confirm: {
                            date, _, _ =>
                            visible5 = false
                            if (date.isSome()) {
                                PromptAction.showToast(message: "选择的日期：" + date.getOrThrow().toString())
                            }
                        },
                        cancel: {=> visible5 = false}
                    )
                    // 自定义 颜色
                    SilkCalendar(
                        props: option6,
                        visible: visible6,
                        confirm: {
                            date, _, _ =>
                            visible6 = false
                            if (date.isSome()) {
                                PromptAction.showToast(message: "选择的日期：" + date.getOrThrow().toString())
                            }
                        },
                        cancel: {=> visible6 = false}
                    )
                    // 自定义 日期范围
                    SilkCalendar(
                        props: option7,
                        visible: visible7,
                        confirm: {
                            date, _, _ =>
                            visible7 = false
                            if (date.isSome()) {
                                PromptAction.showToast(message: "选择的日期：" + date.getOrThrow().toString())
                            }
                        },
                        cancel: {=> visible7 = false}
                    )
                    // 自定义 按钮文字
                    SilkCalendar(
                        props: option8,
                        visible: visible8,
//                        hasDay: true,
                        confirm: {
                            date, _, _ =>
                            visible8 = false
                            if (date.isSome()) {
                                PromptAction.showToast(message: "选择的日期：" + date.getOrThrow().toString())
                            }
                        },
                        cancel: {=> visible8 = false}
                    )
                    // 自定义 日期文案
                    SilkCalendar(
                        props: option9,
                        visible: visible9,
//                        hasDay: true,
                        confirm: {
                            date, _, _ =>
                            visible9 = false
                            if (date.isSome()) {
                                PromptAction.showToast(message: "选择的日期：" + date.getOrThrow().toString())
                            }
                        },
                        cancel: {=> visible9 = false}
                    )
                    // 自定义 弹出位置
                    SilkCalendar(
                        props: option10,
                        visible: visible10,
//                        hasDay: true,
                        confirm: {
                            date, _, _ =>
                            visible10 = false
                            if (date.isSome()) {
                                PromptAction.showToast(message: "选择的日期：" + date.getOrThrow().toString())
                            }
                        },
                        cancel: {=> visible10 = false}
                    )
                    // 自定义 最大范围
                    SilkCalendar(
                        props: option11,
                        visible: visible11,
//                        hasDay: true,
                        confirm: {
                            date, _, _ =>
                            visible11 = false
                            if (date.isSome()) {
                                PromptAction.showToast(message: "选择的日期：" + date.getOrThrow().toString())
                            }
                        },
                        cancel: {=> visible11 = false}
                    )
                    // 自定义 周起始日
                    SilkCalendar(
                        props: option12,
                        visible: visible12,
//                        hasDay: true,
                        confirm: {
                            date, _, _ =>
                            visible12 = false
                            if (date.isSome()) {
                                PromptAction.showToast(message: "选择的日期：" + date.getOrThrow().toString())
                            }
                        },
                        cancel: {=> visible12 = false}
                    )
                }.justifyContent(FlexAlign.Start)
            }.layoutWeight(1).backgroundColor(@r(app.color.silkdocbackground)).align(Alignment.Top)
        }.width(100.percent).height(100.percent)
    }
}