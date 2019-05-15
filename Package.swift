// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SideVolumeHUD",
    products: [
        .library(
            name: "SideVolumeHUD",
            targets: ["SideVolumeHUD"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SideVolumeHUD",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "SideVolumeHUDTests",
            dependencies: ["SideVolumeHUD"],
            path: "Tests"
        ),
    ]
)
