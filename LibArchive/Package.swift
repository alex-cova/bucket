// swift-tools-version: 6.0
import PackageDescription

/// Static libarchive (zlib-only) for App Store–safe linking.
/// Built by `./build-xcframework.sh` — does not link system libarchive/liblzma/libbz2.
let package = Package(
    name: "LibArchive",
    platforms: [.macOS("15")],
    products: [
        .library(name: "LibArchive", targets: ["LibArchive"]),
    ],
    targets: [
        .binaryTarget(
            name: "LibArchive",
            path: "LibArchive.xcframework"
        ),
    ]
)
