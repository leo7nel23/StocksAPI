// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "StocksAPI",
  platforms: [
    .iOS(.v13), .macOS(.v12), .macCatalyst(.v13), .tvOS(.v13), .watchOS(.v8)
  ],
  products: [
    .library(
      name: "StocksAPI",
      targets: ["StocksAPI"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/AlexRoar/SwiftYFinance", .upToNextMajor(from: "1.4.0"))
  ],
  targets: [
    .target(
      name: "StocksAPI",
      dependencies: ["SwiftYFinance"]
    ),
    .testTarget(
      name: "StocksAPITests",
      dependencies: ["StocksAPI"]
    )
  ]
)
