// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "swift-keypath-mapping",
	products: [
		.library(
			name: "KeyPathMapping",
			targets: ["KeyPathMapping"]
		)
	],
	dependencies: [
		.package(
			url: "https://github.com/capturecontext/swift-marker-protocols.git",
			.upToNextMajor(from: "1.5.1")
		),
	],
	targets: [
		.target(
			name: "KeyPathMapping",
			dependencies: [
				.product(
					name: "SwiftMarkerProtocols",
					package: "swift-marker-protocols"
				)
			]
		),
		.testTarget(
			name: "KeyPathMappingTests",
			dependencies: ["KeyPathMapping"]
		)
	]
)
