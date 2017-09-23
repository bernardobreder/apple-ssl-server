//
//  SSLClient.swift
//  codegenv
//
//  Created by Bernardo Breder on 10/11/16.
//
//

import Foundation

#if SWIFT_PACKAGE
    import Server
    import StdSocket
    import SSLSocket
    import DataStream
#endif

class SSLClient: Client {
    
    internal let stdFd: Int32
    
    internal let sslFd: SSLSocketClient
    
    internal let inStream: DataInStream

    public var timeout: Int
    
    public private(set) var closed: Bool = false
    
    internal init(stdFd: Int32, sslFd: SSLSocketClient) {
        self.stdFd = stdFd
        self.sslFd = sslFd
        let timeout = 60
        self.timeout = timeout
        self.inStream = DataInStream(reader: {
            try SSLSocket.receive(sslFd, count: min(1024, try StdSocket.waitAvaliable(stdFd, timeout: timeout)))
        })
    }
    
    public func read() throws -> UInt8 {
        return try inStream.read()
    }
    
    public func write(data: Data) throws {
        try SSLSocket.send(sslFd, data: data)
    }
    
    func close() {
        if !closed {
            closed = true
            SSLSocket.close(client: sslFd)
            StdSocket.socketClose(stdFd)
        }
    }
    
}
