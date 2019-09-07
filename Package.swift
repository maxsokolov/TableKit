// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TableKit",

    products: [
        .library(
            name: "TableKit",
            targets: ["TableKit"]),
    ],

    targets: [
        .target(
            name: "TableKit",
            path: "Sources")
    ]
)
