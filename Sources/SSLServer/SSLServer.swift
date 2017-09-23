//
//  SSLServer.swift
//  codegenv
//
//  Created by Bernardo Breder on 10/11/16.
//
//

import Foundation
import Dispatch

#if SWIFT_PACKAGE
    import Server
    import StdSocket
    import SSLSocket
    import StdServer
#endif

public class SSLServer: Server {
    
    public let config: StdSocketConfig
    
    internal let stdFd: Int32
    
    internal let sslFd: SSLSocketServer
    
    public internal(set) var closed: Bool = false
    
    public init(stdConfig: StdSocketConfig, sslConfig: SSLSocketConfig) throws {
        SSLSocket.initialize()
        self.config = stdConfig
        self.stdFd = try StdSocket.socket(port: config.port, queueSize: config.queueSize)
        self.sslFd = try SSLSocket.create(config: sslConfig)
    }
    
    open func accept(timeout: Int?) throws -> Client {
        try StdSocket.wait(stdFd, timeout: timeout)
        let stdSocket = try StdSocket.socketAccept(stdFd)
        let client = StdClientServer(fd: stdSocket)
        do {
            let sslSocket = try SSLSocket.accept(sslFd, fd: client.stdFd)
            return SSLClient(stdFd: stdSocket, sslFd: sslSocket)
        } catch let e {
            client.close()
            throw e
        }
    }
    
    open func close() {
        if !closed {
            SSLSocket.close(server: sslFd)
            StdSocket.socketClose(stdFd)
        }
    }
    
}
