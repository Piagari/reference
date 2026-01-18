/**
 * Created on 2025/5/9
 *
 * SilkImage 图片组件常量定义
 *
 * 本文件定义了图片组件使用的各种常量，包括颜色、尺寸等
 *
 * @module silkui/constants/image
 */
package silkui.constants
import std.collection.HashMap
import ohos.base.Length
import ohos.base.LengthType
import ohos.base.Color
import silkui.ResourceColor
import silkui.ResourceStr

/**
 * 图片颜色常量枚举
 */
public enum SilkImageColorKey {
    | IMAGE_PLACEHOLDER_TEXT_COLOR
    | IMAGE_LOADING_ICON_COLOR
    | IMAGE_ERROR_ICON_COLOR
    | IMAGE_PLACEHOLDER_BACKGROUND
}

/**
 * 将图片颜色枚举转换为字符串
 * @param key 图片颜色枚举值
 * @return 对应的字符串键
 */
private func imageColorKeyToString(key: SilkImageColorKey): String {
    match (key) {
        case SilkImageColorKey.IMAGE_PLACEHOLDER_TEXT_COLOR => "--silk-image-placeholder-text-color"
        case SilkImageColorKey.IMAGE_LOADING_ICON_COLOR => "--silk-image-loading-icon-color"
        case SilkImageColorKey.IMAGE_ERROR_ICON_COLOR => "--silk-image-error-icon-color"
        case SilkImageColorKey.IMAGE_PLACEHOLDER_BACKGROUND => "--silk-image-placeholder-background"
    }
}

/**
 * 图片尺寸常量枚举
 */
public enum SilkImageSizeKey {
    | IMAGE_PLACEHOLDER_FONT_SIZE
    | IMAGE_LOADING_ICON_SIZE
    | IMAGE_ERROR_ICON_SIZE
    | IMAGE_RADIUS
}

/**
 * 将图片尺寸枚举转换为字符串
 * @param key 图片尺寸枚举值
 * @return 对应的字符串键
 */
private func imageSizeKeyToString(key: SilkImageSizeKey): String {
    match (key) {
        case SilkImageSizeKey.IMAGE_PLACEHOLDER_FONT_SIZE => "--silk-image-placeholder-font-size"
        case SilkImageSizeKey.IMAGE_LOADING_ICON_SIZE => "--silk-image-loading-icon-size"
        case SilkImageSizeKey.IMAGE_ERROR_ICON_SIZE => "--silk-image-error-icon-size"
        case SilkImageSizeKey.IMAGE_RADIUS => "--silk-image-radius"
    }
}

/**
 * 默认图片颜色常量
 *
 * 定义了图片的默认颜色常量，用于重置
 */
private let DefaultSilkImageColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-image-placeholder-text-color", getColorConstant(SilkColorKey.TEXT_COLOR_2)),
    ("--silk-image-loading-icon-color", getColorConstant(SilkColorKey.GRAY_4)),
    ("--silk-image-error-icon-color", getColorConstant(SilkColorKey.GRAY_4)),
    ("--silk-image-placeholder-background", getColorConstant(SilkColorKey.BACKGROUND))
])

/**
 * 图片颜色常量
 *
 * 定义了图片的各种颜色常量
 */
private let SilkImageColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-image-placeholder-text-color", getColorConstant(SilkColorKey.TEXT_COLOR_2)),
    ("--silk-image-loading-icon-color", getColorConstant(SilkColorKey.GRAY_4)),
    ("--silk-image-error-icon-color", getColorConstant(SilkColorKey.GRAY_4)),
    ("--silk-image-placeholder-background", getColorConstant(SilkColorKey.BACKGROUND))
])

/**
 * 默认图片尺寸常量
 *
 * 定义了图片的默认尺寸常量，用于重置
 */
private let DefaultSilkImageSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-image-placeholder-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-image-loading-icon-size", Length(32, unitType: LengthType.vp)),
    ("--silk-image-error-icon-size", Length(32, unitType: LengthType.vp)),
    ("--silk-image-radius", Length(0, unitType: LengthType.vp))
])

/**
 * 图片尺寸常量
 *
 * 定义了图片的各种尺寸常量
 */
private let SilkImageSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-image-placeholder-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-image-loading-icon-size", Length(32, unitType: LengthType.vp)),
    ("--silk-image-error-icon-size", Length(32, unitType: LengthType.vp)),
    ("--silk-image-radius", Length(0, unitType: LengthType.vp))
])

/**
 * 通过枚举获取图片颜色常量的值
 * @param key 图片颜色枚举键
 * @return 对应的颜色值
 */
public func getImageColorConstant(key: SilkImageColorKey): ResourceColor {
    let stringKey = imageColorKeyToString(key)
    return SilkImageColorConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举获取图片尺寸常量的值
 * @param key 图片尺寸枚举键
 * @return 对应的尺寸值
 */
public func getImageSizeConstant(key: SilkImageSizeKey): Length {
    let stringKey = imageSizeKeyToString(key)
    return SilkImageSizeConstants.get(stringKey).getOrThrow()
}

/**
 * 更新图片颜色常量
 * @param key 图片颜色枚举键
 * @param value 新的颜色值
 */
public func updateImageColorConstant(key: SilkImageColorKey, value: ResourceColor) {
    let stringKey = imageColorKeyToString(key)
    SilkImageColorConstants.put(stringKey, value)
}

/**
 * 更新图片尺寸常量
 * @param key 图片尺寸枚举键
 * @param value 新的尺寸值
 */
public func updateImageSizeConstant(key: SilkImageSizeKey, value: Length) {
    let stringKey = imageSizeKeyToString(key)
    SilkImageSizeConstants.put(stringKey, value)
}

/**
 * 重置图片颜色常量
 * @param key 图片颜色枚举键
 */
public func resetImageColorConstant(key: SilkImageColorKey) {
    let stringKey = imageColorKeyToString(key)
    let defaultValue = DefaultSilkImageColorConstants.get(stringKey).getOrThrow()
    SilkImageColorConstants.put(stringKey, defaultValue)
}

/**
 * 重置图片尺寸常量
 * @param key 图片尺寸枚举键
 */
public func resetImageSizeConstant(key: SilkImageSizeKey) {
    let stringKey = imageSizeKeyToString(key)
    let defaultValue = DefaultSilkImageSizeConstants.get(stringKey).getOrThrow()
    SilkImageSizeConstants.put(stringKey, defaultValue)
}

/**
 * 重置所有图片颜色常量
 */
public func resetAllImageColorConstants() {
    for ((key, value) in DefaultSilkImageColorConstants) {
        SilkImageColorConstants.put(key, value)
    }
}

/**
 * 重置所有图片尺寸常量
 */
public func resetAllImageSizeConstants() {
    for ((key, value) in DefaultSilkImageSizeConstants) {
        SilkImageSizeConstants.put(key, value)
    }
}

/**
 * 重置所有图片常量
 */
public func resetAllImageConstants() {
    resetAllImageColorConstants()
    resetAllImageSizeConstants()
}
