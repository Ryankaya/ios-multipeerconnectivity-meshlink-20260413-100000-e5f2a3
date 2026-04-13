import Foundation
import MultipeerConnectivity
import Combine

@MainActor
final class PeerDiscoveryViewModel: ObservableObject {

    let service = MultipeerService()

    @Published var allPeers: [Peer] = []
    @Published var messages: [Message] = []
    @Published var broadcastText: String = ""
    @Published var isActive: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        bindService()
    }

    private func bindService() {
        service.$discoveredPeers.combineLatest(service.$connectedPeers, service.$peerStates)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] discovered, connected, states in
                guard let self else { return }
                var peers: [Peer] = []
                for pid in connected {
                    peers.append(Peer(id: pid, state: .connected))
                }
                for pid in discovered {
                    if !connected.contains(pid) {
                        let state = states[pid] ?? .notConnected
                        peers.append(Peer(id: pid, state: state))
                    }
                }
                self.allPeers = peers
            }
            .store(in: &cancellables)

        service.$receivedMessages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] msgs in
                self?.messages = msgs
            }
            .store(in: &cancellables)
    }

    func toggleActive() {
        if isActive {
            service.stop()
        } else {
            service.start()
        }
        isActive.toggle()
    }

    func connect(to peer: Peer) {
        service.invite(peer: peer.id)
    }

    func sendBroadcast() {
        guard !broadcastText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let msg = Message(senderName: service.myPeerID.displayName, text: broadcastText, isBroadcast: true)
        service.broadcast(message: msg)
        messages.append(msg)
        broadcastText = ""
    }

    func send(text: String, to peer: Peer) {
        let msg = Message(senderName: service.myPeerID.displayName, text: text)
        service.send(message: msg, to: [peer.id])
        messages.append(msg)
    }

    func messagesFor(peer: Peer) -> [Message] {
        messages.filter { $0.senderName == peer.displayName || ($0.senderName == service.myPeerID.displayName && !$0.isBroadcast) }
    }
}
