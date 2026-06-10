// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "w3w-swift-core",

    platforms: [.macOS(.v10_15), .iOS(.v12), .tvOS(.v12), .watchOS(.v4)],

    products: [.library(name: "W3WSwiftCore",   targets: ["W3WSwiftCore"])],

    dependencies: [
      .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "603.0.0-latest"),
    ],

    targets: [
      .target(name: "W3WSwiftCore", dependencies: ["W3WSwiftCoreMacros"]),
      .macro(
        name: "W3WSwiftCoreMacros",
        dependencies: [
          .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
          .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
        ]
      ),
      .testTarget(name: "w3w-swift-typesTests", dependencies: ["W3WSwiftCore"]),
      .testTarget(name: "w3w-swift-Tests", dependencies: ["W3WSwiftCore"]),
      .testTarget(name: "languages-Tests", dependencies: ["W3WSwiftCore"])
    ]
)
