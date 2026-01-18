/**
 * Created on 2025/4/28
 *
 * SilkCell 单元格组件常量定义
 *
 * 本文件定义了单元格组件使用的各种常量，包括颜色、尺寸等
 * 这里定义样式变量。由于泛型的问题，所以此处不使用 resource，全部采用 string
 *
 * @module silkui/constants/cell
 */
package silkui.constants
import std.collection.HashMap
import ohos.base.Length
import ohos.base.LengthType
import ohos.base.Color
import silkui.ResourceColor
import silkui.ResourceStr
import silkui.SilkUIPaddingOptions

/**
 * 单元格颜色常量枚举
 */
public enum SilkCellColorKey {
    | CELL_TEXT_COLOR
    | CELL_BACKGROUND
    | CELL_BORDER_COLOR
    | CELL_ACTIVE_COLOR
    | CELL_REQUIRED_COLOR
    | CELL_LABEL_COLOR
    | CELL_VALUE_COLOR
    | CELL_RIGHT_ICON_COLOR
    | CELL_GROUP_BACKGROUND
    | CELL_GROUP_TITLE_COLOR
}

/**
 * 将单元格颜色枚举转换为字符串
 * @param key 单元格颜色枚举值
 * @return 对应的字符串键
 */
private func cellColorKeyToString(key: SilkCellColorKey): String {
    match (key) {
        case SilkCellColorKey.CELL_TEXT_COLOR => "--silk-cell-text-color"
        case SilkCellColorKey.CELL_BACKGROUND => "--silk-cell-background"
        case SilkCellColorKey.CELL_BORDER_COLOR => "--silk-cell-border-color"
        case SilkCellColorKey.CELL_ACTIVE_COLOR => "--silk-cell-active-color"
        case SilkCellColorKey.CELL_REQUIRED_COLOR => "--silk-cell-required-color"
        case SilkCellColorKey.CELL_LABEL_COLOR => "--silk-cell-label-color"
        case SilkCellColorKey.CELL_VALUE_COLOR => "--silk-cell-value-color"
        case SilkCellColorKey.CELL_RIGHT_ICON_COLOR => "--silk-cell-right-icon-color"
        case SilkCellColorKey.CELL_GROUP_BACKGROUND => "--silk-cell-group-background"
        case SilkCellColorKey.CELL_GROUP_TITLE_COLOR => "--silk-cell-group-title-color"
    }
}

/**
 * 单元格尺寸常量枚举
 */
public enum SilkCellSizeKey {
    | CELL_FONT_SIZE
    | CELL_LINE_HEIGHT
    | CELL_VERTICAL_PADDING
    | CELL_HORIZONTAL_PADDING
    | CELL_LABEL_FONT_SIZE
    | CELL_LABEL_LINE_HEIGHT
    | CELL_LABEL_MARGIN_TOP
    | CELL_ICON_SIZE
    | CELL_LARGE_VERTICAL_PADDING
    | CELL_LARGE_TITLE_FONT_SIZE
    | CELL_LARGE_LABEL_FONT_SIZE
    | CELL_GROUP_TITLE_LINE_HEIGHT
    | CELL_GROUP_TITLE_FONT_SIZE
    | CELL_GROUP_INSET_RADIUS
}

/**
 * 将单元格尺寸枚举转换为字符串
 * @param key 单元格尺寸枚举值
 * @return 对应的字符串键
 */
