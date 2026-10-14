import SwiftUI

// MARK: - Level 2: Custom Types, Properties & Access Control (Deep Dive)

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: Sample Classes/Enums for Interactive Demos
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// Property Observer Demo
private class Thermostat {
    var onLog: ((String) -> Void)?

    var temperature: Double = 20.0 {
        willSet {
            onLog?("⏳ [willSet] About to change: \(temperature)°C → \(newValue)°C")
        }
        didSet {
            onLog?("✅ [didSet] Changed! old: \(oldValue)°C → new: \(temperature)°C")
            if temperature > 35.0 {
                onLog?("🚨 [didSet] HIGH TEMP ALERT! Triggering cooling system...")
            }
            if temperature < 5.0 {
                onLog?("❄️ [didSet] FREEZE WARNING! Activating heater...")
            }
        }
    }
}

// Enum with Associated Values
private enum PaymentMethod: CustomStringConvertible {
    case cash
    case creditCard(number: String, expDate: String, cvv: String)
    case applePay(deviceToken: String)
    case upi(vpa: String)

    var description: String {
        switch self {
        case .cash:
            return "💵 Cash Payment (no additional data)"
        case .creditCard(let number, let exp, _):
            return "💳 Card ending ****\(number.suffix(4)) (Exp: \(exp))"
        case .applePay(let token):
            return "🍎 Apple Pay (Token: \(token.prefix(6))...)"
        case .upi(let vpa):
            return "📱 UPI: \(vpa)"
        }
    }
    
    var icon: String {
        switch self {
        case .cash: return "banknote"
        case .creditCard: return "creditcard"
        case .applePay: return "apple.logo"
        case .upi: return "indianrupeesign.circle"
        }
    }
}

struct CustomTypesAndPropertiesView: View {
    @State private var selectedTab = 0
    
    // Property Observer state
    @State private var thermostat = Thermostat()
    @State private var observerLogs: [String] = []

    // Enum state
    @State private var selectedPayment: PaymentMethod = .applePay(deviceToken: "a9f3b1c8e7d4")

