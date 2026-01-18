/**
 * Created on 2025/5/9
 *
 * SilkCalendar 日历组件常量定义
 *
 * 本文件定义了日历组件使用的各种常量，包括颜色、尺寸等
 *
 * @module silkui/constants/calendar
 */
package silkui.constants
import std.collection.HashMap
import ohos.base.Length
import ohos.base.LengthType
import ohos.base.Color
import silkui.ResourceColor
import silkui.ResourceStr

/**
 * 日历颜色常量枚举
 */
public enum SilkCalendarColorKey {
    | CALENDAR_BACKGROUND
    | CALENDAR_TITLE_TEXT_COLOR
    | CALENDAR_SUBTITLE_TEXT_COLOR
    | CALENDAR_WEEKDAY_TEXT_COLOR
    | CALENDAR_DAY_TEXT_COLOR
    | CALENDAR_DAY_DISABLED_TEXT_COLOR
    | CALENDAR_DAY_SELECTED_TEXT_COLOR
    | CALENDAR_DAY_SELECTED_BACKGROUND
    | CALENDAR_DAY_START_END_BACKGROUND
    | CALENDAR_DAY_MIDDLE_BACKGROUND
    | CALENDAR_DAY_HOVER_BACKGROUND
    | CALENDAR_CONFIRM_BUTTON_TEXT_COLOR
    | CALENDAR_CONFIRM_BUTTON_BACKGROUND
    | CALENDAR_CONFIRM_BUTTON_DISABLED_TEXT_COLOR
    | CALENDAR_CONFIRM_BUTTON_DISABLED_BACKGROUND
    | CALENDAR_TODAY_TEXT_COLOR
    | CALENDAR_MONTH_MARK_COLOR
    | CALENDAR_HEADER_ACTION_COLOR
    | CALENDAR_HEADER_ACTION_DISABLED_COLOR
}

/**
 * 将日历颜色枚举转换为字符串
 * @param key 日历颜色枚举值
 * @return 对应的字符串键
 */
private func calendarColorKeyToString(key: SilkCalendarColorKey): String {
    match (key) {
        case SilkCalendarColorKey.CALENDAR_BACKGROUND => "--silk-calendar-background"
        case SilkCalendarColorKey.CALENDAR_TITLE_TEXT_COLOR => "--silk-calendar-title-text-color"
        case SilkCalendarColorKey.CALENDAR_SUBTITLE_TEXT_COLOR => "--silk-calendar-subtitle-text-color"
        case SilkCalendarColorKey.CALENDAR_WEEKDAY_TEXT_COLOR => "--silk-calendar-weekday-text-color"
        case SilkCalendarColorKey.CALENDAR_DAY_TEXT_COLOR => "--silk-calendar-day-text-color"
        case SilkCalendarColorKey.CALENDAR_DAY_DISABLED_TEXT_COLOR => "--silk-calendar-day-disabled-text-color"
        case SilkCalendarColorKey.CALENDAR_DAY_SELECTED_TEXT_COLOR => "--silk-calendar-day-selected-text-color"
        case SilkCalendarColorKey.CALENDAR_DAY_SELECTED_BACKGROUND => "--silk-calendar-day-selected-background"
        case SilkCalendarColorKey.CALENDAR_DAY_START_END_BACKGROUND => "--silk-calendar-day-start-end-background"
        case SilkCalendarColorKey.CALENDAR_DAY_MIDDLE_BACKGROUND => "--silk-calendar-day-middle-background"
        case SilkCalendarColorKey.CALENDAR_DAY_HOVER_BACKGROUND => "--silk-calendar-day-hover-background"
        case SilkCalendarColorKey.CALENDAR_CONFIRM_BUTTON_TEXT_COLOR => "--silk-calendar-confirm-button-text-color"
        case SilkCalendarColorKey.CALENDAR_CONFIRM_BUTTON_BACKGROUND => "--silk-calendar-confirm-button-background"
        case SilkCalendarColorKey.CALENDAR_CONFIRM_BUTTON_DISABLED_TEXT_COLOR => "--silk-calendar-confirm-button-disabled-text-color"
        case SilkCalendarColorKey.CALENDAR_CONFIRM_BUTTON_DISABLED_BACKGROUND => "--silk-calendar-confirm-button-disabled-background"
        case SilkCalendarColorKey.CALENDAR_TODAY_TEXT_COLOR => "--silk-calendar-today-text-color"
        case SilkCalendarColorKey.CALENDAR_MONTH_MARK_COLOR => "--silk-calendar-month-mark-color"
        case SilkCalendarColorKey.CALENDAR_HEADER_ACTION_COLOR => "--silk-calendar-header-action-color"
        case SilkCalendarColorKey.CALENDAR_HEADER_ACTION_DISABLED_COLOR => "--silk-calendar-header-action-disabled-color"

    }
}

