// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ImageKitIO",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ImageKitIO",
            targets: ["ImageKitIO"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "10.0.0")),
        .package(url: "https://github.com/WeTransfer/Mocker.git", .upToNextMajor(from: "2.5"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
       .target(
            name: "ImageKitIO",
            path: "Sources",
       ),
        .testTarget(
            name: "ImageKitIO-Tests",
            path: "Tests"
            dependencies: ["ImageKitIO", "Quick", "Nimble", "Mocker"]
        ),
    ]
)
