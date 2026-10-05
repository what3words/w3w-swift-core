// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "w3w-swift-core",

    platforms: [.macOS(.v10_15), .iOS(.v12), .tvOS(.v12), .watchOS(.v4)],

    products: [.library(name: "W3WSwiftCore",   targets: ["W3WSwiftCore"])],

    dependencies: [],

    targets: [
      .target(name: "W3WSwiftCore", dependencies: []),
      .testTarget(name: "w3w-swift-typesTests", dependencies: ["W3WSwiftCore"]),
      .testTarget(name: "w3w-swift-Tests", dependencies: ["W3WSwiftCore"]),
      .testTarget(name: "languages-Tests", dependencies: ["W3WSwiftCore"])
    ],
    swiftLanguageModes: [.v5]
)
