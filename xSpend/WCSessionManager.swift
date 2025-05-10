import Foundation
import WatchConnectivity

class WCSessionManager: NSObject, WCSessionDelegate {
    
    static let shared = WCSessionManager()

    private override init() {
        super.init()
        activateSession()
    }

    private func activateSession() {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        session.delegate = self
        session.activate()
    }

    func sendMessage(_ data: [String: Any]) {
        guard WCSession.default.isReachable else { return }
        WCSession.default.sendMessage(data, replyHandler: nil) { error in
            print("iOS: Failed to send message: \(error.localizedDescription)")
        }
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("iOS: WCSession activated with state: \(activationState.rawValue)")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("iOS: Message received: \(message)")
        // Handle or post notification to update UI
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}

