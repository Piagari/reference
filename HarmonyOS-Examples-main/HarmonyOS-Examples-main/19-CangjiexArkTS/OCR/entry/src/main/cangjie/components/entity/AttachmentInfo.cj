/**
 * Created on 2024/8/26
 */
package ohos_app_cangjie_entry.components.entity

import std.io.ByteArrayStream
import encoding.json.*
import std.collection.*
import std.time.*
import std.core.Array
import CJson.jsonmacro.*
import CJson.IJsonSerializable
import CJson.IJsonValueSerializable

import ohos_app_cangjie_entry.utils.FileType
import ohos_app_cangjie_entry.interop.OcrFileInfo


/**
 * 附件信息类，用于表示用户选择的文件及其OCR处理状态
 *
 * 功能说明：
 * 1. 封装文件的基本信息：URI、大小、类型、在附件列表中的索引
 * 2. 跟踪文件处理状态：上传/解析/完成等阶段
 * 3. 存储OCR识别结果文本
 * 4. 支持JSON序列化，便于数据存储和传输
 * 5. 实现哈希和相等比较，支持在集合中使用
**/

public class AttachmentInfo <: Hashable & Equatable<AttachmentInfo> {
    // 主构造函数
    protected AttachmentInfo(
        protected let uri: String,         // 文件URI
        protected let size: Int64,         // 文件大小
        protected let kind: FileType,      // 文件类型枚举
        protected var index: Int64,        // 在附件列表中的索引
        protected var stage!: ProcessStage = UPLOADING, // 处理阶段，默认上传中
        protected var ocrResult!: String = "" // OCR结果文本，初始为空
    ) {}

    // 从OCR文件信息构造的便捷构造函数
    protected init(
        info: OcrFileInfo,     // OCR文件信息对象
        kind: FileType,        // 文件类型
        index: Int64,          // 在附件列表中的索引
        stage!: ProcessStage = UPLOADING // 处理阶段，默认上传中
    ) {
        this.uri = info.uri
        this.size = info.size
        this.ocrResult = info.ocrResult
        this.kind = kind
        this.index = index
        this.stage = stage
    }

    // 将对象序列化为JSON字符串
    public func toJsonString() {
        let obj = JsonObject()
        obj.put("uri", JsonString(uri))
        obj.put("size", JsonInt(size))
        obj.put("kind", JsonString(kind.toString())) // 枚举转字符串存储
        obj.put("ocr_result", JsonString(ocrResult))
        obj.toString()  // 返回JSON格式字符串
    }

    // 计算对象的哈希值（用于HashMap/HashSet）
    @OverflowWrapping
    public func hashCode() {
        const factor = 31
        var result = uri.hashCode()
        result = factor * result + size
        result = factor * result + kind.hashCode()
        result = factor * result + index
        result = factor * result + stage.hashCode()
        result = factor * result + ocrResult.hashCode()
        result
    }

    // 相等比较运算符重载
    public operator func==(r: AttachmentInfo) {
        this.hashCode() == r.hashCode()
    }

    // 不等比较运算符重载
    public operator func!=(r: AttachmentInfo) {
        this.hashCode() != r.hashCode()
    }

    public func isValid() {
        match (this.stage) {
            case FINISHED =>  // 解析完成状态
                // 检查OCR结果是否为空
                if (this.ocrResult.isEmpty()) {
                    false  // 结果为空则无效
                } else {
                    true   // 结果非空则有效
                }
            case FAILED => false  // 解析失败状态直接无效
            case _ => true        // 其他状态（上传中/等待中/解析中）视为有效
        }
    }
}
