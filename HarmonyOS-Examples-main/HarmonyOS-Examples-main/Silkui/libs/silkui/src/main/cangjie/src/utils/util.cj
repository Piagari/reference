/**
 * Created on 2024/11/21
 */
package silkui.utils
import ohos.base.CJResource
import ohos.base.Color
import silkui.ResourceColor
import silkui.ResourceStr
import ohos.base.getResourceColor
import ohos.base.getResourceString

public func ResourceColorToColor (value: ?ResourceColor): Color {
    if (value.isNone()) {
        return Color(0x00ffffff)
    }
    if (value.getOrThrow() is Color) {
        if ((value.getOrThrow() as Color).isSome()) {
            (value.getOrThrow() as Color).getOrThrow()
        } else {
            Color(0x00ffffff)
        }

    } else {
        if ((value.getOrThrow() as CJResource).isSome()) {
            getResourceColor((value.getOrThrow() as CJResource).getOrThrow())
        } else {
            Color(0x00ffffff)
        }
    }
}
public func ResourceStrToString (value: ?ResourceStr): String {
    if (value.isNone()) {
        return String.empty
    }
    if (value.getOrThrow() is String) {
        if ((value.getOrThrow() as String).isSome()) {
            (value.getOrThrow() as String).getOrThrow()
        } else {
            String.empty
        }

    } else {
        if ((value.getOrThrow() as CJResource).isSome()) {
            getResourceString((value.getOrThrow() as CJResource).getOrThrow())
        } else {
            String.empty
        }
    }
}

/**
 * 将字符串转换为Int64类型
 *
 * 如果字符串仅包含数字，则转换成功，返回对应的Int64值
 * 如果字符串包含小数点、负号或其他非数字字符，则转换失败，返回None
 *
 * @param str 要转换的字符串
 * @return 转换结果，成功返回Option<Int64>，失败返回None
 */
public func StringToInt64(str: String): Option<Int64> {
    if (str == "") {
        return Option.None
    }

    var result: Int64 = 0

    // 获取字符编码数组
    let charCodes = str.toArray()

    let size = charCodes.size
    for (i in 0..size) {
        if (i >= size) {
            break
        }
        let code = charCodes[i]

        // 检查是否是数字字符 (0-9的ASCII码是48-57)
        if (code >= 48 && code <= 57) {
            // 将字符转换为数字并累加到结果中
            result = result * 10 + Int64(code - 48)
        } else {
            // 如果包含非数字字符，返回None
            return Option.None
        }
    }

    return Option.Some(result)
}
