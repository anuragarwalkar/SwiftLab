import SwiftUI

// MARK: - Grand Central Dispatch (GCD) & Modern Swift Concurrency

struct ConcurrencyView: View {
    @State private var logs: [String] = []
    @State private var taskProgress: Double = 0.0
    @State private var currentRunningTask: Task<Void, Never>?
    @State private var isTaskRunning = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.warning)
                        Text("Concurrency: GCD & Async/Await")
                            .font(.title2.bold())
                    }
                    Text("Master asynchronous execution in iOS: from traditional Grand Central Dispatch (GCD) to modern Swift Concurrency (async/await, Task, @MainActor).")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.warning.opacity(0.08))
                .cornerRadius(16)

                // Interactive Concurrency Lab
                ConceptCard(
                    title: "Live Concurrency Lab",
                    subtitle: "Test GCD Async, Global Background & Task Cancellation",
                    icon: "play.circle.fill",
                    iconColor: AppTheme.accent
                ) {
                    VStack(spacing: 12) {
                        HStack(spacing: 10) {
                            Button("GCD Async") {
                                runGCDAsync()
                            }
                            .font(.caption.bold())
                            .buttonStyle(.borderedProminent)

                            Button("Async/Await Task") {
                                runSwiftTask()
                            }
                            .font(.caption.bold())
                            .buttonStyle(.borderedProminent)
                            .tint(AppTheme.purple)

                            Button("Cancel Task") {
                                currentRunningTask?.cancel()
                                logs.append("🛑 Task cancellation requested!")
                            }
                            .font(.caption.bold())
                            .buttonStyle(.bordered)
                            .tint(.red)
                            .disabled(!isTaskRunning)
                        }

                        if isTaskRunning {
                            ProgressView(value: taskProgress, total: 1.0)
                                .accentColor(AppTheme.purple)
                        }

                        InteractiveLogBox(logs: logs, onClear: { logs.removeAll() })
                    }
                }

                // Deadlock Warning Alert Card
                ConceptCard(
                    title: "🚨 The Famous GCD Deadlock Trap",
                    subtitle: "Why calling DispatchQueue.main.sync freezes the app",
                    icon: "exclamationmark.octagon.fill",
                    iconColor: AppTheme.error
                ) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("If you are currently on the Main Thread and you call `DispatchQueue.main.sync { ... }`, your app will INSTANTLY DEADLOCK and crash!")
                            .font(.subheadline.bold())
                            .foregroundColor(AppTheme.error)

                        BulletPoint(text: "Why? 'sync' blocks the current thread until the closure finishes.", color: AppTheme.error)
                        BulletPoint(text: "The main queue cannot start executing the closure because the main thread is blocked waiting for it to finish!", color: AppTheme.error)
                        BulletPoint(text: "Result: Mutual infinite block = Deadlock.", color: AppTheme.error)

                        CodeBlockView(
                            title: "❌ Instant Deadlock",
                            code: """
// Running on Main Thread:
DispatchQueue.main.sync {
    // 💥 DEADLOCK! Main thread is paused waiting for this,
    // but this block cannot run until main thread unpauses!
}
"""
                        )
                    }
                }

                // GCD vs Modern Concurrency Matrix
                ConceptCard(
                    title: "Modern Concurrency: async/await/Task",
                    subtitle: "Introduced in Swift 5.5",
                    icon: "bolt.fill",
                    iconColor: AppTheme.primary
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("1. async")
                                .font(.headline)
                                .foregroundColor(AppTheme.primary)
                            BulletPoint(text: "Declares a function as asynchronous, signaling it may suspend.")
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 4) {
                            Text("2. await")
                                .font(.headline)
                                .foregroundColor(AppTheme.secondary)
                            BulletPoint(text: "Suspension point! Gives up the thread so other work can proceed, resuming when done without blocking the CPU thread.")
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 4) {
                            Text("3. @MainActor")
                                .font(.headline)
                                .foregroundColor(AppTheme.accent)
                            BulletPoint(text: "A global actor that synchronizes execution to the main thread. Indispensable for updating SwiftUI UI state.")
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 4) {
                            Text("4. Task")
                                .font(.headline)
                                .foregroundColor(AppTheme.purple)
                            BulletPoint(text: "Bridges synchronous code to asynchronous execution.")
                            BulletPoint(text: "Inherits priority and actor context by default.")
                            BulletPoint(text: "Supports cooperative cancellation (Task.isCancelled).")
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Concurrency & GCD")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Simulators
    private func runGCDAsync() {
        logs.append("▶ [Main Thread] Triggering GCD Background Dispatch...")

        DispatchQueue.global(qos: .userInitiated).async {
            // Background heavy work
            let threadName = Thread.isMainThread ? "Main" : "Background"
            DispatchQueue.main.async {
                self.logs.append("  ⚙️ [\(threadName) Thread] Processing heavy computation in background...")
            }

            Thread.sleep(forTimeInterval: 0.8)

            DispatchQueue.main.async {
                self.logs.append("  ✔ [Main Thread] Switched back to main queue to safely update UI!")
            }
        }

        logs.append("✔ [Main Thread] Main thread continued immediately without freezing UI.")
    }

    private func runSwiftTask() {
        logs.append("▶ [Task] Launching Swift 5.5 Structured Task...")
        isTaskRunning = true
        taskProgress = 0.0

        currentRunningTask = Task {
            for step in 1...5 {
                try? await Task.sleep(nanoseconds: 300_000_000)

                if Task.isCancelled {
                    await MainActor.run {
                        self.logs.append("❌ Task was cancelled at step \(step)!")
                        self.isTaskRunning = false
                    }
                    return
                }

                await MainActor.run {
                    self.taskProgress = Double(step) / 5.0
                    self.logs.append("  ⏳ Task step \(step)/5 completed (Progress: \(Int(self.taskProgress * 100))%)")
                }
            }

            await MainActor.run {
                self.logs.append("✔ [Task] Finished asynchronously on MainActor!")
                self.isTaskRunning = false
            }
        }
    }
}
