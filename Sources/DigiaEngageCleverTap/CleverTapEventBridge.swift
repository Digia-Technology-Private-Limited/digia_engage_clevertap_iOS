@_exported import DigiaEngage

@MainActor
final class CleverTapEventBridge {
    private let bridge: CleverTapBridge

    init(bridge: CleverTapBridge) {
        self.bridge = bridge
    }

    func notifyEvent(_ event: DigiaExperienceEvent, payload: InAppPayload) {
        guard case .dismissed = event else { return }
        let templateName = payload.cepContext["templateName"] ?? payload.id
        bridge.dismissTemplate(templateName)
    }
}
