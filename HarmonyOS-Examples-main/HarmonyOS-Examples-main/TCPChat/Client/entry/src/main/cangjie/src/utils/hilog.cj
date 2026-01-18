/**
 * Created on 2024/8/21
 */
package ohos_app_cangjie_entry.utils

internal import ohos.hilog.*

public class HiLog {
    public init() {
    }

    public static func info(tag: String, msg: String): Unit {
        Hilog.info(0x0002, tag, msg)
    }

    public static func error(tag: String, msg: String): Unit {
        Hilog.error(0x0002, tag, msg)
    }
}
