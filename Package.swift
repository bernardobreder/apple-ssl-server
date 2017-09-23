//
//  Package.swift
//  SSLServer
//
//

import PackageDescription

let package = Package(
	name: "SSLServer",
	targets: [
		Target(name: "SSLServer", dependencies: ["SSLSocket", "StdServer", "StdSocket"]),
		Target(name: "DataBuffer", dependencies: []),
		Target(name: "DataStream", dependencies: []),
		Target(name: "SSLSocket", dependencies: ["StdSocket"]),
		Target(name: "Server", dependencies: []),
		Target(name: "StdServer", dependencies: ["DataBuffer", "DataStream", "Server", "StdSocket"]),
		Target(name: "StdSocket", dependencies: []),
	]
)

#if os(Linux)
	package.dependencies.append(.Package(url: "git@codegenv.com:OpenSSL.git", majorVersion: 1))
#endif
