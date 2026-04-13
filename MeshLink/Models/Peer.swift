import Foundation
import MultipeerConnectivity

struct Peer: Identifiable, Equatable {
    let id: MCPeerID
    var displayName: String { id.displayName }
    var state: PeerState

    static func == (lhs: Peer, rhs: Peer) -> Bool {
        lhs.id == rhs.id
    }
}

enum PeerState: Equatable {
    case notConnected
    case connecting
    case connected

    var label: String {
        switch self {
        case .notConnected: return "Nearby"
        case .connecting: return "Connecting..."
        case .connected: return "Connected"
        }
    }

    var color: String {
        switch self {
        case .notConnected: return "gray"
        case .connecting: return "orange"
        case .connected: return "green"
        }
    }
}
