/**
 * Created on 2024/8/26
 */
package ohos_app_cangjie_entry.data

import ohos_app_cangjie_entry.chat.*
import ohos.hilog.*
import std.collection.ArrayList
import std.fs.*
import std.io.ByteArrayStream
import encoding.json.stream.*
import encoding.json.*

func formatArrange(data: Array<Byte>) {
    var cleanData = ArrayList<Byte>()
    for (i in 0..data.size) {
        if (data[i] != 10) {
            cleanData.append(data[i])
        }
    }
    return cleanData.toArray()
}

func byteArrayToString(data: Array<Byte>) {
    var result = StringBuilder("")
    for (i in 0..data.size) {
        result.append(Rune(data[i]))
    }
    return result.toString()
}

public func readHistory(filePath: Path) {
    var historyArray: ArrayList<Chat> = ArrayList<Chat>([])
    if (File.exists(filePath)) {
        var allData = formatArrange(File.readFrom(filePath))
        var head = 0
        for (i in 3..allData.size) {
            if (byteArrayToString(allData[i - 2..i + 1]) == "}]}") { // 结束符
                var slicingData = allData[head..i + 1]
                head = i + 2 // 跳过逗号
                historyArray.append(Chat.fromJson(String.fromUtf8(slicingData)))
            }
        }
    }
    return historyArray.toArray()
}

public func writeHistory(writeChat: Chat, filePath: Path) {
    var file: File
    if (!File.exists(filePath)) {
        file = File(filePath, OpenOption.Create(false)) /* 新建文件 */
    } else {
        file = File(filePath, OpenOption.Append) /* 以 追加模式 打开文件 */
        file.write(',\n'.toArray())
    }
    file.write(writeChat.toJson().toArray())
    file.close()
}
