import SwiftUI

// MARK: - Memory Management & Retain Cycle Simulator

// Simulation Classes
private class SimulationPerson {
    let name: String
    var apartmentStrong: SimulationApartment?
    weak var apartmentWeak: SimulationApartment?
    unowned var apartmentUnowned: SimulationApartment?

    var onDeinit: ((String) -> Void)?

    init(name: String, onDeinit: ((String) -> Void)? = nil) {
        self.name = name
        self.onDeinit = onDeinit
    }

    deinit {
        onDeinit?("🗑️ Person '\(name)' deallocated from Heap!")
    }
}

private class SimulationApartment {
    let unit: String
    var tenantStrong: SimulationPerson?
    weak var tenantWeak: SimulationPerson?
    var onDeinit: ((String) -> Void)?

    init(unit: String, onDeinit: ((String) -> Void)? = nil) {
        self.unit = unit
        self.onDeinit = onDeinit
    }

    deinit {
        onDeinit?("🗑️ Apartment '\(unit)' deallocated from Heap!")
    }
}

struct MemoryManagementView: View {
    @State private var logs: [String] = []
    @State private var referenceTypeSelected = 0 // 0: Strong-Strong (Leak), 1: Strong-Weak (Safe), 2: Strong-Unowned
    @State private var activePerson: SimulationPerson?
    @State private var activeApartment: SimulationApartment?
    @State private var retainCycleDetected = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Banner
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "memorychip")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.primary)
                        Text("ARC & Memory Management")
                            .font(.title2.bold())
                    }
                    Text("Automatic Reference Counting (ARC) manages memory in Swift. Understand strong, weak, and unowned references to prevent memory leaks and retain cycles.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.primary.opacity(0.08))
                .cornerRadius(16)

                // Interactive Simulator Card
                ConceptCard(
                    title: "Live Retain Cycle Simulator",
                    subtitle: "Simulate Person & Apartment reference binding",
                    icon: "play.circle.fill",
                    iconColor: AppTheme.accent
                ) {
                    VStack(spacing: 14) {
                        Picker("Reference Mode", selection: $referenceTypeSelected) {
                            Text("Strong-Strong (Leak)").tag(0)
                            Text("Strong-Weak (Safe)").tag(1)
                            Text("Strong-Unowned").tag(2)
                        }
                        .pickerStyle(.segmented)

                        HStack(spacing: 12) {
                            VStack(spacing: 6) {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(activePerson != nil ? AppTheme.primary : .gray)
                                Text("Person Object")
                                    .font(.caption.bold())
                                Text(activePerson != nil ? "In Memory" : "Nil")
                                    .font(.caption2)
                                    .foregroundColor(activePerson != nil ? .green : .secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(Color(.tertiarySystemGroupedBackground))
                            .cornerRadius(10)

                            Image(systemName: referenceTypeSelected == 0 ? "arrow.left.arrow.right" : "arrow.right")
                                .foregroundColor(referenceTypeSelected == 0 ? AppTheme.error : AppTheme.success)
                                .font(.title3.bold())

                            VStack(spacing: 6) {
                                Image(systemName: "building.2.crop.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(activeApartment != nil ? AppTheme.purple : .gray)
                                Text("Apartment Object")
                                    .font(.caption.bold())
                                Text(activeApartment != nil ? "In Memory" : "Nil")
                                    .font(.caption2)
                                    .foregroundColor(activeApartment != nil ? .green : .secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(Color(.tertiarySystemGroupedBackground))
                            .cornerRadius(10)
                        }

                        if retainCycleDetected {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                Text("Memory Leak Alert: Both objects still in Heap after scope release!")
                                    .font(.caption.bold())
                                    .foregroundColor(.orange)
                            }
                            .padding(8)
                            .background(Color.orange.opacity(0.12))
                            .cornerRadius(8)
                        }

                        HStack(spacing: 12) {
                            Button(action: allocateObjects) {
                                Label("1. Allocate & Bind", systemImage: "plus.circle.fill")
                                    .font(.subheadline.bold())
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(AppTheme.primary)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }

                            Button(action: releaseScope) {
                                Label("2. Release Scope", systemImage: "xmark.circle.fill")
                                    .font(.subheadline.bold())
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(AppTheme.error)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }

                        InteractiveLogBox(logs: logs, onClear: {
                            logs.removeAll()
                            retainCycleDetected = false
                        })
                    }
                }

                // Reference Types Comparison
                ConceptCard(
                    title: "Reference Types Breakdown",
                    subtitle: "Strong vs Weak vs Unowned",
                    icon: "list.bullet.rectangle",
                    iconColor: AppTheme.secondary
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Strong Reference")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.primary)
                                Spacer()
                                Text("Increases Retain Count")
                                    .font(.caption2.bold())
                                    .padding(4)
                                    .background(AppTheme.primary.opacity(0.15))
                                    .cornerRadius(4)
                            }
                            BulletPoint(text: "Default reference type in Swift.")
                            BulletPoint(text: "Increases the object's retain count by +1.")
                            BulletPoint(text: "Keeps the object in memory as long as the pointer exists.")
                            BulletPoint(text: "When 2 objects hold strong references to each other = Retain Cycle & Memory Leak!")
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Weak Reference")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.success)
                                Spacer()
                                Text("Optional • Zeroing")
                                    .font(.caption2.bold())
                                    .padding(4)
                                    .background(AppTheme.success.opacity(0.15))
                                    .cornerRadius(4)
                            }
                            BulletPoint(text: "Does NOT increase retain count (reference count remains unchanged).", color: AppTheme.success)
                            BulletPoint(text: "Must always be declared as Optional var (e.g., weak var delegate: MyDelegate?).", color: AppTheme.success)
                            BulletPoint(text: "Automatically zeroed (set to nil) as soon as the target object is deallocated.", color: AppTheme.success)
                            BulletPoint(text: "Prevents retain cycles in parent-child relationships and delegates.", color: AppTheme.success)
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Unowned Reference")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.warning)
                                Spacer()
                                Text("Non-Optional • Danger on nil")
                                    .font(.caption2.bold())
                                    .padding(4)
                                    .background(AppTheme.warning.opacity(0.15))
                                    .cornerRadius(4)
                            }
                            BulletPoint(text: "Does NOT increase retain count.", color: AppTheme.warning)
                            BulletPoint(text: "Expected to NEVER be nil while accessed.", color: AppTheme.warning)
                            BulletPoint(text: "Does NOT zero out: reading an unowned variable after target deallocates causes a fatal runtime crash!", color: AppTheme.error)
                            BulletPoint(text: "Use ONLY when sure the child's lifetime is <= parent's lifetime (e.g. CreditCard and Customer).", color: AppTheme.warning)
                        }
                    }
                }

                // Code Example
                CodeBlockView(
                    title: "Swift Retain Cycle & Solution",
                    code: """
// ❌ Retain Cycle (Memory Leak)
class Person {
    var apartment: Apartment? // Strong
    deinit { print("Person deallocated") }
}

class Apartment {
    var tenant: Person? // Strong -> Cycle!
    deinit { print("Apartment deallocated") }
}

// ✅ Solution: Break cycle with weak or unowned
class ApartmentFixed {
    weak var tenant: Person? // Weak reference breaks cycle
    deinit { print("Apartment deallocated safely!") }
}
"""
                )
            }
            .padding()
        }
        .navigationTitle("Memory & ARC")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func allocateObjects() {
        retainCycleDetected = false
        let logDealloc: (String) -> Void = { msg in
            DispatchQueue.main.async {
                self.logs.append(msg)
            }
        }

        let person = SimulationPerson(name: "Anurag", onDeinit: logDealloc)
        let apartment = SimulationApartment(unit: "Penthouse 404", onDeinit: logDealloc)

        logs.append("✨ Allocated Person ('Anurag') - Retain count +1")
        logs.append("✨ Allocated Apartment ('Penthouse 404') - Retain count +1")

        switch referenceTypeSelected {
        case 0:
            // Strong-Strong
            person.apartmentStrong = apartment
            apartment.tenantStrong = person
            logs.append("🔗 Linked Strong <-> Strong: Retain cycles formed!")
        case 1:
            // Strong-Weak
            person.apartmentStrong = apartment
            apartment.tenantWeak = person
            logs.append("🔗 Linked Strong -> Weak: Safe weak back-pointer!")
        case 2:
            // Strong-Unowned
            person.apartmentStrong = apartment
            person.apartmentUnowned = apartment
            logs.append("🔗 Linked Strong -> Unowned: Assuming child lifespan <= parent!")
        default:
            break
        }

        activePerson = person
        activeApartment = apartment
    }

    private func releaseScope() {
        if activePerson == nil && activeApartment == nil {
            logs.append("⚠️ No active objects to release.")
            return
        }

        logs.append("🚪 Releasing local scope variables (setting references to nil)...")
        activePerson = nil
        activeApartment = nil

        if referenceTypeSelected == 0 {
            // Strong-Strong retains each other in memory
            retainCycleDetected = true
            logs.append("🚨 LEAK: Neither deinit was called! Objects still trapped in Heap memory.")
        } else {
            retainCycleDetected = false
            logs.append("✅ Both objects deallocated cleanly!")
        }
    }
}
