// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ShaperyCore",
    platforms: [.iOS(.v17), .macOS(.v14), .tvOS(.v17)],
    products: [.library(name: "ShaperyCore", targets: ["ShaperyCore"])],
    targets: [
        .target(name: "ShaperyCore"),
        .testTarget(name: "ShaperyCoreTests", dependencies: ["ShaperyCore"])
    ]
)