    // Computed property playground
    @State private var sideLength: Double = 5.0
    @State private var radiusCm: Double = 10.0

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Banner
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        ZStack {
                            Circle().fill(Color.purple.opacity(0.15)).frame(width: 44, height: 44)
                            Text("L2").font(.headline.bold()).foregroundColor(.purple)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Level 2: Custom Types & Properties")
                                .font(.title2.bold())
                            Text("Enums, Properties, Observers, Structs vs Classes & Access Control")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    Text("Master Swift's powerful type system. Understand how enums carry data, how properties react to changes, when to choose struct vs class, and how to control API visibility.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.purple.opacity(0.08))
                .cornerRadius(16)

                // Subtopic Picker
                Picker("Topic", selection: $selectedTab) {
                    Text("Enums").tag(0)
                    Text("Properties").tag(1)
                    Text("Struct vs Class").tag(2)
                    Text("Access Control").tag(3)
                }
                .pickerStyle(.segmented)

                switch selectedTab {
                case 0: enumsSection
                case 1: propertiesSection
                case 2: structVsClassSection
                case 3: accessControlSection
                default: EmptyView()
                }
            }
            .padding()
        }
        .navigationTitle("Types & Properties")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            thermostat.onLog = { msg in
                observerLogs.append(msg)
            }
        }
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 1. Enums Deep Dive
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @ViewBuilder
    private var enumsSection: some View {
        
        ConceptCard(
            title: "Swift Enums — NOT Like C/Java Enums!",
            subtitle: "First-class citizens with superpowers",
            icon: "list.bullet.indent",
            iconColor: AppTheme.primary
        ) {
            VStack(alignment: .leading, spacing: 12) {
                calloutBox(
                    text: "In C/Java, enums are just integer constants (0, 1, 2...). In Swift, each enum case can carry DIFFERENT associated data, have computed properties, methods, and even conform to protocols. They're full types!",
                    icon: "lightbulb.fill",
                    color: AppTheme.warning
                )
                
                BulletPoint(text: "Raw Values: Each case maps to a fixed value (Int, String). Useful for API codes.")
                BulletPoint(text: "Associated Values: Each case carries different data payloads. Like a mini-struct per case.")
                BulletPoint(text: "CaseIterable: Conform to loop through all cases automatically.")
                BulletPoint(text: "Recursive Enums: Use 'indirect' for tree-like data structures.")
            }
        }
        
        CodeBlockView(
            title: "Enum Types — All 4 Flavors",
            code: """
// ═══ 1. Simple Enum (No Data) ═══
enum Direction {
    case north, south, east, west
}
let heading = Direction.north  // Type-safe, no magic strings!

// ═══ 2. Raw Value Enum (Fixed backing value) ═══
enum HTTPStatus: Int {
    case ok = 200
    case notFound = 404
    case serverError = 500
}
let status = HTTPStatus(rawValue: 404)  // Optional(HTTPStatus.notFound)
print(status?.rawValue ?? 0)            // 404

enum Coin: String {
    case bitcoin = "BTC"
    case ethereum = "ETH"
    case solana = "SOL"
}
let coin = Coin.bitcoin
print(coin.rawValue)  // "BTC"

// ═══ 3. Associated Value Enum (DIFFERENT data per case) ═══
enum NetworkResult {
    case success(data: Data, statusCode: Int)
    case failure(error: Error)
    case loading(progress: Double)
    case cancelled(reason: String)
}

// Each case carries DIFFERENT types of data!
let result = NetworkResult.success(data: Data(), statusCode: 200)

switch result {
case .success(let data, let code):
    print("Got \\(data.count) bytes, status \\(code)")
case .failure(let error):
    print("Error: \\(error.localizedDescription)")
case .loading(let progress):
    print("Loading: \\(Int(progress * 100))%")
case .cancelled(let reason):
    print("Cancelled: \\(reason)")
}

// ═══ 4. CaseIterable — Loop Through All Cases ═══
enum Season: String, CaseIterable {
    case spring = "🌸"
    case summer = "☀️"
    case autumn = "🍂"
    case winter = "❄️"
}
for season in Season.allCases {
    print("\\(season): \\(season.rawValue)")
}
// spring: 🌸, summer: ☀️, autumn: 🍂, winter: ❄️
"""
        )
        
        // Interactive Payment Method Demo
        ConceptCard(
            title: "Live: Associated Values in Action",
            subtitle: "Tap to see different data per enum case",
            icon: "creditcard.fill",
            iconColor: AppTheme.accent
        ) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Each payment method carries DIFFERENT associated data:")
                    .font(.caption)
                    .foregroundColor(.secondary)

                VStack(spacing: 8) {
                    paymentButton("Cash", method: .cash)
                    paymentButton("Credit Card", method: .creditCard(number: "4111222233334567", expDate: "12/28", cvv: "123"))
                    paymentButton("Apple Pay", method: .applePay(deviceToken: "a9f3b1c8e7d4"))
                    paymentButton("UPI", method: .upi(vpa: "anurag@paytm"))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Pattern-Matched Output:")
                        .font(.caption.bold())
                    HStack(spacing: 8) {
                        Image(systemName: selectedPayment.icon)
                            .foregroundColor(AppTheme.primary)
                        Text(selectedPayment.description)
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundColor(AppTheme.primary)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.tertiarySystemGroupedBackground))
                    .cornerRadius(8)
                }
            }
        }
        
        CodeBlockView(
            title: "Enums with Methods & Computed Properties",
            code: """
// ═══ Enums Can Have Methods! ═══
enum Planet: Int, CaseIterable {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune

    var isHabitable: Bool {
        self == .earth  // Computed property
    }

    var distanceFromSun: String {
        switch self {
        case .mercury: return "57.9 million km"
        case .venus:   return "108.2 million km"
        case .earth:   return "149.6 million km"
        case .mars:    return "227.9 million km"
        case .jupiter: return "778.5 million km"
        case .saturn:  return "1.434 billion km"
        case .uranus:  return "2.871 billion km"
        case .neptune: return "4.495 billion km"
        }
    }

    func explore() -> String {
        if isHabitable {
            return "🌍 \\(self) is habitable!"
        } else {
            return "🚀 \\(self) is \\(distanceFromSun) from the Sun"
        }
    }
}

print(Planet.earth.explore())    // "🌍 earth is habitable!"
print(Planet.mars.explore())     // "🚀 mars is 227.9 million km from the Sun"
print(Planet.earth.rawValue)     // 3

// ═══ Indirect Enums (Recursive Data) ═══
indirect enum ArithExpr {
    case number(Int)
    case add(ArithExpr, ArithExpr)
    case multiply(ArithExpr, ArithExpr)
}

let expr = ArithExpr.add(
    .number(5),
    .multiply(.number(3), .number(4))
)
// Represents: 5 + (3 × 4) = 17

func evaluate(_ expr: ArithExpr) -> Int {
    switch expr {
    case .number(let n): return n
    case .add(let a, let b): return evaluate(a) + evaluate(b)
    case .multiply(let a, let b): return evaluate(a) * evaluate(b)
    }
}
print(evaluate(expr))  // 17
"""
        )
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 2. Properties Deep Dive
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @ViewBuilder
    private var propertiesSection: some View {
        
        ConceptCard(
            title: "3 Types of Properties in Swift",
            subtitle: "Stored, Computed, and Type (static) Properties",
            icon: "square.stack.fill",
            iconColor: AppTheme.secondary
        ) {
            VStack(alignment: .leading, spacing: 12) {
                propertyTypeRow(
                    name: "Stored Property",
                    description: "Stores an actual value in memory (only in classes/structs).",
                    example: "var name: String = \"Anurag\"",
                    color: AppTheme.primary
                )
                Divider()
                propertyTypeRow(
                    name: "Computed Property",
                    description: "Calculates value on-the-fly. No memory storage. Has get{} and optional set{}.",
                    example: "var fullName: String { \"\\(first) \\(last)\" }",
                    color: AppTheme.purple
                )
                Divider()
                propertyTypeRow(
                    name: "Type Property (static)",
                    description: "Belongs to the TYPE, not instances. Shared across all instances. Like Java's static.",
                    example: "static let maxAge = 150",
                    color: AppTheme.accent
                )
            }
        }
        
        CodeBlockView(
            title: "All 3 Property Types — Complete Example",
            code: """
struct Employee {
    // ═══ 1. Stored Properties ═══
    var firstName: String        // Mutable stored
    var lastName: String         // Mutable stored
    let employeeID: String       // Immutable stored (never changes)
    var salary: Double           // Mutable stored

    // ═══ 2. Computed Properties ═══
    // Read-only (get only — no set)
    var fullName: String {
        "\\(firstName) \\(lastName)"  // Implicit return
    }

    // Read-Write (get + set)
    var annualBonus: Double {
        get {
            salary * 0.15  // 15% of salary
        }
        set {
            // newValue is the value being assigned
            salary = newValue / 0.15
        }
    }

    // ═══ 3. Type Properties (static) ═══
    static let company = "SwiftCraft Inc."    // Shared by ALL employees
    static var totalEmployees = 0             // Tracks total count

    init(firstName: String, lastName: String, id: String, salary: Double) {
        self.firstName = firstName
        self.lastName = lastName
        self.employeeID = id
        self.salary = salary
        Employee.totalEmployees += 1
    }
}

var dev = Employee(firstName: "Anurag", lastName: "A", id: "E001", salary: 100_000)
print(dev.fullName)           // "Anurag A" (computed)
print(dev.annualBonus)        // 15000.0 (computed get)
dev.annualBonus = 20000       // Triggers set → salary becomes 133333.33
print(Employee.company)       // "SwiftCraft Inc." (type property)
print(Employee.totalEmployees) // 1 (type property)
"""
        )
        
        // Interactive Property Observers
        ConceptCard(
            title: "Live: Property Observers (willSet & didSet)",
            subtitle: "React to value changes BEFORE and AFTER storage",
            icon: "thermometer.medium",
            iconColor: AppTheme.accent
        ) {
            VStack(alignment: .leading, spacing: 14) {
                calloutBox(
                    text: "willSet fires BEFORE the value changes (you get 'newValue'). didSet fires AFTER the value changes (you get 'oldValue'). Cannot be used on computed properties (use set{} instead). Cannot be used on let constants.",
                    icon: "info.circle.fill",
                    color: AppTheme.primary
                )
                
                HStack {
                    Text("Current: \(String(format: "%.1f", thermostat.temperature))°C")
                        .font(.subheadline.bold())
                    Spacer()
                    Text(thermostat.temperature > 35 ? "🔥 HOT" : thermostat.temperature < 5 ? "❄️ COLD" : "✅ OK")
                        .font(.caption.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(thermostat.temperature > 35 ? Color.red.opacity(0.15) : thermostat.temperature < 5 ? Color.blue.opacity(0.15) : Color.green.opacity(0.15))
                        .cornerRadius(6)
                }

                HStack(spacing: 8) {
                    Button("22°C") { thermostat.temperature = 22.0 }
                        .font(.caption.bold()).buttonStyle(.bordered)
                    Button("25°C") { thermostat.temperature = 25.0 }
                        .font(.caption.bold()).buttonStyle(.bordered)
                    Button("🔥 38°C") { thermostat.temperature = 38.0 }
                        .font(.caption.bold()).buttonStyle(.borderedProminent).tint(.red)
                    Button("❄️ 2°C") { thermostat.temperature = 2.0 }
                        .font(.caption.bold()).buttonStyle(.borderedProminent).tint(.blue)
                    Button("Reset") { thermostat.temperature = 20.0 }
                        .font(.caption).buttonStyle(.bordered)
                }

                InteractiveLogBox(logs: observerLogs, onClear: { observerLogs.removeAll() })
            }
        }
        
        CodeBlockView(
            title: "willSet & didSet — Real-World Patterns",
            code: """
// ═══ Pattern 1: Validation on Change ═══
class UserProfile {
    var username: String = "" {
        didSet {
            // Enforce lowercase
            if username != username.lowercased() {
                username = username.lowercased()
                print("⚠️ Username auto-lowered to: \\(username)")
            }
        }
    }
}

// ═══ Pattern 2: UI Refresh Trigger ═══
class ViewModel: ObservableObject {
    var items: [String] = [] {
        didSet {
            print("📊 Items changed: \\(oldValue.count) → \\(items.count)")
            // Trigger reload, recalculate, etc.
            updateBadgeCount()
        }
    }
    
    var searchText: String = "" {
        willSet {
            print("🔍 Search will change to: '\\(newValue)'")
        }
        didSet {
            if searchText != oldValue {
                performSearch(searchText)
            }
        }
    }
    
    func updateBadgeCount() { /* ... */ }
    func performSearch(_ query: String) { /* ... */ }
}

// ═══ Pattern 3: Clamping Values ═══
class AudioPlayer {
    var volume: Double = 0.5 {
        didSet {
            // Clamp between 0 and 1
            volume = min(max(volume, 0.0), 1.0)
            print("🔊 Volume: \\(Int(volume * 100))%")
        }
    }
}
"""
        )
        
        // Interactive Computed Property
        ConceptCard(
            title: "Live: Computed Properties in Action",
            subtitle: "Change the radius and watch derived values update",
            icon: "ruler.fill",
            iconColor: AppTheme.secondary
        ) {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Circle Radius: \(String(format: "%.0f", radiusCm)) cm")
                        .font(.caption.bold())
                    Slider(value: $radiusCm, in: 1...50, step: 1)
                    
                    HStack {
                        computedValueBadge(label: "Diameter", value: "\(String(format: "%.0f", radiusCm * 2)) cm", color: .blue)
                        computedValueBadge(label: "Circumference", value: "\(String(format: "%.1f", 2 * .pi * radiusCm)) cm", color: .purple)
                        computedValueBadge(label: "Area", value: "\(String(format: "%.1f", .pi * radiusCm * radiusCm)) cm²", color: .green)
                    }
                }
                
                Text("All three values are COMPUTED — they don't store anything. They recalculate every time radius changes.")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        
        // Lazy Properties
        ConceptCard(
            title: "lazy var — Deferred Initialization",
            subtitle: "Only created when first accessed",
            icon: "clock.fill",
            iconColor: AppTheme.warning
        ) {
            VStack(alignment: .leading, spacing: 10) {
                BulletPoint(text: "lazy var delays initialization until the property is FIRST ACCESSED.")
                BulletPoint(text: "Must be 'var' (never 'let') because it changes from uninitialized → initialized.")
                BulletPoint(text: "Perfect for expensive objects: database connections, image decoders, heavy computations.")
                BulletPoint(text: "NOT thread-safe by default — can be initialized twice on concurrent access!", color: AppTheme.error)
            }
        }
        
        CodeBlockView(
            title: "lazy var — When and Why",
            code: """
class DataManager {
    // ═══ This is expensive — don't create until needed ═══
    lazy var database: Database = {
        print("💾 Database initialized (expensive!)")
        let db = Database()
        db.configure(maxConnections: 5)
        db.migrate()
        return db
    }()

    // ═══ Depends on another stored property ═══
    let userId: String
    lazy var userProfile: Profile = {
        // Can access 'self' because lazy runs AFTER init
        return Profile.load(for: userId)
    }()

    init(userId: String) {
        self.userId = userId
        // database and userProfile are NOT created yet!
        print("DataManager init — no DB connection yet")
    }
}

let manager = DataManager(userId: "usr_123")
// Output: "DataManager init — no DB connection yet"
// database is still nil at this point!

manager.database.query("SELECT * FROM users")
// NOW output: "💾 Database initialized (expensive!)"
// Only created when actually needed.
"""
        )
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 3. Struct vs Class
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @ViewBuilder
    private var structVsClassSection: some View {
        
        ConceptCard(
            title: "Struct vs Class — The MOST Asked Interview Question",
            subtitle: "Value type vs Reference type fundamentals",
            icon: "square.stack.3d.up.fill",
            iconColor: AppTheme.primary
        ) {
            VStack(alignment: .leading, spacing: 12) {
                calloutBox(
                    text: "Apple's guideline: Use struct by default. Only use class when you need inheritance, reference semantics, or deinit. SwiftUI views are ALL structs!",
                    icon: "apple.logo",
                    color: AppTheme.primary
                )
                
                structClassComparisonView
            }
        }
        
        CodeBlockView(
            title: "Value vs Reference — See the Difference",
            code: """
// ═══ STRUCT (Value Type) — Makes a COPY ═══
struct Point {
    var x: Int
    var y: Int
}
var pointA = Point(x: 10, y: 20)
var pointB = pointA     // Creates an independent COPY
pointB.x = 99           // Modifying B does NOT affect A

print(pointA.x)  // 10  ← Original untouched!
print(pointB.x)  // 99  ← Only the copy changed

// ═══ CLASS (Reference Type) — Shares the SAME instance ═══
class Person {
    var name: String
    init(name: String) { self.name = name }
    deinit { print("\\(name) deallocated") }
}

var personA = Person(name: "Anurag")
var personB = personA   // Both point to SAME object in memory
personB.name = "Arwalkar"

print(personA.name)  // "Arwalkar" ← BOTH changed!
print(personB.name)  // "Arwalkar" ← Same object

// ═══ Identity Check (=== vs ==) ═══
print(personA === personB)  // true → Same memory address
let personC = Person(name: "Arwalkar")
print(personA === personC)  // false → Different objects

// ═══ When to Use What ═══
// Struct: Data models, coordinates, colors, API responses
// Class: ViewModels, singletons, delegates, when you need deinit
// Actor: When you need class-like behavior + thread safety (Level 5)
"""
        )
        
        ConceptCard(
            title: "Mutability Rules — struct vs class",
            subtitle: "Why struct methods need 'mutating'",
            icon: "pencil.circle.fill",
            iconColor: AppTheme.warning
        ) {
            VStack(alignment: .leading, spacing: 10) {
                BulletPoint(text: "Struct methods CANNOT modify properties by default (because value types are copied).")
                BulletPoint(text: "Use 'mutating func' to allow a struct method to modify its own properties.")
                BulletPoint(text: "Class methods can ALWAYS modify properties (reference type — no copy involved).")
                BulletPoint(text: "You cannot call a mutating func on a 'let' struct instance.", color: AppTheme.error)
            }
        }
        
        CodeBlockView(
            title: "mutating func — Why Structs Need It",
            code: """
struct Counter {
    var count = 0

    // Without 'mutating', this would be a compiler error!
    mutating func increment() {
        count += 1  // Modifying self's property
    }

    mutating func reset() {
        self = Counter()  // Can even replace self entirely!
    }
}

var counter = Counter()
counter.increment()     // count = 1
counter.increment()     // count = 2
counter.reset()         // count = 0

// let fixedCounter = Counter()
// fixedCounter.increment()  // ❌ ERROR: Cannot use mutating on 'let'

// ═══ WHY does struct need mutating? ═══
// Because structs are VALUE TYPES. When you call a method,
// Swift creates a copy. 'mutating' tells the compiler:
// "I intend to modify this copy and write it back."
// Internally, it's like:
// var temp = self
// temp.count += 1
// self = temp

// ═══ Class doesn't need 'mutating' ═══
class ClassCounter {
    var count = 0
    func increment() {  // No 'mutating' needed!
        count += 1      // Modifying the actual object in heap
    }
}
"""
        )
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 4. Access Control
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @ViewBuilder
    private var accessControlSection: some View {
        
        ConceptCard(
            title: "Access Control Levels — Complete Hierarchy",
            subtitle: "From most restrictive to most open",
            icon: "lock.shield.fill",
            iconColor: AppTheme.error
        ) {
            VStack(alignment: .leading, spacing: 10) {
                accessLevelRow(level: "private", scope: "Same declaration (+ extensions in same file)", emoji: "🔒", color: .red)
                accessLevelRow(level: "fileprivate", scope: "Same source file only", emoji: "📄", color: .orange)
                accessLevelRow(level: "internal", scope: "Same module (DEFAULT if you write nothing)", emoji: "📦", color: .blue)
                accessLevelRow(level: "package", scope: "Same Swift package (Swift 5.9+)", emoji: "📬", color: .purple)
                accessLevelRow(level: "public", scope: "Any module that imports yours (cannot subclass/override)", emoji: "🌍", color: .green)
                accessLevelRow(level: "open", scope: "Any module + CAN subclass and override", emoji: "🔓", color: .mint)
            }
        }
        
        CodeBlockView(
            title: "Access Control — Real-World SDK Design",
            code: """
// ═══ Imagine you're building a Networking SDK ═══

// 'open' — Other apps can subclass this
open class NetworkClient {

    // 'public' — Can be read from outside, but not subclassed
    public let baseURL: URL

    // 'internal' — Only your SDK code can access (default)
    var session: URLSession

    // 'private' — Only this class declaration
    private var authToken: String?

    // 'fileprivate' — Only code in this .swift file
    fileprivate var requestCount = 0

    public init(baseURL: URL) {
        self.baseURL = baseURL
        self.session = URLSession.shared
    }

    // 'open' — Other apps can override this method
    open func handleError(_ error: Error) {
        print("Default error handling: \\(error)")
    }

    // 'public' but NOT 'open' — cannot be overridden
    public func fetch(path: String) async throws -> Data {
        requestCount += 1
        let url = baseURL.appendingPathComponent(path)
        let (data, _) = try await session.data(from: url)
        return data
    }

    // 'private' — only this class can call it
    private func refreshToken() {
        authToken = "new_token_\\(Date())"
    }
}

// ═══ In the consuming app: ═══
// let client = NetworkClient(baseURL: url)  ✅
// client.baseURL                            ✅ (public)
// client.session                            ❌ (internal — different module)
// client.authToken                          ❌ (private)
// client.requestCount                       ❌ (fileprivate)

// ═══ Common Pattern: Public getter, Private setter ═══
class BankAccount {
    // Anyone can READ the balance, but only this class can SET it
    public private(set) var balance: Double = 0

    public func deposit(_ amount: Double) {
        balance += amount
    }
}
let account = BankAccount()
print(account.balance)    // ✅ Can read
// account.balance = 1000 // ❌ Cannot set — private(set)
"""
        )
        
        ConceptCard(
            title: "Interview Key: open vs public",
            subtitle: "The subtle but critical difference",
            icon: "key.fill",
            iconColor: AppTheme.warning
        ) {
            VStack(alignment: .leading, spacing: 10) {
                calloutBox(
                    text: "Both allow access from other modules. But 'open' also allows SUBCLASSING and OVERRIDING from other modules. Use 'open' when designing frameworks meant to be extended. Use 'public' when you want controlled, non-overridable APIs.",
                    icon: "brain.filled.head.profile",
                    color: AppTheme.warning
                )
                BulletPoint(text: "UIViewController is 'open' — you subclass it in every app.", icon: "checkmark.circle.fill")
                BulletPoint(text: "String is 'public' (not open) — you can USE it but cannot subclass it (it's a struct anyway).", icon: "xmark.circle.fill", color: AppTheme.error)
            }
        }
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - Helper Views
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    private func calloutBox(text: String, icon: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(color)
                .padding(.top, 2)
            Text(text)
                .font(.caption)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .background(color.opacity(0.08))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func paymentButton(_ name: String, method: PaymentMethod) -> some View {
        Button {
            selectedPayment = method
        } label: {
            HStack {
                Image(systemName: method.icon)
                    .foregroundColor(AppTheme.primary)
                Text(name)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(10)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(8)
        }
    }
    
    private func propertyTypeRow(name: String, description: String, example: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .font(.caption.bold())
                .foregroundColor(color)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(color.opacity(0.1))
                .cornerRadius(4)
            Text(description)
                .font(.caption)
                .foregroundColor(.primary)
            Text(example)
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(.secondary)
                .padding(4)
                .background(Color(.tertiarySystemGroupedBackground))
                .cornerRadius(4)
        }
    }
    
    private func computedValueBadge(label: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(label).font(.system(size: 9)).foregroundColor(.secondary)
            Text(value)
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(color.opacity(0.08))
        .cornerRadius(8)
    }
    
    private func accessLevelRow(level: String, scope: String, emoji: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(emoji)
                .font(.caption)
            VStack(alignment: .leading, spacing: 2) {
                Text(level)
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(color)
                Text(scope)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    private var structClassComparisonView: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading, spacing: 6) {
                Text("struct (Value)")
                    .font(.caption.bold())
                    .foregroundColor(AppTheme.success)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppTheme.success.opacity(0.1))
                    .cornerRadius(6)
                svcItem("✅ Stack allocated (fast)")
                svcItem("✅ Copy on assignment")
                svcItem("✅ Thread-safe by default")
                svcItem("✅ No deinit needed")
                svcItem("❌ No inheritance")
                svcItem("❌ mutating func needed")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("class (Reference)")
                    .font(.caption.bold())
                    .foregroundColor(AppTheme.warning)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppTheme.warning.opacity(0.1))
                    .cornerRadius(6)
                svcItem("⚠️ Heap allocated (slower)")
                svcItem("⚠️ Shared reference")
                svcItem("⚠️ Needs synchronization")
                svcItem("✅ Has deinit (cleanup)")
                svcItem("✅ Supports inheritance")
                svcItem("✅ No mutating needed")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func svcItem(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10))
            .foregroundColor(.primary)
    }
}
