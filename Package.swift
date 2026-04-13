// swift-tools-version: 5.9
// Package.swift — Swift Package manifest for MeshLink
// NOTE: MultipeerConnectivity is an Apple-only framework requiring a real iOS device or simulator.
// To build as a proper iOS app, open in Xcode by adding a new iOS App target pointing to MeshLink/.

import PackageDescription

let package = Package(
    name: "MeshLink",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "MeshLink",
            targets: ["MeshLink"]
        )
    ],
    targets: [
        .target(
            name: "MeshLink",
            path: "MeshLink",
            sources: [
                "MeshLinkApp.swift",
                "Models/Peer.swift",
                "Models/Message.swift",
                "Services/MultipeerService.swift",
                "ViewModels/PeerDiscoveryViewModel.swift",
                "ViewModels/ChatViewModel.swift",
                "Views/ContentView.swift",
                "Views/PeerListView.swift",
                "Views/PeerRowView.swift",
                "Views/ChatView.swift",
                "Views/MessageBubbleView.swift",
                "Views/BroadcastView.swift"
            ],
            resources: [
                .process("Info.plist")
            ]
        )
    ]
)
