// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserEmails",
	platforms: [
		.macOS(.v15)
	],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UserEmails",
            targets: ["UserEmails"]),
    ],
	dependencies: [
		.package(url: "https://github.com/vapor/vapor", from: "4.106.0"),
		.package(url: "https://github.com/vapor/fluent.git", from: "4.12.0"),
		.package(url: "https://github.com/vapor/leaf.git", .upToNextMajor(from: "4.4.0")),
		.package(url: "https://github.com/vapor/queues.git", from: "1.16.0"),
		.package(url: "https://github.com/vapor/queues-redis-driver.git", from: "1.1.0"),
		.package(name: "SMTPTool", path: "../SmtpTool"),
		.package(name: "UserDTOs", path: "../UserDTOs"),
		.package(name: "UserModels", path: "../UserModels")
	],
	targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "UserEmails",
			dependencies: [
				.product(
					name: "Vapor",
					package: "vapor"
				),
				.product(
					name: "Fluent",
					package: "fluent"
				),
				.product(
					name: "Leaf",
					package: "leaf"
				),
				.product(
					name: "Queues",
						package: "queues"
				),
				.product(
					name: "QueuesRedisDriver",
						package: "queues-redis-driver"
				),
				.product(
					name: "SMTPTool",
					package: "SMTPTool"
				),
				.product(
					name: "UserDTOs",
					package: "UserDTOs"
				),
				.product(
					name: "UserModels",
					package: "UserModels"
				)
			],
			resources: [
				.copy("Resources/")
			]
		),
        .testTarget(
            name: "UserEmailsTests",
            dependencies: ["UserEmails"]
        ),
    ]
)
