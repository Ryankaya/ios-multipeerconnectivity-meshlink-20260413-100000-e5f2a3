import SwiftUI

struct PeerRowView: View {
    let peer: Peer

    private var stateColor: Color {
        switch peer.state {
        case .connected: return .green
        case .connecting: return .orange
        case .notConnected: return .gray
        }
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(stateColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: "iphone")
                    .foregroundStyle(stateColor)
                    .font(.title3)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(peer.displayName)
                    .font(.headline)
                Text(peer.state.label)
                    .font(.caption)
                    .foregroundStyle(stateColor)
            }
            Spacer()
            if peer.state == .connecting {
                ProgressView()
            } else if peer.state == .notConnected {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
}
