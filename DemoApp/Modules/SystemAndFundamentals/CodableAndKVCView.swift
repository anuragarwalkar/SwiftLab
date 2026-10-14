import SwiftUI

// MARK: - Codable, KVC & KVO

// Live Model for Codable
private struct UserAccount: Codable {
    let userId: Int
    let fullName: String
    let registeredAt: Date
}

// Live Class for KVO
private class ObservableAccount: NSObject {
    @objc dynamic var balance: Double = 100.0
}

struct CodableAndKVCView: View {
    @State private var jsonOutput: String = ""
    @State private var decodedName: String = ""
    @State private var kvoLogs: [String] = []

    // KVO Object and observation token
    @State private var account = ObservableAccount()
    @State private var kvoObservation: NSKeyValueObservation?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.primary)
                        Text("Codable, KVC & KVO")
                            .font(.title2.bold())
                    }
                    Text("Swift serialization with Decodable/Encodable, date strategies, convertFromSnakeCase, and Objective-C runtime dynamic inspection with KVC & KVO.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.primary.opacity(0.08))
                .cornerRadius(16)

                // Codable Live Playground
                ConceptCard(
                    title: "Live Codable Playground",
                    subtitle: "Decodable with snake_case & ISO8601 Date Strategy",
                    icon: "arrow.triangle.swap",
                    iconColor: AppTheme.accent
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Decodes snake_case JSON directly into camelCase Swift model with custom dateDecodingStrategy.")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Button {
                            runCodableTest()
                        } label: {
                            Label("Decode Snake_Case JSON", systemImage: "play.circle.fill")
                                .font(.subheadline.bold())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(AppTheme.accent)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        if !decodedName.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Decoded Swift Model:")
                                    .font(.caption.bold())
                                    .foregroundColor(AppTheme.accent)
                                Text("Name: \(decodedName)")
                                    .font(.system(size: 11, design: .monospaced))
                                Text("Raw JSON:")
                                    .font(.caption.bold())
                                    .padding(.top, 4)
                                Text(jsonOutput)
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundColor(.secondary)
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.tertiarySystemGroupedBackground))
                            .cornerRadius(8)
                        }
                    }
                }

                // KVC & KVO Live Demo
                ConceptCard(
                    title: "Live KVC & KVO Inspector",
                    subtitle: "Key-Value Coding & Key-Value Observing",
                    icon: "eye.circle.fill",
                    iconColor: AppTheme.purple
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Account Balance: $\(String(format: "%.2f", account.balance))")
                                .font(.subheadline.bold())
                            Spacer()
                            Button("Deposit $50") {
                                account.balance += 50.0
                            }
                            .font(.caption.bold())
                            .buttonStyle(.borderedProminent)
                            .tint(AppTheme.purple)
                        }

                        Button("Read via KVC (value(forKey:))") {
                            if let val = account.value(forKey: "balance") as? Double {
                                kvoLogs.append("🔑 [KVC] value(forKey: \"balance\") returned: $\(val)")
                            }
                        }
                        .font(.caption)
                        .buttonStyle(.bordered)

                        InteractiveLogBox(logs: kvoLogs, onClear: { kvoLogs.removeAll() })
                    }
                }

                // Breakdown Card
                ConceptCard(
                    title: "Conceptual Deep Dive",
                    subtitle: "Decodable, Encodable, KVC, and KVO",
                    icon: "list.bullet.rectangle",
                    iconColor: AppTheme.secondary
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Codable (Decodable & Encodable)")
                                .font(.headline)
                                .foregroundColor(AppTheme.primary)
                            BulletPoint(text: "Decodable: converts external representation (JSON, PropertyList) into Swift models.")
                            BulletPoint(text: "decoder.keyDecodingStrategy = .convertFromSnakeCase converts user_name -> userName automatically.")
                            BulletPoint(text: "decoder.dateDecodingStrategy = .iso8601 handles standard timestamps.")
                            BulletPoint(text: "Encodable: serializes Swift structs into Data/JSON.")
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 4) {
                            Text("KVC (Key-Value Coding)")
                                .font(.headline)
                                .foregroundColor(AppTheme.secondary)
                            BulletPoint(text: "Indirect property access mechanism using strings (e.g. value(forKey:), setValue(_:forKey:)).")
                            BulletPoint(text: "Requires Objective-C runtime (@objc members in NSObject subclasses).")
                            BulletPoint(text: "Heavily utilized in UserDefaults, Core Data, and interface bindings.")
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 4) {
                            Text("KVO (Key-Value Observing)")
                                .font(.headline)
                                .foregroundColor(AppTheme.purple)
                            BulletPoint(text: "Enables an object to be notified whenever another object's property value changes.", color: AppTheme.purple)
                            BulletPoint(text: "Requires '@objc dynamic' property declaration.", color: AppTheme.purple)
                            BulletPoint(text: "Swift syntax uses strongly-typed key paths: `observe(\\.balance, options: [.old, .new])`.", color: AppTheme.purple)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Codable & KVC/KVO")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            setupKVO()
        }
    }

    private func setupKVO() {
        kvoObservation = account.observe(\.balance, options: [.old, .new]) { [self] obj, change in
            let oldVal = change.oldValue ?? 0
            let newVal = change.newValue ?? 0
            DispatchQueue.main.async {
                self.kvoLogs.append("👀 [KVO Listener] Balance changed from $\(oldVal) to $\(newVal)!")
            }
        }
    }

    private func runCodableTest() {
        let sampleJSON = """
        {
            "user_id": 99,
            "full_name": "Anurag Arwalkar",
            "registered_at": "2026-10-14T10:00:00Z"
        }
        """
        jsonOutput = sampleJSON

        guard let data = sampleJSON.data(using: .utf8) else { return }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        do {
            let user = try decoder.decode(UserAccount.self, from: data)
            decodedName = "\(user.fullName) (ID: \(user.userId))"
        } catch {
            decodedName = "Decoding error: \(error.localizedDescription)"
        }
    }
}
