// swift-tools-version: 6.2
//===----------------------------------------------------------------------===//
// Copyright © 2025-2026 Apple Inc. and the container project authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//===----------------------------------------------------------------------===//

// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let releaseVersion = ProcessInfo.processInfo.environment["RELEASE_VERSION"] ?? "0.0.0"
let gitCommit = ProcessInfo.processInfo.environment["GIT_COMMIT"] ?? "unspecified"
let builderShimVersion = "0.13.1"
let scVersion = "0.41.0"

let package = Package(
    name: "bucket",
    platforms: [.macOS("15")],
    products: [
        .library(name: "ContainerCommands", targets: ["ContainerCommands"]),
        .library(name: "ContainerBuild", targets: ["ContainerBuild"]),
        .library(name: "ContainerAPIService", targets: ["ContainerAPIService"]),
        .library(name: "ContainerAPIClient", targets: ["ContainerAPIClient"]),
        .library(name: "ContainerImagesService", targets: ["ContainerImagesService", "ContainerImagesServiceClient"]),
        .library(name: "ContainerNetworkClient", targets: ["ContainerNetworkClient"]),
        .library(name: "ContainerNetworkServer", targets: ["ContainerNetworkServer"]),
        .library(name: "ContainerNetworkVmnetServer", targets: ["ContainerNetworkVmnetServer"]),
        .library(name: "ContainerResource", targets: ["ContainerResource"]),
        .library(name: "ContainerTestSupport", targets: ["ContainerTestSupport"]),
        .library(name: "ContainerLog", targets: ["ContainerLog"]),
        .library(name: "ContainerPersistence", targets: ["ContainerPersistence"]),
        .library(name: "ContainerPlugin", targets: ["ContainerPlugin"]),
        .library(name: "ContainerRuntimeClient", targets: ["ContainerRuntimeClient"]),
        .library(name: "ContainerRuntimeLinuxClient", targets: ["ContainerRuntimeLinuxClient"]),
        .library(name: "ContainerRuntimeLinuxServer", targets: ["ContainerRuntimeLinuxServer"]),
        .library(name: "ContainerVersion", targets: ["ContainerVersion"]),
        .library(name: "ContainerXPC", targets: ["ContainerXPC"]),
        .library(name: "ContainerOS", targets: ["ContainerOS"]),
        .library(name: "SocketForwarder", targets: ["SocketForwarder"]),
        .library(name: "TerminalProgress", targets: ["TerminalProgress"]),
        .library(name: "MachineAPIClient", targets: ["MachineAPIClient"]),
        .library(name: "MachineAPIService", targets: ["MachineAPIService"]),
        .library(name: "ContainerK8s", targets: ["ContainerK8s"]),
        .library(name: "Containerization", targets: ["Containerization", "ContainerizationError"]),
        .library(name: "ContainerizationEXT4", targets: ["ContainerizationEXT4"]),
        .library(name: "ContainerizationOCI", targets: ["ContainerizationOCI"]),
        .library(name: "ContainerizationNetlink", targets: ["ContainerizationNetlink"]),
        .library(name: "ContainerizationIO", targets: ["ContainerizationIO"]),
        .library(name: "ContainerizationOS", targets: ["ContainerizationOS"]),
        .library(name: "ContainerizationExtras", targets: ["ContainerizationExtras"]),
        .library(name: "ContainerizationArchive", targets: ["ContainerizationArchive"]),
        .library(name: "VminitdCore", targets: ["VminitdCore", "Cgroup", "LCShim"]),
        .library(name: "CloudHypervisor", targets: ["CloudHypervisor"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.7.0"),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-configuration", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.10.1"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.80.0"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.36.0"),
        .package(url: "https://github.com/apple/swift-system.git", from: "1.6.4"),
        .package(url: "https://github.com/grpc/grpc-swift-2.git", from: "2.3.0"),
        .package(url: "https://github.com/grpc/grpc-swift-nio-transport.git", from: "2.9.0"),
        .package(url: "https://github.com/grpc/grpc-swift-protobuf.git", from: "2.2.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.20.1"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin.git", from: "1.1.0"),
        .package(url: "https://github.com/mattt/swift-toml.git", from: "2.0.0"),
        .package(url: "https://github.com/mattt/swift-configuration-toml", from: "2.0.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "6.2.1"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.0.0"),
        .package(url: "https://github.com/apple/swift-nio-ssl.git", from: "2.36.0"),
        .package(url: "https://github.com/facebook/zstd.git", exact: "1.5.7"),
    ],
    targets: [
        .executableTarget(
            name: "container",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "ContainerAPIClient",
                "ContainerCommands",
            ],
            path: "Sources/CLI"
        ),
        .testTarget(
            name: "IntegrationTests",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "SystemPackage", package: "swift-system"),
                "Containerization",
                "ContainerizationArchive",
                "ContainerizationExtras",
                "ContainerizationOCI",
                "ContainerizationOS",
                .product(name: "TOML", package: "swift-toml"),
                "ContainerAPIClient",
                "ContainerLog",
                "ContainerPersistence",
                "ContainerPlugin",
                "ContainerResource",
                "ContainerTestSupport",
                "MachineAPIClient",
                "Yams",
            ],
            path: "Tests/IntegrationTests"
        ),
        .target(
            name: "ContainerCommands",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "SwiftProtobuf", package: "swift-protobuf"),
                .product(name: "TOML", package: "swift-toml"),
                "Containerization",
                "ContainerizationOCI",
                "ContainerizationOS",
                "ContainerBuild",
                "ContainerAPIClient",
                "ContainerLog",
                "ContainerPersistence",
                "ContainerPlugin",
                "ContainerResource",
                "ContainerRuntimeClient",
                "ContainerRuntimeLinuxClient",
                "ContainerVersion",
                .product(name: "SystemPackage", package: "swift-system"),
                "ContainerXPC",
                "MachineAPIClient",
                "TerminalProgress",
                "Yams",
            ],
            path: "Sources/ContainerCommands"
        ),
        .target(
            name: "ContainerBuild",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                "Containerization",
                "ContainerizationArchive",
                "ContainerizationOCI",
                "ContainerizationOS",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "GRPCCore", package: "grpc-swift-2"),
                .product(name: "GRPCNIOTransportHTTP2", package: "grpc-swift-nio-transport"),
                .product(name: "GRPCProtobuf", package: "grpc-swift-protobuf"),
                "ContainerAPIClient",
            ]
        ),
        .testTarget(
            name: "ContainerBuildTests",
            dependencies: [
                "ContainerBuild"
            ]
        ),
        .testTarget(
            name: "ContainerCommandsTests",
            dependencies: [
                "ContainerCommands",
                "ContainerResource",
            ]
        ),
        .testTarget(
            name: "K8sTests",
            dependencies: [
                "ContainerK8s",
                "ContainerResource",
                "Yams",
            ],
            path: "Tests/K8sPluginTests"
        ),
        .target(
            name: "ContainerK8s",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Logging", package: "swift-log"),
                "Containerization",
                "ContainerizationOCI",
                "ContainerizationOS",
                .product(name: "SystemPackage", package: "swift-system"),
                "ContainerAPIClient",
                "ContainerLog",
                "ContainerPersistence",
                "ContainerPlugin",
                "ContainerResource",
                "ContainerVersion",
                "TerminalProgress",
                "Yams",
            ]
        ),
        .executableTarget(
            name: "k8s",
            dependencies: ["ContainerK8s"],
            path: "Sources/Plugins/K8s",
            exclude: ["config.toml", "Resources"]
        ),
        .executableTarget(
            name: "container-apiserver",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                "Containerization",
                "ContainerizationExtras",
                "ContainerizationOS",
                "ContainerizationEXT4",
                .product(name: "GRPCCore", package: "grpc-swift-2"),
                .product(name: "GRPCNIOTransportHTTP2", package: "grpc-swift-nio-transport"),
                .product(name: "GRPCProtobuf", package: "grpc-swift-protobuf"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "SystemPackage", package: "swift-system"),
                "ContainerAPIService",
                "ContainerAPIClient",
                "ContainerLog",
                "ContainerNetworkClient",
                "ContainerPersistence",
                "ContainerPlugin",
                "ContainerResource",
                "ContainerVersion",
                "ContainerXPC",
                "ContainerOS",
                "DNSServer",
            ],
            path: "Sources/APIServer"
        ),
        .target(
            name: "ContainerAPIService",
            dependencies: [
                "Containerization",
                "ContainerizationArchive",
                "ContainerizationExtras",
                "ContainerizationOS",
                .product(name: "Logging", package: "swift-log"),
                .product(name: "SystemPackage", package: "swift-system"),
                "CVersion",
                "ContainerAPIClient",
                "ContainerNetworkClient",
                "ContainerPersistence",
                "ContainerPlugin",
                "ContainerResource",
                "ContainerRuntimeClient",
                "ContainerVersion",
                "ContainerXPC",
                "TerminalProgress",
            ],
            path: "Sources/Services/ContainerAPIService/Server"
        ),
        .testTarget(
            name: "ContainerAPIServiceTests",
            dependencies: [
                "Containerization",
                "ContainerAPIService",
                "ContainerResource",
                "ContainerRuntimeLinuxClient",
                "ContainerRuntimeClient",
            ]
        ),
        .target(
            name: "ContainerAPIClient",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Containerization",
                "ContainerizationArchive",
                "ContainerizationOCI",
                "ContainerizationOS",
                .product(name: "Logging", package: "swift-log"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "SystemPackage", package: "swift-system"),
                "ContainerImagesServiceClient",
                "ContainerPersistence",
                "ContainerPlugin",
                "ContainerResource",
                "ContainerXPC",
                "DNSServer",
                "TerminalProgress",
            ],
            path: "Sources/Services/ContainerAPIService/Client"
        ),
        .testTarget(
            name: "ContainerAPIClientTests",
            dependencies: [
                "Containerization",
                .product(name: "SystemPackage", package: "swift-system"),
                "ContainerAPIClient",
                "ContainerPersistence",
                "ContainerTestSupport",
            ]
        ),
        .executableTarget(
            name: "container-core-images",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Logging", package: "swift-log"),
                "Containerization",
                .product(name: "SystemPackage", package: "swift-system"),
                "ContainerImagesService",
                "ContainerLog",
                "ContainerPersistence",
                "ContainerPlugin",
                "ContainerVersion",
                "ContainerXPC",
            ],
            path: "Sources/Plugins/CoreImages",
            exclude: ["config.toml"]
        ),
        .target(
            name: "ContainerImagesService",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                "Containerization",
                "ContainerizationArchive",
                "ContainerizationExtras",
                "ContainerizationOCI",
                "ContainerizationOS",
                "ContainerAPIClient",
                "ContainerImagesServiceClient",
                "ContainerLog",
                "ContainerPersistence",
                "ContainerResource",
                "ContainerXPC",
                "TerminalProgress",
            ],
            path: "Sources/Services/ContainerImagesService/Server"
        ),
        .target(
            name: "ContainerImagesServiceClient",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                "Containerization",
                "ContainerXPC",
                "ContainerLog",
            ],
            path: "Sources/Services/ContainerImagesService/Client"
        ),
        .executableTarget(
            name: "container-network-vmnet",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Logging", package: "swift-log"),
                "ContainerizationExtras",
                "ContainerizationOS",
                "ContainerLog",
                "ContainerNetworkClient",
                "ContainerNetworkServer",
                "ContainerNetworkVmnetServer",
                "ContainerPersistence",
                "ContainerPlugin",
                "ContainerResource",
                "ContainerVersion",
                "ContainerXPC",
            ],
            path: "Sources/Plugins/NetworkVmnet",
            exclude: ["config.toml"]
        ),
        .target(
            name: "ContainerNetworkClient",
            dependencies: [
                "ContainerizationExtras",
                "ContainerResource",
                "ContainerXPC",
            ],
            path: "Sources/Services/Network/Client"
        ),
        .target(
            name: "ContainerNetworkServer",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                "ContainerizationExtras",
                "ContainerNetworkClient",
                "ContainerResource",
                "ContainerXPC",
            ],
            path: "Sources/Services/Network/Server"
        ),
        .testTarget(
            name: "ContainerNetworkServerTests",
            dependencies: [
                "ContainerizationExtras",
                "ContainerNetworkServer",
            ]
        ),
        .target(
            name: "ContainerNetworkVmnetServer",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                "ContainerizationExtras",
                "ContainerNetworkServer",
                "ContainerResource",
                "ContainerXPC",
            ],
            path: "Sources/Services/NetworkVmnet/Server"
        ),
        .target(
            name: "ContainerRuntimeLinuxClient",
            dependencies: [],
            path: "Sources/Services/RuntimeLinux/Client"
        ),
        .executableTarget(
            name: "container-runtime-linux",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Logging", package: "swift-log"),
                "Containerization",
                "ContainerLog",
                "ContainerPlugin",
                "ContainerResource",
                "ContainerRuntimeClient",
                "ContainerRuntimeLinuxClient",
                "ContainerRuntimeLinuxServer",
                "ContainerVersion",
                "ContainerXPC",
            ],
            path: "Sources/Plugins/RuntimeLinux",
            exclude: ["config.toml"]
        ),
        .target(
            name: "ContainerRuntimeLinuxServer",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                "Containerization",
                "ContainerizationExtras",
                "ContainerizationOS",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "ContainerAPIClient",
                "ContainerNetworkClient",
                "ContainerOS",
                "ContainerPersistence",
                "ContainerResource",
                "ContainerRuntimeClient",
                "ContainerRuntimeLinuxClient",
                "ContainerXPC",
                "SocketForwarder",
            ],
            path: "Sources/Services/RuntimeLinux/Server"
        ),
        .target(
            name: "ContainerRuntimeClient",
            dependencies: [
                "ContainerAPIClient",
                "ContainerResource",
                "ContainerXPC",
            ],
            path: "Sources/Services/Runtime/RuntimeClient"
        ),
        .target(
            name: "ContainerResource",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                "Containerization",
                "ContainerXPC",
                "CVersion",
            ]
        ),
        .testTarget(
            name: "ContainerResourceTests",
            dependencies: [
                "Containerization",
                "ContainerizationExtras",
                "ContainerAPIService",
                "ContainerResource",
            ]
        ),
        .target(
            name: "ContainerLog",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "SystemPackage", package: "swift-system"),
            ]
        ),
        .target(
            name: "ContainerPersistence",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                "Containerization",
                .product(name: "Configuration", package: "swift-configuration"),
                .product(name: "ConfigurationTOML", package: "swift-configuration-toml"),
                .product(name: "SystemPackage", package: "swift-system"),
                "CVersion",
                "ContainerVersion",
            ]
        ),
        .testTarget(
            name: "ContainerPersistenceTests",
            dependencies: [
                .product(name: "Configuration", package: "swift-configuration"),
                "ContainerizationExtras",
                .product(name: "Logging", package: "swift-log"),
                .product(name: "SystemPackage", package: "swift-system"),
                "ContainerPersistence",
                "ContainerTestSupport",
            ]
        ),
        .target(
            name: "ContainerPlugin",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                "ContainerizationOS",
                .product(name: "SystemPackage", package: "swift-system"),
                .product(name: "TOML", package: "swift-toml"),
                "ContainerVersion",
            ]
        ),
        .testTarget(
            name: "ContainerPluginTests",
            dependencies: [
                "ContainerPlugin"
            ]
        ),
        .target(
            name: "ContainerXPC",
            dependencies: [
                "ContainerizationExtras",
                .product(name: "Logging", package: "swift-log"),
            ]
        ),
        .target(
            name: "ContainerOS",
            dependencies: [
                "Containerization",
                "ContainerizationOS",
            ],
            path: "Sources/ContainerOS"
        ),
        .testTarget(
            name: "ContainerOSTests",
            dependencies: [
                "ContainerOS"
            ]
        ),
        .target(
            name: "TerminalProgress",
            dependencies: [
                "ContainerizationOS"
            ]
        ),
        .testTarget(
            name: "TerminalProgressTests",
            dependencies: ["TerminalProgress"]
        ),
        .target(
            name: "DNSServer",
            dependencies: [
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "Logging", package: "swift-log"),
                "ContainerizationExtras",
                "ContainerizationOS",
            ]
        ),
        .testTarget(
            name: "DNSServerTests",
            dependencies: [
                "DNSServer"
            ]
        ),
        .target(
            name: "SocketForwarder",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOFoundationCompat", package: "swift-nio"),
            ]
        ),
        .testTarget(
            name: "SocketForwarderTests",
            dependencies: ["SocketForwarder"]
        ),
        .target(
            name: "ContainerVersion",
            dependencies: [
                .product(name: "SystemPackage", package: "swift-system"),
                "CVersion",
            ],
        ),
        .testTarget(
            name: "ContainerVersionTests",
            dependencies: [
                .product(name: "SystemPackage", package: "swift-system"),
                "ContainerVersion",
            ]
        ),
        .target(
            name: "CVersion",
            dependencies: [],
            publicHeadersPath: "include",
            cSettings: [
                .define("CZ_VERSION", to: "\"\(scVersion)\""),
                .define("GIT_COMMIT", to: "\"\(gitCommit)\""),
                .define("RELEASE_VERSION", to: "\"\(releaseVersion)\""),
                .define("BUILDER_SHIM_VERSION", to: "\"\(builderShimVersion)\""),
            ],
        ),
        // App Store: CAuditToken target omitted — upstream declares private
        // xpc_dictionary_get_audit_token (Guideline 2.5.1). See XPCServer.swift.
        .target(
            name: "ContainerTestSupport",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                "Containerization",
                "ContainerizationArchive",
                "ContainerizationExtras",
                .product(name: "Logging", package: "swift-log"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "SystemPackage", package: "swift-system"),
                .product(name: "TOML", package: "swift-toml"),
                "ContainerLog",
                "ContainerPersistence",
                "ContainerPlugin",
                "ContainerResource",
            ]
        ),
        .target(
            name: "MachineAPIClient",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "ContainerizationOCI",
                .product(name: "Logging", package: "swift-log"),
                "ContainerAPIClient",
                "ContainerPersistence",
                "ContainerResource",
                "ContainerXPC",
                "TerminalProgress",
            ],
            path: "Sources/Services/MachineAPIService/Client"
        ),
        .target(
            name: "MachineAPIService",
            dependencies: [
                "Containerization",
                "ContainerizationEXT4",
                "ContainerizationExtras",
                "ContainerizationOCI",
                .product(name: "Logging", package: "swift-log"),
                .product(name: "SystemPackage", package: "swift-system"),
                "ContainerAPIClient",
                "ContainerResource",
                "ContainerRuntimeClient",
                "ContainerXPC",
                "MachineAPIClient",
            ],
            path: "Sources/Services/MachineAPIService/Server"
        ),
        .executableTarget(
            name: "machine-apiserver",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Logging", package: "swift-log"),
                "ContainerAPIClient",
                "ContainerLog",
                "ContainerPersistence",
                "ContainerPlugin",
                "ContainerVersion",
                "ContainerXPC",
                "MachineAPIClient",
                "MachineAPIService",
            ],
            path: "Sources/Plugins/MachineAPIServer",
            exclude: ["config.toml", "Resources"]
        ),
        .binaryTarget(
            name: "LibArchive",
            path: "LibArchive/LibArchive.xcframework"
        ),
        .target(
            name: "ContainerizationError",
            path: "containerization/Sources/ContainerizationError"
        ),
        .target(
            name: "Containerization",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "SystemPackage", package: "swift-system"),
                .product(name: "GRPCCore", package: "grpc-swift-2"),
                .product(name: "GRPCNIOTransportHTTP2", package: "grpc-swift-nio-transport"),
                .product(name: "GRPCProtobuf", package: "grpc-swift-protobuf"),
                .product(name: "_NIOFileSystem", package: "swift-nio"),
                "CloudHypervisor",
                "ContainerizationArchive",
                "ContainerizationOCI",
                "ContainerizationOS",
                "ContainerizationIO",
                "ContainerizationExtras",
                "ContainerizationEXT4",
                "ContainerizationNetlink",
                "CShim",
            ],
            path: "containerization/Sources/Containerization",
            exclude: [
                "SandboxContext/SandboxContext.proto"
            ]
        ),
        .executableTarget(
            name: "cctl",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Containerization",
                "ContainerizationArchive",
                "ContainerizationEXT4",
                "ContainerizationExtras",
                "ContainerizationOCI",
                "ContainerizationOS",
            ],
            path: "containerization/Sources/cctl"
        ),
        .testTarget(
            name: "ContainerizationUnitTests",
            dependencies: ["Containerization", "CloudHypervisor"],
            path: "containerization/Tests/ContainerizationTests",
            resources: [
                .copy("ImageTests/Resources/scratch.tar"),
                .copy("ImageTests/Resources/scratch_no_annotations.tar"),
            ]
        ),
        .target(
            name: "ContainerizationEXT4",
            dependencies: [
                "ContainerizationArchive",
                .product(name: "OrderedCollections", package: "swift-collections"),
                .product(name: "SystemPackage", package: "swift-system"),
                "ContainerizationOS",
            ],
            path: "containerization/Sources/ContainerizationEXT4",
            exclude: [
                "README.md"
            ]
        ),
        .testTarget(
            name: "ContainerizationEXT4Tests",
            dependencies: [
                "ContainerizationEXT4",
                "ContainerizationArchive",
            ],
            path: "containerization/Tests/ContainerizationEXT4Tests",
            resources: [
                .copy(
                    "Resources/content/blobs/sha256/ad59e9f71edceca7b1ac7c642410858489b743c97233b0a26a5e2098b1443762"),  // index
                .copy(
                    "Resources/content/blobs/sha256/48a06049d3738991b011ca8b12473d712b7c40666a1462118dae3c403676afc2"),  // manifest
                .copy(
                    "Resources/content/blobs/sha256/8e2eb240a6cd7be1a0d308125afe0060b020e89275ced2e729eda7d4eeff62a2"),  // config
                .copy(
                    "Resources/content/blobs/sha256/c6b39de5b33961661dc939b997cc1d30cda01e38005a6c6625fd9c7e748bab44"),  // layer 1
                .copy(
                    "Resources/content/blobs/sha256/4f4fb700ef54461cfa02571ae0db9a0dc1e0cdb5577484a6d75e68dc38e8acc1"),  // layer 2
            ]
        ),
        .target(
            name: "ContainerizationArchive",
            dependencies: [
                .product(name: "SystemPackage", package: "swift-system"),
                "CArchive",
                "ContainerizationExtras",
                "ContainerizationOS",
            ],
            path: "containerization/Sources/ContainerizationArchive",
            exclude: [
                "CArchive"
            ]
        ),
        .testTarget(
            name: "ContainerizationArchiveTests",
            dependencies: [
                "ContainerizationArchive"
            ],
            path: "containerization/Tests/ContainerizationArchiveTests",
            resources: [
                .copy("Resources/test.tar.zst")
            ]
        ),
        .target(
            name: "CArchive",
            dependencies: [
                .product(name: "libzstd", package: "zstd"),
                "LibArchive",
            ],
            path: "containerization/Sources/ContainerizationArchive/CArchive",
            sources: [
                "archive_swift_bridge.c"
            ],
            cSettings: [
                .define(
                    "PLATFORM_CONFIG_H", to: "\"config_darwin.h\"",
                    .when(platforms: [.iOS, .macOS, .macCatalyst, .watchOS, .driverKit, .tvOS])),
                .define("PLATFORM_CONFIG_H", to: "\"config_linux.h\"", .when(platforms: [.linux])),
                .unsafeFlags(["-fno-modules"]),
            ],
            linkerSettings: [
                // Public system libs only. libarchive symbols come from LibArchive
                // (static XCFramework). Do not link system archive/bz2/lzma (App Store 2.5.1).
                .linkedLibrary("z"),
                .linkedLibrary("iconv", .when(platforms: [.macOS])),
                .linkedLibrary("crypto", .when(platforms: [.linux])),
            ]
        ),
        .target(
            name: "ContainerizationOCI",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "_NIOFileSystem", package: "swift-nio"),
                "ContainerizationError",
                "ContainerizationOS",
                "ContainerizationExtras",
            ],
            path: "containerization/Sources/ContainerizationOCI"
        ),
        .testTarget(
            name: "ContainerizationOCITests",
            dependencies: [
                "ContainerizationOCI",
                "Containerization",
                "ContainerizationIO",
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "Crypto", package: "swift-crypto"),
            ],
            path: "containerization/Tests/ContainerizationOCITests"
        ),
        .target(
            name: "ContainerizationNetlink",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                "ContainerizationOS",
                "ContainerizationExtras",
            ],
            path: "containerization/Sources/ContainerizationNetlink"
        ),
        .testTarget(
            name: "ContainerizationNetlinkTests",
            dependencies: [
                "ContainerizationNetlink"
            ],
            path: "containerization/Tests/ContainerizationNetlinkTests"
        ),
        .target(
            name: "ContainerizationOS",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "SystemPackage", package: "swift-system"),
                "CShim",
                "ContainerizationError",
            ],
            path: "containerization/Sources/ContainerizationOS",
            exclude: [
                "README.md"
            ]
        ),
        .testTarget(
            name: "ContainerizationOSTests",
            dependencies: [
                .product(name: "SystemPackage", package: "swift-system"),
                "ContainerizationOS",
                "ContainerizationExtras",
            ],
            path: "containerization/Tests/ContainerizationOSTests"
        ),
        .target(
            name: "ContainerizationIO",
            dependencies: [
                "ContainerizationOS",
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOFoundationCompat", package: "swift-nio"),
            ],
            path: "containerization/Sources/ContainerizationIO"
        ),
        .target(
            name: "ContainerizationExtras",
            dependencies: [
                "ContainerizationError",
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),

            ],
            path: "containerization/Sources/ContainerizationExtras"
        ),
        .testTarget(
            name: "ContainerizationExtrasTests",
            dependencies: [
                "ContainerizationExtras",
                "CShim",
            ],
            path: "containerization/Tests/ContainerizationExtrasTests"
        ),
        .target(
            name: "CShim",
            path: "containerization/Sources/CShim"
        ),
        .target(
            name: "CloudHypervisor",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
                .product(name: "NIOConcurrencyHelpers", package: "swift-nio"),
            ],
            path: "containerization/Sources/CloudHypervisor",
            exclude: [
                "README.md"
            ]
        ),
        .testTarget(
            name: "CloudHypervisorTests",
            dependencies: [
                "CloudHypervisor",
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
                .product(name: "NIOConcurrencyHelpers", package: "swift-nio"),
            ],
            path: "containerization/Tests/CloudHypervisorTests"
        ),
        .target(
            name: "LCShim",
            path: "containerization/vminitd/Sources/LCShim"
        ),
        .target(
            name: "Cgroup",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                "ContainerizationOCI",
                "ContainerizationOS",
                .product(name: "SystemPackage", package: "swift-system"),
                "LCShim",
            ],
            path: "containerization/vminitd/Sources/Cgroup"
        ),
        .target(
            name: "VminitdCore",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Logging", package: "swift-log"),
                "Containerization",
                "ContainerizationArchive",
                "ContainerizationNetlink",
                "ContainerizationIO",
                "ContainerizationOS",
                .product(name: "SystemPackage", package: "swift-system"),
                .product(name: "GRPCCore", package: "grpc-swift-2"),
                .product(name: "GRPCNIOTransportHTTP2", package: "grpc-swift-nio-transport"),
                .product(name: "GRPCProtobuf", package: "grpc-swift-protobuf"),
                "LCShim",
                "Cgroup",
            ],
            path: "containerization/vminitd/Sources/VminitdCore"
        ),
        .executableTarget(
            name: "containerization-integration",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                "Containerization",
            ],
            path: "containerization/Sources/Integration"
        ),
    ]
)