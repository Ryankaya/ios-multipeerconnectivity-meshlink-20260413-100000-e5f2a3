import SwiftUI

@main
struct MeshLinkApp: App {
    @StateObject private var peerDiscoveryVM = PeerDiscoveryViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(peerDiscoveryVM)
        }
    }
}