/**
 * 日历尺寸常量枚举
 */
public enum SilkCalendarSizeKey {
    | CALENDAR_TITLE_HEIGHT
    | CALENDAR_TITLE_FONT_SIZE
    | CALENDAR_INFO_FONT_SIZE
    | CALENDAR_INFO_LINE_HEIGHT
    | CALENDAR_HEADER_TITLE_FONT_SIZE
    | CALENDAR_HEADER_SUBTITLE_FONT_SIZE
    | CALENDAR_WEEKDAY_HEIGHT
    | CALENDAR_WEEKDAY_FONT_SIZE
    | CALENDAR_DAY_HEIGHT
    | CALENDAR_DAY_FONT_SIZE
    | CALENDAR_DAY_MARGIN_BOTTOM
    | CALENDAR_DAY_RADIUS
    | CALENDAR_CONFIRM_BUTTON_HEIGHT
    | CALENDAR_CONFIRM_BUTTON_FONT_SIZE
    | CALENDAR_CONFIRM_BUTTON_MARGIN
    | CALENDAR_POPUP_HEIGHT
    | CALENDAR_HEADER_TITLE_HEIGHT
    | CALENDAR_MONTH_MARK_FONT_SIZE
    | CALENDAR_MONTH_TITLE_FONT_SIZE
    | CALENDAR_HEADER_ACTION_WIDTH
}

/**
 * 将日历尺寸枚举转换为字符串
 * @param key 日历尺寸枚举值
 * @return 对应的字符串键
 */
private func calendarSizeKeyToString(key: SilkCalendarSizeKey): String {
    match (key) {
        case SilkCalendarSizeKey.CALENDAR_TITLE_HEIGHT => "--silk-calendar-title-height"
        case SilkCalendarSizeKey.CALENDAR_TITLE_FONT_SIZE => "--silk-calendar-title-font-size"
        case SilkCalendarSizeKey.CALENDAR_INFO_FONT_SIZE => "--silk-calendar-info-font-size"
        case SilkCalendarSizeKey.CALENDAR_INFO_LINE_HEIGHT => "--silk-calendar-info-line-height"
        case SilkCalendarSizeKey.CALENDAR_HEADER_TITLE_FONT_SIZE => "--silk-calendar-header-title-font-size"
        case SilkCalendarSizeKey.CALENDAR_HEADER_SUBTITLE_FONT_SIZE => "--silk-calendar-header-subtitle-font-size"
        case SilkCalendarSizeKey.CALENDAR_WEEKDAY_HEIGHT => "--silk-calendar-weekday-height"
        case SilkCalendarSizeKey.CALENDAR_WEEKDAY_FONT_SIZE => "--silk-calendar-weekday-font-size"
        case SilkCalendarSizeKey.CALENDAR_DAY_HEIGHT => "--silk-calendar-day-height"
        case SilkCalendarSizeKey.CALENDAR_DAY_FONT_SIZE => "--silk-calendar-day-font-size"
        case SilkCalendarSizeKey.CALENDAR_DAY_MARGIN_BOTTOM => "--silk-calendar-day-margin-bottom"
        case SilkCalendarSizeKey.CALENDAR_DAY_RADIUS => "--silk-calendar-day-radius"
        case SilkCalendarSizeKey.CALENDAR_CONFIRM_BUTTON_HEIGHT => "--silk-calendar-confirm-button-height"
        case SilkCalendarSizeKey.CALENDAR_CONFIRM_BUTTON_FONT_SIZE => "--silk-calendar-confirm-button-font-size"
        case SilkCalendarSizeKey.CALENDAR_CONFIRM_BUTTON_MARGIN => "--silk-calendar-confirm-button-margin"
        case SilkCalendarSizeKey.CALENDAR_POPUP_HEIGHT => "--silk-calendar-popup-height"
        case SilkCalendarSizeKey.CALENDAR_HEADER_TITLE_HEIGHT => "--silk-calendar-header-title-height"
        case SilkCalendarSizeKey.CALENDAR_MONTH_MARK_FONT_SIZE => "--silk-calendar-month-mark-font-size"
        case SilkCalendarSizeKey.CALENDAR_MONTH_TITLE_FONT_SIZE => "--silk-calendar-month-title-font-size"
        case SilkCalendarSizeKey.CALENDAR_HEADER_ACTION_WIDTH => "--silk-calendar-header-action-width"
    }
}

