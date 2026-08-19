#!/bin/sh
# Build a static LibArchive.xcframework (macosx arm64 + x86_64) with zlib only.
# No system libarchive / liblzma / libbz2 — App Store safe.
#
# Usage: ./Vendor/LibArchive/build-xcframework.sh
# Requires: cmake, curl, Xcode CLT
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
VERSION="${LIBARCHIVE_VERSION:-3.7.7}"
TARBALL="libarchive-${VERSION}.tar.gz"
SRC_URL="https://github.com/libarchive/libarchive/releases/download/v${VERSION}/${TARBALL}"
WORK="${ROOT}/.build"
OUT_XCFW="${ROOT}/LibArchive.xcframework"
SDK="$(xcrun --sdk macosx --show-sdk-path)"
MACOSX_DEPLOYMENT_TARGET="${MACOSX_DEPLOYMENT_TARGET:-15.0}"
export MACOSX_DEPLOYMENT_TARGET

if ! command -v cmake >/dev/null 2>&1; then
    echo "error: cmake required (brew install cmake)" >&2
    exit 1
fi

echo "==> LibArchive ${VERSION} → ${OUT_XCFW}"

rm -rf "${WORK}" "${OUT_XCFW}"
mkdir -p "${WORK}"
cd "${WORK}"

if [ ! -f "${ROOT}/${TARBALL}" ]; then
    echo "==> Downloading ${SRC_URL}"
    curl -L --fail -o "${ROOT}/${TARBALL}" "${SRC_URL}"
fi
cp "${ROOT}/${TARBALL}" .
tar -xzf "${TARBALL}"
SRC="${WORK}/libarchive-${VERSION}"

build_arch() {
    arch="$1"
    prefix="${WORK}/prefix-${arch}"
    builddir="${WORK}/build-${arch}"
    rm -rf "${prefix}" "${builddir}"
    mkdir -p "${builddir}"
    cd "${builddir}"

    # zlib-only: OCI unpack uses tar + gzip; zstd layers are pre-decompressed
    # by ContainerizationArchive (SPM libzstd) before libarchive sees them.
    cmake "${SRC}" \
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
        -DCMAKE_INSTALL_PREFIX="${prefix}" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_OSX_ARCHITECTURES="${arch}" \
        -DCMAKE_OSX_DEPLOYMENT_TARGET="${MACOSX_DEPLOYMENT_TARGET}" \
        -DCMAKE_OSX_SYSROOT="${SDK}" \
        -DBUILD_SHARED_LIBS=OFF \
        -DENABLE_ACL=ON \
        -DENABLE_ICONV=OFF \
        -DENABLE_CNG=OFF \
        -DENABLE_LIBB2=OFF \
        -DENABLE_LZ4=OFF \
        -DENABLE_LZO=OFF \
        -DENABLE_LZMA=OFF \
        -DENABLE_ZSTD=OFF \
        -DENABLE_BZip2=OFF \
        -DENABLE_LIBXML2=OFF \
        -DENABLE_EXPAT=OFF \
        -DENABLE_PCREPOSIX=OFF \
        -DENABLE_PCRE2POSIX=OFF \
        -DENABLE_OPENSSL=OFF \
        -DENABLE_MBEDTLS=OFF \
        -DENABLE_NETTLE=OFF \
        -DENABLE_ZLIB=ON \
        -DENABLE_TAR=OFF \
        -DENABLE_CPIO=OFF \
        -DENABLE_CAT=OFF \
        -DENABLE_UNZIP=OFF \
        -DENABLE_TEST=OFF \
        -DENABLE_INSTALL=ON >&2

    cmake --build . --config Release -j"$(sysctl -n hw.ncpu)" >&2
    cmake --install . >&2

    hdr="${WORK}/headers-${arch}"
    rm -rf "${hdr}"
    mkdir -p "${hdr}"
    cp "${prefix}/include/archive.h" "${prefix}/include/archive_entry.h" "${hdr}/"
    cat >"${hdr}/module.modulemap" <<'EOF'
module LibArchive {
    header "archive.h"
    header "archive_entry.h"
    export *
}
EOF

    if [ -f "${prefix}/lib/libarchive.a" ]; then
        printf '%s\n' "${prefix}/lib/libarchive.a"
    else
        find "${prefix}/lib" -name 'libarchive*.a' | head -1
    fi
}

echo "==> Building arm64"
ARM_LIB="$(build_arch arm64)"
echo "    ${ARM_LIB}"
echo "==> Building x86_64"
X86_LIB="$(build_arch x86_64)"
echo "    ${X86_LIB}"

UNI="${WORK}/universal"
rm -rf "${UNI}"
mkdir -p "${UNI}/Headers"
lipo -create "${ARM_LIB}" "${X86_LIB}" -output "${UNI}/libarchive.a"
cp -R "${WORK}/headers-arm64/"* "${UNI}/Headers/"

echo "==> Creating XCFramework"
rm -rf "${OUT_XCFW}"
xcodebuild -create-xcframework \
    -library "${UNI}/libarchive.a" -headers "${UNI}/Headers" \
    -output "${OUT_XCFW}"

cp "${SRC}/COPYING" "${ROOT}/COPYING"
{
    echo "This product includes software developed by the libarchive project."
    echo "libarchive ${VERSION} — see COPYING for the full license text."
    echo "Built with zlib only (no bz2 / lzma / zstd / lz4)."
} >"${ROOT}/NOTICE"

echo "==> Done: ${OUT_XCFW}"
find "${OUT_XCFW}" -type f | head -20
lipo -info "$(find "${OUT_XCFW}" -name 'libarchive.a' | head -1)"
nm -gU "$(find "${OUT_XCFW}" -name 'libarchive.a' | head -1)" | rg ' _archive_read_new$| _archive_write_new$' | head -5
