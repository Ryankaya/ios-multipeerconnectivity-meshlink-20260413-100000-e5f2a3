import SwiftUI

struct MessageBubbleView: View {
    let message: Message
    let isOwn: Bool

    private let formatter: RelativeDateTimeFormatter = {
        let f = RelativeDateTimeFormatter()
        f.unitsStyle = .short
        return f
    }()

    var body: some View {
        HStack {
            if isOwn { Spacer(minLength: 60) }
            VStack(alignment: isOwn ? .trailing : .leading, spacing: 2) {
                if !isOwn {
                    Text(message.senderName)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Text(message.text)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(isOwn ? Color.blue : Color(.systemGray5))
                    .foregroundStyle(isOwn ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                Text(formatter.localizedString(for: message.timestamp, relativeTo: Date()))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
            }
            if !isOwn { Spacer(minLength: 60) }
        }
    }
}