/**
 * 默认日历颜色常量
 *
 * 定义了日历的默认颜色常量，用于重置
 */
private let DefaultSilkCalendarColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-calendar-background", getColorConstant(SilkColorKey.WHITE)),
    ("--silk-calendar-title-text-color", getColorConstant(SilkColorKey.TEXT_COLOR)),
    ("--silk-calendar-subtitle-text-color", getColorConstant(SilkColorKey.TEXT_COLOR)),
    ("--silk-calendar-weekday-text-color", getColorConstant(SilkColorKey.TEXT_COLOR_2)),
    ("--silk-calendar-day-text-color", getColorConstant(SilkColorKey.TEXT_COLOR)),
    ("--silk-calendar-day-disabled-text-color", getColorConstant(SilkColorKey.GRAY_5)),
    ("--silk-calendar-day-selected-text-color", getColorConstant(SilkColorKey.WHITE)),
    ("--silk-calendar-day-selected-background", getColorConstant(SilkColorKey.PRIMARY_COLOR)),
    ("--silk-calendar-day-start-end-background", getColorConstant(SilkColorKey.PRIMARY_COLOR)),
    ("--silk-calendar-day-middle-background", Color(245, 247, 255, alpha: 1.0)),
    ("--silk-calendar-day-hover-background", Color(245, 247, 255, alpha: 1.0)),
    ("--silk-calendar-confirm-button-text-color", getColorConstant(SilkColorKey.WHITE)),
    ("--silk-calendar-confirm-button-background", getColorConstant(SilkColorKey.PRIMARY_COLOR)),
    ("--silk-calendar-confirm-button-disabled-text-color", getColorConstant(SilkColorKey.GRAY_5)),
    ("--silk-calendar-confirm-button-disabled-background", getColorConstant(SilkColorKey.GRAY_2)),
    ("--silk-calendar-today-text-color", getColorConstant(SilkColorKey.PRIMARY_COLOR)),
    ("--silk-calendar-month-mark-color", Color(242, 243, 245, alpha: 0.8)),
    ("--silk-calendar-header-action-color", getColorConstant(SilkColorKey.TEXT_COLOR)),
    ("--silk-calendar-header-action-disabled-color", getColorConstant(SilkColorKey.TEXT_COLOR_3))
])

/**
 * 日历颜色常量
 *
 * 定义了日历的各种颜色常量
 */
