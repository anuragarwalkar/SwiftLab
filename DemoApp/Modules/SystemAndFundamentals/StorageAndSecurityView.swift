import SwiftUI

// MARK: - UserDefaults vs Keychain & Persistence

struct StorageAndSecurityView: View {
    // Live UserDefaults via @AppStorage
    @AppStorage("user_email_pref") private var savedEmail: String = "developer@apple.com"
    @AppStorage("app_theme_mode") private var themeMode: String = "Dark"

    @State private var inputEmail: String = ""
    @State private var keychainSimulatedToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6..."
    @State private var storageLogs: [String] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "lock.shield.fill")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.warning)
                        Text("UserDefaults vs Keychain")
                            .font(.title2.bold())
                    }
                    Text("Compare app preferences with hardware-encrypted credentials, lifecycle persistence, and sandboxed storage.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.warning.opacity(0.08))
                .cornerRadius(16)

                // Interactive Storage Lab
                ConceptCard(
                    title: "Live Storage Sandbox",
                    subtitle: "Test @AppStorage vs Keychain Services",
                    icon: "externaldrive.fill",
                    iconColor: AppTheme.primary
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        // UserDefaults Section
                        VStack(alignment: .leading, spacing: 6) {
                            Text("1. UserDefaults (@AppStorage):")
                                .font(.caption.bold())
                                .foregroundColor(AppTheme.primary)

                            HStack {
                                TextField("Enter Email", text: $inputEmail)
                                    .textFieldStyle(.roundedBorder)
                                    .font(.caption)

                                Button("Save") {
                                    if !inputEmail.isEmpty {
                                        savedEmail = inputEmail
                                        storageLogs.append("💾 [UserDefaults] Saved email: '\(inputEmail)' to plist.")
                                        inputEmail = ""
                                    }
                                }
                                .font(.caption.bold())
                                .buttonStyle(.borderedProminent)
                            }

                            Text("Current Stored Value: \(savedEmail)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Divider()

                        // Keychain Section
                        VStack(alignment: .leading, spacing: 6) {
                            Text("2. Keychain (Secure Enclave Encrypted):")
                                .font(.caption.bold())
                                .foregroundColor(AppTheme.warning)

                            HStack {
                                Text("JWT Auth Token:")
                                    .font(.caption)
                                Spacer()
                                Text("AES-256 Encrypted")
                                    .font(.system(size: 9, weight: .bold))
                                    .padding(4)
                                    .background(Color.green.opacity(0.15))
                                    .foregroundColor(.green)
                                    .cornerRadius(4)
                            }

                            Text(keychainSimulatedToken)
                                .font(.system(size: 11, design: .monospaced))
                                .padding(8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.tertiarySystemGroupedBackground))
                                .cornerRadius(6)

                            HStack(spacing: 10) {
                                Button("Simulate App Deletion") {
                                    simulateAppDeletion()
                                }
                                .font(.caption.bold())
                                .buttonStyle(.bordered)
                                .tint(.red)
                            }
                        }

                        InteractiveLogBox(logs: storageLogs, onClear: { storageLogs.removeAll() })
                    }
                }

                // Comparison Card
                ConceptCard(
                    title: "Deep Comparison Breakdown",
                    subtitle: "Security, file format & app lifecycle",
                    icon: "tablecells.fill",
                    iconColor: AppTheme.secondary
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("UserDefaults")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.primary)
                                Spacer()
                                Text("Unencrypted .plist")
                                    .font(.caption2.bold())
                                    .padding(4)
                                    .background(AppTheme.primary.opacity(0.12))
                                    .cornerRadius(4)
                            }
                            BulletPoint(text: "Stored as an unencrypted XML/Binary plist file inside app's sandboxed Library/Preferences.")
                            BulletPoint(text: "SwiftUI syntax: @AppStorage(\"key\") var email: String = \"\"")
                            BulletPoint(text: "App Deletion: WIPED OUT completely when user deletes the app.")
                            BulletPoint(text: "Security: NOT secure. Never store tokens, passwords, or PII here.")
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Keychain Services")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.warning)
                                Spacer()
                                Text("Hardware Encrypted")
                                    .font(.caption2.bold())
                                    .padding(4)
                                    .background(AppTheme.warning.opacity(0.12))
                                    .cornerRadius(4)
                            }
                            BulletPoint(text: "Centralized encrypted SQLite database managed by macOS/iOS securityd daemon.", color: AppTheme.warning)
                            BulletPoint(text: "Protected by AES-256 encryption and device passcode / FaceID / Secure Enclave.", color: AppTheme.warning)
                            BulletPoint(text: "App Deletion: PERSISTS in the Keychain even after user deletes the app! If user reinstalls, items can still be read.", color: AppTheme.warning)
                            BulletPoint(text: "Usage: Passwords, private keys, authentication tokens, cryptographic secrets.", color: AppTheme.warning)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Storage & Security")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func simulateAppDeletion() {
        storageLogs.append("🗑️ [App Deletion Simulation] User deleted the app from home screen...")
        storageLogs.append("❌ UserDefaults (.plist): Sandbox destroyed! Stored preferences erased.")
        storageLogs.append("🔒 Keychain: Keychain item persisted securely! Retained for future reinstall.")
    }
}
