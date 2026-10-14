import SwiftUI
import Combine

// MARK: - Combine Framework: Publishers, Subjects & Operators

struct CombineView: View {
    @State private var logs: [String] = []
    @State private var passthroughCounter = 0
    @State private var currentValueDisplay = "Initial Value"
    @State private var cancellables = Set<AnyCancellable>()

    // Live Subjects
    private let passthroughSubject = PassthroughSubject<String, Never>()
    private let currentValueSubject = CurrentValueSubject<String, Never>("Initial Value")

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "point.3.filled.connected.trianglepath.dotted")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.primary)
                        Text("Combine Framework")
                            .font(.title2.bold())
                    }
                    Text("Apple's declarative reactive framework: customize handling of asynchronous events by combining event-processing operators with Publishers and Subscribers.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.primary.opacity(0.08))
                .cornerRadius(16)

                // Interactive Live Subjects Lab
                ConceptCard(
                    title: "Live Subject Emission Stream",
                    subtitle: "Compare PassthroughSubject vs CurrentValueSubject",
                    icon: "wave.3.forward.circle.fill",
                    iconColor: AppTheme.accent
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("CurrentValueSubject.value:")
                                .font(.caption.bold())
                            Spacer()
                            Text(currentValueDisplay)
                                .font(.caption.bold())
                                .padding(4)
                                .background(AppTheme.purple.opacity(0.15))
                                .foregroundColor(AppTheme.purple)
                                .cornerRadius(4)
                        }

                        HStack(spacing: 10) {
                            Button("Emit to Passthrough") {
                                passthroughCounter += 1
                                passthroughSubject.send("Event #\(passthroughCounter)")
                            }
                            .font(.caption.bold())
                            .buttonStyle(.borderedProminent)

                            Button("Update CurrentValue") {
                                let newVal = "Value \(Int.random(in: 100...999))"
                                currentValueSubject.send(newVal)
                            }
                            .font(.caption.bold())
                            .buttonStyle(.borderedProminent)
                            .tint(AppTheme.purple)

                            Button("Run 'Just'") {
                                runJustDemo()
                            }
                            .font(.caption.bold())
                            .buttonStyle(.bordered)
                        }

                        InteractiveLogBox(logs: logs, onClear: { logs.removeAll() })
                    }
                }

                // Publishers Comparison Table
                ConceptCard(
                    title: "Core Combine Subjects & Publishers",
                    subtitle: "Key differences you must know",
                    icon: "list.dash.header.rectangle",
                    iconColor: AppTheme.secondary
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("1. Just")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.primary)
                                Spacer()
                                Text("Emits Once & Finishes")
                                    .font(.caption2.bold())
                                    .padding(4)
                                    .background(AppTheme.primary.opacity(0.12))
                                    .cornerRadius(4)
                            }
                            BulletPoint(text: "Emits exactly one value to each subscriber and then immediately completes.")
                            BulletPoint(text: "Useful for stubbing mock data or returning immediate values from async protocols.")
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("2. PassthroughSubject")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.accent)
                                Spacer()
                                Text("Stateless Event Stream")
                                    .font(.caption2.bold())
                                    .padding(4)
                                    .background(AppTheme.accent.opacity(0.12))
                                    .cornerRadius(4)
                            }
                            BulletPoint(text: "Emits values to active subscribers, but holds NO internal state or history.", color: AppTheme.accent)
                            BulletPoint(text: "New subscribers do NOT receive past events; only future emissions.", color: AppTheme.accent)
                            BulletPoint(text: "Ideal for user actions, button taps, and ephemeral triggers.", color: AppTheme.accent)
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("3. CurrentValueSubject")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.purple)
                                Spacer()
                                Text("Holds Current Value")
                                    .font(.caption2.bold())
                                    .padding(4)
                                    .background(AppTheme.purple.opacity(0.12))
                                    .cornerRadius(4)
                            }
                            BulletPoint(text: "Maintains a buffer containing its most recent value (.value property).", color: AppTheme.purple)
                            BulletPoint(text: "Requires an initial starting value upon creation.", color: AppTheme.purple)
                            BulletPoint(text: "Whenever a new subscriber attaches, it IMMEDIATELY receives the current value.", color: AppTheme.purple)
                        }
                    }
                }

                // Code Example
                CodeBlockView(
                    title: "Combine Subscription Example",
                    code: """
// 1. CurrentValueSubject
let subject = CurrentValueSubject<String, Never>("Initial")
subject
    .map { $0.uppercased() }
    .sink { value in
        print("Received: \\(value)")
    }
    .store(in: &cancellables)

subject.send("Hello Combine!") // Prints "HELLO COMBINE!"
"""
                )
            }
            .padding()
        }
        .navigationTitle("Combine")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            setupSubscriptions()
        }
    }

    private func setupSubscriptions() {
        cancellables.removeAll()

        passthroughSubject
            .sink { event in
                logs.append("⚡ [PassthroughSubject] Emitted: \(event)")
            }
            .store(in: &cancellables)

        currentValueSubject
            .sink { newVal in
                currentValueDisplay = newVal
                logs.append("📦 [CurrentValueSubject] Updated to: \(newVal)")
            }
            .store(in: &cancellables)
    }

    private func runJustDemo() {
        Just("Single value payload")
            .sink(
                receiveCompletion: { completion in
                    logs.append("✔ [Just] Completed immediately after emission!")
                },
                receiveValue: { val in
                    logs.append("⚡ [Just] Emitted value: '\(val)'")
                }
            )
            .store(in: &cancellables)
    }
}
