// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "CArch",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "CArch",
            targets: ["CArch"]),
        .executable(
            name: "CArchClient",
            targets: ["CArchClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0-swift-5.9-DEVELOPMENT-SNAPSHOT-2023-04-25-b"),
    ],
    targets: [
        .macro(
            name: "CArchMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            path: "CArchMacros"
        ),
        .target(
            name: "CArch",
            dependencies: ["CArchMacros"],
            path: "Sources",
            exclude: ["Info.plist"]
        ),
        .executableTarget(
            name: "CArchClient",
            dependencies: ["CArch"],
            path: "CArchClient"
        ),
        .testTarget(
            name: "CArchTests",
            dependencies: [
                "CArch"
            ],
            path: "CArchTests",
            exclude: ["Info.plist"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
