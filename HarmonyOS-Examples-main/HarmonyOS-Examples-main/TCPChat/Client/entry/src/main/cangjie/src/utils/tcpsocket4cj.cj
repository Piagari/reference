/**
 * Created on 2024/8/21
 */
package ohos_app_cangjie_entry.utils

import std.socket.*
import encoding.url.*
import std.collection.*

public class Socket4CJ {
    let SERVER_ADDR: String = "192.168.3.66" // 这里请替换为您的后端地址
    let SERVER_PORT: UInt16 = 8080 // 注意这里的端后号，需要与我们Sever端绑定的端口号保持一致
    var tcpSocket: TcpSocket

    public init() {
        this.tcpSocket = TcpSocket(SERVER_ADDR, SERVER_PORT)
    }

    public func connectServer(): Unit {
        try {
            this.tcpSocket.connect() // 连接Sever端
            HiLog.info("Socket", "Connect to server successfully")
        } catch (e: Exception) {
            HiLog.error("Socket", "Connect to server failed, reason is ${e.message}")
        }
    }

    public func sendMsg(msg: String): Unit {
        try {
            this.tcpSocket.write(msg.toArray()) // 向Sever端发送消息
            HiLog.info("Socket", "Send message successfully")
        } catch (e: Exception) {
            HiLog.error("Socket", "Send message failed, reason is ${e.message}")
        }
    }

    public func receiveMsg(): (String, Int64) {
        let buffer: Array<UInt8> = Array<UInt8>(1024, item: 0) // 先声明一个buffer空数组，用于存放Sever端发来的消息数组
        let bufferLen: Int64 = this.tcpSocket.read(buffer) // 将得到的数据写入buffer
        HiLog.info("Socket", "Buffer length is ${bufferLen}")
        let msg: String = String.fromUtf8(buffer) // 将buffer转化为String类型
        return (msg, bufferLen)
    }

    public func closeClient(): Unit {
        this.tcpSocket.close() // 释放socket连接
    }
}
