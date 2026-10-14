import SwiftUI
import Combine

// MARK: - Level 4: All Data Sharing Ways in Swift & iOS

// 1. Delegate Protocol
protocol DataSharingDelegate: AnyObject {
    func didUpdateMessage(_ message: String)
}

struct DataSharingWaysView: View {
    @State private var selectedMechanism = 0
    @State private var sharingLogs: [String] = []
    @State private var receivedMessage: String = "No message received yet"
    @State private var parentCounter: Int = 100

    // Combine Subject for data sharing
    private let combineDataBus = PassthroughSubject<String, Never>()
    @State private var cancellables = Set<AnyCancellable>()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Banner
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        ZStack {
                            Circle().fill(Color.orange.opacity(0.15)).frame(width: 44, height: 44)
                            Text("L4").font(.headline.bold()).foregroundColor(.orange)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Level 4: Data Sharing Ways")
                                .font(.title2.bold())
                            Text("All 8 Core Communication Patterns in iOS")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    Text("How data flows between views, view controllers, and services is one of the most frequently asked iOS interview topics. Compare 1-to-1, 1-to-Many, reactive, and declarative state sharing.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.orange.opacity(0.08))
                .cornerRadius(16)

                // Interactive Data Sharing Lab
                ConceptCard(
                    title: "Live Data Sharing Lab",
                    subtitle: "Test data transfer between Component A and Component B",
                    icon: "arrow.triangle.swap",
                    iconColor: AppTheme.accent
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        Picker("Sharing Mechanism", selection: $selectedMechanism) {
                            Text("1. Props").tag(0)
                            Text("2. Delegate").tag(1)
                            Text("3. Closure").tag(2)
                            Text("4. Notification").tag(3)
                            Text("5. Combine").tag(4)
                            Text("6. @Binding").tag(5)
                        }
                        .pickerStyle(.segmented)

                        // Data Pipeline Visualization
                        HStack(spacing: 8) {
                            VStack(spacing: 2) {
                                Text("Component A")
                                    .font(.caption.bold())
                                Text("Sender")
                                    .font(.system(size: 9))
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color(.tertiarySystemGroupedBackground))
                            .cornerRadius(8)

                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(AppTheme.accent)
                                .font(.title3)

                            VStack(spacing: 2) {
                                Text("Component B")
                                    .font(.caption.bold())
                                Text("Receiver")
                                    .font(.system(size: 9))
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color(.tertiarySystemGroupedBackground))
                            .cornerRadius(8)
                        }

                        // Current Received Message
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Receiver State:")
                                .font(.caption.bold())
                            Text(receivedMessage)
                                .font(.system(size: 11, design: .monospaced))
                                .padding(8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.secondarySystemGroupedBackground))
                                .cornerRadius(6)
                        }

                        Button {
                            triggerDataSharing()
                        } label: {
                            Label("Transmit Payload via Selected Method", systemImage: "paperplane.fill")
                                .font(.subheadline.bold())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(AppTheme.primary)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        InteractiveLogBox(logs: sharingLogs, onClear: {
                            sharingLogs.removeAll()
                            receivedMessage = "Cleared"
                        })
                    }
                }

