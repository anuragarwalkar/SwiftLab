import SwiftUI

// MARK: - Defer Statement & Lazy Stored Properties

private class DatabaseSimulator {
    var isOpen = false
    var records: [String] = []

    func openConnection() {
        isOpen = true
    }

    func closeConnection() {
        isOpen = false
    }
}

private class HeavyDataProvider {
    var creationLog: String = ""

    lazy var heavyDatabase: [String] = {
        // Expensive calculation simulation
        return (1...5).map { "Heavy Record #\($0)" }
    }()
}

struct DeferAndLazyView: View {
    @State private var deferLogs: [String] = []
    @State private var isDatabaseOpen = false
    @State private var lazyLoaded = false
    @State private var lazyItems: [String] = []
    private let db = DatabaseSimulator()
    @State private var heavyProvider = HeavyDataProvider()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "arrow.uturn.forward.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.warning)
                        Text("Defer & Lazy Properties")
                            .font(.title2.bold())
                    }
                    Text("Master scope exit guarantees with `defer` and deferred performance optimizations with `lazy var`.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.warning.opacity(0.08))
                .cornerRadius(16)

                // Interactive Defer Simulator
                ConceptCard(
                    title: "Live Defer Execution Simulator",
                    subtitle: "Guaranteed cleanup & LIFO execution order",
                    icon: "shield.lefthalf.filled",
                    iconColor: AppTheme.primary
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("`defer` guarantees that code runs immediately before exiting the scope, regardless of whether the function returns early, throws an error, or completes normally.")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        HStack(spacing: 12) {
                            Button("Simulate DB Operation") {
                                runDatabaseOperation()
                            }
                            .font(.caption.bold())
                            .buttonStyle(.borderedProminent)

                            Button("Simulate Multiple Defers (LIFO)") {
                                testLIFOOrder()
                            }
                            .font(.caption.bold())
                            .buttonStyle(.borderedProminent)
                            .tint(AppTheme.purple)
                        }

                        InteractiveLogBox(logs: deferLogs, onClear: { deferLogs.removeAll() })
                    }
                }

                // Defer Key Points
                ConceptCard(
                    title: "Defer Rules & Best Practices",
                    subtitle: "When and why to use defer",
                    icon: "checklist",
                    iconColor: AppTheme.secondary
                ) {
                    VStack(alignment: .leading, spacing: 8) {
                        BulletPoint(text: "Executes just before the program control transfers outside the current scope { }.")
                        BulletPoint(text: "Ideal for resource cleanup: closing file handles, disconnecting sockets, releasing locks.")
                        BulletPoint(text: "LIFO Execution: If you define multiple defers, the last one defined runs FIRST.")
                        BulletPoint(text: "Does NOT execute if the program crashes or encounters a fatalError.")
                    }
                }

                // Lazy Stored Property Card
                ConceptCard(
                    title: "Lazy Stored Properties (lazy var)",
                    subtitle: "On-demand initialization",
                    icon: "clock.badge.checkmark.fill",
                    iconColor: AppTheme.accent
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("A `lazy` property calculates its initial value only upon the FIRST time it is accessed. Must be declared as a `var`.")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        HStack {
                            Text("State:")
                                .font(.subheadline.bold())
                            Text(lazyLoaded ? "Loaded into Memory" : "Not yet loaded (0 bytes used)")
                                .font(.caption.bold())
                                .foregroundColor(lazyLoaded ? .green : .secondary)
                            Spacer()
                        }
                        .padding(8)
                        .background(Color(.tertiarySystemGroupedBackground))
                        .cornerRadius(8)

                        if lazyLoaded {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Loaded Data:")
                                    .font(.caption.bold())
                                ForEach(lazyItems, id: \.self) { item in
                                    Text("• \(item)")
                                        .font(.caption)
                                        .foregroundColor(AppTheme.primary)
                                }
                            }
                            .padding(8)
                            .background(AppTheme.primary.opacity(0.08))
                            .cornerRadius(8)
                        }

                        HStack(spacing: 12) {
                            Button("Access Lazy Property") {
                                if !lazyLoaded {
                                    // Trigger first access
                                    lazyItems = heavyProvider.heavyDatabase
                                    lazyLoaded = true
                                    deferLogs.append("⚡ First access: Computed and stored lazy var in memory!")
                                }
                            }
                            .font(.caption.bold())
                            .buttonStyle(.borderedProminent)
                            .disabled(lazyLoaded)

                            Button("Reset Provider") {
                                heavyProvider = HeavyDataProvider()
                                lazyLoaded = false
                                lazyItems.removeAll()
                                deferLogs.append("🔄 Re-instantiated provider. Property is back to unloaded state.")
                            }
                            .font(.caption)
                            .buttonStyle(.bordered)
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Key Lazy Facts:")
                                .font(.caption.bold())
                            BulletPoint(text: "Must always be 'var' (constant 'let' must be known before initialization completes).")
                            BulletPoint(text: "NOT thread-safe by default (two threads accessing simultaneously might initialize twice).")
                            BulletPoint(text: "Cannot be used as a computed property or stored in a struct mutating context without mutating keyword.")
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Defer & Lazy")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Simulators
    private func runDatabaseOperation() {
        deferLogs.append("1. [Main Scope] Opening Database connection...")
        db.openConnection()

        defer {
            db.closeConnection()
            deferLogs.append("🔒 [Defer Scope] Guaranteed DB connection closed safely!")
        }

        deferLogs.append("2. [Main Scope] Writing 5 records into DB...")
        db.records.append(contentsOf: ["User1", "User2", "User3"])
        deferLogs.append("3. [Main Scope] Finished processing business logic.")
    }

    private func testLIFOOrder() {
        deferLogs.append("▶ Entering scope with 3 defers...")

        defer {
            deferLogs.append("  [Defer 1] Executed LAST (LIFO #3)")
        }

        defer {
            deferLogs.append("  [Defer 2] Executed SECOND (LIFO #2)")
        }

        defer {
            deferLogs.append("  [Defer 3] Executed FIRST (LIFO #1)")
        }

        deferLogs.append("⚡ Exiting scope now...")
    }
}