private let SilkCalendarColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-calendar-background", getColorConstant(SilkColorKey.WHITE)),
    ("--silk-calendar-title-text-color", getColorConstant(SilkColorKey.TEXT_COLOR)),
    ("--silk-calendar-subtitle-text-color", getColorConstant(SilkColorKey.TEXT_COLOR_2)),
    ("--silk-calendar-weekday-text-color", getColorConstant(SilkColorKey.TEXT_COLOR_2)),
    ("--silk-calendar-day-text-color", getColorConstant(SilkColorKey.TEXT_COLOR)),
    ("--silk-calendar-day-disabled-text-color", getColorConstant(SilkColorKey.GRAY_5)),
    ("--silk-calendar-day-selected-text-color", getColorConstant(SilkColorKey.WHITE)),
    ("--silk-calendar-day-selected-background", getColorConstant(SilkColorKey.PRIMARY_COLOR)),
    ("--silk-calendar-day-start-end-background", getColorConstant(SilkColorKey.PRIMARY_COLOR)),
    ("--silk-calendar-day-middle-background", Color(245, 247, 255, alpha: 1.0)),
    ("--silk-calendar-day-hover-background", Color(245, 247, 255, alpha: 1.0)),
    ("--silk-calendar-confirm-button-text-color", getColorConstant(SilkColorKey.WHITE)),
    ("--silk-calendar-confirm-button-background", getColorConstant(SilkColorKey.PRIMARY_COLOR)),
    ("--silk-calendar-confirm-button-disabled-text-color", getColorConstant(SilkColorKey.GRAY_5)),
    ("--silk-calendar-confirm-button-disabled-background", getColorConstant(SilkColorKey.GRAY_2)),
    ("--silk-calendar-today-text-color", getColorConstant(SilkColorKey.PRIMARY_COLOR)),
    ("--silk-calendar-month-mark-color", Color(242, 243, 245, alpha: 0.8)),
    ("--silk-calendar-header-action-color", getColorConstant(SilkColorKey.TEXT_COLOR)),
    ("--silk-calendar-header-action-disabled-color", getColorConstant(SilkColorKey.TEXT_COLOR_3))
])

/**
 * 默认日历尺寸常量
 *
 * 定义了日历的默认尺寸常量，用于重置
 */
