import SwiftUI

// MARK: - Level 3a: Closures — Non-Escaping, Escaping, Autoclosure & Capture Lists (Deep Dive)

struct ClosuresView: View {
    @State private var logs: [String] = []
    @State private var counter = 10
    @State private var capturedSnapshot = 0
    @State private var isAsyncRunning = false
    @State private var selectedTab = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        ZStack {
                            Circle().fill(AppTheme.purple.opacity(0.15)).frame(width: 44, height: 44)
                            Text("L3").font(.headline.bold()).foregroundColor(AppTheme.purple)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Level 3a: Closures In-Depth")
                                .font(.title2.bold())
                            Text("The building block of functional programming in Swift")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    Text("Closures are self-contained blocks of functionality that can be passed around. They capture and store references to variables from the surrounding context.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.purple.opacity(0.08))
                .cornerRadius(16)

                Picker("Topic", selection: $selectedTab) {
                    Text("Basics").tag(0)
                    Text("Escaping").tag(1)
                    Text("Capture Lists").tag(2)
                    Text("HOFs").tag(3)
                }
                .pickerStyle(.segmented)

                switch selectedTab {
                case 0: closureBasicsSection
                case 1: escapingSection
                case 2: captureListSection
                case 3: higherOrderSection
                default: EmptyView()
                }
            }
            .padding()
        }
        .navigationTitle("Closures")
        .navigationBarTitleDisplayMode(.inline)
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 1. Closure Basics
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @ViewBuilder
    private var closureBasicsSection: some View {
        
        ConceptCard(
            title: "What IS a Closure?",
            subtitle: "Functions are actually named closures",
            icon: "curlybraces",
            iconColor: AppTheme.purple
        ) {
            VStack(alignment: .leading, spacing: 12) {
                calloutBox(
                    text: "A closure is an unnamed function (a block of code) that you can assign to variables, pass as arguments, and return from functions. In Swift, every function is actually a named closure!",
                    icon: "lightbulb.fill",
                    color: AppTheme.warning
                )
                
                BulletPoint(text: "Closures capture values from their surrounding scope (hence the name 'closure' — they close over variables).")
                BulletPoint(text: "Syntax: { (parameters) -> ReturnType in body }")
                BulletPoint(text: "Trailing closure syntax: When the last parameter is a closure, you can move it outside the parentheses.")
                BulletPoint(text: "Shorthand: $0, $1, $2 for first, second, third parameters.")
            }
        }
        
        CodeBlockView(
            title: "Closure Syntax — From Verbose to Short",
            code: """
// ═══ Step 1: Full Verbose Form ═══
let add: (Int, Int) -> Int = { (a: Int, b: Int) -> Int in
    return a + b
}

// ═══ Step 2: Type Inference (compiler knows the types) ═══
let add2: (Int, Int) -> Int = { a, b in
    return a + b
}

// ═══ Step 3: Implicit Return (single expression) ═══
let add3: (Int, Int) -> Int = { a, b in a + b }

// ═══ Step 4: Shorthand Arguments ($0, $1) ═══
let add4: (Int, Int) -> Int = { $0 + $1 }

// All four are IDENTICAL in behavior!
print(add(3, 5))   // 8
print(add4(3, 5))  // 8

// ═══ Trailing Closure Syntax ═══
let names = ["Charlie", "Alice", "Bob"]

// Without trailing closure:
let sorted1 = names.sorted(by: { (a: String, b: String) -> Bool in
    return a < b
})

// With trailing closure (move closure outside parens):
let sorted2 = names.sorted { $0 < $1 }

// Even shorter (operator as closure):
let sorted3 = names.sorted(by: <)

// All produce: ["Alice", "Bob", "Charlie"]

// ═══ Multiple Trailing Closures (Swift 5.3+) ═══
// UIView.animate(withDuration: 0.3) {
//     view.alpha = 0
// } completion: { finished in
//     view.removeFromSuperview()
// }
"""
        )
        
        // Interactive Non-Escaping Demo
        ConceptCard(
            title: "Live: Non-Escaping Closure Execution",
            subtitle: "Closures execute BEFORE the function returns",
            icon: "play.fill",
            iconColor: AppTheme.success
        ) {
            VStack(spacing: 12) {
                Button("Run Non-Escaping Demo") {
                    executeNonEscaping()
                }
                .font(.caption.bold())
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.success)
                
                InteractiveLogBox(logs: logs, onClear: { logs.removeAll() })
            }
        }

