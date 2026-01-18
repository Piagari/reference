/**
 * Created on 2025/7/8
 *
 * SilkActionSheet 动作面板组件常量定义
 *
 * 本文件定义了动作面板组件使用的各种常量，包括颜色、尺寸、字体等
 * 这里定义样式变量。由于泛型的问题，所以此处不使用 resource，全部采用 string
 *
 * @module silkui/constants/action_sheet
 */
package silkui.constants
import std.collection.HashMap
import ohos.base.Length
import ohos.base.LengthType
import ohos.base.Color
import ohos.state_macro_manage.*
import ohos.resource_manager.*
import cj_res_silkui.*
import silkui.ResourceColor
import silkui.ResourceStr
import ohos.component.FontWeight

/**
 * 动作面板颜色常量枚举
 */
public enum SilkActionSheetColorKey {
    | ACTION_SHEET_DESCRIPTION_COLOR
    | ACTION_SHEET_ITEM_BACKGROUND
    | ACTION_SHEET_ITEM_TEXT_COLOR
    | ACTION_SHEET_ITEM_DISABLED_TEXT_COLOR
    | ACTION_SHEET_SUBNAME_COLOR
    | ACTION_SHEET_CLOSE_ICON_COLOR
    | ACTION_SHEET_CANCEL_TEXT_COLOR
    | ACTION_SHEET_CANCEL_PADDING_COLOR
}

/**
 * 将动作面板颜色枚举转换为字符串
 * @param key 动作面板颜色枚举值
 * @return 对应的字符串键
 */
private func actionSheetColorKeyToString(key: SilkActionSheetColorKey): String {
    match (key) {
        case SilkActionSheetColorKey.ACTION_SHEET_DESCRIPTION_COLOR => "--silk-action-sheet-description-color"
        case SilkActionSheetColorKey.ACTION_SHEET_ITEM_BACKGROUND => "--silk-action-sheet-item-background"
        case SilkActionSheetColorKey.ACTION_SHEET_ITEM_TEXT_COLOR => "--silk-action-sheet-item-text-color"
        case SilkActionSheetColorKey.ACTION_SHEET_ITEM_DISABLED_TEXT_COLOR => "--silk-action-sheet-item-disabled-text-color"
        case SilkActionSheetColorKey.ACTION_SHEET_SUBNAME_COLOR => "--silk-action-sheet-subname-color"
        case SilkActionSheetColorKey.ACTION_SHEET_CLOSE_ICON_COLOR => "--silk-action-sheet-close-icon-color"
        case SilkActionSheetColorKey.ACTION_SHEET_CANCEL_TEXT_COLOR => "--silk-action-sheet-cancel-text-color"
        case SilkActionSheetColorKey.ACTION_SHEET_CANCEL_PADDING_COLOR => "--silk-action-sheet-cancel-padding-color"
    }
}

/**
 * 动作面板尺寸常量枚举
 */
public enum SilkActionSheetSizeKey {
    | ACTION_SHEET_MAX_HEIGHT
    | ACTION_SHEET_HEADER_HEIGHT
    | ACTION_SHEET_HEADER_FONT_SIZE
    | ACTION_SHEET_DESCRIPTION_FONT_SIZE
    | ACTION_SHEET_DESCRIPTION_LINE_HEIGHT
    | ACTION_SHEET_ITEM_FONT_SIZE
    | ACTION_SHEET_ITEM_LINE_HEIGHT
    | ACTION_SHEET_ITEM_ICON_SIZE
    | ACTION_SHEET_ITEM_ICON_MARGIN_RIGHT
    | ACTION_SHEET_SUBNAME_FONT_SIZE
    | ACTION_SHEET_SUBNAME_LINE_HEIGHT
    | ACTION_SHEET_CLOSE_ICON_SIZE
    | ACTION_SHEET_LOADING_ICON_SIZE
    | ACTION_SHEET_CLOSE_ICON_PADDING_TOP
    | ACTION_SHEET_CLOSE_ICON_PADDING_RIGHT
    | ACTION_SHEET_CLOSE_ICON_PADDING_BOTTOM
    | ACTION_SHEET_CLOSE_ICON_PADDING_LEFT
    | ACTION_SHEET_CANCEL_PADDING_TOP
}

/**
 * 将动作面板尺寸枚举转换为字符串
 * @param key 动作面板尺寸枚举值
 * @return 对应的字符串键
 */
