// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SimpleOpenAIKit",
    // AsyncBytes is v12 support and UTType is v11
    platforms: [.macOS(.v12), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SimpleOpenAIKit",
            targets: ["SimpleOpenAIKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "603.0.0-latest"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.

        // MARK: SimpleCodableMacro
        .macro(
            name: "SimpleCodableMacroPlugin",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            path: "Sources/SimpleCodableMacroPlugin"
        ),
        .target(
            name: "SimpleCodableMacro",
            dependencies: ["SimpleCodableMacroPlugin"],
            path: "Sources/SimpleCodableMacro"
        ),
        .testTarget(
            name: "SimpleCodableMacroTests",
            dependencies: [ "SimpleCodableMacro" ],
            path: "Tests/SimpleCodableMacroTests"
        ),
        
        // MARK: SimpleOpenAIKitMacro
        .macro(
            name: "SimpleOpenAIKitMacroPlugin",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                "SimpleCodableMacro"
            ],
            path: "Sources/SimpleOpenAIKitMacroPlugin"
        ),
        .target(
            name: "SimpleOpenAIKitMacro",
            dependencies: ["SimpleOpenAIKitMacroPlugin"],
            path: "Sources/SimpleOpenAIKitMacro"
        ),
        .testTarget(
            name: "SimpleOpenAIKitMacroTests",
            dependencies: [ "SimpleOpenAIKitMacro" ],
            path: "Tests/SimpleOpenAIKitMacroTests"
        ),
        
        // MARK: SimpleOpenAIKit
        .target(
            name: "SimpleOpenAIKit",
            dependencies: [
                "SimpleCodableMacro",
                "SimpleOpenAIKitMacro"
            ],
            path: "Sources/SimpleOpenAIKit",
            swiftSettings: [
                .define("SelectInputStream"),
//                .define("HasNetWorkURL"),
            ]
        ),
        .testTarget(
            name: "SimpleOpenAIKitTests",
            dependencies: ["SimpleOpenAIKit"],
            path: "Tests/SimpleOpenAIKitTests",
            resources: [.process("Resources")],
        ),
    ],
    swiftLanguageModes: [.v6]
)
