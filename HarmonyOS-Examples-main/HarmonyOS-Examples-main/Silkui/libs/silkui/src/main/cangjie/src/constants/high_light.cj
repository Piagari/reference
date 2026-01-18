/**
 * Created on 2025/4/28
 */
package silkui.constants
import std.collection.HashMap
import ohos.base.Color
import silkui.ResourceColor

/**
 * 高亮文本颜色常量枚举
 */
public enum SilkHighLightColorKey {
    | HIGHLIGHT_TAG_COLOR
}

/**
 * 将高亮文本颜色枚举转换为字符串
 * @param key 高亮文本颜色枚举值
 * @return 对应的字符串键
 */
private func highLightColorKeyToString(key: SilkHighLightColorKey): String {
    match (key) {
        case SilkHighLightColorKey.HIGHLIGHT_TAG_COLOR => "--silk-highlight-tag-color"
    }
}

/**
 * 默认高亮文本颜色常量
 *
 * 定义了高亮文本的默认颜色常量，用于重置
 */
private let DefaultSilkHighLightColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-highlight-tag-color", getColorConstant(SilkColorKey.PRIMARY_COLOR))
])

/**
 * 高亮文本颜色常量
 *
 * 定义了高亮文本的各种颜色常量
 */
private let SilkHighLightColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-highlight-tag-color", getColorConstant(SilkColorKey.PRIMARY_COLOR))
])

/**
 * 通过枚举获取高亮文本颜色常量的值
 * @param key 高亮文本颜色枚举键
 * @return 对应的颜色值
 */
public func getHighLightColorConstant(key: SilkHighLightColorKey): ResourceColor {
    let stringKey = highLightColorKeyToString(key)
    return SilkHighLightColorConstants.get(stringKey).getOrThrow()
}


/**
 * 通过枚举修改高亮文本颜色常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的颜色值
 * @return 是否修改成功
 */
public func updateHighLightColorConstant(key: SilkHighLightColorKey, value: ResourceColor): Bool {
    let stringKey = highLightColorKeyToString(key)
    if (SilkHighLightColorConstants.contains(stringKey)) {
        SilkHighLightColorConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 重置所有高亮文本常量为默认值
 *
 * 将所有高亮文本常量重置为初始默认值
 */
public func resetHighLightConstants() {
    // 重置高亮文本颜色常量
    resetHighLightColorConstants()
}

/**
 * 重置高亮文本颜色常量为默认值
 */
public func resetHighLightColorConstants() {
    SilkHighLightColorConstants.clear()
    for ((key, value) in DefaultSilkHighLightColorConstants) {
        SilkHighLightColorConstants.put(key, value)
    }
}