// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "LostAPI",
    platforms: [
       .macOS(.v13)
    ],
    products: [
        .library(name: "LostAPI", targets: ["LostAPI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.77.1"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.8.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "LostAPI",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver")
            ],
            resources: [
                .process("Resources/preload_data.json")
            ]
        )
    ]
)
