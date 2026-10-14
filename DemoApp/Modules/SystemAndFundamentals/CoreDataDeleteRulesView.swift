import SwiftUI

// MARK: - Core Data Delete Rules (Nullify, Cascade, Deny, No Action)

enum CoreDataDeleteRule: String, CaseIterable, Identifiable {
    case nullify = "Nullify"
    case cascade = "Cascade"
    case deny = "Deny"
    case noAction = "No Action"

    var id: String { rawValue }

    var summary: String {
        switch self {
        case .nullify: return "Sets destination relationship to nil (default rule)."
        case .cascade: return "Deletes related destination records along with parent."
        case .deny: return "Prevents deletion if any related records exist."
        case .noAction: return "Does nothing; leaves dangling reference to be handled manually."
        }
    }
}

struct CoreDataDeleteRulesView: View {
    @State private var selectedRule: CoreDataDeleteRule = .cascade
    @State private var departmentExists = true
    @State private var employees = ["Alice", "Bob", "Charlie"]
    @State private var employeesDepartmentPointer: String? = "Engineering"
    @State private var simulationLogs: [String] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "cylinder.split.1x2.fill")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.primary)
                        Text("Core Data Delete Rules")
                            .font(.title2.bold())
                    }
                    Text("Learn how relationships in Core Data react when a parent object is deleted: Nullify, Cascade, Deny, and No Action.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.primary.opacity(0.08))
                .cornerRadius(16)

                // Interactive Delete Simulator
                ConceptCard(
                    title: "Live Deletion Simulator",
                    subtitle: "Delete Department (Engineering) under selected rule",
                    icon: "trash.circle.fill",
                    iconColor: AppTheme.error
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        Picker("Delete Rule", selection: $selectedRule) {
                            ForEach(CoreDataDeleteRule.allCases) { rule in
                                Text(rule.rawValue).tag(rule)
                            }
                        }
                        .pickerStyle(.segmented)

                        Text("Rule Description: \(selectedRule.summary)")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        // Visual Relationship Diagram
                        HStack(spacing: 12) {
                            // Department Card
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Department (Source)")
                                    .font(.caption.bold())
                                    .foregroundColor(.secondary)
                                if departmentExists {
                                    Text("🏢 Engineering")
                                        .font(.subheadline.bold())
                                        .foregroundColor(AppTheme.primary)
                                    Text("Status: Active in DB")
                                        .font(.system(size: 10))
                                        .foregroundColor(.green)
                                } else {
                                    Text("❌ Deleted")
                                        .font(.subheadline.bold())
                                        .foregroundColor(.red)
                                    Text("Status: Removed from DB")
                                        .font(.system(size: 10))
                                        .foregroundColor(.secondary)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                            .background(Color(.tertiarySystemGroupedBackground))
                            .cornerRadius(8)

                            Image(systemName: "arrow.right")
                                .foregroundColor(.secondary)

                            // Employees Card
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Employees (Destination)")
                                    .font(.caption.bold())
                                    .foregroundColor(.secondary)
                                if employees.isEmpty {
                                    Text("🗑️ Deleted (Cascaded)")
                                        .font(.caption.bold())
                                        .foregroundColor(.red)
                                } else {
                                    ForEach(employees, id: \.self) { emp in
                                        HStack {
                                            Text("👤 \(emp)")
                                                .font(.caption.bold())
                                            Spacer()
                                            Text(employeesDepartmentPointer ?? "nil")
                                                .font(.system(size: 9, design: .monospaced))
                                                .foregroundColor(employeesDepartmentPointer == nil ? .orange : .blue)
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                            .background(Color(.tertiarySystemGroupedBackground))
                            .cornerRadius(8)
                        }

                        HStack(spacing: 12) {
                            Button("Delete Department") {
                                executeDelete()
                            }
                            .font(.caption.bold())
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                            .disabled(!departmentExists)

                            Button("Reset Data") {
                                resetSimulation()
                            }
                            .font(.caption)
                            .buttonStyle(.bordered)
                        }

                        InteractiveLogBox(logs: simulationLogs, onClear: { simulationLogs.removeAll() })
                    }
                }

                // Detailed Rules Breakdown
                ConceptCard(
                    title: "The 4 Delete Rules Explained",
                    subtitle: "Core Data Relationship Configurations",
                    icon: "list.number",
                    iconColor: AppTheme.secondary
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        ruleRow(
                            name: "1. Nullify (Default)",
                            color: .blue,
                            text: "Sets the relationship pointer to nil on destination objects. The destination objects (Employees) remain alive in the database, but their department reference becomes null."
                        )

                        Divider()

                        ruleRow(
                            name: "2. Cascade",
                            color: .red,
                            text: "Automatically deletes all destination objects when the parent object is deleted. If you delete Department, all its Employees are deleted as well. Use carefully!"
                        )

                        Divider()

                        ruleRow(
                            name: "3. Deny",
                            color: .orange,
                            text: "Refuses to delete the source object if ANY destination object exists. Deleting Department throws a validation error unless all Employees are first reassigned or manually deleted."
                        )

                        Divider()

                        ruleRow(
                            name: "4. No Action",
                            color: .purple,
                            text: "Core Data takes no action whatsoever. Destination objects still point to the deleted object in memory/DB, creating dangling pointers and data corruption unless cleaned up manually by code."
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Core Data Delete Rules")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func ruleRow(name: String, color: Color, text: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .font(.headline)
                .foregroundColor(color)
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private func executeDelete() {
        switch selectedRule {
        case .nullify:
            departmentExists = false
            employeesDepartmentPointer = nil
            simulationLogs.append("🗑️ [Nullify Rule] Department deleted from store.")
            simulationLogs.append("ℹ️ Destination employees preserved! Their 'department' property was set to nil.")

        case .cascade:
            departmentExists = false
            employees.removeAll()
            employeesDepartmentPointer = nil
            simulationLogs.append("🗑️ [Cascade Rule] Department deleted from store.")
            simulationLogs.append("💥 CASCADE TRIGGERED: All 3 related employees deleted automatically!")

        case .deny:
            simulationLogs.append("🚫 [Deny Rule] CoreData validation rejected save!")
            simulationLogs.append("❌ Error: Department has active related Employees. Deletion is DENIED.")

        case .noAction:
            departmentExists = false
            // Pointer stays as 'Engineering' even though parent is gone!
            simulationLogs.append("⚠️ [No Action Rule] Department deleted, but CoreData did not update destination pointers.")
            simulationLogs.append("🚨 DANGER: Employees still hold dangling pointer to deleted Department ID!")
        }
    }

    private func resetSimulation() {
        departmentExists = true
        employees = ["Alice", "Bob", "Charlie"]
        employeesDepartmentPointer = "Engineering"
        simulationLogs.append("🔄 Reset database: Department 'Engineering' restored with 3 employees.")
    }
}
