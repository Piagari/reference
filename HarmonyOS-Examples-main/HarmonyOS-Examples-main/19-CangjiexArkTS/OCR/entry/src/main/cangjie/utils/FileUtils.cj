/**
 * Created on 2025/5/27
 */
package ohos_app_cangjie_entry.utils

import ohos.base.*
import ohos.file_picker.*
import ohos.state_macro_manage.r
import cj_res_entry.app
import cj_res_entry.sys
import std.collection.ArrayList
import std.fs.Path
import std.format.Formatter

/*
 * 文件处理工具模块
 * 提供文件类型枚举、文件名/扩展名获取、文件大小格式化等功能
*/

//自定义异常类：非文件异常
protected class NonFileException <: Exception {
    public func getClassName(): String {
        "NonFileException"
    }
}

// 文件类型枚举:用于枚举用户选择的文件的类型
public enum FileType <: Hashable & ToString {
    NonFile | Image | Document

    public func icon(): CJResource {
        match (this) {
            case Image => @r(app.media.picture)
            case Document => @r(app.media.file)
            case NonFile => throw NonFileException()
        }
    }

    public func isImage(): Bool {
        match (this) {
            case Image => true
            case _ => false
        }
    }

    // 计算文件类型的哈希值
    public func hashCode() {
        match (this) {
            case Image => 0
            case Document => 1
            case NonFile => -1
        }
    }
    // 将文件类型转换为字符串表示
    public func toString() {
        match (this) {
            case Image => "Image"
            case Document => "Document"
            case NonFile => "NonFile"
        }
    }
    // 从字符串解析文件类型
    public static func of(s: String) {
        match (s) {
            case "Image" => Image
            case "Document" => Document
            case _ => NonFile
        }
    }
}

// 根据文件的uri获取文件名
protected func getFileName(uri: String) {
    Path(uri).fileName.getOrDefault() {
        ""
    }
}

// 根据文件的uri获取文件的扩展名
protected func getFileExt(uri: String) {
    Path(uri).extensionName.getOrDefault() {
        ""
    }
}

/**
 * 根据文件大小获取其字符串表示。
 * @param size: 文件大小，以字节为单位
 */
protected func getSizeStr(size: Int64) {
    if (size < 1000) {
        "${size}B"
    } else if (size < 1000 * 1024) {
        "${(Float64(size) / Float64(1024)).format(".2")}KB"
    } else if (size < 1000 * 1024 * 1024) {
        "${(Float64(size) / Float64(1024*1024)).format(".2")}MB"
    } else {
        "${(Float64(size) / Float64(1024*1024*1024)).format(".2")}GB"
    }
}