        CodeBlockView(
            title: "Non-Escaping Closures — Default Behavior",
            code: """
// Non-escaping closures execute WITHIN the function lifetime.
// They are the DEFAULT in Swift (no special attribute needed).

func performCalculation(a: Int, b: Int, operation: (Int) -> Void) {
    // ↑ No @escaping — this is non-escaping by default
    print("1️⃣ Function starts")
    operation(a * b)       // Closure runs HERE, before return
    print("3️⃣ Function ends")
}

performCalculation(a: 5, b: 10) { result in
    print("2️⃣ Closure executed: \\(result)")
}

// Output ORDER is ALWAYS:
// 1️⃣ Function starts
// 2️⃣ Closure executed: 50
// 3️⃣ Function ends

// ═══ WHY Non-Escaping is Default ═══
// 1. Compiler can optimize (no heap allocation needed)
// 2. No retain cycle risk (closure doesn't outlive scope)
// 3. No need for 'self.' in classes (no ambiguity)
"""
        )
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 2. Escaping & Autoclosure
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @ViewBuilder
    private var escapingSection: some View {
        
        ConceptCard(
            title: "@escaping — Closure Outlives the Function",
            subtitle: "Required for async callbacks, stored closures",
            icon: "arrow.up.right.circle.fill",
            iconColor: AppTheme.purple
        ) {
            VStack(alignment: .leading, spacing: 12) {
                calloutBox(
                    text: "When a closure is stored in a property, dispatched to a background queue, or used in a completion handler, it 'escapes' the function scope. The compiler requires @escaping so you're explicitly aware this closure will run LATER.",
                    icon: "exclamationmark.triangle.fill",
                    color: AppTheme.purple
                )
                
                BulletPoint(text: "Must be marked @escaping in the function signature.")
                BulletPoint(text: "In classes, requires explicit 'self.' or [weak self] capture list.")
                BulletPoint(text: "Common uses: network callbacks, animations, DispatchQueue.async, stored closures.")
                BulletPoint(text: "Without [weak self], escaping closures can create RETAIN CYCLES (memory leaks)!", color: AppTheme.error)
            }
        }
        
        // Interactive Escaping Demo
        ConceptCard(
            title: "Live: @escaping Async Execution",
            subtitle: "Watch the execution order — closure fires AFTER function returns",
            icon: "play.fill",
            iconColor: AppTheme.purple
        ) {
            VStack(spacing: 12) {
                HStack(spacing: 10) {
                    Button("Run @escaping Demo") {
                        executeEscaping()
                    }
                    .font(.caption.bold())
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.purple)
                    .disabled(isAsyncRunning)
                    
                    if isAsyncRunning {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Waiting for async...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                InteractiveLogBox(logs: logs, onClear: { logs.removeAll() })
            }
        }

        CodeBlockView(
            title: "@escaping — Real-World Network Call",
            code: """
// ═══ Pattern 1: Completion Handler (Most Common) ═══
class NetworkManager {
    func fetchUser(id: String, completion: @escaping (Result<User, Error>) -> Void) {
        // Closure is 'escaping' because it's dispatched to background
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))  // Runs LATER
                return
            }
            guard let data = data else { return }
            let user = try? JSONDecoder().decode(User.self, from: data)
            completion(.success(user!))      // Runs LATER
        }.resume()
        // Function returns HERE immediately, before completion fires
    }
}

// ═══ Pattern 2: Stored Closure Property ═══
class EventEmitter {
    // Storing a closure = it escapes the function that assigned it
    var onEvent: ((String) -> Void)?

    func subscribe(handler: @escaping (String) -> Void) {
        self.onEvent = handler  // Stored → escaping
    }

    func emit(_ event: String) {
        onEvent?(event)  // Fires later when event happens
    }
}

// ═══ Pattern 3: [weak self] to Prevent Retain Cycles ═══
class ViewController {
    var name = "HomeVC"

    func loadData() {
        // ❌ BAD: Strong self → retain cycle!
        // NetworkManager.shared.fetch { data in
        //     self.process(data)  // self holds NetworkManager, 
        //                         // NetworkManager holds closure,
        //                         // closure holds self → LEAK!
        // }

        // ✅ GOOD: [weak self] breaks the cycle
        NetworkManager.shared.fetch { [weak self] data in
            guard let self = self else { return }  // Check if still alive
            self.process(data)
        }
    }
    
    func process(_ data: Data) { /* ... */ }
}
"""
        )
        
        // Autoclosure Section
        ConceptCard(
            title: "@autoclosure — Automatic Wrapping",
            subtitle: "The magic behind assert(), ??, and lazy evaluation",
            icon: "wand.and.stars",
            iconColor: AppTheme.warning
        ) {
            VStack(alignment: .leading, spacing: 12) {
                calloutBox(
                    text: "@autoclosure automatically wraps an expression into a zero-argument closure. This enables lazy evaluation — the expression isn't evaluated until the closure is explicitly called inside the function.",
                    icon: "sparkles",
                    color: AppTheme.warning
                )
                
                BulletPoint(text: "You pass a plain expression (e.g., 2 + 3), NOT a closure { 2 + 3 }.")
                BulletPoint(text: "The compiler silently wraps it in { } for you.")
                BulletPoint(text: "Used by Swift's assert(), precondition(), and ?? operator.")
                BulletPoint(text: "Can be combined with @escaping: @autoclosure @escaping () -> Bool")
            }
        }
        
        CodeBlockView(
            title: "@autoclosure — How It Works",
            code: """
// ═══ Without @autoclosure ═══
func logIfTrue_v1(condition: () -> Bool, message: () -> String) {
    if condition() {
        print(message())  // Only evaluated if condition is true
    }
}
// Ugly call site with curly braces everywhere:
logIfTrue_v1(condition: { 2 > 1 }, message: { "Math works!" })

// ═══ With @autoclosure — Clean Call Site ═══
func logIfTrue(
    condition: @autoclosure () -> Bool,
    message: @autoclosure () -> String
) {
    if condition() {
        print(message())
    }
}
// Beautiful call site — looks like normal arguments:
logIfTrue(condition: 2 > 1, message: "Math works!")
// Compiler wraps each into { 2 > 1 } and { "Math works!" }

// ═══ Real Example: How ?? Works Internally ═══
// This is a simplified version of Swift's ?? operator:
func ?? <T>(optional: T?, defaultValue: @autoclosure () -> T) -> T {
    switch optional {
    case .some(let value):
        return value
    case .none:
        return defaultValue()  // Only evaluated if needed!
    }
}

let name: String? = "Anurag"
let result = name ?? expensiveComputation()
// expensiveComputation() is NEVER called because name has a value!
// Without @autoclosure, it would be called eagerly (wasted work).

// ═══ Real Example: How assert() Works ═══
// assert uses @autoclosure so the condition string
// is only computed if the assertion FAILS:
func myAssert(
    _ condition: @autoclosure () -> Bool,
    _ message: @autoclosure () -> String = "Assertion failed",
    file: String = #file,
    line: Int = #line
) {
    #if DEBUG
    if !condition() {
        print("\\(file):\\(line) — \\(message())")
    }
    #endif
}
myAssert(1 + 1 == 2, "Basic math is broken")
"""
        )
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 3. Capture Lists
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @ViewBuilder
    private var captureListSection: some View {
        
        ConceptCard(
            title: "Capture Lists — [weak self], [value], [unowned self]",
            subtitle: "How closures hold onto variables from outer scope",
            icon: "camera.viewfinder",
            iconColor: AppTheme.primary
        ) {
            VStack(alignment: .leading, spacing: 12) {
                calloutBox(
                    text: "By default, closures capture variables BY REFERENCE. This means if the outer variable changes, the closure sees the new value. Capture lists let you override this behavior — either copying the value at creation time, or using weak/unowned references.",
                    icon: "brain.filled.head.profile",
                    color: AppTheme.primary
                )
                
                VStack(alignment: .leading, spacing: 8) {
                    captureTypeRow(
                        type: "Default (no list)",
                        behavior: "Captures by REFERENCE. Sees latest value. Can cause retain cycles in classes.",
                        example: "{ self.name }",
                        color: AppTheme.warning
                    )
                    Divider()
                    captureTypeRow(
                        type: "[value]",
                        behavior: "Captures by VALUE (copy at creation time). Frozen snapshot. The variable becomes a let constant inside.",
                        example: "{ [counter] in print(counter) }",
                        color: AppTheme.primary
                    )
                    Divider()
                    captureTypeRow(
                        type: "[weak self]",
                        behavior: "Captures self as Optional. Becomes nil if deallocated. Breaks retain cycles. MUST unwrap.",
                        example: "{ [weak self] in self?.update() }",
                        color: AppTheme.success
                    )
                    Divider()
                    captureTypeRow(
                        type: "[unowned self]",
                        behavior: "Like weak but NOT optional. CRASHES if self is deallocated. Use when sure self outlives closure.",
                        example: "{ [unowned self] in self.update() }",
                        color: AppTheme.error
                    )
                }
            }
        }
        
        // Interactive Capture Demo
        ConceptCard(
            title: "Live: Value Capture vs Reference Capture",
            subtitle: "See the difference in real-time",
            icon: "play.circle.fill",
            iconColor: AppTheme.accent
        ) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Outer Counter: \(counter)")
                            .font(.headline)
                        Text("Captured Copy: \(capturedSnapshot)")
                            .font(.subheadline)
                            .foregroundColor(.purple)
                    }
                    Spacer()
                    Button("+ Counter") {
                        counter += 1
                        logs.append("🔼 Outer counter → \(counter) (captured copy unchanged: \(capturedSnapshot))")
                    }
                    .font(.caption.bold()).buttonStyle(.bordered)
                }
                .padding(10)
                .background(Color(.tertiarySystemGroupedBackground))
                .cornerRadius(8)

                HStack(spacing: 10) {
                    Button("Capture [counter]") {
                        let snapshotClosure = { [captured = counter] in
                            captured
                        }
                        capturedSnapshot = snapshotClosure()
                        logs.append("📸 Captured counter = \(capturedSnapshot) (frozen at this moment)")
                        logs.append("   Now increment outer counter and see the difference!")
                    }
                    .font(.caption.bold())
                    .buttonStyle(.borderedProminent)

                    Button("Reset") {
                        counter = 10; capturedSnapshot = 0
                        logs.append("🔁 Reset: counter=10, captured=0")
                    }
                    .font(.caption).buttonStyle(.bordered)
                }

                InteractiveLogBox(logs: logs, onClear: { logs.removeAll() })
            }
        }
        
        CodeBlockView(
            title: "Capture List — All Patterns Explained",
            code: """
// ═══ 1. Default Capture (By Reference) ═══
var counter = 0
let incrementer = {
    counter += 1  // Captures 'counter' by REFERENCE
    print(counter)
}
counter = 100
incrementer()  // Prints 101 (uses current value of counter!)
incrementer()  // Prints 102

// ═══ 2. Value Capture [counter] (Frozen Copy) ═══
var score = 10
let printer = { [score] in  // Copies score = 10 right NOW
    print(score)             // Always prints 10
}
score = 999
printer()  // Still prints 10! The copy was frozen.

// ═══ 3. [weak self] — The Most Important Pattern ═══
class DataLoader {
    var data: [String] = []

    func load() {
        APIClient.fetch { [weak self] result in
            // self is now Optional (String?)
            guard let self = self else {
                print("DataLoader was deallocated, skipping update")
                return
            }
            // self is safely unwrapped here
            self.data = result
        }
    }
    
    deinit {
        print("DataLoader freed — no retain cycle!")
    }
}

// ═══ 4. [unowned self] — When You're CERTAIN ═══
class HTMLElement {
    let name: String
    let text: String?
    
    // 'asHTML' will never outlive self (it's a property of self)
    lazy var asHTML: () -> String = { [unowned self] in
        if let text = self.text {
            return "<\\(self.name)>\\(text)</\\(self.name)>"
        } else {
            return "<\\(self.name) />"
        }
    }
    
    init(name: String, text: String?) {
        self.name = name
        self.text = text
    }
    
    deinit { print("\\(name) is being deinitialized") }
}

// ═══ 5. Multiple Captures ═══
class ViewModel {
    var items: [String] = []
    var delegate: Delegate?
    
    func refresh() {
        service.fetch { [weak self, weak delegate = self.delegate] result in
            self?.items = result
            delegate?.didUpdate()
        }
    }
}
"""
        )
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 4. Higher-Order Functions
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @ViewBuilder
    private var higherOrderSection: some View {
        
        ConceptCard(
            title: "Higher-Order Functions (HOFs)",
            subtitle: "Functions that take or return closures",
            icon: "arrow.triangle.2.circlepath",
            iconColor: AppTheme.accent
        ) {
            VStack(alignment: .leading, spacing: 12) {
                calloutBox(
                    text: "Higher-order functions are the backbone of functional programming in Swift. map, filter, reduce, compactMap, flatMap, sorted, forEach — all take closures as arguments to transform data declaratively.",
                    icon: "sparkles",
                    color: AppTheme.accent
                )
                
                BulletPoint(text: "map: Transform each element → [A] → [B]")
                BulletPoint(text: "filter: Keep elements matching condition → [A] → [A]")
                BulletPoint(text: "reduce: Collapse into single value → [A] → B")
                BulletPoint(text: "compactMap: map + remove nils → [A?] → [B]")
                BulletPoint(text: "flatMap: Flatten nested arrays → [[A]] → [A]")
                BulletPoint(text: "sorted: Return sorted copy with comparison closure")
            }
        }
        
        CodeBlockView(
            title: "HOFs — Complete Real-World Examples",
            code: """
let users = [
    (name: "Alice", age: 28, city: "Mumbai"),
    (name: "Bob", age: 17, city: "Delhi"),
    (name: "Charlie", age: 32, city: "Mumbai"),
    (name: "Diana", age: 24, city: "Bangalore"),
    (name: "Eve", age: 15, city: "Mumbai")
]

// ═══ map — Transform Each Element ═══
let names = users.map { $0.name }
// ["Alice", "Bob", "Charlie", "Diana", "Eve"]

let greetings = users.map { "Hello, \\($0.name)!" }
// ["Hello, Alice!", "Hello, Bob!", ...]

// ═══ filter — Keep Matching Elements ═══
let adults = users.filter { $0.age >= 18 }
// [Alice(28), Charlie(32), Diana(24)]

let mumbaiAdults = users.filter { $0.age >= 18 && $0.city == "Mumbai" }
// [Alice(28), Charlie(32)]

// ═══ reduce — Collapse to Single Value ═══
let totalAge = users.reduce(0) { sum, user in sum + user.age }
// 116

let nameList = users.reduce("") { result, user in
    result.isEmpty ? user.name : "\\(result), \\(user.name)"
}
// "Alice, Bob, Charlie, Diana, Eve"

// ═══ compactMap — map + Remove Nils ═══
let strings = ["1", "2", "hello", "4", "world"]
let numbers = strings.compactMap { Int($0) }
// [1, 2, 4] — "hello" and "world" returned nil, removed!

// ═══ flatMap — Flatten Nested Arrays ═══
let nested = [[1, 2, 3], [4, 5], [6]]
let flat = nested.flatMap { $0 }
// [1, 2, 3, 4, 5, 6]

// ═══ Chaining — Combine Multiple HOFs ═══
let result = users
    .filter { $0.age >= 18 }           // Adults only
    .sorted { $0.age > $1.age }        // Oldest first
    .map { "\\($0.name) (\\($0.age))" } // Format as strings
    .joined(separator: ", ")            // Join into one string
// "Charlie (32), Alice (28), Diana (24)"

// ═══ forEach — Side Effects (No Return) ═══
users.forEach { user in
    print("Processing \\(user.name)...")
}
// Note: forEach cannot use 'break' or 'return' to exit early!
// Use a regular for-in loop if you need early exit.
"""
        )
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - Actions
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    private func executeNonEscaping() {
        logs.append("1️⃣ Calling non-escaping function...")
        performCalculation(a: 5, b: 10) { result in
            logs.append("2️⃣ Inside closure: result = \(result)")
            logs.append("   → Closure ran BEFORE function returned")
        }
        logs.append("3️⃣ Function returned. Notice closure ran at step 2.")
        logs.append("   → This is non-escaping: synchronous, ordered execution")
    }

    private func performCalculation(a: Int, b: Int, operation: (Int) -> Void) {
        operation(a * b)
    }

    private func executeEscaping() {
        logs.append("1️⃣ Calling @escaping async function...")
        isAsyncRunning = true
        performAsyncTask { message in
            DispatchQueue.main.async {
                self.logs.append("3️⃣ Escaping closure fired: \(message)")
                self.logs.append("   → Ran AFTER the function already returned at step 2!")
                self.isAsyncRunning = false
            }
        }
        logs.append("2️⃣ Function already returned! Closure hasn't fired yet...")
        logs.append("   → Waiting 1.2 seconds for async closure to escape...")
    }

    private func performAsyncTask(completion: @escaping (String) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.2) {
            completion("Data fetched from API!")
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
    
    private func captureTypeRow(type: String, behavior: String, example: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(type)
                .font(.caption.bold())
                .foregroundColor(color)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(color.opacity(0.1))
                .cornerRadius(4)
            Text(behavior)
                .font(.system(size: 10))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
            Text(example)
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(.secondary)
                .padding(4)
                .background(Color(.tertiarySystemGroupedBackground))
                .cornerRadius(4)
        }
    }
}