private func actionSheetSizeKeyToString(key: SilkActionSheetSizeKey): String {
    match (key) {
        case SilkActionSheetSizeKey.ACTION_SHEET_MAX_HEIGHT => "--silk-action-sheet-max-height"
        case SilkActionSheetSizeKey.ACTION_SHEET_HEADER_HEIGHT => "--silk-action-sheet-header-height"
        case SilkActionSheetSizeKey.ACTION_SHEET_HEADER_FONT_SIZE => "--silk-action-sheet-header-font-size"
        case SilkActionSheetSizeKey.ACTION_SHEET_DESCRIPTION_FONT_SIZE => "--silk-action-sheet-description-font-size"
        case SilkActionSheetSizeKey.ACTION_SHEET_DESCRIPTION_LINE_HEIGHT => "--silk-action-sheet-description-line-height"
        case SilkActionSheetSizeKey.ACTION_SHEET_ITEM_FONT_SIZE => "--silk-action-sheet-item-font-size"
        case SilkActionSheetSizeKey.ACTION_SHEET_ITEM_LINE_HEIGHT => "--silk-action-sheet-item-line-height"
        case SilkActionSheetSizeKey.ACTION_SHEET_ITEM_ICON_SIZE => "--silk-action-sheet-item-icon-size"
        case SilkActionSheetSizeKey.ACTION_SHEET_ITEM_ICON_MARGIN_RIGHT => "--silk-action-sheet-item-icon-margin-right"
        case SilkActionSheetSizeKey.ACTION_SHEET_SUBNAME_FONT_SIZE => "--silk-action-sheet-subname-font-size"
        case SilkActionSheetSizeKey.ACTION_SHEET_SUBNAME_LINE_HEIGHT => "--silk-action-sheet-subname-line-height"
        case SilkActionSheetSizeKey.ACTION_SHEET_CLOSE_ICON_SIZE => "--silk-action-sheet-close-icon-size"
        case SilkActionSheetSizeKey.ACTION_SHEET_LOADING_ICON_SIZE => "--silk-action-sheet-loading-icon-size"
        case SilkActionSheetSizeKey.ACTION_SHEET_CLOSE_ICON_PADDING_TOP => "--silk-action-sheet-close-icon-padding-top"
        case SilkActionSheetSizeKey.ACTION_SHEET_CLOSE_ICON_PADDING_RIGHT => "--silk-action-sheet-close-icon-padding-right"
        case SilkActionSheetSizeKey.ACTION_SHEET_CLOSE_ICON_PADDING_BOTTOM => "--silk-action-sheet-close-icon-padding-bottom"
        case SilkActionSheetSizeKey.ACTION_SHEET_CLOSE_ICON_PADDING_LEFT => "--silk-action-sheet-close-icon-padding-left"
        case SilkActionSheetSizeKey.ACTION_SHEET_CANCEL_PADDING_TOP => "--silk-action-sheet-cancel-padding-top"
    }
}



/**
 * 动作面板百分比常量枚举
 */
public enum SilkActionSheetPercentKey {
    | ACTION_SHEET_MAX_HEIGHT_PERCENT
}

/**
 * 将动作面板百分比枚举转换为字符串
 * @param key 动作面板百分比枚举值
 * @return 对应的字符串键
 */
private func actionSheetPercentKeyToString(key: SilkActionSheetPercentKey): String {
    match (key) {
        case SilkActionSheetPercentKey.ACTION_SHEET_MAX_HEIGHT_PERCENT => "--silk-action-sheet-max-height-percent"
    }
}

/**
 * 默认动作面板颜色常量
 *
 * 定义了动作面板的默认颜色常量，用于重置
 */
private let DefaultSilkActionSheetColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-action-sheet-description-color", getColorConstant(SilkColorKey.TEXT_COLOR_2)),
    ("--silk-action-sheet-item-background", getColorConstant(SilkColorKey.BACKGROUND_2)),
    ("--silk-action-sheet-item-text-color", getColorConstant(SilkColorKey.TEXT_COLOR)),
    ("--silk-action-sheet-item-disabled-text-color", getColorConstant(SilkColorKey.TEXT_COLOR_3)),
    ("--silk-action-sheet-subname-color", getColorConstant(SilkColorKey.TEXT_COLOR_2)),
    ("--silk-action-sheet-close-icon-color", getColorConstant(SilkColorKey.GRAY_5)),
    ("--silk-action-sheet-cancel-text-color", getColorConstant(SilkColorKey.GRAY_7)),
    ("--silk-action-sheet-cancel-padding-color", getColorConstant(SilkColorKey.BACKGROUND))
])