private func cellSizeKeyToString(key: SilkCellSizeKey): String {
    match (key) {
        case SilkCellSizeKey.CELL_FONT_SIZE => "--silk-cell-font-size"
        case SilkCellSizeKey.CELL_LINE_HEIGHT => "--silk-cell-line-height"
        case SilkCellSizeKey.CELL_VERTICAL_PADDING => "--silk-cell-vertical-padding"
        case SilkCellSizeKey.CELL_HORIZONTAL_PADDING => "--silk-cell-horizontal-padding"
        case SilkCellSizeKey.CELL_LABEL_FONT_SIZE => "--silk-cell-label-font-size"
        case SilkCellSizeKey.CELL_LABEL_LINE_HEIGHT => "--silk-cell-label-line-height"
        case SilkCellSizeKey.CELL_LABEL_MARGIN_TOP => "--silk-cell-label-margin-top"
        case SilkCellSizeKey.CELL_ICON_SIZE => "--silk-cell-icon-size"
        case SilkCellSizeKey.CELL_LARGE_VERTICAL_PADDING => "--silk-cell-large-vertical-padding"
        case SilkCellSizeKey.CELL_LARGE_TITLE_FONT_SIZE => "--silk-cell-large-title-font-size"
        case SilkCellSizeKey.CELL_LARGE_LABEL_FONT_SIZE => "--silk-cell-large-label-font-size"
        case SilkCellSizeKey.CELL_GROUP_TITLE_LINE_HEIGHT => "--silk-cell-group-title-line-height"
        case SilkCellSizeKey.CELL_GROUP_TITLE_FONT_SIZE => "--silk-cell-group-title-font-size"
        case SilkCellSizeKey.CELL_GROUP_INSET_RADIUS => "--silk-cell-group-inset-radius"
    }
}

/**
 * 单元格内边距常量枚举
 */
public enum SilkCellPaddingKey {
    | CELL_GROUP_TITLE_PADDING
    | CELL_GROUP_INSET_PADDING
    | CELL_GROUP_INSET_TITLE_PADDING
}

/**
 * 将单元格内边距枚举转换为字符串
 * @param key 单元格内边距枚举值
 * @return 对应的字符串键
 */
private func cellPaddingKeyToString(key: SilkCellPaddingKey): String {
    match (key) {
        case SilkCellPaddingKey.CELL_GROUP_TITLE_PADDING => "--silk-cell-group-title-padding"
        case SilkCellPaddingKey.CELL_GROUP_INSET_PADDING => "--silk-cell-group-inset-padding"
        case SilkCellPaddingKey.CELL_GROUP_INSET_TITLE_PADDING => "--silk-cell-group-inset-title-padding"
    }
}

/**
 * 默认单元格颜色常量
 *
 * 定义了单元格的默认颜色，用于重置
 */
private let DefaultSilkCellColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-cell-text-color", getColorConstant(SilkColorKey.TEXT_COLOR)),
    ("--silk-cell-background", getColorConstant(SilkColorKey.BACKGROUND_2)),
    ("--silk-cell-border-color", getColorConstant(SilkColorKey.BORDER_COLOR)),
    ("--silk-cell-active-color", getColorConstant(SilkColorKey.ACTIVE_COLOR)),
    ("--silk-cell-required-color", getColorConstant(SilkColorKey.DANGER_COLOR)),
    ("--silk-cell-label-color", getColorConstant(SilkColorKey.TEXT_COLOR_2)),
    ("--silk-cell-value-color", getColorConstant(SilkColorKey.TEXT_COLOR_2)),
    ("--silk-cell-right-icon-color", getColorConstant(SilkColorKey.GRAY_6)),
    ("--silk-cell-group-background", getColorConstant(SilkColorKey.BACKGROUND_2)),
    ("--silk-cell-group-title-color", getColorConstant(SilkColorKey.TEXT_COLOR_2))
])

/**
 * 单元格颜色常量
 *
 * 定义了单元格的各种颜色，包括文字颜色、背景颜色和边框颜色
 */
private let SilkCellColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-cell-text-color", getColorConstant(SilkColorKey.TEXT_COLOR)),
    ("--silk-cell-background", getColorConstant(SilkColorKey.BACKGROUND_2)),
    ("--silk-cell-border-color", getColorConstant(SilkColorKey.BORDER_COLOR)),
    ("--silk-cell-active-color", getColorConstant(SilkColorKey.ACTIVE_COLOR)),
    ("--silk-cell-required-color", getColorConstant(SilkColorKey.DANGER_COLOR)),
    ("--silk-cell-label-color", getColorConstant(SilkColorKey.TEXT_COLOR_2)),
    ("--silk-cell-value-color", getColorConstant(SilkColorKey.TEXT_COLOR_2)),
    ("--silk-cell-right-icon-color", getColorConstant(SilkColorKey.GRAY_6)),
    ("--silk-cell-group-background", getColorConstant(SilkColorKey.BACKGROUND_2)),
    ("--silk-cell-group-title-color", getColorConstant(SilkColorKey.TEXT_COLOR_2))
])

