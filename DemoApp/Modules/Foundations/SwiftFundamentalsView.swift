import SwiftUI

// MARK: - Level 1: Swift Fundamentals (Complete Deep Dive)

struct SwiftFundamentalsView: View {
    @State private var selectedTab = 0
    
    // Optionals Lab State
    @State private var optionalTestValue: String? = "Anurag"
    @State private var playgroundLogs: [String] = []
    
    // Type Inference Playground
    @State private var inferenceInput: String = "42"
    @State private var typeLogs: [String] = []
    
    // Functions Playground
    @State private var funcLogs: [String] = []
    @State private var inoutA: Int = 10
    @State private var inoutB: Int = 20
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Banner
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        ZStack {
                            Circle().fill(Color.blue.opacity(0.15)).frame(width: 44, height: 44)
                            Text("L1").font(.headline.bold()).foregroundColor(.blue)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Level 1: Swift Foundations")
                                .font(.title2.bold())
                            Text("Data Types, let/var, Control Flow, Functions & Optionals")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    Text("The bedrock of iOS programming. Master type safety, immutability, pattern matching, parameter passing, and how Swift solves the 'billion-dollar mistake' with Optionals.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.blue.opacity(0.08))
                .cornerRadius(16)

                // Subtopic Picker
                Picker("Topic", selection: $selectedTab) {
                    Text("Data Types").tag(0)
                    Text("Optionals").tag(1)
                    Text("Control Flow").tag(2)
                    Text("Functions").tag(3)
                }
                .pickerStyle(.segmented)

                switch selectedTab {
                case 0:
                    dataTypesSection
                case 1:
                    optionalsSection
                case 2:
                    controlFlowSection
                case 3:
                    functionsSection
                default:
                    EmptyView()
                }
            }
            .padding()
        }
        .navigationTitle("Level 1: Foundations")
        .navigationBarTitleDisplayMode(.inline)
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 1. Data Types & Mutability (Deep Dive)
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @ViewBuilder
    private var dataTypesSection: some View {
        
        // Card 1: Core Primitive Types
        ConceptCard(
            title: "Core Primitive Types",
            subtitle: "Swift is strongly & statically typed",
            icon: "number.circle.fill",
            iconColor: AppTheme.primary
        ) {
            VStack(alignment: .leading, spacing: 14) {
                
                // Why This Matters
                calloutBox(
                    text: "Unlike Python/JS, Swift checks every type at COMPILE TIME. You cannot accidentally add a String to an Int — the compiler catches it before you even run your app.",
                    icon: "lightbulb.fill",
                    color: AppTheme.warning
                )
                
                VStack(spacing: 8) {
                    typeDetailRow(
                        type: "Int",
                        size: "64-bit on modern Apple hardware",
                        range: "-9,223,372,036,854,775,808 to 9,223,372,036,854,775,807",
                        example: "let age: Int = 28",
                        realWorld: "User age, item count, array indices"
                    )
                    typeDetailRow(
                        type: "Double",
                        size: "64-bit IEEE 754 floating point",
                        range: "~15 significant decimal digits of precision",
                        example: "let latitude: Double = 19.0760",
                        realWorld: "GPS coordinates, financial calculations, animations"
                    )
                    typeDetailRow(
                        type: "Float",
                        size: "32-bit IEEE 754 floating point",
                        range: "~6 significant decimal digits (less precise!)",
                        example: "let opacity: Float = 0.85",
                        realWorld: "Graphics rendering (Metal/SceneKit). Rarely used otherwise."
                    )
                    typeDetailRow(
                        type: "Bool",
                        size: "1-bit logical value",
                        range: "true or false (no 0/1 like C!)",
                        example: "let isLoggedIn: Bool = true",
                        realWorld: "Feature flags, auth state, toggle switches"
                    )
                    typeDetailRow(
                        type: "String",
                        size: "Unicode-compliant character collection",
                        range: "Supports ALL Unicode: emoji, CJK, RTL scripts",
                        example: "let greeting = \"Hello 🇮🇳\"",
                        realWorld: "User input, API responses, UI labels"
                    )
                    typeDetailRow(
                        type: "Character",
                        size: "Single extended grapheme cluster",
                        range: "One visual character (can be multi-byte!)",
                        example: "let emoji: Character = \"👨‍💻\"",
                        realWorld: "Text parsing, cursor manipulation"
                    )
                }
            }
        }
        
        // Card 2: String Deep Dive
        CodeBlockView(
            title: "String Operations You MUST Know",
            code: """
// ═══ String Interpolation ═══
let name = "Anurag"
let age = 28
let bio = "\\(name) is \\(age) years old"
// Result: "Anurag is 28 years old"

// ═══ Multi-line Strings ═══
let json = \"\"\"
{
    "user": "\\(name)",
    "active": true
}
\"\"\"

// ═══ String is a Collection of Characters ═══
let word = "Swift"
print(word.count)        // 5
print(word.first!)       // "S"
print(word.last!)        // "t"
print(word.reversed())   // ["t", "f", "i", "w", "S"]

// ═══ Why String Indexing is NOT Int-based ═══
// ❌ word[0]  — This CRASHES! Swift strings are NOT arrays.
// ✅ word[word.startIndex]  — Correct way
// 
// WHY? Because emoji like "👨‍👩‍👧" is actually 5 Unicode scalars
// but counts as 1 Character. Int indexing would be misleading.
let family = "👨‍👩‍👧"
print(family.count)                // 1 (one visible character)
print(family.unicodeScalars.count) // 5 (five code points!)

// ═══ Useful String Methods ═══
let email = "  User@Gmail.COM  "
print(email.trimmingCharacters(in: .whitespaces))  // "User@Gmail.COM"
print(email.lowercased())                           // "  user@gmail.com  "
print(email.contains("@"))                          // true
print(email.replacingOccurrences(of: "Gmail", with: "iCloud"))
"""
        )
        
        // Card 3: let vs var (Deep Dive)
        ConceptCard(
            title: "let (Constant) vs var (Variable)",
            subtitle: "Immutability is Swift's FIRST defense",
            icon: "lock.fill",
            iconColor: AppTheme.success
        ) {
            VStack(alignment: .leading, spacing: 12) {
                
                calloutBox(
                    text: "Rule of Thumb: ALWAYS start with 'let'. Only change to 'var' when the compiler complains that you're trying to mutate it. This prevents entire categories of bugs.",
                    icon: "star.fill",
                    color: AppTheme.success
                )
                
                VStack(alignment: .leading, spacing: 8) {
                    comparisonRow(
                        left: "let (Immutable)",
                        right: "var (Mutable)",
                        leftItems: [
                            "Value CANNOT change after assignment",
                            "Thread-safe by default (no data races)",
                            "Compiler optimizes more aggressively",
                            "Signals intent: 'This will never change'"
                        ],
                        rightItems: [
                            "Value CAN be reassigned freely",
                            "Needs synchronization in concurrency",
                            "Compiler must track potential mutations",
                            "Signals intent: 'This WILL be modified'"
                        ],
                        leftColor: AppTheme.success,
                        rightColor: AppTheme.warning
                    )
                }
            }
        }
        
        CodeBlockView(
            title: "let vs var — Real World Examples",
            code: """
// ═══ Constants (let) — Things That Should NEVER Change ═══
let apiBaseURL = "https://api.myapp.com/v2"   // API endpoint
let maxRetryCount = 3                          // Config constant  
let taxRate = 0.18                             // GST rate

// ═══ Variables (var) — Things That WILL Change ═══
var currentUser: String? = nil    // Will be set after login
var itemsInCart = 0               // Changes as user shops
var isLoading = false             // Toggle during API call

// ═══ The Subtle Difference with Reference Types ═══
// Even with 'let', a CLASS instance's PROPERTIES can change!
class User {
    var name: String              // Property is var → mutable
    init(name: String) { self.name = name }
}

let user = User(name: "Anurag")  // 'let' = pointer can't change
user.name = "Arwalkar"           // ✅ WORKS! Property is var
// user = User(name: "New")      // ❌ FAILS! Can't reassign let

// But with STRUCTS, let makes EVERYTHING immutable:
struct Point {
    var x: Int
    var y: Int
}
let origin = Point(x: 0, y: 0)
// origin.x = 5                  // ❌ FAILS! Struct is let
"""
        )
        
        // Card 4: Type Inference
        ConceptCard(
            title: "Type Inference Engine",
            subtitle: "How Swift guesses types at compile time",
            icon: "brain.filled.head.profile",
            iconColor: AppTheme.purple
        ) {
            VStack(alignment: .leading, spacing: 12) {
                BulletPoint(text: "Swift's compiler analyzes the RIGHT side of '=' to infer the type automatically.")
                BulletPoint(text: "You can ALWAYS add explicit types for clarity: let age: Int = 28")
                BulletPoint(text: "Type inference happens at COMPILE TIME — zero runtime cost.")
                BulletPoint(text: "Integer literals default to Int, decimal literals default to Double.")
            }
        }
        
        CodeBlockView(
            title: "Type Inference — What Swift Sees",
            code: """
// What YOU write           → What COMPILER infers
let score = 100             // → Int (integer literal → Int)
let pi = 3.14159            // → Double (decimal → Double, NOT Float!)
let name = "Swift"          // → String
let flag = true             // → Bool
let mixed = 3 + 0.14        // → Double (Int promoted to Double)

// ═══ When Inference Can FAIL ═══
// let x = nil              // ❌ Error: Can't infer type from nil
let x: String? = nil        // ✅ Must specify type

// ═══ Type Aliases (Readability) ═══
typealias UserID = String
typealias Latitude = Double
typealias Longitude = Double

let userId: UserID = "usr_29x8f"
let lat: Latitude = 19.0760
let lng: Longitude = 72.8777

// ═══ Numeric Literals — Readability Trick ═══
let oneMillion = 1_000_000      // Underscores for readability
let creditLimit = 50_000.00     // Works with decimals too
let binary = 0b1010_1100        // Binary literal
let hex = 0xFF_AA_00            // Hex color literal
"""
        )
        
        // Card 5: Tuples Deep Dive
        ConceptCard(
            title: "Tuples — Lightweight Value Groups",
            subtitle: "Multiple return values without creating a struct",
            icon: "rectangle.split.2x1.fill",
            iconColor: AppTheme.accent
        ) {
            VStack(alignment: .leading, spacing: 12) {
                BulletPoint(text: "Tuples group multiple values into a single compound value.")
                BulletPoint(text: "Named elements make code self-documenting: (statusCode: 200, message: \"OK\")")
                BulletPoint(text: "Perfect for functions that need to return multiple values.")
                BulletPoint(text: "NOT suitable for complex data — use struct/class instead.", color: AppTheme.warning)
            }
        }
        
        CodeBlockView(
            title: "Tuples — Complete Guide",
            code: """
// ═══ Basic Tuple ═══
let httpResponse = (200, "OK")
print(httpResponse.0)  // 200  (access by index)
print(httpResponse.1)  // "OK"

// ═══ Named Tuple (Preferred — Self-Documenting) ═══
let response: (statusCode: Int, message: String, data: Data?) = (
    statusCode: 200,
    message: "Success",
    data: nil
)
print(response.statusCode)  // 200 (access by name ✅)

// ═══ Decomposing (Destructuring) a Tuple ═══
let (code, message, _) = response  // _ ignores 'data'
print("\\(code): \\(message)")       // "200: Success"

// ═══ Real-World: Function Returning Multiple Values ═══
func parseFullName(_ fullName: String) -> (first: String, last: String) {
    let parts = fullName.split(separator: " ")
    return (
        first: String(parts.first ?? ""),
        last: String(parts.last ?? "")
    )
}

let name = parseFullName("Anurag Arwalkar")
print(name.first)  // "Anurag"
print(name.last)   // "Arwalkar"

// ═══ Tuple Comparison ═══
let a = (1, "apple")
let b = (1, "apple")
print(a == b)  // true (compares element-by-element)
"""
        )
        
        // Card 6: Collections Overview
        ConceptCard(
            title: "Collections — Array, Dictionary, Set",
            subtitle: "The three primary collection types",
            icon: "square.stack.3d.down.right.fill",
            iconColor: Color.orange
        ) {
            VStack(alignment: .leading, spacing: 12) {
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Array — Ordered, Duplicates Allowed")
                        .font(.caption.bold())
                        .foregroundColor(.orange)
                    BulletPoint(text: "Indexed access: O(1) random access by position.")
                    BulletPoint(text: "Append: O(1) amortized. Insert at middle: O(n).")
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Dictionary — Key-Value Pairs, Unordered")
                        .font(.caption.bold())
                        .foregroundColor(.purple)
                    BulletPoint(text: "Lookup by key: O(1) average. Keys must be Hashable.")
                    BulletPoint(text: "Returns Optional — key might not exist!")
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Set — Unique Values, Unordered")
                        .font(.caption.bold())
                        .foregroundColor(.teal)
                    BulletPoint(text: "Contains check: O(1). Perfect for uniqueness checks.")
                    BulletPoint(text: "Supports mathematical set ops: union, intersection, subtract.")
                }
            }
        }
        
