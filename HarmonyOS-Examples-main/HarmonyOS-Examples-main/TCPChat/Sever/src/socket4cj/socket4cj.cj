package net_server.socket4cj

import std.socket.{TcpServerSocket, TcpSocket}
import std.console.{Console}

public class Socket4CJ {
    var tcpServerSocket: TcpServerSocket
    var client: TcpSocket
    let SERVER_PORT: UInt16 = 8080 // 服务端端口号，一定与客户端（Client）端口号保持一致

    public init() {
        this.tcpServerSocket = TcpServerSocket(bindAt: SERVER_PORT)
        try {
            this.tcpServerSocket.bind() // 绑定端口号
            println("Bind port successfully")
            this.client = this.tcpServerSocket.accept() // 与客户端建立连接
            println("Connect to client successfully")
        } catch (e: Exception) {
            println("Error has been appended, error is ${e.message}")
        }
    }

    public func readMsg(): Bool {
        let buffer: Array<UInt8> = Array<UInt8>(1024, item: 0)
        let len: Int64 = this.client.read(buffer) // 读取消息
        if (len == 0) {
            println("Client has been closed")
            return false
        } else {
            println("Buffer size is ${len}")
            let msg: String = String.fromUtf8(buffer) // 数组转字符串
            println("Msg is ${msg}")
            return true
        }
    }

    public func writeMsg(msg: String): Unit {
        this.client.write(msg.toArray()) // 写入消息
    }

    public func startServer(): Unit {
        spawn { // 子线程
            while (true) {
                let b: Bool = readMsg()
                if (!b) {
                    break
                }
            }
        }
        var message: String = ''
        Console.stdOut.write("Start dialog\n")
        while (true) {
            let input = Console.stdIn.readln() // 从控制台读取输入
            message = input.getOrThrow()
            if (message != "ok") {
                writeMsg(message)
            } else {
                break
            }
        }
        this.client.close() // 释放连接
        this.tcpServerSocket.close()
    }
}