/**
 * 默认单元格尺寸常量
 *
 * 定义了单元格的默认尺寸常量，用于重置
 */
private let DefaultSilkCellSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-cell-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-cell-line-height", Length(24, unitType: LengthType.vp)),
    ("--silk-cell-vertical-padding", Length(10, unitType: LengthType.vp)),
    ("--silk-cell-horizontal-padding", getSizeConstant(SilkSizeKey.PADDING_MD)),
    ("--silk-cell-label-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_SM)),
    ("--silk-cell-label-line-height", Length(18, unitType: LengthType.vp)),
    ("--silk-cell-label-margin-top", getSizeConstant(SilkSizeKey.PADDING_BASE)),
    ("--silk-cell-icon-size", Length(16, unitType: LengthType.vp)),
    ("--silk-cell-large-vertical-padding", getSizeConstant(SilkSizeKey.PADDING_SM)),
    ("--silk-cell-large-title-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_LG)),
    ("--silk-cell-large-label-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-cell-group-title-line-height", Length(16, unitType: LengthType.vp)),
    ("--silk-cell-group-title-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-cell-group-inset-radius", getSizeConstant(SilkSizeKey.RADIUS_LG))
])

/**
 * 单元格尺寸常量
 *
 * 定义了单元格的各种尺寸常量，包括高度、内边距、字体大小等
 */
private let SilkCellSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-cell-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-cell-line-height", Length(24, unitType: LengthType.vp)),
    ("--silk-cell-vertical-padding", Length(10, unitType: LengthType.vp)),
    ("--silk-cell-horizontal-padding", getSizeConstant(SilkSizeKey.PADDING_MD)),
    ("--silk-cell-label-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_SM)),
    ("--silk-cell-label-line-height", Length(18, unitType: LengthType.vp)),
    ("--silk-cell-label-margin-top", getSizeConstant(SilkSizeKey.PADDING_BASE)),
    ("--silk-cell-icon-size", Length(16, unitType: LengthType.vp)),
    ("--silk-cell-large-vertical-padding", getSizeConstant(SilkSizeKey.PADDING_SM)),
    ("--silk-cell-large-title-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_LG)),
    ("--silk-cell-large-label-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-cell-group-title-line-height", Length(16, unitType: LengthType.vp)),
    ("--silk-cell-group-title-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-cell-group-inset-radius", getSizeConstant(SilkSizeKey.RADIUS_LG))
])

/**
 * 默认单元格内边距常量
 *
 * 定义了单元格的默认内边距常量，用于重置
 */
private let DefaultSilkCellPaddingConstants: HashMap<String, SilkUIPaddingOptions> = HashMap<String, SilkUIPaddingOptions>([
    ("--silk-cell-group-title-padding", SilkUIPaddingOptions(
        top: getSizeConstant(SilkSizeKey.PADDING_MD),
        right: getSizeConstant(SilkSizeKey.PADDING_MD),
        bottom: getSizeConstant(SilkSizeKey.PADDING_XS),
        left: getSizeConstant(SilkSizeKey.PADDING_MD)
    )),
    ("--silk-cell-group-inset-padding", SilkUIPaddingOptions(
        top: Length(0, unitType: LengthType.vp),
        right: getSizeConstant(SilkSizeKey.PADDING_MD),
        bottom: Length(0, unitType: LengthType.vp),
        left: getSizeConstant(SilkSizeKey.PADDING_MD)
    )),
    ("--silk-cell-group-inset-title-padding", SilkUIPaddingOptions(
        top: getSizeConstant(SilkSizeKey.PADDING_MD),
        right: getSizeConstant(SilkSizeKey.PADDING_MD),
        bottom: getSizeConstant(SilkSizeKey.PADDING_XS),
        left: getSizeConstant(SilkSizeKey.PADDING_XL)
    ))
])

/**
 * 单元格内边距常量
 *
 * 定义了单元格的各种内边距常量
 */
