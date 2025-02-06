// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "StockAPI",
  platforms: [
    .iOS(.v13), .macOS(.v12), .macCatalyst(.v13), .tvOS(.v13), .watchOS(.v8)
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
