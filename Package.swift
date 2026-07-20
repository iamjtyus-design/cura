// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "CURA",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "CuraCore", targets: ["CuraCore"]),
        .executable(name: "CuraApp", targets: ["CuraApp"]),
        .executable(name: "CuraSmokeTests", targets: ["CuraSmokeTests"])
    ],
    targets: [
        .target(
            name: "CuraCore",
            path: "Cura",
            exclude: [
                "App",
                "Resources",
                "Core/Configuration/Development.xcconfig",
                "Core/Configuration/Staging.xcconfig",
                "Core/Configuration/Production.xcconfig"
            ]
        ),
        .executableTarget(
            name: "CuraApp",
            dependencies: ["CuraCore"],
            path: "Cura/App"
        ),
        .executableTarget(
            name: "CuraSmokeTests",
            dependencies: ["CuraCore"],
            path: "CuraSmokeTests"
        ),
        .testTarget(
            name: "CuraTests",
            dependencies: ["CuraCore"],
            path: "CuraTests"
        )
    ]
)
