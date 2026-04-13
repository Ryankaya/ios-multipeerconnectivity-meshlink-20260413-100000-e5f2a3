import Foundation

struct Message: Identifiable, Codable {
    let id: UUID
    let senderName: String
    let text: String
    let timestamp: Date
    let isBroadcast: Bool

    init(senderName: String, text: String, isBroadcast: Bool = false) {
        self.id = UUID()
        self.senderName = senderName
        self.text = text
        self.timestamp = Date()
        self.isBroadcast = isBroadcast
    }
}