                // Complete 8 Ways Breakdown
                ConceptCard(
                    title: "The 8 Data Sharing Patterns in iOS",
                    subtitle: "When to use each pattern",
                    icon: "list.bullet.rectangle.portrait.fill",
                    iconColor: AppTheme.secondary
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        patternRow(
                            number: "1",
                            name: "Property / Initializer Injection",
                            cardinality: "1-to-1 (Parent -> Child)",
                            color: .blue,
                            summary: "Pass data down directly into the child view's init or stored property. Best for simple parent-to-child data flow."
                        )

                        Divider()

                        patternRow(
                            number: "2",
                            name: "Delegate Pattern",
                            cardinality: "1-to-1 (Child -> Parent)",
                            color: .purple,
                            summary: "Uses a protocol with `weak var delegate: Protocol?` to communicate upwards without creating retain cycles. Decouples the child from the parent's concrete type."
                        )

                        Divider()

                        patternRow(
                            number: "3",
                            name: "Closures / Callbacks",
                            cardinality: "1-to-1 (Event Completion)",
                            color: .green,
                            summary: "Passes a function closure e.g. `(Data) -> Void` to return values or notify completion. Lightweight and concise."
                        )

                        Divider()

                        patternRow(
                            number: "4",
                            name: "NotificationCenter",
                            cardinality: "1-to-Many (Broadcasting)",
                            color: .orange,
                            summary: "Posts a notification across the entire app. Any subscribed observer receives the broadcast. Ideal for app-wide events (e.g. user logged out, network lost)."
                        )

                        Divider()

                        patternRow(
                            number: "5",
                            name: "Combine Subjects / Streams",
                            cardinality: "Reactive (1-to-Many)",
                            color: .pink,
                            summary: "Uses PassthroughSubject or CurrentValueSubject to continuously emit updates to multiple subscribers with operator filtering."
                        )

                        Divider()

                        patternRow(
                            number: "6",
                            name: "SwiftUI State & Binding",
                            cardinality: "Two-Way Binding",
                            color: .teal,
                            summary: "@State owns the truth; @Binding provides read/write access to child views without duplicating data."
                        )

                        Divider()

                        patternRow(
                            number: "7",
                            name: "Environment / Dependency Injection",
                            cardinality: "Tree-Wide Hierarchy",
                            color: .indigo,
                            summary: "Injecting @EnvironmentObject or @Environment allows deep child views to access data without passing it through every intermediate view."
                        )

                        Divider()

                        patternRow(
                            number: "8",
                            name: "Singleton / Shared Store",
                            cardinality: "Global Access Point",
                            color: .red,
                            summary: "A single instance (`static let shared`) accessible anywhere. Useful for session managers or caches, but must be used judiciously to avoid global state pollution."
                        )
                    }
                }

                // Comparison Table
                CodeBlockView(
                    title: "Delegate vs Closure vs Notification",
                    code: """
// 1. Delegate (1-to-1 upward)
protocol CartDelegate: AnyObject { func cartDidUpdate() }
class CartView { weak var delegate: CartDelegate? }

// 2. Closure (1-to-1 lightweight)
class Downloader { var onComplete: ((Data) -> Void)? }

// 3. NotificationCenter (1-to-Many broadcast)
NotificationCenter.default.post(name: .cartUpdated, object: nil)
"""
                )
            }
            .padding()
        }
        .navigationTitle("Data Sharing Ways")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            setupCombineBus()
            setupNotificationObserver()
        }
    }

    private func patternRow(number: String, name: String, cardinality: String, color: Color, summary: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            ZStack {
                Circle().fill(color.opacity(0.15)).frame(width: 28, height: 28)
                Text(number).font(.caption.bold()).foregroundColor(color)
            }
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(name).font(.subheadline.bold()).foregroundColor(.primary)
                    Spacer()
                    Text(cardinality)
                        .font(.system(size: 9, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(color.opacity(0.12))
                        .foregroundColor(color)
                        .cornerRadius(4)
                }
                Text(summary).font(.caption).foregroundColor(.secondary)
            }
        }
    }

    private func setupCombineBus() {
        cancellables.removeAll()
        combineDataBus
            .sink { payload in
                self.receivedMessage = payload
                self.sharingLogs.append("⚡ [Combine Stream] Received event: \"\(payload)\"")
            }
            .store(in: &cancellables)
    }

    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("CustomDataNotification"),
            object: nil,
            queue: .main
        ) { notif in
            if let text = notif.userInfo?["text"] as? String {
                self.receivedMessage = text
                self.sharingLogs.append("📢 [NotificationCenter] Broadcast received: \"\(text)\"")
            }
        }
    }

    private func triggerDataSharing() {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)

        switch selectedMechanism {
        case 0: // Property injection
            let msg = "Property Injected: UserID #42 (at \(timestamp))"
            receivedMessage = msg
            sharingLogs.append("1. [Property Injection] Component A directly passed data into Component B initializer.")

        case 1: // Delegate
            let msg = "Delegate Protocol: didUpdateMessage() triggered"
            receivedMessage = msg
            sharingLogs.append("2. [Delegate] Component A invoked delegate?.didUpdateMessage() on Component B.")

        case 2: // Closure
            let msg = "Closure Callback: Completion returned success!"
            receivedMessage = msg
            sharingLogs.append("3. [Closure] Component A executed completionBlock(\"\(msg)\").")

        case 3: // NotificationCenter
            let msg = "Notification Broadcast: New Data Available"
            NotificationCenter.default.post(
                name: NSNotification.Name("CustomDataNotification"),
                object: nil,
                userInfo: ["text": msg]
            )

        case 4: // Combine
            let msg = "Combine Payload: Stream Event #\(Int.random(in: 100...999))"
            combineDataBus.send(msg)

        case 5: // @Binding
            parentCounter += 1
            let msg = "Two-Way @Binding: Counter updated to \(parentCounter)"
            receivedMessage = msg
            sharingLogs.append("6. [@Binding] Value updated simultaneously in parent and child views!")

        default:
            break
        }
    }
}