        CodeBlockView(
            title: "Collections — Real-World Patterns",
            code: """
// ═══ Array — Ordered List ═══
var cart: [String] = ["iPhone", "AirPods"]
cart.append("MacBook")           // ["iPhone", "AirPods", "MacBook"]
cart.insert("iPad", at: 1)       // ["iPhone", "iPad", "AirPods", "MacBook"]
cart.remove(at: 0)               // ["iPad", "AirPods", "MacBook"]
print(cart.contains("AirPods"))  // true
print(cart.count)                // 3

// Higher-order functions (covered in Level 3)
let prices = [999, 199, 1299]
let total = prices.reduce(0, +)           // 2497
let expensive = prices.filter { $0 > 500 } // [999, 1299]

// ═══ Dictionary — Key-Value Store ═══
var userProfile: [String: Any] = [
    "name": "Anurag",
    "age": 28,
    "isPremium": true
]
// Access returns Optional! (key might not exist)
if let name = userProfile["name"] as? String {
    print(name)  // "Anurag"
}
userProfile["city"] = "Mumbai"  // Add new key
userProfile["age"] = nil        // Remove key

// ═══ Set — Unique Collection ═══
var skills: Set<String> = ["Swift", "UIKit", "SwiftUI"]
skills.insert("Swift")   // No duplicate! Still 3 elements
skills.insert("Combine")
let otherSkills: Set = ["Swift", "React", "Flutter"]

let common = skills.intersection(otherSkills)   // {"Swift"}
let allSkills = skills.union(otherSkills)        // 6 unique
let onlyMine = skills.subtracting(otherSkills)   // {"UIKit", "SwiftUI", "Combine"}
"""
        )
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 2. Optionals In-Depth (Complete Guide)
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @ViewBuilder
    private var optionalsSection: some View {
        
        // Card 1: What ARE Optionals?
        ConceptCard(
            title: "What Are Optionals? (The WHY)",
            subtitle: "Swift's answer to null pointer crashes",
            icon: "questionmark.diamond.fill",
            iconColor: AppTheme.accent
        ) {
            VStack(alignment: .leading, spacing: 12) {
                
                calloutBox(
                    text: "In Objective-C, Java, and JavaScript, ANY variable could be nil/null at any time, causing runtime crashes. Tony Hoare (inventor of null) called this his 'billion-dollar mistake'. Swift Optionals force you to EXPLICITLY handle the absence of a value AT COMPILE TIME.",
                    icon: "exclamationmark.triangle.fill",
                    color: AppTheme.error
                )
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Under the Hood — Optional is Just an Enum!")
                        .font(.caption.bold())
                        .foregroundColor(AppTheme.primary)
                    Text("Optional<String> is syntactic sugar for:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        
        CodeBlockView(
            title: "Optional is an Enum (Mind-Blowing!)",
            code: """
// This is what Optional ACTUALLY is in Swift's source code:
enum Optional<Wrapped> {
    case none           // ← This is nil
    case some(Wrapped)  // ← This wraps the actual value
}

// So when you write:
var name: String? = "Anurag"
// The compiler sees:
var name: Optional<String> = .some("Anurag")

// And when you write:
name = nil
// The compiler sees:
name = .none

// That's why you can pattern-match optionals with switch:
switch name {
case .some(let value):
    print("Has value: \\(value)")
case .none:
    print("Is nil")
}
"""
        )
        
        // Card 2: Interactive Unwrapping Lab
        ConceptCard(
            title: "Live Optionals Unwrapping Lab",
            subtitle: "Try all 7 unwrapping methods interactively",
            icon: "play.circle.fill",
            iconColor: AppTheme.accent
        ) {
            VStack(alignment: .leading, spacing: 14) {
                // Current value display
                HStack {
                    Text("Optional Value:")
                        .font(.caption.bold())
                    Spacer()
                    Text(optionalTestValue == nil ? "nil (.none)" : "Optional(\"\(optionalTestValue!)\")")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(optionalTestValue == nil ? Color.red.opacity(0.15) : Color.green.opacity(0.15))
                        .foregroundColor(optionalTestValue == nil ? .red : .green)
                        .cornerRadius(4)
                }

                // Set/Clear buttons
                HStack(spacing: 8) {
                    Button("Set \"Anurag\"") {
                        optionalTestValue = "Anurag"
                        playgroundLogs.append("📦 Set to Optional(\"Anurag\")")
                    }
                    .font(.caption).buttonStyle(.bordered)

                    Button("Set nil") {
                        optionalTestValue = nil
                        playgroundLogs.append("📭 Set to nil (.none)")
                    }
                    .font(.caption).buttonStyle(.bordered).tint(.red)
                }

                // Unwrapping Methods
                VStack(spacing: 6) {
                    unwrapButton("1. if let (Safe Bind)", color: AppTheme.success) {
                        if let value = optionalTestValue {
                            playgroundLogs.append("✅ [if let] Safely unwrapped: \"\(value)\"")
                            playgroundLogs.append("   → 'value' exists ONLY inside this if block")
                        } else {
                            playgroundLogs.append("⚠️ [if let] Was nil — else branch executed safely")
                        }
                    }
                    
                    unwrapButton("2. guard let (Early Exit)", color: AppTheme.primary) {
                        // Simulating guard behavior
                        guard let value = optionalTestValue else {
                            playgroundLogs.append("🚪 [guard let] Was nil — would RETURN/THROW here")
                            playgroundLogs.append("   → Function stops early. No pyramid of doom!")
                            return
                        }
                        playgroundLogs.append("✅ [guard let] Unwrapped: \"\(value)\"")
                        playgroundLogs.append("   → 'value' available for REST of the function scope!")
                    }
                    
                    unwrapButton("3. ?? Nil-Coalescing (Fallback)", color: AppTheme.purple) {
                        let result = optionalTestValue ?? "DefaultGuest"
                        playgroundLogs.append("🛡️ [??] Result: \"\(result)\"")
                        playgroundLogs.append("   → If nil, uses the fallback value after ??")
                    }
                    
                    unwrapButton("4. ?. Optional Chaining", color: AppTheme.secondary) {
                        let uppercased = optionalTestValue?.uppercased()
                        playgroundLogs.append("🔗 [?.] Chained .uppercased() → \(uppercased.map { "\"\($0)\"" } ?? "nil")")
                        playgroundLogs.append("   → If nil, entire chain returns nil (no crash!)")
                        
                        let count = optionalTestValue?.count
                        playgroundLogs.append("🔗 [?.] Chained .count → \(count.map { String($0) } ?? "nil")")
                    }
                    
                    unwrapButton("5. Force Unwrap ! (DANGEROUS)", color: AppTheme.error) {
                        if optionalTestValue != nil {
                            playgroundLogs.append("💥 [!] Force unwrapped: \"\(optionalTestValue!)\"")
                            playgroundLogs.append("   → Only passed because it's NOT nil right now")
                        } else {
                            playgroundLogs.append("🚨 [CRASH] Fatal error: Unexpectedly found nil while unwrapping!")
                            playgroundLogs.append("   → In a real app, this CRASHES and kills the app!")
                        }
                    }
                    
                    unwrapButton("6. switch Pattern Match", color: AppTheme.warning) {
                        switch optionalTestValue {
                        case .some(let value):
                            playgroundLogs.append("🎯 [switch .some] Matched value: \"\(value)\"")
                        case .none:
                            playgroundLogs.append("🎯 [switch .none] Matched nil case")
                        }
                        playgroundLogs.append("   → Remember: Optional is just an enum!")
                    }
                    
                    unwrapButton("7. if let SHORTHAND (Swift 5.7+)", color: AppTheme.accent) {
                        // Swift 5.7 shorthand: if let optionalTestValue {
                        if let optionalTestValue {
                            playgroundLogs.append("✨ [if let shorthand] Value: \"\(optionalTestValue)\"")
                            playgroundLogs.append("   → Swift 5.7+: Same name, no need for '= optionalTestValue'")
                        } else {
                            playgroundLogs.append("⚠️ [if let shorthand] Was nil")
                        }
                    }
                }

                InteractiveLogBox(logs: playgroundLogs, onClear: { playgroundLogs.removeAll() })
            }
        }
        
        // Card 3: When to Use What
        ConceptCard(
            title: "Which Unwrapping Method to Use? (Decision Guide)",
            subtitle: "Interview cheat sheet",
            icon: "arrow.triangle.branch",
            iconColor: AppTheme.warning
        ) {
            VStack(alignment: .leading, spacing: 10) {
                decisionRow(method: "if let / if let shorthand", when: "You need to use the value in a small block. Most common.")
                decisionRow(method: "guard let", when: "You want early exit if nil. Keeps code flat (no nesting). Preferred in functions.")
                decisionRow(method: "?? Nil Coalescing", when: "You want a default fallback value. Great for UI labels.")
                decisionRow(method: "?. Optional Chaining", when: "You want to call a method/property only if not nil. Chain multiple: user?.profile?.avatar?.url")
                decisionRow(method: "Force Unwrap (!)", when: "You are 100% certain it's not nil (e.g., @IBOutlet, hardcoded URL). Use sparingly!", isWarning: true)
                decisionRow(method: "switch pattern", when: "When you need to handle both cases with complex logic, or when working with nested optionals.")
            }
        }
        
        // Card 4: Real-World Optional Patterns
        CodeBlockView(
            title: "Real-World Optional Patterns (Production Code)",
            code: """
// ═══ Pattern 1: API Response Handling ═══
struct APIResponse {
    let data: Data?
    let error: Error?
}

func handleResponse(_ response: APIResponse) {
    // guard let for early exit — keeps code flat
    guard let data = response.data else {
        print("No data received")
        return
    }
    // 'data' is safely unwrapped here
    processData(data)
}

// ═══ Pattern 2: Optional Chaining (3 levels deep!) ═══
struct App {
    var currentUser: User?
}
struct User {
    var profile: Profile?
}
struct Profile {
    var avatar: URL?
}

let app = App(currentUser: nil)
// Instead of nested if-lets:
let avatarURL = app.currentUser?.profile?.avatar
// avatarURL is nil — no crash! The chain short-circuits.

// ═══ Pattern 3: Nil-Coalescing for UI ═══
let username = currentUser?.name ?? "Anonymous"
let profileImage = user?.avatarURL ?? URL(string: "https://placeholder.com")!

// ═══ Pattern 4: map & flatMap on Optionals ═══
let optionalNumber: Int? = 42
let doubled = optionalNumber.map { $0 * 2 }   // Optional(84)
let nilNumber: Int? = nil
let result = nilNumber.map { $0 * 2 }         // nil

// flatMap unwraps nested optionals:
let stringNumber: String? = "42"
let parsed = stringNumber.flatMap { Int($0) }  // Optional(42)
// Without flatMap: Optional(Optional(42)) — double wrapped!
"""
        )
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 3. Control Flow & Guard (Complete Guide)
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @ViewBuilder
    private var controlFlowSection: some View {
        
        // Card 1: guard vs if-let Visual Comparison
        ConceptCard(
            title: "guard let vs if let — The Core Difference",
            subtitle: "This is asked in EVERY iOS interview",
            icon: "arrow.triangle.branch",
            iconColor: AppTheme.purple
        ) {
            VStack(alignment: .leading, spacing: 12) {
                
                calloutBox(
                    text: "guard let unwraps the value into the OUTER scope (available for rest of function). if let unwraps into the INNER scope (only inside the braces). guard MUST have an else that exits (return/throw/break).",
                    icon: "brain.filled.head.profile",
                    color: AppTheme.primary
                )
                
                comparisonRow(
                    left: "if let (Scoped Inside)",
                    right: "guard let (Scoped Outside)",
                    leftItems: [
                        "Unwrapped value ONLY inside { }",
                        "No requirement to exit in else",
                        "Can lead to nested indentation",
                        "Good for: optional blocks of logic"
                    ],
                    rightItems: [
                        "Unwrapped value for REST of function",
                        "MUST exit in else (return/throw)",
                        "Keeps code flat & readable",
                        "Good for: validation at top of func"
                    ],
                    leftColor: AppTheme.primary,
                    rightColor: AppTheme.success
                )
            }
        }
        
        CodeBlockView(
            title: "guard let vs if let — Side by Side",
            code: """
// ═══ BAD: Nested if-let (Pyramid of Doom) ═══
func processOrderBad(userId: String?, productId: String?, qty: Int?) {
    if let userId = userId {
        if let productId = productId {
            if let qty = qty {
                if qty > 0 {
                    // Finally do work here... deeply nested!
                    print("Order: \\(userId) buys \\(qty)x \\(productId)")
                }
            }
        }
    }
}

// ═══ GOOD: guard let (Flat & Clean) ═══
func processOrderGood(userId: String?, productId: String?, qty: Int?) {
    guard let userId = userId else {
        print("Error: Missing user ID")
        return  // ← MUST exit scope
    }
    guard let productId = productId else {
        print("Error: Missing product ID")
        return
    }
    guard let qty = qty, qty > 0 else {
        print("Error: Invalid quantity")
        return
    }
    // All values safely unwrapped and available here!
    // No nesting, easy to read, easy to debug.
    print("Order: \\(userId) buys \\(qty)x \\(productId)")
}
"""
        )
        
        // Card 2: Switch Deep Dive
        ConceptCard(
            title: "switch Statement — Way More Powerful Than You Think",
            subtitle: "Exhaustive pattern matching, not just if-else chains",
            icon: "arrow.triangle.swap",
            iconColor: AppTheme.secondary
        ) {
            VStack(alignment: .leading, spacing: 12) {
                BulletPoint(text: "Exhaustive: The compiler FORCES you to handle all possible cases. Prevents missing edge cases.")
                BulletPoint(text: "No Implicit Fallthrough: Unlike C/Java, each case auto-breaks. Use 'fallthrough' keyword explicitly if needed.")
                BulletPoint(text: "Supports: ranges (1...100), tuples, enums, 'where' clauses, value binding.")
                BulletPoint(text: "Compound Cases: Combine multiple cases with comma: case .success, .cached:")
            }
        }
        
        CodeBlockView(
            title: "switch — Advanced Pattern Matching",
            code: """
// ═══ 1. Range Matching ═══
let httpStatus = 404
switch httpStatus {
case 200..<300:
    print("Success")
case 300..<400:
    print("Redirect")
case 400..<500:
    print("Client Error")     // ← This matches
case 500..<600:
    print("Server Error")
default:
    print("Unknown")
}

// ═══ 2. Tuple Pattern Matching ═══
let point = (x: 3, y: 0)
switch point {
case (0, 0):
    print("Origin")
case (_, 0):                  // _ means "any value"
    print("On X-axis")        // ← This matches (y is 0)
case (0, _):
    print("On Y-axis")
case let (x, y) where x == y:
    print("On the diagonal")
default:
    print("Somewhere else: (\\(point.x), \\(point.y))")
}

// ═══ 3. Enum with Associated Value Extraction ═══
enum NetworkResult {
    case success(data: Data, statusCode: Int)
    case failure(error: Error)
    case loading(progress: Double)
}

let result: NetworkResult = .success(data: Data(), statusCode: 200)
switch result {
case .success(let data, let code) where code == 200:
    print("OK with \\(data.count) bytes")
case .success(_, let code):
    print("Success but non-200: \\(code)")
case .failure(let error):
    print("Failed: \\(error.localizedDescription)")
case .loading(let progress) where progress > 0.9:
    print("Almost done: \\(Int(progress * 100))%")
case .loading(let progress):
    print("Loading: \\(Int(progress * 100))%")
}

// ═══ 4. where Clause Filtering ═══
let numbers = [1, -3, 5, -2, 8]
for number in numbers {
    switch number {
    case let n where n > 0:
        print("\\(n) is positive")
    case let n where n < 0:
        print("\\(n) is negative")
    default:
        print("zero")
    }
}
"""
        )
        
        // Card 3: for-in and while
        ConceptCard(
            title: "Loops — for-in, while, repeat-while",
            subtitle: "Iteration patterns in Swift",
            icon: "arrow.triangle.2.circlepath",
            iconColor: AppTheme.warning
        ) {
            VStack(alignment: .leading, spacing: 10) {
                BulletPoint(text: "for-in: Iterates over sequences (Arrays, Ranges, Dictionaries, Strings).")
                BulletPoint(text: "while: Checks condition BEFORE each iteration.")
                BulletPoint(text: "repeat-while: Executes body FIRST, then checks (like do-while in C/Java). Guarantees at least one execution.")
                BulletPoint(text: "stride(from:to:by:): Step through ranges with custom increments.")
                BulletPoint(text: "labeled statements: break/continue from specific nested loop using labels.")
            }
        }
        
        CodeBlockView(
            title: "Loops — Patterns You'll Use Daily",
            code: """
// ═══ for-in with enumerated() (index + value) ═══
let fruits = ["🍎", "🍊", "🍇"]
for (index, fruit) in fruits.enumerated() {
    print("\\(index): \\(fruit)")   // 0: 🍎, 1: 🍊, 2: 🍇
}

// ═══ for-in with where clause (filtering) ═══
for i in 1...20 where i % 3 == 0 {
    print(i)  // 3, 6, 9, 12, 15, 18
}

// ═══ stride — Custom Step Size ═══
for temp in stride(from: 0, through: 100, by: 25) {
    print("\\(temp)°C")  // 0, 25, 50, 75, 100
}

// ═══ Iterating a Dictionary ═══
let scores = ["Alice": 95, "Bob": 87, "Charlie": 92]
for (name, score) in scores.sorted(by: { $0.value > $1.value }) {
    print("\\(name): \\(score)")
}

// ═══ Labeled Statements (Break Outer Loop) ═══
outerLoop: for i in 1...5 {
    for j in 1...5 {
        if i * j > 10 {
            print("Breaking at \\(i) × \\(j) = \\(i * j)")
            break outerLoop  // Breaks the OUTER loop
        }
    }
}
"""
        )
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 4. Functions & inout (Complete Guide)
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @ViewBuilder
    private var functionsSection: some View {
        
        // Card 1: Function Anatomy
        ConceptCard(
            title: "Function Anatomy — Every Piece Explained",
            subtitle: "Argument labels, return types, and overloading",
            icon: "function",
            iconColor: AppTheme.warning
        ) {
            VStack(alignment: .leading, spacing: 12) {
                
                calloutBox(
                    text: "Swift functions have DUAL names: an external label (for readability at call site) and an internal parameter name (for use inside the body). This makes Swift APIs read like English sentences.",
                    icon: "text.book.closed.fill",
                    color: AppTheme.primary
                )
                
                BulletPoint(text: "Parameters are CONSTANTS (let) by default — you cannot modify them inside the function body.")
                BulletPoint(text: "Use _ to suppress the external label: func add(_ a: Int, _ b: Int)")
                BulletPoint(text: "Default values: func connect(timeout: Int = 30) — no need to pass if using default.")
                BulletPoint(text: "Variadic: func sum(_ numbers: Int...) — accepts 0 or more values as an array.")
            }
        }
        
        CodeBlockView(
            title: "Function Signatures — All Forms",
            code: """
// ═══ 1. External vs Internal Labels ═══
// func name(externalLabel internalName: Type) -> ReturnType

func send(message text: String, to recipient: String) {
    print("Sending '\\(text)' to \\(recipient)")
}
send(message: "Hello", to: "Anurag")
// Reads like English: "send message 'Hello' to Anurag"

// ═══ 2. Suppress External Label with _ ═══
func add(_ a: Int, _ b: Int) -> Int {
    return a + b
}
let sum = add(3, 5)  // Cleaner: no labels needed

// ═══ 3. Default Parameter Values ═══
func fetchData(
    from url: String,
    timeout: TimeInterval = 30,
    retries: Int = 3,
    cachePolicy: String = "default"
) {
    print("Fetching \\(url) (timeout: \\(timeout)s, retries: \\(retries))")
}
// All of these are valid calls:
fetchData(from: "https://api.com/users")
fetchData(from: "https://api.com/users", timeout: 60)
fetchData(from: "https://api.com/users", retries: 5)

// ═══ 4. Variadic Parameters ═══
func average(_ numbers: Double...) -> Double {
    guard !numbers.isEmpty else { return 0 }
    return numbers.reduce(0, +) / Double(numbers.count)
}
print(average(10, 20, 30))  // 20.0
print(average(85.5, 92.3))  // 88.9

// ═══ 5. Multiple Return Values (Tuple) ═══
func minMax(in array: [Int]) -> (min: Int, max: Int)? {
    guard let first = array.first else { return nil }
    var min = first, max = first
    for value in array.dropFirst() {
        if value < min { min = value }
        if value > max { max = value }
    }
    return (min: min, max: max)
}
if let bounds = minMax(in: [3, 1, 7, 2, 9]) {
    print("Min: \\(bounds.min), Max: \\(bounds.max)")
}
"""
        )
        
        // Card 2: inout Parameters (Interactive)
        ConceptCard(
            title: "inout — Modifying Values Inside Functions",
            subtitle: "Pass-by-value vs Pass-by-reference (inout)",
            icon: "arrow.left.arrow.right",
            iconColor: AppTheme.error
        ) {
            VStack(alignment: .leading, spacing: 14) {
                
                calloutBox(
                    text: "By default, Swift passes ALL parameters by value (a copy). With 'inout', the function can modify the original variable. You MUST prefix the argument with '&' at the call site to signal mutation.",
                    icon: "exclamationmark.triangle.fill",
                    color: AppTheme.error
                )
                
                // Interactive swap demo
                HStack {
                    VStack(spacing: 4) {
                        Text("Variable a").font(.caption2).foregroundColor(.secondary)
                        Text("\(inoutA)")
                            .font(.title2.bold())
                            .foregroundColor(AppTheme.primary)
                            .frame(width: 60, height: 60)
                            .background(AppTheme.primary.opacity(0.1))
                            .cornerRadius(12)
                    }
                    
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 4) {
                        Text("Variable b").font(.caption2).foregroundColor(.secondary)
                        Text("\(inoutB)")
                            .font(.title2.bold())
                            .foregroundColor(AppTheme.purple)
                            .frame(width: 60, height: 60)
                            .background(AppTheme.purple.opacity(0.1))
                            .cornerRadius(12)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Button("Swap (&a, &b)") {
                            funcLogs.append("📍 Before: a=\(inoutA), b=\(inoutB)")
                            let temp = inoutA
                            inoutA = inoutB
                            inoutB = temp
                            funcLogs.append("🔄 swapValues(&a, &b) called")
                            funcLogs.append("✅ After:  a=\(inoutA), b=\(inoutB)")
                        }
                        .font(.caption.bold())
                        .buttonStyle(.borderedProminent)
                        
                        Button("Reset") {
                            inoutA = 10
                            inoutB = 20
                            funcLogs.append("🔁 Reset to a=10, b=20")
                        }
                        .font(.caption)
                        .buttonStyle(.bordered)
                    }
                }
                
                InteractiveLogBox(logs: funcLogs, onClear: { funcLogs.removeAll() })
            }
        }
        
        CodeBlockView(
            title: "inout — How It Works Under the Hood",
            code: """
// ═══ Without inout (Copy-In, does NOT affect original) ═══
func doubleValue(_ x: Int) -> Int {
    // x is a COPY. Original is untouched.
    return x * 2
}
var num = 5
let result = doubleValue(num)  // result = 10, num = still 5

// ═══ With inout (Copy-In Copy-Out) ═══
func doubleInPlace(_ x: inout Int) {
    x = x * 2  // Modifies the ORIGINAL variable!
}
var score = 50
doubleInPlace(&score)  // &score = "I know this will be modified"
print(score)           // 100 — the original changed!

// ═══ Real-World: Sorting In-Place ═══
var leaderboard = ["Charlie", "Alice", "Bob"]
// This is how Swift's .sort() works internally with inout:
func bubbleSort(_ array: inout [String]) {
    for i in 0..<array.count {
        for j in 0..<(array.count - 1 - i) {
            if array[j] > array[j + 1] {
                array.swapAt(j, j + 1)
            }
        }
    }
}
bubbleSort(&leaderboard)
print(leaderboard) // ["Alice", "Bob", "Charlie"]

// ═══ KEY: What You Can NOT Pass as inout ═══
// ❌ Cannot pass a 'let' constant as inout
// let fixed = 10
// doubleInPlace(&fixed)  // ERROR: Cannot pass immutable value

// ❌ Cannot pass a computed property as inout
// ❌ Cannot pass a literal as inout: doubleInPlace(&5)
"""
        )
        
        // Card 3: Functions as First-Class Citizens
        ConceptCard(
            title: "Functions Are First-Class Citizens",
            subtitle: "Store, pass, and return functions like any other value",
            icon: "arrow.right.arrow.left",
            iconColor: AppTheme.accent
        ) {
            VStack(alignment: .leading, spacing: 12) {
                BulletPoint(text: "Functions have a TYPE: (Int, Int) -> Int describes a function taking 2 Ints and returning Int.")
                BulletPoint(text: "You can store functions in variables, arrays, and dictionaries.")
                BulletPoint(text: "You can pass functions as arguments to other functions (Higher-Order Functions).")
                BulletPoint(text: "You can return functions from functions (Function Factories).")
                BulletPoint(text: "This is the foundation for Closures (Level 3) and Functional Programming.")
            }
        }
        
        CodeBlockView(
            title: "Functions as Values — Foundation for Closures",
            code: """
// ═══ 1. Function Types ═══
func add(_ a: Int, _ b: Int) -> Int { a + b }
func multiply(_ a: Int, _ b: Int) -> Int { a * b }

// Store in a variable (type is (Int, Int) -> Int)
var operation: (Int, Int) -> Int = add
print(operation(3, 5))  // 8

operation = multiply
print(operation(3, 5))  // 15

// ═══ 2. Pass Functions as Arguments ═══
func applyOperation(_ a: Int, _ b: Int, using op: (Int, Int) -> Int) -> Int {
    return op(a, b)
}
print(applyOperation(10, 3, using: add))       // 13
print(applyOperation(10, 3, using: multiply))  // 30

// ═══ 3. Return Functions from Functions (Factory) ═══
func makeMultiplier(factor: Int) -> (Int) -> Int {
    func multiplier(number: Int) -> Int {
        return number * factor
    }
    return multiplier
}
let double = makeMultiplier(factor: 2)
let triple = makeMultiplier(factor: 3)
print(double(5))  // 10
print(triple(5))  // 15

// ═══ 4. Array of Functions ═══
let transforms: [(Int) -> Int] = [
    { $0 * 2 },      // double
    { $0 + 10 },     // add 10
    { $0 * $0 }      // square
]
var value = 3
for transform in transforms {
    value = transform(value)
}
print(value)  // ((3 * 2) + 10) * ((3 * 2) + 10) = 256... 
              // Actually: 3→6→16→256
"""
        )
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - Reusable Helper Views
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    private func typeDetailRow(type: String, size: String, range: String, example: String, realWorld: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(type)
                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                    .foregroundColor(AppTheme.primary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(AppTheme.primary.opacity(0.1))
                    .cornerRadius(4)
                Spacer()
                Text(size)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Text(example)
                .font(.system(size: 11, design: .monospaced))
                .foregroundColor(.primary)
                .padding(4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.tertiarySystemGroupedBackground))
                .cornerRadius(4)
            HStack(spacing: 4) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
                Text("Range: \(range)")
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
            }
            HStack(spacing: 4) {
                Image(systemName: "briefcase.fill")
                    .font(.system(size: 9))
                    .foregroundColor(AppTheme.accent)
                Text("Used for: \(realWorld)")
                    .font(.system(size: 9))
                    .foregroundColor(AppTheme.accent)
            }
        }
        .padding(.vertical, 4)
    }
    
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
    
    private func comparisonRow(
        left: String, right: String,
        leftItems: [String], rightItems: [String],
        leftColor: Color, rightColor: Color
    ) -> some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading, spacing: 6) {
                Text(left)
                    .font(.caption.bold())
                    .foregroundColor(leftColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(leftColor.opacity(0.1))
                    .cornerRadius(6)
                ForEach(leftItems, id: \.self) { item in
                    HStack(alignment: .top, spacing: 4) {
                        Text("•").font(.caption).foregroundColor(leftColor)
                        Text(item).font(.system(size: 10)).foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(right)
                    .font(.caption.bold())
                    .foregroundColor(rightColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(rightColor.opacity(0.1))
                    .cornerRadius(6)
                ForEach(rightItems, id: \.self) { item in
                    HStack(alignment: .top, spacing: 4) {
                        Text("•").font(.caption).foregroundColor(rightColor)
                        Text(item).font(.system(size: 10)).foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func unwrapButton(_ title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.caption.bold())
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .tint(color)
    }
    
    private func decisionRow(method: String, when: String, isWarning: Bool = false) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: isWarning ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                .font(.system(size: 12))
                .foregroundColor(isWarning ? AppTheme.error : AppTheme.success)
                .padding(.top, 2)
            VStack(alignment: .leading, spacing: 2) {
                Text(method)
                    .font(.caption.bold())
                    .foregroundColor(isWarning ? AppTheme.error : AppTheme.primary)
                Text(when)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