private let SilkCellPaddingConstants: HashMap<String, SilkUIPaddingOptions> = HashMap<String, SilkUIPaddingOptions>([
    ("--silk-cell-group-title-padding", SilkUIPaddingOptions(
        top: getSizeConstant(SilkSizeKey.PADDING_MD),
        right: getSizeConstant(SilkSizeKey.PADDING_MD),
        bottom: getSizeConstant(SilkSizeKey.PADDING_XS),
        left: getSizeConstant(SilkSizeKey.PADDING_MD)
    )),
    ("--silk-cell-group-inset-padding", SilkUIPaddingOptions(
        top: Length(0, unitType: LengthType.vp),
        right: getSizeConstant(SilkSizeKey.PADDING_MD),
        bottom: Length(0, unitType: LengthType.vp),
        left: getSizeConstant(SilkSizeKey.PADDING_MD)
    )),
    ("--silk-cell-group-inset-title-padding", SilkUIPaddingOptions(
        top: getSizeConstant(SilkSizeKey.PADDING_MD),
        right: getSizeConstant(SilkSizeKey.PADDING_MD),
        bottom: getSizeConstant(SilkSizeKey.PADDING_XS),
        left: getSizeConstant(SilkSizeKey.PADDING_XL)
    ))
])

/**
 * 通过枚举获取单元格颜色常量的值
 * @param key 单元格颜色枚举键
 * @return 对应的颜色值
 */
public func getCellColorConstant(key: SilkCellColorKey): ResourceColor {
    let stringKey = cellColorKeyToString(key)
    return SilkCellColorConstants.get(stringKey).getOrThrow()
}


/**
 * 通过枚举修改单元格颜色常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的颜色值
 * @return 是否修改成功
 */
public func updateCellColorConstant(key: SilkCellColorKey, value: ResourceColor): Bool {
    let stringKey = cellColorKeyToString(key)
    if (SilkCellColorConstants.contains(stringKey)) {
        SilkCellColorConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取单元格尺寸常量的值
 * @param key 单元格尺寸枚举键
 * @return 对应的尺寸值
 */
public func getCellSizeConstant(key: SilkCellSizeKey): Length {
    let stringKey = cellSizeKeyToString(key)
    return SilkCellSizeConstants.get(stringKey).getOrThrow()
}


/**
 * 通过枚举修改单元格尺寸常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的尺寸值
 * @return 是否修改成功
 */
public func updateCellSizeConstant(key: SilkCellSizeKey, value: Length): Bool {
    let stringKey = cellSizeKeyToString(key)
    if (SilkCellSizeConstants.contains(stringKey)) {
        SilkCellSizeConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取单元格内边距常量的值
 * @param key 单元格内边距枚举键
 * @return 对应的内边距值
 */
public func getCellPaddingConstant(key: SilkCellPaddingKey): SilkUIPaddingOptions {
    let stringKey = cellPaddingKeyToString(key)
    return SilkCellPaddingConstants.get(stringKey).getOrThrow()
}


/**
 * 通过枚举修改单元格内边距常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的内边距值
 * @return 是否修改成功
 */
public func updateCellPaddingConstant(key: SilkCellPaddingKey, value: SilkUIPaddingOptions): Bool {
    let stringKey = cellPaddingKeyToString(key)
    if (SilkCellPaddingConstants.contains(stringKey)) {
        SilkCellPaddingConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 重置所有单元格常量为默认值
 *
 * 将所有单元格常量重置为初始默认值
 */
public func resetCellConstants() {
    // 重置单元格颜色常量
    resetCellColorConstants()

    // 重置单元格尺寸常量
    resetCellSizeConstants()

    // 重置单元格内边距常量
    resetCellPaddingConstants()
}

/**
 * 重置单元格颜色常量为默认值
 */
public func resetCellColorConstants() {
    SilkCellColorConstants.clear()
    for ((key, value) in DefaultSilkCellColorConstants) {
        SilkCellColorConstants.put(key, value)
    }
}

/**
 * 重置单元格尺寸常量为默认值
 */
public func resetCellSizeConstants() {
    SilkCellSizeConstants.clear()
    for ((key, value) in DefaultSilkCellSizeConstants) {
        SilkCellSizeConstants.put(key, value)
    }
}

/**
 * 重置单元格内边距常量为默认值
 */
public func resetCellPaddingConstants() {
    SilkCellPaddingConstants.clear()
    for ((key, value) in DefaultSilkCellPaddingConstants) {
        SilkCellPaddingConstants.put(key, value)
    }
}
