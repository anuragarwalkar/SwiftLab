import SwiftUI

// MARK: - GoF Design Patterns (Creational, Structural, Behavioural)

enum PatternCategory: String, CaseIterable, Identifiable {
    case creational = "Creational"
    case structural = "Structural"
    case behavioural = "Behavioural"

    var id: String { rawValue }
}

struct DesignPatternsView: View {
    @State private var selectedCategory: PatternCategory = .creational
    @State private var singletonLogs: [String] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "puzzlepiece.extension.fill")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.accent)
                        Text("Design Patterns in Swift")
                            .font(.title2.bold())
                    }
                    Text("Time-tested solutions to recurring software engineering problems, categorized by Creational, Structural, and Behavioural.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.accent.opacity(0.08))
                .cornerRadius(16)

                // Category Picker
                Picker("Pattern Type", selection: $selectedCategory) {
                    ForEach(PatternCategory.allCases) { cat in
                        Text(cat.rawValue).tag(cat)
                    }
                }
                .pickerStyle(.segmented)

                // Render content depending on category
                switch selectedCategory {
                case .creational:
                    creationalSection
                case .structural:
                    structuralSection
                case .behavioural:
                    behaviouralSection
                }
            }
            .padding()
        }
        .navigationTitle("Design Patterns")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Creational Patterns
    @ViewBuilder
    private var creationalSection: some View {
        ConceptCard(
            title: "1. Singleton Pattern",
            subtitle: "Single instance with global access & private init",
            icon: "1.circle.fill",
            iconColor: AppTheme.primary
        ) {
            VStack(alignment: .leading, spacing: 10) {
                BulletPoint(text: "Ensures exactly one instance of a class exists across the entire app lifecycle.")
                BulletPoint(text: "Private init() prevents external initialization: `private init() {}`.")
                BulletPoint(text: "Thread Safety: In Swift, `static let shared = NetworkManager()` is lazily initialized and thread-safe via `dispatch_once` under the hood.")
                BulletPoint(text: "Warning: Can become an anti-pattern if used as a dumping ground for global state or making unit testing impossible without DI.")

                CodeBlockView(
                    title: "Thread-Safe Singleton in Swift",
                    code: """
final class NetworkManager {
    static let shared = NetworkManager() // Lazily & atomically created
    private init() { } // Prevents additional instances
    
    func request() { print("Fetching...") }
}
"""
                )
            }
        }

        ConceptCard(
            title: "2. Factory Pattern",
            subtitle: "Create objects without exposing concrete instantiation logic",
            icon: "shippingbox.fill",
            iconColor: AppTheme.secondary
        ) {
            VStack(alignment: .leading, spacing: 10) {
                BulletPoint(text: "Decouples object creation from client code.")
                BulletPoint(text: "The client asks for a protocol or base type; the factory decides which concrete class to instantiate.")

                CodeBlockView(
                    title: "Factory Method Example",
                    code: """
protocol Payment { func process() }
class ApplePay: Payment { func process() {} }
class GooglePay: Payment { func process() {} }

enum PaymentFactory {
    static func createPayment(type: String) -> Payment {
        switch type {
        case "apple": return ApplePay()
        default: return GooglePay()
        }
    }
}
"""
                )
            }
        }

        ConceptCard(
            title: "3. Builder Pattern",
            subtitle: "Construct complex objects step-by-step",
            icon: "hammer.fill",
            iconColor: AppTheme.warning
        ) {
            VStack(alignment: .leading, spacing: 10) {
                BulletPoint(text: "Builds complex composite objects step by step.")
                BulletPoint(text: "Avoids gigantic initializers with 15 optional parameters ('telescoping constructor').")

                CodeBlockView(
                    title: "Builder Example in Swift",
                    code: """
class URLRequestBuilder {
    private var url: URL?
    private var method = "GET"
    private var headers: [String: String] = [:]

    func set(url: URL) -> Self { self.url = url; return self }
    func set(method: String) -> Self { self.method = method; return self }
    func set(header: String, value: String) -> Self { self.headers[header] = value; return self }
    func build() -> URLRequest? {
        guard let url = url else { return nil }
        var req = URLRequest(url: url)
        req.httpMethod = method
        req.allHTTPHeaderFields = headers
        return req
    }
}
"""
                )
            }
        }
    }

    // MARK: - Structural Patterns
    @ViewBuilder
    private var structuralSection: some View {
        ConceptCard(
            title: "1. Adapter Pattern",
            subtitle: "Allows incompatible interfaces to work together",
            icon: "cable.connector",
            iconColor: AppTheme.purple
        ) {
            VStack(alignment: .leading, spacing: 10) {
                BulletPoint(text: "Converts the interface of a class into another interface clients expect.")
                BulletPoint(text: "Frequently used when integrating 3rd party SDKs, legacy systems, or bridging Obj-C APIs.")

                CodeBlockView(
                    title: "Adapter Pattern Example",
                    code: """
// 3rd-Party SDK interface (Incompatible)
class ThirdPartyPaymentSDK {
    func makeTransactionInCents(cents: Int) { }
}

// Client expectation
protocol StandardPaymentGateway {
    func pay(dollars: Double)
}

// Adapter bridges them
class PaymentSDKAdapter: StandardPaymentGateway {
    private let sdk = ThirdPartyPaymentSDK()
    func pay(dollars: Double) {
        let cents = Int(dollars * 100)
        sdk.makeTransactionInCents(cents: cents)
    }
}
"""
                )
            }
        }

        ConceptCard(
            title: "2. Decorator Pattern",
            subtitle: "Dynamically add responsibilities to objects",
            icon: "gift.fill",
            iconColor: AppTheme.pink
        ) {
            VStack(alignment: .leading, spacing: 10) {
                BulletPoint(text: "Adds behavior to an individual object, either statically or dynamically, without affecting other objects of the same class.")
                BulletPoint(text: "Achieved via protocol conformance and wrapping the decorated instance.")

                CodeBlockView(
                    title: "Decorator Pattern Example",
                    code: """
protocol Coffee { func cost() -> Double }
class SimpleCoffee: Coffee { func cost() -> Double { 2.0 } }

class MilkDecorator: Coffee {
    private let coffee: Coffee
    init(_ coffee: Coffee) { self.coffee = coffee }
    func cost() -> Double { coffee.cost() + 0.5 }
}
let myLatte = MilkDecorator(SimpleCoffee()) // 2.5
"""
                )
            }
        }

        ConceptCard(
            title: "3. Facade Pattern",
            subtitle: "Simplified single interface to a complex subsystem",
            icon: "building.columns.fill",
            iconColor: AppTheme.accent
        ) {
            VStack(alignment: .leading, spacing: 10) {
                BulletPoint(text: "Provides a single, easy-to-use entry point that hides the complexity of multiple subsystems.")
                BulletPoint(text: "Prevents client classes from having to interact with 5 different managers (Auth, Cache, Analytics, Network, DB).")

                CodeBlockView(
                    title: "Facade Pattern Example",
                    code: """
class UserAccountFacade {
    private let auth = AuthService()
    private let cache = CacheService()
    private let analytics = AnalyticsService()

    func loginAndSetup(user: String) {
        auth.authenticate(user)
        cache.clear()
        analytics.trackLogin(user)
    }
}
"""
                )
            }
        }
    }

    // MARK: - Behavioural Patterns
    @ViewBuilder
    private var behaviouralSection: some View {
        ConceptCard(
            title: "1. Observer & NotificationCenter",
            subtitle: "1-to-many state change broadcasting",
            icon: "bell.badge.fill",
            iconColor: AppTheme.warning
        ) {
            VStack(alignment: .leading, spacing: 10) {
                BulletPoint(text: "Defines a one-to-many dependency so that when one object changes state, all its dependents are notified automatically.")
                BulletPoint(text: "iOS implementations: NotificationCenter, Combine publishers, KVO, and Swift's modern @Observable.")

                CodeBlockView(
                    title: "NotificationCenter Observer Example",
                    code: """
// Post
NotificationCenter.default.post(name: .userDidLogin, object: nil)

// Observe
NotificationCenter.default.addObserver(
    forName: .userDidLogin,
    object: nil,
    queue: .main
) { notification in
    print("User logged in!")
}
"""
                )
            }
        }

        ConceptCard(
            title: "2. Delegate Pattern",
            subtitle: "1-to-1 decoupled coordination protocol",
            icon: "hand.raised.fill",
            iconColor: AppTheme.primary
        ) {
            VStack(alignment: .leading, spacing: 10) {
                BulletPoint(text: "One object acts on behalf of, or in coordination with, another object.")
                BulletPoint(text: "Very common in UIKit (UITableViewDelegate, UITextFieldDelegate).")
                BulletPoint(text: "Crucial Rule: Always declare delegates as `weak var delegate: Protocol?` to prevent retain cycles!")

                CodeBlockView(
                    title: "Delegate Pattern in Swift",
                    code: """
protocol DownloadDelegate: AnyObject { // AnyObject required for weak
    func downloadDidFinish(data: Data)
}

class Downloader {
    weak var delegate: DownloadDelegate? // Break retain cycle!
    func finish() { delegate?.downloadDidFinish(data: Data()) }
}
"""
                )
            }
        }
    }
}