/**
 * 动作面板颜色常量
 *
 * 定义了动作面板的各种颜色常量，包括文字颜色、背景颜色等
 */
private let SilkActionSheetColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-action-sheet-description-color", getColorConstant(SilkColorKey.TEXT_COLOR_2)),
    ("--silk-action-sheet-item-background", getColorConstant(SilkColorKey.BACKGROUND_2)),
    ("--silk-action-sheet-item-text-color", getColorConstant(SilkColorKey.TEXT_COLOR)),
    ("--silk-action-sheet-item-disabled-text-color", getColorConstant(SilkColorKey.TEXT_COLOR_3)),
    ("--silk-action-sheet-subname-color", getColorConstant(SilkColorKey.TEXT_COLOR_2)),
    ("--silk-action-sheet-close-icon-color", getColorConstant(SilkColorKey.GRAY_5)),
    ("--silk-action-sheet-cancel-text-color", getColorConstant(SilkColorKey.GRAY_7)),
    ("--silk-action-sheet-cancel-padding-color", getColorConstant(SilkColorKey.BACKGROUND))
])

/**
 * 默认动作面板尺寸常量
 *
 * 定义了动作面板的默认尺寸常量，用于重置
 */
private let DefaultSilkActionSheetSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-action-sheet-header-height", Length(48, unitType: LengthType.vp)),
    ("--silk-action-sheet-header-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_LG)),
    ("--silk-action-sheet-description-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-action-sheet-description-line-height", getSizeConstant(SilkSizeKey.LINE_HEIGHT_MD)),
    ("--silk-action-sheet-item-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_LG)),
    ("--silk-action-sheet-item-line-height", getSizeConstant(SilkSizeKey.LINE_HEIGHT_LG)),
    ("--silk-action-sheet-item-icon-size", Length(18, unitType: LengthType.vp)),
    ("--silk-action-sheet-item-icon-margin-right", getSizeConstant(SilkSizeKey.PADDING_XS)),
    ("--silk-action-sheet-subname-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_SM)),
    ("--silk-action-sheet-subname-line-height", getSizeConstant(SilkSizeKey.LINE_HEIGHT_SM)),
    ("--silk-action-sheet-close-icon-size", Length(22, unitType: LengthType.vp)),
    ("--silk-action-sheet-loading-icon-size", Length(22, unitType: LengthType.vp)),
    ("--silk-action-sheet-close-icon-padding-top", Length(0, unitType: LengthType.vp)),
    ("--silk-action-sheet-close-icon-padding-right", getSizeConstant(SilkSizeKey.PADDING_MD)),
    ("--silk-action-sheet-close-icon-padding-bottom", Length(0, unitType: LengthType.vp)),
    ("--silk-action-sheet-close-icon-padding-left", getSizeConstant(SilkSizeKey.PADDING_MD)),
    ("--silk-action-sheet-cancel-padding-top", getSizeConstant(SilkSizeKey.PADDING_XS))
])

/**
 * 动作面板尺寸常量
 *
 * 定义了动作面板的各种尺寸常量，包括大小、内边距、字体大小等
 */
private let SilkActionSheetSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-action-sheet-header-height", Length(48, unitType: LengthType.vp)),
    ("--silk-action-sheet-header-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_LG)),
    ("--silk-action-sheet-description-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-action-sheet-description-line-height", getSizeConstant(SilkSizeKey.LINE_HEIGHT_MD)),
    ("--silk-action-sheet-item-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_LG)),
    ("--silk-action-sheet-item-line-height", getSizeConstant(SilkSizeKey.LINE_HEIGHT_LG)),
    ("--silk-action-sheet-item-icon-size", Length(18, unitType: LengthType.vp)),
    ("--silk-action-sheet-item-icon-margin-right", getSizeConstant(SilkSizeKey.PADDING_XS)),
    ("--silk-action-sheet-subname-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_SM)),
    ("--silk-action-sheet-subname-line-height", getSizeConstant(SilkSizeKey.LINE_HEIGHT_SM)),
    ("--silk-action-sheet-close-icon-size", Length(22, unitType: LengthType.vp)),
    ("--silk-action-sheet-loading-icon-size", Length(22, unitType: LengthType.vp)),
    ("--silk-action-sheet-close-icon-padding-top", Length(0, unitType: LengthType.vp)),
    ("--silk-action-sheet-close-icon-padding-right", getSizeConstant(SilkSizeKey.PADDING_MD)),
    ("--silk-action-sheet-close-icon-padding-bottom", Length(0, unitType: LengthType.vp)),
    ("--silk-action-sheet-close-icon-padding-left", getSizeConstant(SilkSizeKey.PADDING_MD)),
    ("--silk-action-sheet-cancel-padding-top", getSizeConstant(SilkSizeKey.PADDING_XS))
])



/**
 * 默认动作面板百分比常量
 *
 * 定义了动作面板的默认百分比常量，用于重置
 */
private let DefaultSilkActionSheetPercentConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-action-sheet-max-height-percent", Length(80, unitType: LengthType.percent))
])