private let DefaultSilkCalendarSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-calendar-title-height", Length(44, unitType: LengthType.vp)),
    ("--silk-calendar-title-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_LG)),
    ("--silk-calendar-info-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_XS)),
    ("--silk-calendar-info-line-height", getSizeConstant(SilkSizeKey.LINE_HEIGHT_XS)),
    ("--silk-calendar-header-title-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_LG)),
    ("--silk-calendar-header-subtitle-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-calendar-weekday-height", Length(30, unitType: LengthType.vp)),
    ("--silk-calendar-weekday-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_SM)),
    ("--silk-calendar-day-height", Length(64, unitType: LengthType.vp)),
    ("--silk-calendar-day-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_LG)),
    ("--silk-calendar-day-margin-bottom", Length(4, unitType: LengthType.vp)),
    ("--silk-calendar-day-radius", Length(4, unitType: LengthType.vp)),
    ("--silk-calendar-confirm-button-height", Length(36, unitType: LengthType.vp)),
    ("--silk-calendar-confirm-button-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-calendar-confirm-button-margin", Length(8, unitType: LengthType.vp)),
    ("--silk-calendar-popup-height", Length(80, unitType: LengthType.percent)),
    ("--silk-calendar-header-title-height", Length(44, unitType: LengthType.vp)),
    ("--silk-calendar-month-mark-font-size", Length(160, unitType: LengthType.vp)),
    ("--silk-calendar-month-title-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-calendar-header-action-width", Length(28, unitType: LengthType.vp))

])

/**
 * 日历尺寸常量
 *
 * 定义了日历的各种尺寸常量
 */
private let SilkCalendarSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-calendar-title-height", Length(44, unitType: LengthType.vp)),
    ("--silk-calendar-title-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_LG)),
    ("--silk-calendar-info-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_XS)),
    ("--silk-calendar-info-line-height", getSizeConstant(SilkSizeKey.LINE_HEIGHT_XS)),
    ("--silk-calendar-header-title-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_LG)),
    ("--silk-calendar-header-subtitle-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-calendar-weekday-height", Length(30, unitType: LengthType.vp)),
    ("--silk-calendar-weekday-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_SM)),
    ("--silk-calendar-day-height", Length(64, unitType: LengthType.vp)),
    ("--silk-calendar-day-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-calendar-day-margin-bottom", Length(4, unitType: LengthType.vp)),
    ("--silk-calendar-day-radius", Length(4, unitType: LengthType.vp)),
    ("--silk-calendar-confirm-button-height", Length(36, unitType: LengthType.vp)),
    ("--silk-calendar-confirm-button-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-calendar-confirm-button-margin", Length(8, unitType: LengthType.vp)),
    ("--silk-calendar-popup-height", Length(80, unitType: LengthType.percent)),
    ("--silk-calendar-header-title-height", Length(44, unitType: LengthType.vp)),
    ("--silk-calendar-month-mark-font-size", Length(160, unitType: LengthType.vp)),
    ("--silk-calendar-month-title-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-calendar-header-action-width", Length(28, unitType: LengthType.vp))
])

/**
 * 通过枚举获取日历颜色常量的值
 * @param key 日历颜色枚举键
 * @return 对应的颜色值
 */
public func getCalendarColorConstant(key: SilkCalendarColorKey): ResourceColor {
    let stringKey = calendarColorKeyToString(key)
    return SilkCalendarColorConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举获取日历尺寸常量的值
 * @param key 日历尺寸枚举键
 * @return 对应的尺寸值
 */
public func getCalendarSizeConstant(key: SilkCalendarSizeKey): Length {
    let stringKey = calendarSizeKeyToString(key)
    return SilkCalendarSizeConstants.get(stringKey).getOrThrow()
}

/**
 * 更新日历颜色常量
 * @param key 日历颜色枚举键
 * @param value 新的颜色值
 */
public func updateCalendarColorConstant(key: SilkCalendarColorKey, value: ResourceColor) {
    let stringKey = calendarColorKeyToString(key)
    SilkCalendarColorConstants.put(stringKey, value)
}

/**
 * 更新日历尺寸常量
 * @param key 日历尺寸枚举键
 * @param value 新的尺寸值
 */
public func updateCalendarSizeConstant(key: SilkCalendarSizeKey, value: Length) {
    let stringKey = calendarSizeKeyToString(key)
    SilkCalendarSizeConstants.put(stringKey, value)
}

/**
 * 重置日历颜色常量
 * @param key 日历颜色枚举键
 */
public func resetCalendarColorConstant(key: SilkCalendarColorKey) {
    let stringKey = calendarColorKeyToString(key)
    let defaultValue = DefaultSilkCalendarColorConstants.get(stringKey).getOrThrow()
    SilkCalendarColorConstants.put(stringKey, defaultValue)
}

/**
 * 重置日历尺寸常量
 * @param key 日历尺寸枚举键
 */
public func resetCalendarSizeConstant(key: SilkCalendarSizeKey) {
    let stringKey = calendarSizeKeyToString(key)
    let defaultValue = DefaultSilkCalendarSizeConstants.get(stringKey).getOrThrow()
    SilkCalendarSizeConstants.put(stringKey, defaultValue)
}

/**
 * 重置所有日历颜色常量
 */
public func resetAllCalendarColorConstants() {
    for((key, value) in DefaultSilkCalendarColorConstants) {
        SilkCalendarColorConstants.put(key, value)
    }
}

/**
 * 重置所有日历尺寸常量
 */
public func resetAllCalendarSizeConstants() {
    for((key, value) in DefaultSilkCalendarSizeConstants) {
        SilkCalendarSizeConstants.put(key, value)
    }
}

/**
 * 重置所有日历常量
 */
public func resetAllCalendarConstants() {
    resetAllCalendarColorConstants()
    resetAllCalendarSizeConstants()
}
