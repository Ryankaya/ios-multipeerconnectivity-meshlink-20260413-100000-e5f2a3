# MeshLink

A peer-to-peer mesh communication iOS app built with **MultipeerConnectivity**. MeshLink lets nearby Apple devices discover each other and exchange real-time messages and status updates — no internet required. It works as a local-network emergency broadcast system and collaborative notes tool.

## Features

- **Auto-discovery** — Continuously scans for nearby devices over Wi-Fi and Bluetooth using `MCNearbyServiceBrowser` and `MCNearbyServiceAdvertiser`.
- **One-tap connect** — Invitations are auto-accepted; tap any discovered peer to connect.
- **Real-time chat** — Encrypted, reliable message delivery via `MCSession` with `JSONEncoder`/`JSONDecoder` over `Data` payloads.
- **Animated connection states** — Color-coded peer rows (gray → orange → green) reflect `notConnected`, `connecting`, and `connected` states live.
- **Per-peer chat view** — IMessage-style bubble UI with relative timestamps, auto-scrolling to the latest message.
- **Broadcast mode** — Send a single message to all connected peers simultaneously with one tap on the antenna icon.
- **No internet required** — Everything runs over the local network using Bonjour service type `_meshlink-svc._tcp`.

## Architecture

Strict MVVM — value-type models, `@MainActor` view models, SwiftUI views with no business logic.

```
MeshLink/
├── MeshLinkApp.swift               — App entry point, injects PeerDiscoveryViewModel
├── Models/
│   ├── Peer.swift                  — Value type wrapping MCPeerID + PeerState enum
│   └── Message.swift               — Codable value type for chat messages
├── Services/
│   └── MultipeerService.swift      — MCSession + Advertiser + Browser + all delegates
├── ViewModels/
│   ├── PeerDiscoveryViewModel.swift — @MainActor; merges discovered/connected peers via Combine
│   └── ChatViewModel.swift         — @MainActor; filters messages for a specific peer
└── Views/
    ├── ContentView.swift            — NavigationStack host, toolbar Start/Stop + Broadcast
    ├── PeerListView.swift           — Sectioned list (Connected / Nearby) + empty states
    ├── PeerRowView.swift            — Animated colored icon, state label, progress indicator
    ├── ChatView.swift               — ScrollViewReader chat UI with keyboard-aware input bar
    ├── MessageBubbleView.swift      — iMessage-style bubbles with relative timestamps
    └── BroadcastView.swift          — Sheet for composing and sending a broadcast message
```

### Data flow

```
MultipeerService (NSObject, delegates)
    └─ @Published discoveredPeers / connectedPeers / peerStates / receivedMessages
         └─ PeerDiscoveryViewModel (Combine sink → @Published allPeers / messages)
              └─ SwiftUI Views (EnvironmentObject / ObservedObject)
```

## Requirements

- iOS 16.2+
- Xcode 15+ / Swift 5.9
- Two or more Apple devices (or simulators on the same Mac via the Simulator's peer support)

## Build & Run

Open the project folder in Xcode, select your target device, and run. Alternatively use the helper script:

```bash
./build.sh "iPhone 15"
```

The app requires the **NSLocalNetworkUsageDescription** and **NSBonjourServices** keys in `Info.plist` (already configured).

## Privacy

MeshLink never sends data over the internet. All traffic is local-network only, encrypted by `MCSession` with `.required` encryption preference.

## Apple Developer Documentation

- [MultipeerConnectivity — Framework Overview](https://developer.apple.com/documentation/multipeerconnectivity)
- [MCSession — Managing Peer Sessions](https://developer.apple.com/documentation/multipeerconnectivity/mcsession)
- [MCNearbyServiceAdvertiser](https://developer.apple.com/documentation/multipeerconnectivity/mcnearbyserviceadvertiser)
- [MCNearbyServiceBrowser](https://developer.apple.com/documentation/multipeerconnectivity/mcnearbyservicebrowser)
