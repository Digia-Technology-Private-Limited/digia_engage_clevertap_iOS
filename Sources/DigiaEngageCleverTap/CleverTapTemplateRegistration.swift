import Foundation
import CleverTapSDK

enum CleverTapTemplateRegistration {
    static let templateName = "DigiaTemplate"

    nonisolated(unsafe) private static var isRegistered = false
    nonisolated(unsafe) private static var onPayload: (([String: Any]) -> Void)?
    nonisolated(unsafe) private static var onInvalidated: ((String) -> Void)?
    nonisolated(unsafe) private static var activeContext: CTTemplateContext?

    static func register() {
        guard !isRegistered else { return }
        CleverTap.registerCustom(inAppTemplates: DigiaTemplateProducer())
        isRegistered = true
    }

    static func setCallbacks(
        onPayload: @escaping ([String: Any]) -> Void,
        onInvalidated: @escaping (String) -> Void
    ) {
        self.onPayload = onPayload
        self.onInvalidated = onInvalidated
    }

    static func clearCallbacks() {
        onPayload = nil
        onInvalidated = nil
    }

    static func activate(context: CTTemplateContext, payload: [String: Any], campaignId: String) {
        activeContext = context
        context.presented()
        var payload = payload
        payload["id"] = campaignId
        onPayload?(payload)
    }

    static func dismissTemplate(named templateName: String) {
        guard templateName == Self.templateName, let context = activeContext else { return }
        activeContext = nil
        context.dismissed()
    }

    static func invalidate(context: CTTemplateContext, campaignId: String) {
        if activeContext?.name() == context.name() {
            activeContext = nil
        }
        context.dismissed()
        onInvalidated?(campaignId)
    }
}

private final class DigiaTemplateProducer: NSObject, CTTemplateProducer {
    func defineTemplates(_: CleverTapInstanceConfig!) -> Set<CTCustomTemplate>! {
        let builder = CTInAppTemplateBuilder()
        builder.setName(CleverTapTemplateRegistration.templateName)
        builder.addArgument("viewId", string: "")
        builder.addArgument("command", string: "")
        builder.addArgument("args", string: "{}")
        builder.setPresenter(DigiaTemplatePresenter())
        return [builder.build()]
    }
}

private final class DigiaTemplatePresenter: NSObject, CTTemplatePresenter {
    func onPresent(context: CTTemplateContext) {
        let viewId = context.string(name: "viewId")?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let command = context.string(name: "command")?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !viewId.isEmpty, !command.isEmpty else {
            assertionFailure("DigiaTemplate requires viewId and command.")
            context.dismissed()
            return
        }

        let campaignId = "\(CleverTapTemplateRegistration.templateName):\(viewId)"
        var payload: [String: Any] = [
            "templateName": context.name(),
            "viewId": viewId,
            "command": command.uppercased(),
        ]

        if let argsString = context.string(name: "args"),
           let data = argsString.data(using: .utf8),
           let decoded = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            payload["args"] = decoded
        } else if let argsString = context.string(name: "args"), !argsString.isEmpty {
            assertionFailure("DigiaTemplate args must decode to an object.")
        }

        CleverTapTemplateRegistration.activate(
            context: context,
            payload: payload,
            campaignId: campaignId
        )
    }

    func onCloseClicked(context: CTTemplateContext) {
        let viewId = context.string(name: "viewId")?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let campaignId = viewId.isEmpty
            ? context.name()
            : "\(CleverTapTemplateRegistration.templateName):\(viewId)"
        CleverTapTemplateRegistration.invalidate(context: context, campaignId: campaignId)
    }
}
