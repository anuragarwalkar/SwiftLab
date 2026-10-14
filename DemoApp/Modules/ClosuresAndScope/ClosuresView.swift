import SwiftUI

// MARK: - Closures: Non-Escaping, Escaping, Autoclosure & Capture Lists

struct ClosuresView: View {
    @State private var logs: [String] = []
    @State private var counter = 10
    @State private var capturedSnapshot = 0
    @State private var isAsyncRunning = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "curlybraces")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.purple)
                        Text("Closures in Depth")
                            .font(.title2.bold())
                    }
                    Text("Self-contained blocks of functionality. Master non-escaping vs @escaping, @autoclosure syntactical sugar, and capture list semantics.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.purple.opacity(0.08))
                .cornerRadius(16)

                // Interactive Closure Execution Lab
                ConceptCard(
                    title: "Live Closures Playground",
                    subtitle: "Test Non-Escaping, Escaping & Autoclosure",
                    icon: "play.fill",
                    iconColor: AppTheme.accent
                ) {
                    VStack(spacing: 12) {
                        HStack(spacing: 10) {
                            Button("Non-Escaping") {
                                executeNonEscaping()
                            }
                            .font(.caption.bold())
                            .buttonStyle(.borderedProminent)

                            Button("Escaping (@escaping)") {
                                executeEscaping()
                            }
                            .font(.caption.bold())
                            .buttonStyle(.borderedProminent)
                            .tint(AppTheme.purple)

                            Button("Autoclosure") {
                                executeAutoclosureDemo()
                            }
                            .font(.caption.bold())
                            .buttonStyle(.borderedProminent)
                            .tint(AppTheme.warning)
                        }

                        InteractiveLogBox(logs: logs, onClear: { logs.removeAll() })
                    }
                }

                // Capture List Value Copy Simulator
                ConceptCard(
                    title: "Capture List Simulator [value]",
                    subtitle: "Value snapshot copy vs dynamic reference",
                    icon: "camera.viewfinder",
                    iconColor: AppTheme.primary
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("A capture list like `[counter]` creates a constant copy at the moment the closure is created. Subsequent mutations to `counter` will NOT change the captured copy.")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        HStack {
                            VStack(alignment: .leading) {
                                Text("Outer Counter: \(counter)")
                                    .font(.headline)
                                Text("Captured Copy: \(capturedSnapshot)")
                                    .font(.subheadline)
                                    .foregroundColor(.purple)
                            }
                            Spacer()
                            Button("+ Increment Counter") {
                                counter += 1
                                logs.append("🔼 Outer counter incremented to \(counter)")
                            }
                            .font(.caption.bold())
                            .buttonStyle(.bordered)
                        }
                        .padding(10)
                        .background(Color(.tertiarySystemGroupedBackground))
                        .cornerRadius(8)

                        HStack(spacing: 10) {
                            Button("Create Closure [counter]") {
                                let snapshotClosure = { [captured = counter] in
                                    captured
                                }
                                capturedSnapshot = snapshotClosure()
                                logs.append("📸 Closure created! Froze counter at \(capturedSnapshot)")
                            }
                            .font(.caption.bold())
                            .buttonStyle(.borderedProminent)

                            Button("Reset Counter") {
                                counter = 10
                                capturedSnapshot = 0
                            }
                            .font(.caption)
                            .buttonStyle(.bordered)
                        }
                    }
                }

                // Theoretical Deep Dive
                ConceptCard(
                    title: "Closure Variants Compared",
                    subtitle: "Memory lifecycle & call rules",
                    icon: "list.bullet.clipboard",
                    iconColor: AppTheme.secondary
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        // Non-escaping
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("1. Non-Escaping Closures (Default)")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.primary)
                                Spacer()
                                Text("Synchronous")
                                    .font(.caption2.bold())
                                    .padding(4)
                                    .background(AppTheme.primary.opacity(0.15))
                                    .cornerRadius(4)
                            }
                            BulletPoint(text: "Default behavior in Swift functions.")
                            BulletPoint(text: "Guaranteed to execute and finish BEFORE the function returns.")
                            BulletPoint(text: "Does NOT outlive the function scope.")
                            BulletPoint(text: "No need for explicit 'self.' capture because retain cycles are impossible.")
                        }

                        Divider()

                        // Escaping
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("2. Escaping Closures (@escaping)")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.purple)
                                Spacer()
                                Text("Outlives Function")
                                    .font(.caption2.bold())
                                    .padding(4)
                                    .background(AppTheme.purple.opacity(0.15))
                                    .cornerRadius(4)
                            }
                            BulletPoint(text: "Must be marked with '@escaping' attribute.", color: AppTheme.purple)
                            BulletPoint(text: "Stored in a property or dispatched asynchronously (e.g. network completion handler).", color: AppTheme.purple)
                            BulletPoint(text: "Executes AFTER the parent function has already returned.", color: AppTheme.purple)
                            BulletPoint(text: "Requires explicit 'self' or capture list '[weak self]' to avoid retain cycles.", color: AppTheme.purple)
                        }

                        Divider()

                        // Autoclosure
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("3. Autoclosure (@autoclosure)")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.warning)
                                Spacer()
                                Text("Syntactic Sugar")
                                    .font(.caption2.bold())
                                    .padding(4)
                                    .background(AppTheme.warning.opacity(0.15))
                                    .cornerRadius(4)
                            }
                            BulletPoint(text: "Automatically wraps an argument expression into a zero-argument closure.", color: AppTheme.warning)
                            BulletPoint(text: "Lets you pass a clean expression () instead of trailing braces {}.", color: AppTheme.warning)
                            BulletPoint(text: "Enables lazy evaluation: the expression is evaluated ONLY if and when called (e.g. assert() or ?? operator).", color: AppTheme.warning)
                        }
                    }
                }

                // Code Comparison
                CodeBlockView(
                    title: "Autoclosure & Escaping Example",
                    code: """
// 1. @autoclosure turns assert(x > 0) into a delayed closure
func customAssert(_ condition: @autoclosure () -> Bool, message: String) {
    if !condition() {
        print("Assertion failed: \\(message)")
    }
}
customAssert(counter > 0, message: "Counter must be positive")

// 2. @escaping closure stored for async response
func fetchProfile(completion: @escaping (String) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
        completion("Success: Profile Loaded")
    }
}
"""
                )
            }
            .padding()
        }
        .navigationTitle("Closures")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Actions
    private func executeNonEscaping() {
        logs.append("▶ Calling non-escaping function...")
        performCalculation(a: 5, b: 10) { result in
            logs.append("  ⚡ Inside non-escaping closure: result = \(result)")
        }
        logs.append("✔ Non-escaping function finished return.")
    }

    private func performCalculation(a: Int, b: Int, operation: (Int) -> Void) {
        operation(a * b)
    }

    private func executeEscaping() {
        logs.append("▶ Calling @escaping async task...")
        isAsyncRunning = true
        performAsyncTask { message in
            DispatchQueue.main.async {
                self.logs.append("  ⚡ Escaping closure executed on background dispatch: \(message)")
                self.isAsyncRunning = false
            }
        }
        logs.append("✔ Escaping caller function already returned, waiting for async trigger...")
    }

    private func performAsyncTask(completion: @escaping (String) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.2) {
            completion("Data fetched from remote API!")
        }
    }

    private func executeAutoclosureDemo() {
        logs.append("▶ Testing @autoclosure delayed evaluation...")
        var evaluated = false

        logIfTrue(shouldLog: false, message: {
            evaluated = true
            return "Expensive calculation ran!"
        }())

        logs.append("  Result when condition false: evaluated = \(evaluated) (Lazy bypass!)")

        logIfTrue(shouldLog: true, message: "Direct string expression automatically wrapped!")
        logs.append("✔ Autoclosure executed successfully.")
    }

    private func logIfTrue(shouldLog: Bool, message: @autoclosure () -> String) {
        if shouldLog {
            logs.append("  ⚡ Evaluated: \(message())")
        }
    }
}
