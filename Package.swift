// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "CArch",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "CArch",
            targets: [
                "CArch"
            ]
        ),
        .executable(
            name: "CArchClient",
            targets: [
                "CArchClient"
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0-swift-5.9-DEVELOPMENT-SNAPSHOT-2023-04-25-b"),
        //.package(url: "https://github.com/realm/SwiftLint", from: "0.52.4"),
    ],
    targets: [
        .macro(
            name: "CArchMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
            //plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "CArch",
            dependencies: [
                "CArchMacros"
            ],
            exclude: [
                "Sources/CArch/Info.plist"
            ]
            //plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .executableTarget(
            name: "CArchClient",
            dependencies: [
                "CArch"
            ]
            //plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .testTarget(
            name: "CArchTests",
            dependencies: [
                "CArch"
            ],
            path: "CArchTests",
            exclude: [
                "Info.plist"
            ]
            //plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
