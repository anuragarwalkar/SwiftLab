import SwiftUI

// MARK: - Struct vs Class vs Actor & Copy-on-Write

// Sample Class
private class VehicleClass {
    var brand: String
    init(brand: String) { self.brand = brand }
}

// Sample Struct
private struct VehicleStruct {
    var brand: String
}

// Sample Actor
private actor BankAccountActor {
    private(set) var balance: Double = 1000.0

    func deposit(amount: Double) {
        balance += amount
    }

    func withdraw(amount: Double) -> Bool {
        guard balance >= amount else { return false }
        balance -= amount
        return true
    }
}

struct ClassStructActorView: View {
    // COW & Mutation State
    @State private var originalArray = [10, 20, 30]
    @State private var copiedArray = [10, 20, 30]
    @State private var originalAddress = ""
    @State private var copiedAddress = ""
    @State private var cowStatus = "Unmodified: Sharing same backing buffer!"

    // Actor Balance Simulator
    @State private var actorBalance: Double = 1000.0
    @State private var isProcessingActor = false
    private let bankActor = BankAccountActor()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "square.stack.3d.up.fill")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.secondary)
                        Text("Struct vs Class vs Actor")
                            .font(.title2.bold())
                    }
                    Text("Swift's foundational type paradigms: Value Types (Struct), Reference Types (Class), and Data-Isolated Reference Types (Actor), plus Copy-on-Write (COW).")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.secondary.opacity(0.08))
                .cornerRadius(16)

                // Live Copy-on-Write Inspector
                ConceptCard(
                    title: "Live Copy-on-Write (COW) Inspector",
                    subtitle: "Inspect actual memory buffer pointers",
                    icon: "doc.on.doc.fill",
                    iconColor: AppTheme.accent
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("In Swift, collections like Array share the exact same underlying buffer until one is mutated. Upon mutation, a unique copy is made.")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        VStack(spacing: 8) {
                            HStack {
                                Text("Array A:")
                                    .font(.caption.bold())
                                Text("\(originalArray.description)")
                                    .font(.system(size: 11, design: .monospaced))
                                Spacer()
                                Text(originalAddress.isEmpty ? "Tap Inspect" : originalAddress)
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundColor(.secondary)
                            }

                            HStack {
                                Text("Array B (Copied):")
                                    .font(.caption.bold())
                                Text("\(copiedArray.description)")
                                    .font(.system(size: 11, design: .monospaced))
                                Spacer()
                                Text(copiedAddress.isEmpty ? "Tap Inspect" : copiedAddress)
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(10)
                        .background(Color(.tertiarySystemGroupedBackground))
                        .cornerRadius(8)

                        Text("Status: \(cowStatus)")
                            .font(.caption.bold())
                            .foregroundColor(originalAddress == copiedAddress && !originalAddress.isEmpty ? .green : .orange)

                        HStack(spacing: 10) {
                            Button("1. Inspect Addresses") {
                                inspectCOW()
                            }
                            .font(.caption.bold())
                            .buttonStyle(.borderedProminent)

                            Button("2. Mutate Array B") {
                                copiedArray.append(Int.random(in: 40...99))
                                inspectCOW()
                            }
                            .font(.caption.bold())
                            .buttonStyle(.bordered)
                            .tint(AppTheme.warning)

                            Button("Reset") {
                                originalArray = [10, 20, 30]
                                copiedArray = originalArray
                                originalAddress = ""
                                copiedAddress = ""
                                cowStatus = "Reset to fresh copies."
                            }
                            .font(.caption)
                            .buttonStyle(.bordered)
                        }
                    }
                }

                // 3-Way Comparison Table
                ConceptCard(
                    title: "Deep Comparison Matrix",
                    subtitle: "Memory, semantics & thread safety",
                    icon: "tablecells.fill",
                    iconColor: AppTheme.primary
                ) {
                    VStack(spacing: 12) {
                        // Struct Card
                        VStack(alignment: .leading, spacing: 6) {
                            Text("1. Struct (Value Type)")
                                .font(.headline)
                                .foregroundColor(AppTheme.primary)
                            BulletPoint(text: "Memory: Stored on the Stack (extremely fast allocation/deallocation).")
                            BulletPoint(text: "Semantics: Copied on assignment; each copy is completely independent.")
                            BulletPoint(text: "Initializers: Automatically gets memberwise initializer.")
                            BulletPoint(text: "Inheritance: NO inheritance (uses Protocols and Composition).")
                            BulletPoint(text: "Weak: 'weak' CANNOT be used on structs (only class references).")
                            BulletPoint(text: "Safety: Cannot create retain cycles or circular references.")
                            BulletPoint(text: "Thread safety: Safe by value isolation (passing copies).")
                        }

                        Divider()

                        // Class Card
                        VStack(alignment: .leading, spacing: 6) {
                            Text("2. Class (Reference Type)")
                                .font(.headline)
                                .foregroundColor(AppTheme.secondary)
                            BulletPoint(text: "Memory: Stored on the Heap (pointer on stack points to heap object).")
                            BulletPoint(text: "Semantics: References point to the same shared memory instance.")
                            BulletPoint(text: "Inheritance: Full single inheritance and method overriding supported.")
                            BulletPoint(text: "Lifecycle: Has deinit { } when retain count reaches 0.")
                            BulletPoint(text: "Weak & Unowned: Applied to break retain cycles.")
                            BulletPoint(text: "Concurrency: Requires manual synchronization (Locks, Queues) to prevent data races.")
                        }

                        Divider()

                        // Actor Card
                        VStack(alignment: .leading, spacing: 6) {
                            Text("3. Actor (Data-Isolated Reference)")
                                .font(.headline)
                                .foregroundColor(AppTheme.accent)
                            BulletPoint(text: "Reference type (lives on the Heap, passed by reference).", color: AppTheme.accent)
                            BulletPoint(text: "Built-in Thread Safety: Guarantees mutually exclusive access to mutable state.", color: AppTheme.accent)
                            BulletPoint(text: "No Inheritance (like structs, but conforms to protocols).", color: AppTheme.accent)
                            BulletPoint(text: "Access rule: External calls to mutable state must use 'await' keyword.", color: AppTheme.accent)
                        }
                    }
                }

                // Actor Interactive Demo
                ConceptCard(
                    title: "Actor Thread Safety in Action",
                    subtitle: "Safe concurrent mutations without race conditions",
                    icon: "shield.checkered",
                    iconColor: AppTheme.success
                ) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Protected Balance:")
                                .font(.subheadline)
                            Spacer()
                            Text("$\(String(format: "%.2f", actorBalance))")
                                .font(.title3.bold())
                                .foregroundColor(.green)
                        }

                        HStack(spacing: 12) {
                            Button("Deposit $100 (Async)") {
                                Task {
                                    await bankActor.deposit(amount: 100)
                                    let newBal = await bankActor.balance
                                    await MainActor.run {
                                        actorBalance = newBal
                                    }
                                }
                            }
                            .font(.caption.bold())
                            .buttonStyle(.borderedProminent)

                            Button("Withdraw $50 (Async)") {
                                Task {
                                    _ = await bankActor.withdraw(amount: 50)
                                    let newBal = await bankActor.balance
                                    await MainActor.run {
                                        actorBalance = newBal
                                    }
                                }
                            }
                            .font(.caption.bold())
                            .buttonStyle(.bordered)
                            .tint(.red)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Struct, Class & Actor")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            inspectCOW()
        }
    }

    private func inspectCOW() {
        let addr1 = originalArray.withUnsafeBufferPointer { buffer in
            String(format: "%p", buffer.baseAddress ?? 0)
        }
        let addr2 = copiedArray.withUnsafeBufferPointer { buffer in
            String(format: "%p", buffer.baseAddress ?? 0)
        }

        originalAddress = "Buf: " + addr1
        copiedAddress = "Buf: " + addr2

        if addr1 == addr2 {
            cowStatus = "🟢 Same address! Sharing memory without duplicating data."
        } else {
            cowStatus = "🟠 Mutated! New independent memory buffer created (COW in action)."
        }
    }
}
