/**
 * Created on 2025/4/28
 *
 * SilkLoading 加载组件常量定义
 *
 * 本文件定义了加载组件使用的各种常量，包括颜色、尺寸、动画时长等
 * 这里定义样式变量。由于泛型的问题，所以此处不使用 resource，全部采用 string
 *
 * @module silkui/constants/loading
 */
package silkui.constants
import std.collection.HashMap
import ohos.base.Length
import ohos.base.LengthType
import ohos.base.Color
import silkui.ResourceColor
import silkui.ResourceStr

/**
 * 加载组件颜色常量枚举
 */
public enum SilkLoadingColorKey {
    | LOADING_TEXT_COLOR
    | LOADING_SPINNER_COLOR
}

/**
 * 将加载组件颜色枚举转换为字符串
 * @param key 加载组件颜色枚举值
 * @return 对应的字符串键
 */
private func loadingColorKeyToString(key: SilkLoadingColorKey): String {
    match (key) {
        case SilkLoadingColorKey.LOADING_TEXT_COLOR => "--silk-loading-text-color"
        case SilkLoadingColorKey.LOADING_SPINNER_COLOR => "--silk-loading-spinner-color"
    }
}

/**
 * 加载组件尺寸常量枚举
 */
public enum SilkLoadingSizeKey {
    | LOADING_TEXT_FONT_SIZE
    | LOADING_SPINNER_SIZE
}

/**
 * 将加载组件尺寸枚举转换为字符串
 * @param key 加载组件尺寸枚举值
 * @return 对应的字符串键
 */
private func loadingSizeKeyToString(key: SilkLoadingSizeKey): String {
    match (key) {
        case SilkLoadingSizeKey.LOADING_TEXT_FONT_SIZE => "--silk-loading-text-font-size"
        case SilkLoadingSizeKey.LOADING_SPINNER_SIZE => "--silk-loading-spinner-size"
    }
}

/**
 * 加载组件动画常量枚举
 */
public enum SilkLoadingAnimationKey {
    | LOADING_SPINNER_DURATION
}

/**
 * 将加载组件动画枚举转换为字符串
 * @param key 加载组件动画枚举值
 * @return 对应的字符串键
 */
private func loadingAnimationKeyToString(key: SilkLoadingAnimationKey): String {
    match (key) {
        case SilkLoadingAnimationKey.LOADING_SPINNER_DURATION => "--silk-loading-spinner-duration"
    }
}

/**
 * 默认加载组件颜色常量
 *
 * 定义了加载组件的默认颜色常量，用于重置
 */
private let DefaultSilkLoadingColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-loading-text-color", getColorConstant(SilkColorKey.TEXT_COLOR_2)),
    ("--silk-loading-spinner-color", getColorConstant(SilkColorKey.GRAY_5))
])

/**
 * 加载组件颜色常量
 *
 * 定义了加载组件的各种颜色常量，包括文字颜色和加载图标颜色
 */
private let SilkLoadingColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-loading-text-color", getColorConstant(SilkColorKey.TEXT_COLOR_2)),
    ("--silk-loading-spinner-color", getColorConstant(SilkColorKey.GRAY_5))
])

/**
 * 默认加载组件尺寸常量
 *
 * 定义了加载组件的默认尺寸常量，用于重置
 */
private let DefaultSilkLoadingSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-loading-text-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-loading-spinner-size", Length(30, unitType: LengthType.vp))
])

/**
 * 加载组件尺寸常量
 *
 * 定义了加载组件的各种尺寸常量，包括文字大小和加载图标尺寸
 */
private let SilkLoadingSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-loading-text-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-loading-spinner-size", Length(30, unitType: LengthType.vp))
])

/**
 * 默认加载组件动画常量
 *
 * 定义了加载组件的默认动画相关常量，用于重置
 */
private let DefaultSilkLoadingAnimationConstants: HashMap<String, Float64> = HashMap<String, Float64>([
    ("--silk-loading-spinner-duration", 0.8)
])

/**
 * 加载组件动画常量
 *
 * 定义了加载组件的动画相关常量，包括动画时长
 */
private let SilkLoadingAnimationConstants: HashMap<String, Float64> = HashMap<String, Float64>([
    ("--silk-loading-spinner-duration", 0.8)
])

/**
 * 通过枚举获取加载组件颜色常量的值
 * @param key 加载组件颜色枚举键
 * @return 对应的颜色值
 */
public func getLoadingColorConstant(key: SilkLoadingColorKey): ResourceColor {
    let stringKey = loadingColorKeyToString(key)
    return SilkLoadingColorConstants.get(stringKey).getOrThrow()
}


/**
 * 通过枚举修改加载组件颜色常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的颜色值
 * @return 是否修改成功
 */
public func updateLoadingColorConstant(key: SilkLoadingColorKey, value: ResourceColor): Bool {
    let stringKey = loadingColorKeyToString(key)
    if (SilkLoadingColorConstants.contains(stringKey)) {
        SilkLoadingColorConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取加载组件尺寸常量的值
 * @param key 加载组件尺寸枚举键
 * @return 对应的尺寸值
 */
public func getLoadingSizeConstant(key: SilkLoadingSizeKey): Length {
    let stringKey = loadingSizeKeyToString(key)
    return SilkLoadingSizeConstants.get(stringKey).getOrThrow()
}


/**
 * 通过枚举修改加载组件尺寸常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的尺寸值
 * @return 是否修改成功
 */
public func updateLoadingSizeConstant(key: SilkLoadingSizeKey, value: Length): Bool {
    let stringKey = loadingSizeKeyToString(key)
    if (SilkLoadingSizeConstants.contains(stringKey)) {
        SilkLoadingSizeConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取加载组件动画常量的值
 * @param key 加载组件动画枚举键
 * @return 对应的动画时长值（秒）
 */
public func getLoadingAnimationConstant(key: SilkLoadingAnimationKey): Float64 {
    let stringKey = loadingAnimationKeyToString(key)
    return SilkLoadingAnimationConstants.get(stringKey).getOrThrow()
}


/**
 * 通过枚举修改加载组件动画常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的动画时长值（秒）
 * @return 是否修改成功
 */
public func updateLoadingAnimationConstant(key: SilkLoadingAnimationKey, value: Float64): Bool {
    let stringKey = loadingAnimationKeyToString(key)
    if (SilkLoadingAnimationConstants.contains(stringKey)) {
        SilkLoadingAnimationConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 重置所有加载组件常量为默认值
 *
 * 将所有加载组件常量重置为初始默认值
 */
public func resetLoadingConstants() {
    // 重置加载组件颜色常量
    resetLoadingColorConstants()

    // 重置加载组件尺寸常量
    resetLoadingSizeConstants()

    // 重置加载组件动画常量
    resetLoadingAnimationConstants()
}

/**
 * 重置加载组件颜色常量为默认值
 */
public func resetLoadingColorConstants() {
    SilkLoadingColorConstants.clear()
    for ((key, value) in DefaultSilkLoadingColorConstants) {
        SilkLoadingColorConstants.put(key, value)
    }
}

/**
 * 重置加载组件尺寸常量为默认值
 */
public func resetLoadingSizeConstants() {
    SilkLoadingSizeConstants.clear()
    for ((key, value) in DefaultSilkLoadingSizeConstants) {
        SilkLoadingSizeConstants.put(key, value)
    }
}

/**
 * 重置加载组件动画常量为默认值
 */
public func resetLoadingAnimationConstants() {
    SilkLoadingAnimationConstants.clear()
    for ((key, value) in DefaultSilkLoadingAnimationConstants) {
        SilkLoadingAnimationConstants.put(key, value)
    }
}
