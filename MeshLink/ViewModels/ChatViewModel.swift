import Foundation
import Combine

@MainActor
final class ChatViewModel: ObservableObject {

    let peer: Peer
    private let discoveryVM: PeerDiscoveryViewModel

    @Published var messageText: String = ""
    @Published var messages: [Message] = []

    private var cancellables = Set<AnyCancellable>()

    init(peer: Peer, discoveryVM: PeerDiscoveryViewModel) {
        self.peer = peer
        self.discoveryVM = discoveryVM
        bindMessages()
    }

    private func bindMessages() {
        discoveryVM.$messages
            .map { [weak self] all in
                guard let self else { return [] }
                return all.filter {
                    $0.senderName == self.peer.displayName ||
                    ($0.senderName == self.discoveryVM.service.myPeerID.displayName && !$0.isBroadcast)
                }
            }
            .assign(to: &$messages)
    }

    func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        discoveryVM.send(text: trimmed, to: peer)
        messageText = ""
    }
}
