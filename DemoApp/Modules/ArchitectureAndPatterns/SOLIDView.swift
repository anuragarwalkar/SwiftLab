import SwiftUI

// MARK: - SOLID Principles Deep Dive & Interactive Visualizer

enum SolidPrinciple: String, CaseIterable, Identifiable {
    case srp = "S: Single Responsibility"
    case ocp = "O: Open / Closed"
    case lsp = "L: Liskov Substitution"
    case isp = "I: Interface Segregation"
    case dip = "D: Dependency Inversion"

    var id: String { rawValue }

    var shortName: String {
        switch self {
        case .srp: return "SRP"
        case .ocp: return "OCP"
        case .lsp: return "LSP"
        case .isp: return "ISP"
        case .dip: return "DIP"
        }
    }

    var tagline: String {
        switch self {
        case .srp: return "A class should have only one reason to change."
        case .ocp: return "Open for extension, closed for modification."
        case .lsp: return "Subtypes must be substitutable for their base types."
        case .isp: return "Clients should not be forced to depend on methods they don't use."
        case .dip: return "Depend on abstractions, not on concrete implementations."
        }
    }
}

struct SOLIDView: View {
    @State private var selectedPrinciple: SolidPrinciple = .srp

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "square.3.layers.3d.top.filled")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.pink)
                        Text("SOLID Principles")
                            .font(.title2.bold())
                    }
                    Text("The 5 foundational object-oriented design principles that create scalable, testable, and maintainable software architectures.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.pink.opacity(0.08))
                .cornerRadius(16)

                // Segmented Selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(SolidPrinciple.allCases) { principle in
                            Button {
                                selectedPrinciple = principle
                            } label: {
                                Text(principle.shortName)
                                    .font(.subheadline.bold())
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedPrinciple == principle ? AppTheme.pink : Color(.secondarySystemGroupedBackground))
                                    .foregroundColor(selectedPrinciple == principle ? .white : .primary)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                }

                // Principle Detail Card
                ConceptCard(
                    title: selectedPrinciple.rawValue,
                    subtitle: selectedPrinciple.tagline,
                    icon: "sparkles",
                    iconColor: AppTheme.pink
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        detailContent(for: selectedPrinciple)
                    }
                }

                // Bad vs Good Code Comparison
                VStack(alignment: .leading, spacing: 12) {
                    Text("Implementation Comparison")
                        .font(.headline)

                    CodeBlockView(
                        title: "❌ Violating Pattern (Anti-Pattern)",
                        code: badCode(for: selectedPrinciple)
                    )

                    CodeBlockView(
                        title: "✅ Refactored SOLID Pattern",
                        code: goodCode(for: selectedPrinciple)
                    )
                }
            }
            .padding()
        }
        .navigationTitle("SOLID Principles")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func detailContent(for principle: SolidPrinciple) -> some View {
        switch principle {
        case .srp:
            VStack(alignment: .leading, spacing: 8) {
                BulletPoint(text: "A class should have a single responsibility and do it completely.", color: AppTheme.pink)
                BulletPoint(text: "Separate business logic, networking, database persistence, and presentation.", color: AppTheme.pink)
                BulletPoint(text: "Avoid Massive View Controller (MVC) where 1 file handles UI, API calls, parsing, and caching.", color: AppTheme.pink)
            }
        case .ocp:
            VStack(alignment: .leading, spacing: 8) {
                BulletPoint(text: "You should be able to add new functionality without changing existing, tested code.", color: AppTheme.pink)
                BulletPoint(text: "Use protocols and polymorphism instead of large switch statements on enum types.", color: AppTheme.pink)
                BulletPoint(text: "When a new payment type or feature is added, create a new conforming class instead of editing existing functions.", color: AppTheme.pink)
            }
        case .lsp:
            VStack(alignment: .leading, spacing: 8) {
                BulletPoint(text: "Subclasses must be able to replace base classes without breaking the caller's expectations.", color: AppTheme.pink)
                BulletPoint(text: "Do NOT override a base class method with an empty stub, a fatalError(), or unexpected restrictions.", color: AppTheme.pink)
                BulletPoint(text: "Classic example: Square inheriting from Rectangle breaks width/height independence.", color: AppTheme.pink)
            }
        case .isp:
            VStack(alignment: .leading, spacing: 8) {
                BulletPoint(text: "Clients should not be forced to implement methods they don't need.", color: AppTheme.pink)
                BulletPoint(text: "Split large, monolithic protocols into smaller, targeted protocols.", color: AppTheme.pink)
                BulletPoint(text: "Swift supports protocol composition: 'typealias FullWorker = Workable & Feedable'.", color: AppTheme.pink)
            }
        case .dip:
            VStack(alignment: .leading, spacing: 8) {
                BulletPoint(text: "High-level business modules should NOT depend directly on low-level modules (e.g., API client or CoreData).", color: AppTheme.pink)
                BulletPoint(text: "Both must depend on abstractions (Protocols / Interfaces).", color: AppTheme.pink)
                BulletPoint(text: "Enables Dependency Injection (DI) and easy unit test mocking.", color: AppTheme.pink)
            }
        }
    }

    private func badCode(for principle: SolidPrinciple) -> String {
        switch principle {
        case .srp:
            return """
// ❌ Violates SRP: UserProfile handles UI, Network, and DB saving
class UserProfileManager {
    func fetchUserFromAPI() { /* API logic */ }
    func saveUserToDatabase() { /* CoreData logic */ }
    func renderProfileView() { /* UIKit UI logic */ }
}
"""
        case .ocp:
            return """
// ❌ Violates OCP: Adding a new payment requires modifying this switch
class PaymentProcessor {
    func pay(type: String, amount: Double) {
        if type == "ApplePay" { /* Apple Pay */ }
        else if type == "CreditCard" { /* Card */ }
        // Adding PayPal breaks existing tested code!
    }
}
"""
        case .lsp:
            return """
// ❌ Violates LSP: Ostrich cannot fly and breaks Bird assumption
class Bird {
    func fly() { print("Flying high!") }
}
class Ostrich: Bird {
    override func fly() {
        fatalError("Ostriches cannot fly!") // Crash!
    }
}
"""
        case .isp:
            return """
// ❌ Violates ISP: Robot is forced to implement eat()
protocol Worker {
    func work()
    func eat()
}
class RobotWorker: Worker {
    func work() { /* Working */ }
    func eat() { /* Robots don't eat! Forced empty method */ }
}
"""
        case .dip:
            return """
// ❌ Violates DIP: ViewModel directly creates concrete MySQLDatabase
class UserViewModel {
    private let database = MySQLDatabase() // Tightly coupled! Cannot mock for tests
    func load() { database.query() }
}
"""
        }
    }

    private func goodCode(for principle: SolidPrinciple) -> String {
        switch principle {
        case .srp:
            return """
// ✅ Conforms to SRP: Each class has a single responsibility
class UserAPIService { func fetchUser() { } }
class UserRepository { func saveUser() { } }
struct UserProfileView: View { /* View only */ }
"""
        case .ocp:
            return """
// ✅ Conforms to OCP: Open for extension via PaymentMethod protocol
protocol PaymentMethod {
    func process(amount: Double)
}
class ApplePayment: PaymentMethod { func process(amount: Double) { } }
class PayPalPayment: PaymentMethod { func process(amount: Double) { } }
"""
        case .lsp:
            return """
// ✅ Conforms to LSP: Separate Flying from non-flying birds
protocol Bird { func eat() }
protocol FlyingBird: Bird { func fly() }

class Sparrow: FlyingBird { func eat() {}; func fly() {} }
class Ostrich: Bird { func eat() {} } // Clean substitution!
"""
        case .isp:
            return """
// ✅ Conforms to ISP: Segregated small protocols
protocol Workable { func work() }
protocol Feedable { func eat() }

class HumanWorker: Workable, Feedable { func work() {}; func eat() {} }
class RobotWorker: Workable { func work() {} } // Only what it needs!
"""
        case .dip:
            return """
// ✅ Conforms to DIP: Depends on abstraction protocol
protocol DatabaseProtocol { func query() }

class UserViewModel {
    private let database: DatabaseProtocol
    init(database: DatabaseProtocol) { self.database = database }
}
// Easily inject MockDatabase for Unit Tests!
"""
        }
    }
}
