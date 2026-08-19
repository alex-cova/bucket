# bucket

App Store–safe distribution of [apple/container](https://github.com/apple/container) and [apple/containerization](https://github.com/apple/containerization) for embedding in macOS apps.

## What this is

`bucket` vendors Apple's container stack with two patches required for Mac App Store submission:

1. **Static libarchive** — `CArchive` links a prebuilt `LibArchive.xcframework` (zlib/gzip only) instead of the system `libarchive`, `liblzma`, and `libbz2` dylibs (Guideline 2.5.1).
2. **No private XPC SPI** — the `CAuditToken` target and `xpc_dictionary_get_audit_token` declaration are removed; peer EUID checks use `xpc_connection_get_pid` + `proc_pidinfo` instead.

Upstream pins are recorded in [`UPSTREAM_PIN`](UPSTREAM_PIN).

## Layout

```
bucket/
  Package.swift          # SPM package (products match apple/container)
  Sources/               # container sources
  containerization/      # vendored apple/containerization
  LibArchive/            # static libarchive XCFramework + build script
```

## Rebuild LibArchive

```bash
./LibArchive/build-xcframework.sh
```

Requires cmake, curl, and Xcode. Commit the resulting `LibArchive.xcframework`.

## Refresh upstream

1. Replace `Sources/` and `containerization/` from tagged upstream releases.
2. Re-apply App Store patches (see `UPSTREAM_PIN` and git history).
3. Update `UPSTREAM_PIN`, rebuild LibArchive if the libarchive pin changed.
4. Tag a new release.

## Usage

```swift
.package(url: "https://github.com/alex-cova/bucket", from: "1.0.0")
```

Products mirror [apple/container](https://github.com/apple/container) — e.g. `ContainerAPIClient`, `ContainerAPIService`, `ContainerImagesService`, `ContainerPersistence`, `ContainerResource`.
