// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let targets = [
    "libbackend","libbasis_transcoder","libcamutils","libcivetweb","libdracodec","libfilabridge","libfilaflat","libfilamat","libfilament-iblprefilter","libfilament","libfilameshio","libgeometry","libgltfio_core","libibl-lite","libibl","libimage","libktxreader","libmeshoptimizer","libmikktspace","libshaders","libsmol-v","libstb","libuberarchive","libuberzlib","libutils","libviewer","libvkshaders","libzstd"
]

let package = Package(
    name: "filament_swift",
    products: [
        .library(
            name: "Filament",
            type: .dynamic,
            targets: ["Filament"]
        ),
        .library(
            name: "Bindings",
            type: .dynamic,
            targets: ["Bindings"]
        ),
    ],
    targets: ([
        .target(
            name: "Filament",
            dependencies: [
                .target(name: "Bindings"),
            ],
            path: "Helpers"
        ),
        .target(
            name: "Bindings",
            dependencies: targets.map({ .byName(name: $0) }),
            path: "Bindings"
        )
    ] + targets.map({ .binaryTarget(name: $0, path: "lib/\($0).xcframework") })),
    cxxLanguageStandard: .cxx17
)
