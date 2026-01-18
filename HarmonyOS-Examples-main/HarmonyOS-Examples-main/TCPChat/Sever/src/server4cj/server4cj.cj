package net_server.server4cj

import net.{http.Server, http.HttpContext, http.ServerBuilder}

public class Server4CJ {
    private let IP_ADDR: String = "0.0.0.0"
    private let PORT: UInt16 = 8080
    private var _server: Server
    public init() {
        _server = ServerBuilder().addr(IP_ADDR).port(PORT).build()
    }

    public func startServer() {
        _server.serve()
    }

    public func closeServer() {
        _server.close()
    }

    public func registerServer(path: String): Unit {
        _server.distributor.register(
            path,
            {
                HttpContext => HttpContext.responseBuilder.body("{name:nefilibata,age:21}")
            }
        )
    }
}
