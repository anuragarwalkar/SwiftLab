import SwiftUI

// MARK: - SSL / TLS Pinning: Certificate & Public Key Pinning

struct SSLPinningView: View {
    @State private var pinningMode = 0 // 0: Certificate Pinning, 1: Public Key Pinning
    @State private var isAttacked = false
    @State private var connectionLogs: [String] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "checkmark.shield.fill")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.accent)
                        Text("SSL / TLS Pinning")
                            .font(.title2.bold())
                    }
                    Text("Defend your iOS apps against Man-In-The-Middle (MITM) proxy attacks by pinning server certificates or Subject Public Key Info (SPKI).")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.accent.opacity(0.08))
                .cornerRadius(16)

                // Interactive Pinning & MITM Attack Simulator
                ConceptCard(
                    title: "Live TLS Handshake Simulator",
                    subtitle: "Test valid handshake vs MITM proxy attack",
                    icon: "network.badge.shield.half.filled",
                    iconColor: AppTheme.primary
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        Picker("Pinning Strategy", selection: $pinningMode) {
                            Text("Certificate Pinning").tag(0)
                            Text("Public Key Pinning").tag(1)
                        }
                        .pickerStyle(.segmented)

                        Toggle(isOn: $isAttacked) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Simulate MITM Attack (e.g. Proxy)")
                                    .font(.subheadline.bold())
                                Text(isAttacked ? "Attacker intercepting with forged certificate" : "Normal clean network connection")
                                    .font(.caption)
                                    .foregroundColor(isAttacked ? .red : .secondary)
                            }
                        }
                        .tint(.red)

                        Button {
                            testSSLHandshake()
                        } label: {
                            Label("Execute TLS Handshake Challenge", systemImage: "bolt.horizontal.fill")
                                .font(.subheadline.bold())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(isAttacked ? AppTheme.error : AppTheme.primary)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        InteractiveLogBox(logs: connectionLogs, onClear: { connectionLogs.removeAll() })
                    }
                }

                // Two Approaches Card
                ConceptCard(
                    title: "Certificate Pinning vs Public Key Pinning",
                    subtitle: "Two ways to achieve SSL Pinning",
                    icon: "arrow.triangle.swap",
                    iconColor: AppTheme.secondary
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        // Approach 1
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("1. Certificate Pinning")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.primary)
                                Spacer()
                                Text("Bundle File Match")
                                    .font(.caption2.bold())
                                    .padding(4)
                                    .background(AppTheme.primary.opacity(0.12))
                                    .cornerRadius(4)
                            }
                            BulletPoint(text: "Extract and store server's .cer / .der certificate file directly in the app bundle.")
                            BulletPoint(text: "Compare server certificate byte-for-byte during URLSession challenge.")
                            BulletPoint(text: "⚠️ Major Drawback: When the server certificate expires (often every 90 days to 1 year), the app will CRASH / BREAK completely unless a new app version is shipped to the App Store!", color: AppTheme.error)
                        }

                        Divider()

                        // Approach 2
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("2. Public Key Pinning (Recommended)")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.success)
                                Spacer()
                                Text("SPKI Hash Match")
                                    .font(.caption2.bold())
                                    .padding(4)
                                    .background(AppTheme.success.opacity(0.12))
                                    .cornerRadius(4)
                            }
                            BulletPoint(text: "Extracts and checks only the Subject Public Key Info (SPKI) cryptographic hash.", color: AppTheme.success)
                            BulletPoint(text: "When renewing an expired TLS certificate on the server using the SAME private key, the public key hash remains identical!", color: AppTheme.success)
                            BulletPoint(text: "App continues to work seamlessly without requiring an emergency App Store release.", color: AppTheme.success)
                        }
                    }
                }

                // URLSessionDelegate Implementation Code
                CodeBlockView(
                    title: "URLSessionDelegate: didReceiveChallenge",
                    code: """
func urlSession(
    _ session: URLSession,
    didReceive challenge: URLAuthenticationChallenge,
    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
) {
    guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
          let serverTrust = challenge.protectionSpace.serverTrust else {
        completionHandler(.cancelAuthenticationChallenge, nil)
        return
    }

    // 1. Evaluate SecTrustEvaluateWithError
    var error: CFError?
    guard SecTrustEvaluateWithError(serverTrust, &error) else {
        completionHandler(.cancelAuthenticationChallenge, nil)
        return
    }

    // 2. Compare pinned certificate or public key
    if validatePinnedKey(serverTrust: serverTrust) {
        // Match verified!
        completionHandler(.useCredential, URLCredential(trust: serverTrust))
    } else {
        // MITM detected or cert mismatch! Abort!
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
}
"""
                )
            }
            .padding()
        }
        .navigationTitle("SSL Pinning")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func testSSLHandshake() {
        connectionLogs.removeAll()
        connectionLogs.append("🌐 [Client] Initiating TLS handshake with https://api.mybank.com...")
        connectionLogs.append("🤝 [Server] Server responds with TLS certificate chain...")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.connectionLogs.append("🛡️ [URLSessionDelegate] Received 'didReceiveChallenge' for NSURLAuthenticationMethodServerTrust")

            if self.isAttacked {
                self.connectionLogs.append("🚨 [Pinning Validation] Mismatch detected! Attacker's proxy cert does NOT match pinned hash.")
                self.connectionLogs.append("🛑 [Action] Invoking: completionHandler(.cancelAuthenticationChallenge, nil)")
                self.connectionLogs.append("❌ Connection Aborted! MITM Attack Defeated.")
            } else {
                let modeText = self.pinningMode == 0 ? "Certificate bytes match bundle file" : "SPKI Public Key Hash matches 92e4...31b"
                self.connectionLogs.append("✅ [Pinning Validation] \(modeText)")
                self.connectionLogs.append("🔓 [Action] Invoking: completionHandler(.useCredential, URLCredential(trust: serverTrust))")
                self.connectionLogs.append("✔ Secure TLS tunnel established successfully!")
            }
        }
    }
}
