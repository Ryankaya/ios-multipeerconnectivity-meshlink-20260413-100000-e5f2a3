import SwiftUI

struct PeerListView: View {
    @EnvironmentObject var vm: PeerDiscoveryViewModel

    var connectedPeers: [Peer] { vm.allPeers.filter { $0.state == .connected } }
    var discoveredPeers: [Peer] { vm.allPeers.filter { $0.state != .connected } }

    var body: some View {
        Group {
            if !vm.isActive {
                inactiveState
            } else if vm.allPeers.isEmpty {
                searchingState
            } else {
                peerList
            }
        }
    }

    private var inactiveState: some View {
        VStack(spacing: 20) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            Text("Tap Start to begin discovering nearby devices")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var searchingState: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Searching for nearby devices...")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var peerList: some View {
        List {
            if !connectedPeers.isEmpty {
                Section("Connected") {
                    ForEach(connectedPeers) { peer in
                        NavigationLink {
                            ChatView(vm: ChatViewModel(peer: peer, discoveryVM: vm))
                        } label: {
                            PeerRowView(peer: peer)
                        }
                    }
                }
            }
            if !discoveredPeers.isEmpty {
                Section("Nearby") {
                    ForEach(discoveredPeers) { peer in
                        PeerRowView(peer: peer)
                            .onTapGesture { vm.connect(to: peer) }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}
