package net_server

import net_server.server4cj.Server4CJ
import net_server.socket4cj.Socket4CJ

main(): Int64 {
    let socket4cj: Socket4CJ = Socket4CJ()
    socket4cj.startServer()
    return 0
}
