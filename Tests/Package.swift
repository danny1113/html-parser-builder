// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HTMLParserBuilderTests",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .visionOS(.v1),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../"),
        .package(
            url: "https://github.com/scinfu/SwiftSoup.git",
            .upToNextMajor(from: "2.7.7")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .testTarget(
            name: "HTMLParserBuilderTests",
            dependencies: [
                .product(
                    name: "HTMLParserBuilder", package: "html-parser-builder"),
                "SwiftSoup",
            ]
        )
    ]
)
