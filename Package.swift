// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StockAPI",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "StockAPI",
            targets: ["StockAPI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/AlexRoar/SwiftYFinance", .upToNextMajor(from: "1.4.0"))
    ],
    targets: [
        .target(
            name: "StockAPI",
            dependencies: ["SwiftYFinance"]
        ),
        .testTarget(
            name: "StockAPITests",
            dependencies: ["StockAPI"]
        )
    ]
)
