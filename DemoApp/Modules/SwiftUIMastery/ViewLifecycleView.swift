import SwiftUI

// MARK: - SwiftUI View Lifecycle & Modifiers

struct ViewLifecycleView: View {
    @State private var lifecycleLogs: [String] = []
    @State private var watchedProperty = 0
    @State private var isChildPresented = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.primary)
                        Text("View Lifecycle & Events")
                            .font(.title2.bold())
                    }
                    Text("Understand how SwiftUI constructs, renders, monitors, and tears down views: onAppear, onDisappear, .task cancellation, onChange, onReceive, and self vs Self.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.primary.opacity(0.08))
                .cornerRadius(16)

                // Interactive Child Modal for Lifecycle Trigger
                ConceptCard(
                    title: "Live Lifecycle Tester",
                    subtitle: "Present & dismiss sheet to trigger events",
                    icon: "play.circle.fill",
                    iconColor: AppTheme.accent
                ) {
                    VStack(spacing: 12) {
                        Button {
                            isChildPresented = true
                        } label: {
                            Label("Present Lifecycle Sheet", systemImage: "rectangle.portrait.and.arrow.forward")
                                .font(.subheadline.bold())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(AppTheme.primary)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        HStack {
                            Text("Watched Property: \(watchedProperty)")
                                .font(.caption.bold())
                            Spacer()
                            Button("Mutate Property") {
                                watchedProperty += 1
                            }
                            .font(.caption.bold())
                            .buttonStyle(.bordered)
                        }

                        InteractiveLogBox(logs: lifecycleLogs, onClear: { lifecycleLogs.removeAll() })
                    }
                }

                // Breakdown of Modifiers
                ConceptCard(
                    title: "Lifecycle Modifiers Breakdown",
                    subtitle: "Detailed behavior & comparisons",
                    icon: "list.bullet.indent",
                    iconColor: AppTheme.secondary
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        lifecycleRow(
                            name: ".onAppear",
                            analogy: "Like viewWillAppear (UIKit)",
                            desc: "Triggers synchronously whenever the view becomes visible in the window hierarchy."
                        )

                        Divider()

                        lifecycleRow(
                            name: ".onDisappear",
                            analogy: "Like viewWillDisappear (UIKit)",
                            desc: "Triggers when view leaves the screen (popped, dismissed, or conditional removal)."
                        )

                        Divider()

                        lifecycleRow(
                            name: ".task(priority:id:)",
                            analogy: "Modern Async Lifecycle",
                            desc: "Runs asynchronous work when view appears. Automatically CANCELS the task if view disappears before finishing! Re-runs automatically if 'id' parameter changes."
                        )

                        Divider()

                        lifecycleRow(
                            name: ".onChange(of:)",
                            analogy: "Reactive Property Observer",
                            desc: "Fires whenever the observed Equatable value changes. Perfect for reacting to state mutations."
                        )

                        Divider()

                        lifecycleRow(
                            name: ".onReceive(publisher)",
                            analogy: "Combine & NotificationCenter Bridge",
                            desc: "Subscribes directly to a Combine publisher or NotificationCenter broadcast (e.g. UIApplication.willEnterForegroundNotification)."
                        )

                        Divider()

                        // self vs Self
                        VStack(alignment: .leading, spacing: 4) {
                            Text("self vs Self")
                                .font(.subheadline.bold())
                                .foregroundColor(AppTheme.purple)
                            BulletPoint(text: "'self' (lowercase): Refers to the current INSTANCE of the struct/class.", color: AppTheme.purple)
                            BulletPoint(text: "'Self' (capitalized): Refers to the current TYPE (useful in protocols, static members, or factory inits).", color: AppTheme.purple)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("View Lifecycle")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: watchedProperty) { newValue in
            lifecycleLogs.append("🔔 .onChange triggered! New property value: \(newValue)")
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            lifecycleLogs.append("📱 .onReceive: App will resign active notification received!")
        }
        .sheet(isPresented: $isChildPresented) {
            LifecycleChildModal(onLog: { msg in
                lifecycleLogs.append(msg)
            })
        }
    }

    private func lifecycleRow(name: String, analogy: String, desc: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(name)
                    .font(.headline)
                    .foregroundColor(AppTheme.primary)
                Spacer()
                Text(analogy)
                    .font(.caption2.bold())
                    .padding(4)
                    .background(AppTheme.primary.opacity(0.1))
                    .cornerRadius(4)
            }
            Text(desc)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// Child modal demonstrating onAppear, onDisappear, and .task cancellation
private struct LifecycleChildModal: View {
    @Environment(\.dismiss) private var dismiss
    let onLog: (String) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Lifecycle Inspector Sheet")
                .font(.title3.bold())

            Text("This sheet demonstrates .onAppear, .onDisappear, and .task automatic cancellation on dismissal.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            Button("Dismiss Sheet") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onAppear {
            onLog("🟢 [Child Sheet] .onAppear triggered!")
        }
        .onDisappear {
            onLog("🔴 [Child Sheet] .onDisappear triggered!")
        }
        .task {
            onLog("⏳ [Child Sheet] .task started background work...")
            for i in 1...10 {
                try? await Task.sleep(nanoseconds: 500_000_000)
                if Task.isCancelled {
                    onLog("🛑 [Child Sheet] .task CANCELLED automatically because view disappeared!")
                    return
                }
                onLog("  [Child Sheet] .task step \(i)")
            }
        }
    }
}