/**
 * 动作面板百分比常量
 *
 * 定义了动作面板的各种百分比常量
 */
private let SilkActionSheetPercentConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-action-sheet-max-height-percent", Length(80, unitType: LengthType.percent))
])

/**
 * 通过枚举获取动作面板颜色常量的值
 * @param key 动作面板颜色枚举键
 * @return 对应的颜色值
 */
public func getActionSheetColorConstant(key: SilkActionSheetColorKey): ResourceColor {
    let stringKey = actionSheetColorKeyToString(key)
    return SilkActionSheetColorConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举修改动作面板颜色常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的颜色值
 * @return 是否修改成功
 */
public func updateActionSheetColorConstant(key: SilkActionSheetColorKey, value: ResourceColor): Bool {
    let stringKey = actionSheetColorKeyToString(key)
    if (SilkActionSheetColorConstants.contains(stringKey)) {
        SilkActionSheetColorConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取动作面板尺寸常量的值
 * @param key 动作面板尺寸枚举键
 * @return 对应的尺寸值
 */
public func getActionSheetSizeConstant(key: SilkActionSheetSizeKey): Length {
    let stringKey = actionSheetSizeKeyToString(key)
    return SilkActionSheetSizeConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举修改动作面板尺寸常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的尺寸值
 * @return 是否修改成功
 */
public func updateActionSheetSizeConstant(key: SilkActionSheetSizeKey, value: Length): Bool {
    let stringKey = actionSheetSizeKeyToString(key)
    if (SilkActionSheetSizeConstants.contains(stringKey)) {
        SilkActionSheetSizeConstants.put(stringKey, value)
        return true
    }
    return false
}



/**
 * 通过枚举获取动作面板百分比常量的值
 * @param key 动作面板百分比常量键
 * @return 对应的百分比值 Length
 */
public func getActionSheetPercentConstant(key: SilkActionSheetPercentKey): Length {
    let stringKey = actionSheetPercentKeyToString(key)
    return SilkActionSheetPercentConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举修改动作面板百分比常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的百分比值
 * @return 是否修改成功
 */
public func updateActionSheetPercentConstant(key: SilkActionSheetPercentKey, value: Length): Bool {
    let stringKey = actionSheetPercentKeyToString(key)
    if (SilkActionSheetPercentConstants.contains(stringKey)) {
        SilkActionSheetPercentConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 重置所有动作面板常量为默认值
 *
 * 将所有动作面板常量重置为初始默认值
 */
public func resetActionSheetConstants() {
    // 重置动作面板颜色常量
    resetActionSheetColorConstants()

    // 重置动作面板尺寸常量
    resetActionSheetSizeConstants()

    // 重置动作面板百分比常量
    resetActionSheetPercentConstants()
}

/**
 * 重置动作面板颜色常量为默认值
 */
public func resetActionSheetColorConstants() {
    SilkActionSheetColorConstants.clear()
    for ((key, value) in DefaultSilkActionSheetColorConstants) {
        SilkActionSheetColorConstants.put(key, value)
    }
}

/**
 * 重置动作面板尺寸常量为默认值
 */
public func resetActionSheetSizeConstants() {
    SilkActionSheetSizeConstants.clear()
    for ((key, value) in DefaultSilkActionSheetSizeConstants) {
        SilkActionSheetSizeConstants.put(key, value)
    }
}



/**
 * 重置动作面板百分比常量为默认值
 */
public func resetActionSheetPercentConstants() {
    SilkActionSheetPercentConstants.clear()
    for ((key, value) in DefaultSilkActionSheetPercentConstants) {
        SilkActionSheetPercentConstants.put(key, value)
    }
}
