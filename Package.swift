// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CollectionUI",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "CollectionUI",
            targets: ["CollectionUI"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "CollectionUI",
            dependencies: []
        ),
        .testTarget(
            name: "CollectionUITests",
            dependencies: ["CollectionUI"]
        )
    ]
)
