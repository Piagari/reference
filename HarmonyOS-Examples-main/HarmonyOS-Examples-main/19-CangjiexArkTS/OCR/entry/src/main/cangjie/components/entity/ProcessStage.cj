/**
 * Created on 2025/7/30
 */
package ohos_app_cangjie_entry.components.entity

public enum ProcessStage <: Hashable & ToString {
    UPLOADING | PENDING | PARSING | FINISHED | FAILED | INVALID

    // 从Int8转换为枚举值
    public static func fromInt8(o: Int8) {
        match (o) {
            case 0 => UPLOADING
            case 1 => PENDING
            case 2 => PARSING
            case 3 => FINISHED
            case 4 => FAILED
            case _ => INVALID
        }
    }

    // 将枚举值转换为Int8
    public func i8(): Int8 {
        match (this) {
            case UPLOADING => 0
            case PENDING => 1
            case PARSING => 2
            case FINISHED => 3
            case FAILED => 4
            case INVALID => -1
        }
    }

    // 计算哈希值
    public func hashCode() {
        Int64(i8())
    }

    // 转换为字符串表示
    public func toString() {
        match (this) {
            case UPLOADING => "UPLOADING"
            case PENDING => "PENDING"
            case PARSING => "PARSING"
            case FINISHED => "FINISHED"
            case FAILED => "FAILED"
            case INVALID => "INVALID"
        }
    }

    // 枚举值与Int8的比较
    public operator func ==(r: Int8): Bool {
        match (this) {
            case UPLOADING => r == 0
            case PENDING => r == 1
            case PARSING => r == 2
            case FINISHED => r == 3
            case FAILED => r == 4
            case INVALID => r < 0 || r > 4
        }
    }

    public operator func !=(r: Int8): Bool {
        !(this == r)
    }
}