import SwiftUI

// MARK: - Initializers, Optionals, Access Specifiers & Swift Type System

// Sample Classes for Initializers demonstration
private class Vehicle {
    let name: String
    let wheels: Int

    // Designated Initializer
    init(name: String, wheels: Int) {
        self.name = name
        self.wheels = wheels
    }

    // Convenience Initializer
    convenience init(name: String) {
        self.init(name: name, wheels: 4) // Calls designated initializer
    }

    // Failable Initializer
    init?(name: String, wheels: Int, valid: Bool) {
        guard valid && wheels > 0 else { return nil }
        self.name = name
        self.wheels = wheels
    }
}

// Equatable, Comparable, Hashable Model
private struct Developer: Equatable, Comparable, Hashable {
    let id: Int
    let name: String
    let yearsOfExperience: Int

    // Equatable
    static func == (lhs: Developer, rhs: Developer) -> Bool {
        lhs.id == rhs.id
    }

    // Comparable
    static func < (lhs: Developer, rhs: Developer) -> Bool {
        lhs.yearsOfExperience < rhs.yearsOfExperience
    }

    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}

// Protocol with associatedtype
private protocol StorageRepository {
    associatedtype Item
    func save(item: Item)
    func fetch() -> Item?
}

struct TypeSystemAndInitView: View {
    @State private var initLogs: [String] = []
    @State private var selectedTab = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "slider.horizontal.3")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.primary)
                        Text("Type System & Initializers")
                            .font(.title2.bold())
                    }
                    Text("Swift initializers (Designated, Convenience, Failable), Optionals (.some vs .none), Access Specifiers, Any vs AnyObject vs any vs some, and Protocols.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.primary.opacity(0.08))
                .cornerRadius(16)

                // Category Tabs
                Picker("Sub-Topic", selection: $selectedTab) {
                    Text("Initializers").tag(0)
                    Text("Access Specifiers").tag(1)
                    Text("Any vs some").tag(2)
                    Text("Protocols & Traits").tag(3)
                }
                .pickerStyle(.segmented)

                switch selectedTab {
                case 0:
                    initializersAndOptionalsSection
                case 1:
                    accessSpecifiersSection
                case 2:
                    typeKeywordsSection
                case 3:
                    protocolsAndTraitsSection
                default:
                    EmptyView()
                }
            }
            .padding()
        }
        .navigationTitle("Types & Initializers")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Initializers & Optionals
    @ViewBuilder
    private var initializersAndOptionalsSection: some View {
        ConceptCard(
            title: "Swift Initializers Hierarchy",
            subtitle: "Designated, Convenience, Failable, Required & Default",
            icon: "shippingbox.fill",
            iconColor: AppTheme.primary
        ) {
            VStack(alignment: .leading, spacing: 12) {
                initRuleRow(
                    name: "1. Designated Initializer",
                    desc: "Primary initializer for a class. Must initialize all stored properties introduced by that class and call a superclass designated initializer."
                )

                Divider()

                initRuleRow(
                    name: "2. Convenience Initializer",
                    desc: "Secondary supporting initializer marked with 'convenience'. Must call another initializer in the SAME class, ultimately delegating to a designated init (e.g. providing defaults)."
                )

                Divider()

                initRuleRow(
                    name: "3. Failable Initializer (init?)",
                    desc: "Can return nil if preconditions fail. Pre-check validation: guard age >= 0 else { return nil }."
                )

                Divider()

                initRuleRow(
                    name: "4. Required Initializer (required init)",
                    desc: "Must be implemented by every subclass. Enforced by compiler (e.g. required init?(coder:) in UIKit)."
                )

                Divider()

                initRuleRow(
                    name: "5. Default Memberwise Init",
                    desc: "Automatically synthesized for Structs if no custom initializer is written."
                )
            }
        }

        ConceptCard(
            title: "Optionals (? vs ! & enum representation)",
            subtitle: "Optional.some(Wrapped) vs Optional.none",
            icon: "questionmark.square.dashed",
            iconColor: AppTheme.accent
        ) {
            VStack(alignment: .leading, spacing: 10) {
                BulletPoint(text: "Under the hood, an Optional is an enum with two cases: .none (nil) and .some(Wrapped).")
                BulletPoint(text: "Optional (?) requires safe unwrapping (if let, guard let, nil-coalescing ??).")
                BulletPoint(text: "Implicitly Unwrapped Optional (!) always assumes a value exists; reading nil causes a runtime crash!")
                BulletPoint(text: "Even when an optional is nil, it has a concrete type in memory and memory allocation for the enum wrapper.")

                CodeBlockView(
                    title: "Swift Optional Enum Representation",
                    code: """
// Swift standard library definition:
enum Optional<Wrapped> {
    case none
    case some(Wrapped)
}

let name: String? = "Anurag"
switch name {
case .some(let value): print("Found: \\(value)")
case .none: print("Nil")
}
"""
                )
            }
        }
    }

    // MARK: - Access Specifiers
    @ViewBuilder
    private var accessSpecifiersSection: some View {
        ConceptCard(
            title: "Access Specifiers in Swift",
            subtitle: "From most restrictive to most permissive",
            icon: "lock.rectangle.on.rectangle.fill",
            iconColor: AppTheme.purple
        ) {
            VStack(spacing: 12) {
                accessRow(
                    keyword: "private",
                    scope: "Enclosing Declaration & Extensions",
                    desc: "Restricted to the enclosing type declaration and its extensions within the SAME file.",
                    color: .red
                )

                accessRow(
                    keyword: "fileprivate",
                    scope: "Same Source File",
                    desc: "Accessible from any code within the same .swift source file, but hidden outside the file.",
                    color: .orange
                )

                accessRow(
                    keyword: "internal",
                    scope: "Same Module (Default)",
                    desc: "Default access level. Accessible from anywhere within the same framework / target / module.",
                    color: .blue
                )

                accessRow(
                    keyword: "public",
                    scope: "Outside Module (No Subclassing)",
                    desc: "Accessible from other modules importing the framework, but CANNOT be subclassed or overridden outside.",
                    color: .green
                )

                accessRow(
                    keyword: "open",
                    scope: "Outside Module (Subclassable)",
                    desc: "Most permissive. Accessible outside module AND can be subclassed / overridden by external modules.",
                    color: .purple
                )
            }
        }

        ConceptCard(
            title: "class vs static vs final",
            subtitle: "Method overriding rules",
            icon: "arrow.triangle.capsulepath",
            iconColor: AppTheme.secondary
        ) {
            VStack(alignment: .leading, spacing: 10) {
                BulletPoint(text: "class func: Type-level method in classes that CAN be overridden by subclasses.")
                BulletPoint(text: "static func: Type-level method that CANNOT be overridden. In classes, it is equivalent to 'final class func'.")
                BulletPoint(text: "final: Prevents a class from being inherited or a method/property from being overridden.")
            }
        }
    }

    // MARK: - Any vs AnyObject vs any vs some
    @ViewBuilder
    private var typeKeywordsSection: some View {
        ConceptCard(
            title: "Any vs AnyObject vs any vs some",
            subtitle: "Existential containers vs Opaque types",
            icon: "circle.grid.cross.fill",
            iconColor: AppTheme.accent
        ) {
            VStack(alignment: .leading, spacing: 14) {
                typeRow(
                    name: "Any",
                    summary: "Can represent an instance of ANY type at all, including function types, structs, enums, optionals, and classes."
                )

                Divider()

                typeRow(
                    name: "AnyObject",
                    summary: "Can represent an instance of any CLASS type only (reference types). Used in class-bound protocols: protocol MyDelegate: AnyObject {}."
                )

                Divider()

                typeRow(
                    name: "any Protocol (Existential Box)",
                    summary: "Swift 5.6+ syntax for an existential type container. Holds any type conforming to the protocol dynamically at runtime. Has slight boxing overhead."
                )

                Divider()

                typeRow(
                    name: "some Protocol (Opaque Type)",
                    summary: "Swift 5.1+ opaque return type (e.g. var body: some View). The compiler knows the ONE specific concrete type at compile time, preserving static optimization."
                )
            }
        }
    }

    // MARK: - Protocols & Traits
    @ViewBuilder
    private var protocolsAndTraitsSection: some View {
        ConceptCard(
            title: "Equatable, Comparable, Hashable",
            subtitle: "Core Swift standard library protocols",
            icon: "checkmark.seal.fill",
            iconColor: AppTheme.warning
        ) {
            VStack(alignment: .leading, spacing: 10) {
                BulletPoint(text: "Equatable: Types that can be compared for equality using static func == (lhs: Self, rhs: Self) -> Bool.")
                BulletPoint(text: "Comparable: Types that can be ordered using relational operators (<, <=, >, >=).")
                BulletPoint(text: "Hashable: Types that can be hashed into an integer hash value for Set and Dictionary keys using hasher.combine().")

                CodeBlockView(
                    title: "Hashable & Equatable Implementation",
                    code: """
struct Developer: Equatable, Comparable, Hashable {
    let id: Int
    let name: String
    let experience: Int

    static func == (lhs: Developer, rhs: Developer) -> Bool {
        lhs.id == rhs.id
    }
    static func < (lhs: Developer, rhs: Developer) -> Bool {
        lhs.experience < rhs.experience
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
"""
                )
            }
        }

        ConceptCard(
            title: "Protocols with associatedtype",
            subtitle: "Generics in protocol contracts",
            icon: "link",
            iconColor: AppTheme.primary
        ) {
            VStack(alignment: .leading, spacing: 8) {
                BulletPoint(text: "'associatedtype' acts as a placeholder for a type used as part of a protocol.")
                BulletPoint(text: "The conforming type decides the actual concrete type (e.g., typealias Item = String).")
                BulletPoint(text: "Powers Collection, IteratorProtocol, and Identifiable (associatedtype ID).")
            }
        }
    }

    private func initRuleRow(name: String, desc: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(name).font(.subheadline.bold()).foregroundColor(AppTheme.primary)
            Text(desc).font(.caption).foregroundColor(.secondary)
        }
    }

    private func accessRow(keyword: String, scope: String, desc: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(keyword)
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(color)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(color.opacity(0.12))
                .cornerRadius(4)
                .frame(width: 85, alignment: .leading)

            VStack(alignment: .leading, spacing: 2) {
                Text(scope)
                    .font(.caption.bold())
                Text(desc)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }

    private func typeRow(name: String, summary: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(name)
                .font(.subheadline.bold())
                .foregroundColor(AppTheme.accent)
            Text(summary)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
