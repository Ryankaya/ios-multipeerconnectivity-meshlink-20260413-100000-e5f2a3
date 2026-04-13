import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: PeerDiscoveryViewModel
    @State private var showBroadcast = false

    var body: some View {
        NavigationStack {
            PeerListView()
                .navigationTitle("MeshLink")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(vm.isActive ? "Stop" : "Start") {
                            vm.toggleActive()
                        }
                        .tint(vm.isActive ? .red : .green)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showBroadcast = true
                        } label: {
                            Image(systemName: "antenna.radiowaves.left.and.right")
                        }
                        .disabled(!vm.isActive || vm.allPeers.filter { $0.state == .connected }.isEmpty)
                    }
                }
                .sheet(isPresented: $showBroadcast) {
                    BroadcastView()
                        .environmentObject(vm)
                }
        }
    }
}
