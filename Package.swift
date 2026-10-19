// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "CArch",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13),
        .macOS(.v12),
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
        )
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", exact: "0.59.1"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "601.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-macro-testing.git", from: "0.7.0"),
    ],
    targets: [
        .macro(
            name: "CArchMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "CArch",
            dependencies: [
                "CArchMacros"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
        .executableTarget(
            name: "CArchClient",
            dependencies: [
                "CArch"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
        .testTarget(
            name: "CArchTests",
            dependencies: [
                "CArchMacros",
                .product(name: "MacroTesting", package: "swift-macro-testing"),
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
            ],
            path: "CArchTests",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)

let defaultSettings: [SwiftSetting] = [.enableExperimentalFeature("StrictConcurrency=minimal")]
package.targets.forEach { target in
    if var settings = target.swiftSettings, !settings.isEmpty {
        settings.append(contentsOf: defaultSettings)
        target.swiftSettings = settings
    } else {
        target.swiftSettings = defaultSettings
    }
}

