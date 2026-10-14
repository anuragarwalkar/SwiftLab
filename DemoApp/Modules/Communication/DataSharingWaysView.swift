import SwiftUI
import Combine

// MARK: - Level 4: All Data Sharing Ways in Swift & iOS (Deep Dive & Interactive Lab)

// MARK: - 1. Delegate Protocol Definition
// Note: Must conform to AnyObject so it can be declared `weak` to break retain cycles!
protocol OrderProcessingDelegate: AnyObject {
    func orderDidComplete(orderId: String, total: Double, item: String)
    func orderDidFail(reason: String)
}

// MARK: - 2. Mock Singleton Store (Demonstration of static let shared)
final class AppSessionStore: ObservableObject {
    static let shared = AppSessionStore()
    
    @Published var currentUser: String = "Alex Developer"
    @Published var loyaltyPoints: Int = 250
    @Published var isVipMember: Bool = true
    
    // Crucial Interview Point: private init prevents other classes from doing AppSessionStore()
    private init() {}
    
    func reset() {
        currentUser = "Alex Developer"
        loyaltyPoints = 250
        isVipMember = true
    }
}

// MARK: - Custom Notification Name
extension Notification.Name {
    static let globalBroadcastMessage = Notification.Name("AppGlobalBroadcastMessageNotification")
}

// MARK: - Main Container View
struct DataSharingWaysView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                // Header Banner
                headerBanner
                
                // Navigation Tabs
                Picker("Data Sharing Topic", selection: $selectedTab) {
                    Text("Overview").tag(0)
                    Text("1. Props").tag(1)
                    Text("2. Delegate").tag(2)
                    Text("3. Closures").tag(3)
                    Text("4. @Binding").tag(4)
                    Text("5. NotifCenter").tag(5)
                    Text("6. Combine").tag(6)
                    Text("7. Singleton").tag(7)
                    Text("Interview").tag(8)
                }
                .pickerStyle(.segmented)
                
                // Selected Section Content
                switch selectedTab {
                case 0: overviewSection
                case 1: propsInjectionSection
                case 2: delegatePatternSection
                case 3: closuresCallbackSection
                case 4: bindingSection
                case 5: notificationCenterSection
                case 6: combineStreamsSection
                case 7: singletonSection
                case 8: interviewQuestionsSection
                default: EmptyView()
                }
            }
            .padding()
        }
        .navigationTitle("Data Sharing Ways")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Header
    private var headerBanner: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                ZStack {
                    Circle().fill(Color.orange.opacity(0.15)).frame(width: 44, height: 44)
                    Text("L4").font(.headline.bold()).foregroundColor(.orange)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Level 4: Data Sharing Ways")
                        .font(.title2.bold())
                    Text("How Components, Views & Controllers Communicate in iOS")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Text("Passing data between screens is the foundation of every iOS application. Master the 4 communication directions: Downward (Props), Upward (Delegate / Closures), Two-Way (@Binding), and Broadcast (NotificationCenter / Combine / Singleton).")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.orange.opacity(0.08))
        .cornerRadius(16)
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - TAB 0: OVERVIEW & COMPARISON MATRIX
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @ViewBuilder
    private var overviewSection: some View {
        ConceptCard(
            title: "The Big Picture: Why Do We Need Different Ways?",
            subtitle: "Every method solves a specific communication problem",
            icon: "network",
            iconColor: Color.orange
        ) {
            VStack(alignment: .leading, spacing: 12) {
                calloutBox(
                    text: "No single data sharing mechanism fits every scenario. If Screen A opens Screen B, passing a simple property is ideal. But if Screen B needs to return data back to Screen A, or if a user logs out and 10 screens must update at once, you need completely different patterns!",
                    icon: "lightbulb.fill",
                    color: AppTheme.warning
                )
                
                Text("The 4 Core Communication Directions:")
                    .font(.subheadline.bold())
                
                directionCard(
                    title: "1. Downward (Parent ➔ Child)",
                    mechanism: "Property / Initializer Injection",
                    analogy: "Handing a book to someone when you meet them.",
                    icon: "arrow.down.circle.fill",
                    color: .blue
                )
                
                directionCard(
                    title: "2. Upward (Child ➔ Parent)",
                    mechanism: "Delegate Pattern OR Closures / Callbacks",
                    analogy: "Assistant calling the boss, or sending a return envelope.",
                    icon: "arrow.up.circle.fill",
                    color: .purple
                )
                
                directionCard(
                    title: "3. Two-Way Synchronization",
                    mechanism: "SwiftUI @Binding (Single Source of Truth)",
                    analogy: "Shared Google Doc: if anyone edits, everyone sees it.",
                    icon: "arrow.triangle.2.circlepath.circle.fill",
                    color: .teal
                )
                
                directionCard(
                    title: "4. One-to-Many Broadcast",
                    mechanism: "NotificationCenter OR Combine Subjects",
                    analogy: "Radio station broadcast: sender posts once, 10 cars hear it.",
                    icon: "dot.radiowaves.left.and.right",
                    color: .orange
                )
                
                directionCard(
                    title: "5. Global / Tree-Wide Access",
                    mechanism: "Singleton (shared) OR @EnvironmentObject",
                    analogy: "Public Library: accessible from any street in town.",
                    icon: "globe.americas.fill",
                    color: .indigo
                )
            }
        }
        
        // Comparison Matrix
        ConceptCard(
            title: "Decision Matrix: Which Pattern To Choose?",
            subtitle: "Interview comparison cheat sheet",
            icon: "tablecells.fill",
            iconColor: AppTheme.primary
        ) {
            VStack(spacing: 10) {
                matrixRow(pattern: "Property Injection", direction: "Parent ➔ Child", cardinality: "1-to-1", coupling: "Tight", leakRisk: "None", bestFor: "Passing config or model to child view")
                Divider()
                matrixRow(pattern: "Delegate Protocol", direction: "Child ➔ Parent", cardinality: "1-to-1", coupling: "Loose (via protocol)", leakRisk: "High if not weak!", bestFor: "Multi-event contracts (UITableViewDelegate)")
                Divider()
                matrixRow(pattern: "Closure / Callback", direction: "Child ➔ Parent", cardinality: "1-to-1", coupling: "Loose", leakRisk: "High if no [weak self]", bestFor: "Single completion or quick response")
                Divider()
                matrixRow(pattern: "@Binding", direction: "Two-Way", cardinality: "1-to-1", coupling: "Medium", leakRisk: "None (Value types)", bestFor: "SwiftUI controls (Toggle, TextField, Slider)")
                Divider()
                matrixRow(pattern: "NotificationCenter", direction: "Broadcast", cardinality: "1-to-Many", coupling: "Zero (String keys)", leakRisk: "Medium (old observers)", bestFor: "App-wide system events (logout, keyboard)")
                Divider()
                matrixRow(pattern: "Combine Streams", direction: "Reactive", cardinality: "1-to-Many", coupling: "Loose", leakRisk: "Managed via Set<Cancellable>", bestFor: "Pipelines, debouncing search, continuous data")
                Divider()
                matrixRow(pattern: "Singleton (shared)", direction: "Global", cardinality: "Any-to-Any", coupling: "High", leakRisk: "Lives for app lifetime", bestFor: "Caches, hardware managers (Bluetooth/Audio)")
            }
        }
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - TAB 1: PROPERTY / INITIALIZER INJECTION
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @State private var parentUserName = "Sarah Connor"
    @State private var parentUserRole = "Lead Engineer"
    @State private var parentBadgeCount = 5
    
    @ViewBuilder
    private var propsInjectionSection: some View {
        ConceptCard(
            title: "1. Property & Initializer Injection",
            subtitle: "Parent ➔ Child (1-to-1 Downward Flow)",
            icon: "arrow.down.doc.fill",
            iconColor: .blue
        ) {
            VStack(alignment: .leading, spacing: 12) {
                calloutBox(
                    text: "Property Injection is the simplest and most natural way to share data in Swift. When a Parent creates a Child view, it passes the data directly into the Child's initializer or stored property.",
                    icon: "info.circle.fill",
                    color: .blue
                )
                
                BulletPoint(text: "Flow direction: Only Downward (Parent ➔ Child).")
                BulletPoint(text: "The Child cannot change the Parent's original data directly (immutable value copy).")
                BulletPoint(text: "Advantage: 100% type-safe, crystal clear dependencies, compiler verifies all fields.")
                BulletPoint(text: "Downside: 'Prop Drilling' — if View A needs to pass data to View D through B and C, B and C must carry parameters they don't even care about.")
            }
        }
        
        // Interactive Live Demo
        ConceptCard(
            title: "Live Interactive Playground",
            subtitle: "Change Parent state below to observe the Child view update",
            icon: "slider.horizontal.3",
            iconColor: .blue
        ) {
            VStack(alignment: .leading, spacing: 14) {
                Text("Parent View Controls:")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
                
                TextField("User Name", text: $parentUserName)
                    .textFieldStyle(.roundedBorder)
                
                HStack {
                    Picker("Role", selection: $parentUserRole) {
                        Text("Junior Dev").tag("Junior Dev")
                        Text("Lead Engineer").tag("Lead Engineer")
                        Text("Engineering Director").tag("Engineering Director")
                    }
                    .pickerStyle(.menu)
                    
                    Spacer()
                    
                    Stepper("Badges: \(parentBadgeCount)", value: $parentBadgeCount, in: 0...20)
                }
                
                Divider()
                
                Text("Child View (Rendered with Injected Props):")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
                
                // Embedded Child View receiving injected props
                ChildProfileCard(
                    name: parentUserName,
                    role: parentUserRole,
                    unreadCount: parentBadgeCount
                )
            }
        }
        
        // Real Code Block
        CodeBlockView(
            title: "Swift Implementation (Parent & Child)",
            code: """
// ─── 1. The Child View (Receives Data via Init) ───
struct UserBadgeView: View {
    let name: String         // Injected property
    let role: String         // Injected property
    let badgeCount: Int      // Injected property

    var body: some View {
        HStack {
            Text(name).bold()
            Text("(\\(role))").foregroundColor(.secondary)
            Spacer()
            Text("\\(badgeCount)")
                .padding(6)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
        }
    }
}

// ─── 2. The Parent View (Injects Data Downward) ───
struct ParentDashboardView: View {
    @State private var userName = "Sarah Connor"
    @State private var userRole = "Lead Engineer"
    @State private var count = 5

    var body: some View {
        VStack {
            // Data flows down through the initializer!
            UserBadgeView(name: userName, role: userRole, badgeCount: count)
        }
    }
}
"""
        )
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - TAB 2: DELEGATE PATTERN
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @State private var delegateLog: [String] = []
    @State private var delegateLastOrderId: String = "None yet"
    @State private var delegateTotalRevenue: Double = 0.0
    @State private var delegateStatusBadge = "Idle"
    
    @ViewBuilder
    private var delegatePatternSection: some View {
        ConceptCard(
            title: "2. The Delegate Pattern",
            subtitle: "Child ➔ Parent (1-to-1 Decoupled Upward Flow)",
            icon: "person.2.badge.gearshape.fill",
            iconColor: .purple
        ) {
            VStack(alignment: .leading, spacing: 12) {
                calloutBox(
                    text: "The Delegate Pattern is Apple's signature design pattern (e.g. UITableViewDelegate, CLLocationManagerDelegate). A child object holds a reference to a delegate protocol. When an event happens, it calls methods on that delegate.",
                    icon: "hand.raised.fill",
                    color: .purple
                )
                
                Text("The 4 Golden Rules of Delegation:")
                    .font(.subheadline.bold())
                
                BulletPoint(text: "1. Define Protocol: 'protocol OrderDelegate: AnyObject'. Must be class-only (`AnyObject`) so it can be declared `weak`.")
                BulletPoint(text: "2. Child has weak var: 'weak var delegate: OrderDelegate?'. Marking it `weak` breaks retain cycles!")
                BulletPoint(text: "3. Parent Conforms: Parent adopts the protocol and implements required methods.")
                BulletPoint(text: "4. Parent assigns itself: 'child.delegate = self'.")
                
                calloutBox(
                    text: "⚠️ Top Interview Trap: 'Why must a delegate be weak?'\nIf the delegate reference is strong, Parent owns Child (strong), and Child owns Parent (strong delegate). Neither can EVER be freed from memory — a permanent Retain Cycle (Memory Leak)!",
                    icon: "exclamationmark.triangle.fill",
                    color: AppTheme.error
                )
            }
        }
        
        // Interactive Live Demo
        ConceptCard(
            title: "Live Delegate Simulator: Cashier & Store Manager",
            subtitle: "Cashier (Child) informs Store Manager (Parent) via Protocol",
            icon: "cart.fill",
            iconColor: .purple
        ) {
            VStack(alignment: .leading, spacing: 14) {
                // Parent Manager Status Box
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Store Manager (Parent / Delegate):")
                            .font(.caption.bold())
                        Text("Total Revenue: $\(String(format: "%.2f", delegateTotalRevenue))")
                            .font(.subheadline.bold())
                            .foregroundColor(AppTheme.success)
                        Text("Last Order: \(delegateLastOrderId)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(delegateStatusBadge)
                        .font(.caption.bold())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(delegateStatusBadge == "Success" ? Color.green.opacity(0.15) : Color.gray.opacity(0.15))
                        .foregroundColor(delegateStatusBadge == "Success" ? .green : .secondary)
                        .cornerRadius(8)
                }
                .padding(12)
                .background(Color(.tertiarySystemGroupedBackground))
                .cornerRadius(10)
                
                Divider()
                
                Text("Cashier Terminal (Child View):")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
                
                HStack(spacing: 10) {
                    Button {
                        simulateOrder(item: "Coffee ☕️", amount: 4.50)
                    } label: {
                        Text("Order Coffee ($4.50)")
                            .font(.caption.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.purple.opacity(0.15))
                            .foregroundColor(.purple)
                            .cornerRadius(8)
                    }
                    
                    Button {
                        simulateOrder(item: "Laptop 💻", amount: 1299.00)
                    } label: {
                        Text("Order Laptop ($1299)")
                            .font(.caption.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.purple.opacity(0.15))
                            .foregroundColor(.purple)
                            .cornerRadius(8)
                    }
                    
                    Button {
                        simulateOrderFailure(reason: "Card Declined 💳❌")
                    } label: {
                        Text("Fail Card")
                            .font(.caption.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.red.opacity(0.15))
                            .foregroundColor(.red)
                            .cornerRadius(8)
                    }
                }
                
                InteractiveLogBox(logs: delegateLog, onClear: {
                    delegateLog.removeAll()
                    delegateTotalRevenue = 0.0
                    delegateLastOrderId = "None"
                    delegateStatusBadge = "Idle"
                })
            }
        }
        
        // Code Block
        CodeBlockView(
            title: "Standard Swift Delegate Pattern Code",
            code: """
// ─── Step 1: Define the Protocol (class-only via AnyObject) ───
protocol PaymentDelegate: AnyObject {
    func paymentDidSucceed(amount: Double, transactionId: String)
    func paymentDidFail(error: String)
}

// ─── Step 2: The Delegator (Child View/Controller) ───
class CheckoutViewController: UIViewController {
    // MUST BE WEAK to avoid retain cycle!
    weak var delegate: PaymentDelegate?

    func userTappedPayButton() {
        let success = true
        if success {
            // Notify the delegate (upward communication)
            delegate?.paymentDidSucceed(amount: 49.99, transactionId: "TX-9901")
        } else {
            delegate?.paymentDidFail(error: "Insufficient funds")
        }
    }
}

// ─── Step 3: The Delegate (Parent View/Controller) ───
class MainStoreViewController: UIViewController, PaymentDelegate {
    
    func openCheckout() {
        let checkoutVC = CheckoutViewController()
        checkoutVC.delegate = self // Step 4: assign self as delegate
        present(checkoutVC, animated: true)
    }

    // Protocol Conformance:
    func paymentDidSucceed(amount: Double, transactionId: String) {
        print("Parent received: Payment of $\\(amount) succeeded!")
    }

    func paymentDidFail(error: String) {
        print("Parent received error: \\(error)")
    }
}
"""
        )
    }
    
    private func simulateOrder(item: String, amount: Double) {
        let orderId = "ORD-\(Int.random(in: 1000...9999))"
        delegateTotalRevenue += amount
        delegateLastOrderId = "\(orderId) (\(item))"
        delegateStatusBadge = "Success"
        delegateLog.append("🔔 Cashier invoked delegate?.orderDidComplete(orderId: \(orderId), total: $\(amount))")
        delegateLog.append("   ↳ Manager received event & updated revenue to $\(String(format: "%.2f", delegateTotalRevenue))")
    }
    
    private func simulateOrderFailure(reason: String) {
        delegateStatusBadge = "Failed"
        delegateLog.append("⚠️ Cashier invoked delegate?.orderDidFail(reason: \"\(reason)\")")
        delegateLog.append("   ↳ Manager prompted error alert to user.")
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - TAB 3: CLOSURES & CALLBACKS
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @State private var closureFeedbackResult = "No feedback submitted yet"
    @State private var closureRating = 5
    @State private var closureLogs: [String] = []
    
    @ViewBuilder
    private var closuresCallbackSection: some View {
        ConceptCard(
            title: "3. Closures / Callbacks",
            subtitle: "Child ➔ Parent (1-to-1 Event Completion)",
            icon: "curlybraces",
            iconColor: .green
        ) {
            VStack(alignment: .leading, spacing: 12) {
                calloutBox(
                    text: "A closure is a self-contained block of code passed as a variable or parameter. When the child finishes a task, it calls that closure to pass data back to the parent.",
                    icon: "bolt.fill",
                    color: .green
                )
                
                BulletPoint(text: "Syntax: 'var onSave: ((String) -> Void)?'")
                BulletPoint(text: "Why use Closures instead of Delegates? Closures are compact, inline, and don't require writing a protocol.")
                BulletPoint(text: "Rule of Thumb: If there is only ONE event (e.g. completion handler, button tap, save callback), use a Closure. If there are MULTIPLE distinct lifecycle methods, use a Delegate.")
                BulletPoint(text: "⚠️ Memory Rule: Always use `[weak self]` inside closures that capture `self` in classes to prevent retain cycles!")
            }
        }
        
        // Interactive Demo
        ConceptCard(
            title: "Live Closure Callback Simulation",
            subtitle: "Child Rating Card triggers Parent's completion block",
            icon: "star.fill",
            iconColor: .green
        ) {
            VStack(alignment: .leading, spacing: 14) {
                // Parent State Display
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Parent Screen Result:")
                            .font(.caption.bold())
                        Text(closureFeedbackResult)
                            .font(.subheadline)
                            .foregroundColor(closureFeedbackResult.contains("★") ? AppTheme.warning : .secondary)
                    }
                    Spacer()
                }
                .padding(12)
                .background(Color(.tertiarySystemGroupedBackground))
                .cornerRadius(10)
                
                Divider()
                
                Text("Child Feedback Component:")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
                
                // Child View with Closure Callback
                ChildFeedbackView(
                    rating: $closureRating,
                    onSubmit: { rating, comment in
                        // THIS IS THE CLOSURE EXECUTING ON PARENT!
                        let stars = String(repeating: "★", count: rating)
                        closureFeedbackResult = "\(stars) (\(rating)/5) - \"\(comment)\""
                        closureLogs.append("✅ Closure Callback executed! Parent received: Rating=\(rating), Comment=\"\(comment)\"")
                    }
                )
                
                InteractiveLogBox(logs: closureLogs, onClear: {
                    closureLogs.removeAll()
                    closureFeedbackResult = "Cleared"
                })
            }
        }
        
        // Code Block
        CodeBlockView(
            title: "Swift Closure Data Passing Code",
            code: """
// ─── 1. Child View with Closure Property ───
struct EditProfileView: View {
    @State private var enteredName: String = ""
    // The closure callback property!
    var onSave: ((String) -> Void)?

    var body: some View {
        VStack {
            TextField("Enter name", text: $enteredName)
            Button("Save") {
                // Trigger the closure to pass data back to parent!
                onSave?(enteredName)
            }
        }
    }
}

// ─── 2. Parent View provides the Closure ───
struct ProfileHomeView: View {
    @State private var displayName: String = "John"

    var body: some View {
        VStack {
            Text("Current: \\(displayName)")
            
            // Pass closure using trailing closure syntax:
            EditProfileView { updatedName in
                // Runs when child saves!
                self.displayName = updatedName
            }
        }
    }
}
"""
        )
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - TAB 4: SWIFTUI @BINDING
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @State private var sharedVolume: Double = 65.0
    @State private var isMuted: Bool = false
    @State private var sharedThemeColor: Color = .blue
    
    @ViewBuilder
    private var bindingSection: some View {
        ConceptCard(
            title: "4. SwiftUI State & @Binding",
            subtitle: "Two-Way Direct Synchronization",
            icon: "arrow.triangle.2.circlepath",
            iconColor: .teal
        ) {
            VStack(alignment: .leading, spacing: 12) {
                calloutBox(
                    text: "@Binding is SwiftUI's secret weapon for sharing mutable data. It creates a reference (pointer) to a @State property owned by another view, maintaining a Single Source of Truth.",
                    icon: "link",
                    color: .teal
                )
                
                BulletPoint(text: "@State owns the data memory. It is the single source of truth.")
                BulletPoint(text: "@Binding does NOT own the data. It has read and write access to the parent's @State.")
                BulletPoint(text: "The '$' prefix (e.g. '$volume') creates a Binding from a @State variable.")
                BulletPoint(text: "When Child modifies the @Binding, Parent is automatically notified and re-renders, and vice-versa!")
            }
        }
        
        // Interactive Live Demo
        ConceptCard(
            title: "Live Two-Way @Binding Playground",
            subtitle: "Adjust controls in Parent OR Child — both stay 100% in sync!",
            icon: "speaker.wave.3.fill",
            iconColor: .teal
        ) {
            VStack(alignment: .leading, spacing: 16) {
                // Parent Box
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Parent View (@State Owner):")
                            .font(.caption.bold())
                        Spacer()
                        Text("Volume: \(Int(sharedVolume))%")
                            .font(.caption.monospacedDigit().bold())
                            .foregroundColor(isMuted ? .secondary : .primary)
                    }
                    
                    Slider(value: $sharedVolume, in: 0...100)
                        .accentColor(sharedThemeColor)
                        .disabled(isMuted)
                    
                    Toggle("Mute Audio", isOn: $isMuted)
                        .font(.caption)
                }
                .padding(12)
                .background(Color.teal.opacity(0.08))
                .cornerRadius(12)
                
                HStack {
                    Spacer()
                    Image(systemName: "arrow.up.arrow.down.circle.fill")
                        .font(.title2)
                        .foregroundColor(.teal)
                    Text("Two-Way @Binding Synchronization")
                        .font(.caption.bold())
                        .foregroundColor(.teal)
                    Spacer()
                }
                
                // Child Box
                ChildAudioController(
                    volumeBinding: $sharedVolume,
                    muteBinding: $isMuted,
                    accentColor: sharedThemeColor
                )
            }
        }
        
        // Code Block
        CodeBlockView(
            title: "SwiftUI @Binding Code Example",
            code: """
// ─── 1. Child View: Declares @Binding (No Initial Value!) ───
struct VolumeSliderView: View {
    // Does NOT own storage — points to parent's state!
    @Binding var volume: Double
    @Binding var isMuted: Bool

    var body: some View {
        VStack {
            Slider(value: $volume, in: 0...100)
            Button("Toggle Mute") {
                isMuted.toggle() // Modifies Parent's state directly!
            }
        }
    }
}

// ─── 2. Parent View: Owns @State & Passes '$' Binding ───
struct AudioPlayerView: View {
    // Single Source of Truth
    @State private var currentVolume: Double = 50.0
    @State private var isMuted: Bool = false

    var body: some View {
        VStack {
            Text("Volume: \\(Int(currentVolume))%")
            
            // Pass '$' to create a Binding reference!
            VolumeSliderView(volume: $currentVolume, isMuted: $isMuted)
        }
    }
}
"""
        )
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - TAB 5: NOTIFICATIONCENTER
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @State private var broadcastText = "Flash Sale: 50% Off Everything!"
    @State private var broadcastCategory = "Promotions"
    @State private var notifLogs: [String] = []
    
    // Simulated independent observers
    @State private var bannerReceivedText = "Waiting for broadcast..."
    @State private var analyticsReceivedCount = 0
    @State private var badgeNotificationCount = 0
    
    @ViewBuilder
    private var notificationCenterSection: some View {
        ConceptCard(
            title: "5. NotificationCenter",
            subtitle: "1-to-Many Broadcast Across the Entire App",
            icon: "dot.radiowaves.left.and.right",
            iconColor: .orange
        ) {
            VStack(alignment: .leading, spacing: 12) {
                calloutBox(
                    text: "NotificationCenter is a Publish/Subscribe message bus. A sender posts a notification without knowing who (or how many) observers exist. Any component across the entire app can listen for that notification.",
                    icon: "megaphone.fill",
                    color: .orange
                )
                
                BulletPoint(text: "Best for: App-wide global events (e.g. User logged out, theme changed, network connection lost, keyboard appeared).")
                BulletPoint(text: "Cardinality: 1-to-Many. 1 sender can notify 0, 1, 5, or 50 receivers at the same instant.")
                BulletPoint(text: "Pros: Completely decouples sender and receivers. Sender has no idea who receives it.")
                BulletPoint(text: "Cons & Risks: No compile-time type safety (data is passed in a loose dictionary `[AnyHashable: Any]`), harder to trace and debug, can cause memory leaks if observers aren't removed in UIKit.")
            }
        }
        
        // Interactive Live Demo
        ConceptCard(
            title: "Live NotificationCenter Broadcast Station",
            subtitle: "Broadcasting a message triggers multiple independent observers",
            icon: "antenna.radiowaves.left.and.right",
            iconColor: .orange
        ) {
            VStack(alignment: .leading, spacing: 14) {
                Text("Broadcast Transmitter (Sender):")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
                
                TextField("Broadcast Message", text: $broadcastText)
                    .textFieldStyle(.roundedBorder)
                
                HStack {
                    Picker("Category", selection: $broadcastCategory) {
                        Text("Promotions").tag("Promotions")
                        Text("System Alert").tag("System Alert")
                        Text("User Event").tag("User Event")
                    }
                    .pickerStyle(.segmented)
                    
                    Button {
                        postBroadcastNotification()
                    } label: {
                        Label("Broadcast Now", systemImage: "paperplane.fill")
                            .font(.caption.bold())
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
                Divider()
                
                Text("Independent Observers Across App (Receivers):")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
                
                // Observer 1: Promo Banner
                HStack {
                    Image(systemName: "bell.badge.fill")
                        .foregroundColor(.orange)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Observer 1: Global Banner View")
                            .font(.caption.bold())
                        Text(bannerReceivedText)
                            .font(.system(size: 11))
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
                .padding(8)
                .background(Color(.tertiarySystemGroupedBackground))
                .cornerRadius(8)
                
                // Observer 2: Analytics Service
                HStack {
                    Image(systemName: "chart.bar.xaxis")
                        .foregroundColor(.blue)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Observer 2: Analytics Engine")
                            .font(.caption.bold())
                        Text("Tracked \(analyticsReceivedCount) broadcast events so far")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(8)
                .background(Color(.tertiarySystemGroupedBackground))
                .cornerRadius(8)
                
                // Observer 3: Tab Bar Badge
                HStack {
                    Image(systemName: "tray.full.fill")
                        .foregroundColor(.green)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Observer 3: Inbox Badge Counter")
                            .font(.caption.bold())
                        Text("Unread Notifications: \(badgeNotificationCount)")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(8)
                .background(Color(.tertiarySystemGroupedBackground))
                .cornerRadius(8)
                
                InteractiveLogBox(logs: notifLogs, onClear: {
                    notifLogs.removeAll()
                    bannerReceivedText = "Waiting for broadcast..."
                    analyticsReceivedCount = 0
                    badgeNotificationCount = 0
                })
            }
        }
        
        // Code Block
        CodeBlockView(
            title: "Swift NotificationCenter Pattern",
            code: """
// ─── Step 1: Define Type-Safe Notification Name ───
extension Notification.Name {
    static let userDidLogin = Notification.Name("userDidLoginNotification")
}

// ─── Step 2: Post Notification (The Sender) ───
func completeLogin(user: String) {
    NotificationCenter.default.post(
        name: .userDidLogin,
        object: nil,
        userInfo: ["username": user, "timestamp": Date()]
    )
}

// ─── Step 3: Listen in SwiftUI with .onReceive ───
struct HomeHeaderView: View {
    @State private var welcomeText = "Guest"

    var body: some View {
        Text(welcomeText)
            .onReceive(NotificationCenter.default.publisher(for: .userDidLogin)) { notification in
                if let user = notification.userInfo?["username"] as? String {
                    self.welcomeText = "Welcome, \\(user)!"
                }
            }
    }
}

// ─── Step 3 (Alternative): Listen in UIKit ───
// NotificationCenter.default.addObserver(
//     self, selector: #selector(handleLogin),
//     name: .userDidLogin, object: nil
// )
"""
        )
    }
    
    private func postBroadcastNotification() {
        let text = broadcastText
        let cat = broadcastCategory
        let time = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        
        // Post actual notification
        NotificationCenter.default.post(
            name: .globalBroadcastMessage,
            object: nil,
            userInfo: ["message": text, "category": cat, "time": time]
        )
        
        // Update simulated observers
        bannerReceivedText = "[\(cat)] \"\(text)\" (at \(time))"
        analyticsReceivedCount += 1
        badgeNotificationCount += 1
        
        notifLogs.append("📢 Transmitter: Posted .globalBroadcastMessage to NotificationCenter.default")
        notifLogs.append("   ↳ Observer 1 (Banner): Updated display")
        notifLogs.append("   ↳ Observer 2 (Analytics): Logged event #\(analyticsReceivedCount)")
        notifLogs.append("   ↳ Observer 3 (Badge): Incremented unread to \(badgeNotificationCount)")
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - TAB 6: COMBINE & REACTIVE STREAMS
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @State private var combineInputNumber: Double = 25
    @State private var combineSubjectType = 0 // 0 = Passthrough, 1 = CurrentValue
    @State private var combineLogs: [String] = []
    @State private var currentValueStored = 100
    
    // Combine Subjects
    private let passthroughSubject = PassthroughSubject<Int, Never>()
    private let currentValueSubject = CurrentValueSubject<Int, Never>(100)
    @State private var combineCancellables = Set<AnyCancellable>()
    
    @ViewBuilder
    private var combineStreamsSection: some View {
        ConceptCard(
            title: "6. Reactive Combine Streams",
            subtitle: "Publishers, Subjects & Continuous Event Pipelines",
            icon: "point.3.filled.connected.trianglepath.dotted",
            iconColor: .pink
        ) {
            VStack(alignment: .leading, spacing: 12) {
                calloutBox(
                    text: "Combine represents asynchronous values over time. Instead of asking for data once, you subscribe to a publisher stream that delivers new values whenever they are produced.",
                    icon: "waveform.path.ecg",
                    color: .pink
                )
                
                Text("Subject Types: Passthrough vs CurrentValue")
                    .font(.subheadline.bold())
                
                BulletPoint(text: "PassthroughSubject: Like a Doorbell 🔔. It does NOT store the last value. If nobody is home when the doorbell rings, the event is lost.")
                BulletPoint(text: "CurrentValueSubject: Like a Thermometer 🌡️. It ALWAYS holds the current value in '.value'. When a new subscriber attaches, it immediately receives the current value!")
                BulletPoint(text: "Operators: You can filter, map, debounce, and transform streams before they reach the subscriber (e.g. .filter { $0 > 50 }).")
            }
        }
        
        // Interactive Demo
        ConceptCard(
            title: "Live Combine Stream Lab",
            subtitle: "Send integer values through Combine pipeline with .filter operator",
            icon: "play.circle.fill",
            iconColor: .pink
        ) {
            VStack(alignment: .leading, spacing: 14) {
                Picker("Subject Flavor", selection: $combineSubjectType) {
                    Text("PassthroughSubject").tag(0)
                    Text("CurrentValueSubject").tag(1)
                }
                .pickerStyle(.segmented)
                
                if combineSubjectType == 1 {
                    HStack {
                        Text("Current Buffer (.value):")
                            .font(.caption.bold())
                        Spacer()
                        Text("\(currentValueStored)")
                            .font(.subheadline.monospacedDigit().bold())
                            .foregroundColor(.pink)
                    }
                    .padding(8)
                    .background(Color.pink.opacity(0.1))
                    .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Value to Send: \(Int(combineInputNumber))")
                            .font(.caption.bold())
                        Spacer()
                        Text("Filter: Only values > 50 will pass!")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(combineInputNumber > 50 ? .green : .red)
                    }
                    Slider(value: $combineInputNumber, in: 0...100, step: 1)
                        .accentColor(.pink)
                }
                
                Button {
                    sendCombineValue(Int(combineInputNumber))
                } label: {
                    Label("Send \(Int(combineInputNumber)) via Combine Stream", systemImage: "bolt.horizontal.fill")
                        .font(.caption.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                InteractiveLogBox(logs: combineLogs, onClear: {
                    combineLogs.removeAll()
                })
            }
        }
        
        // Code Block
        CodeBlockView(
            title: "Combine Data Pipeline Implementation",
            code: """
import Combine

// ─── 1. Create a Subject ───
// Passthrough: No initial value
let searchPublisher = PassthroughSubject<String, Never>()

// CurrentValue: Holds state
let currentScore = CurrentValueSubject<Int, Never>(0)

// ─── 2. Subscribe with Pipeline Operators ───
var cancellables = Set<AnyCancellable>()

currentScore
    .filter { $0 > 50 }                     // Only let scores > 50 pass
    .map { "Score High: \\($0) points!" }    // Transform to String
    .receive(on: DispatchQueue.main)        // Ensure UI updates on main thread
    .sink { formattedText in
        print(formattedText)
    }
    .store(in: &cancellables)

// ─── 3. Emit Values Anywhere in the App ───
currentScore.send(20)  // Filtered out (< 50)
currentScore.send(85)  // Passed! Prints "Score High: 85 points!"
"""
        )
    }
    
    private func sendCombineValue(_ val: Int) {
        if combineSubjectType == 0 {
            combineLogs.append("⚡ [PassthroughSubject] .send(\(val)) emitted")
            if val > 50 {
                combineLogs.append("   ✅ Subscriber received transformed: \"Value passed filter: \(val)\"")
            } else {
                combineLogs.append("   ❌ Operator .filter dropped value \(val) (not > 50)")
            }
        } else {
            currentValueStored = val
            combineLogs.append("🌡️ [CurrentValueSubject] .value updated to \(val)")
            if val > 50 {
                combineLogs.append("   ✅ Subscriber received transformed: \"Value passed filter: \(val)\"")
            } else {
                combineLogs.append("   ❌ Operator .filter dropped value \(val) (not > 50)")
            }
        }
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - TAB 7: SINGLETON & ENVIRONMENT
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @ObservedObject private var session = AppSessionStore.shared
    @State private var newUserNameInput = ""
    @State private var pointsToAdd = 50
    
    @ViewBuilder
    private var singletonSection: some View {
        ConceptCard(
            title: "7. Singleton Pattern (`static let shared`)",
            subtitle: "Global Shared State Across the Entire Application",
            icon: "globe",
            iconColor: .indigo
        ) {
            VStack(alignment: .leading, spacing: 12) {
                calloutBox(
                    text: "A Singleton is a class that guarantees only ONE single instance will ever exist throughout the app's lifetime. It provides a global access point via `static let shared`.",
                    icon: "lock.shield.fill",
                    color: .indigo
                )
                
                BulletPoint(text: "Why `private init()` is crucial: Prevents anyone from calling `AppSessionStore()` outside and creating a second instance.")
                BulletPoint(text: "Apple's native singletons: `UserDefaults.standard`, `FileManager.default`, `UIApplication.shared`, `NotificationCenter.default`.")
                BulletPoint(text: "Pros: Effortless access from ANY view controller, view, or service without passing parameters.")
                
                calloutBox(
                    text: "⚠️ Senior iOS Interview Warning: 'Why are Singletons an anti-pattern in large apps?'\n1. Hard to Unit Test: Global state leaks across tests.\n2. Hidden Dependencies: Components secretly depend on global state.\n3. Concurrency Hazards: Multiple threads writing to shared state causes data races without locks/actors.",
                    icon: "exclamationmark.triangle.fill",
                    color: AppTheme.error
                )
            }
        }
        
        // Interactive Demo
        ConceptCard(
            title: "Live Shared Session Inspector",
            subtitle: "AppSessionStore.shared accessed from mock screens",
            icon: "person.crop.circle.badge.checkmark",
            iconColor: .indigo
        ) {
            VStack(alignment: .leading, spacing: 14) {
                // Current Singleton State
                VStack(alignment: .leading, spacing: 6) {
                    Text("AppSessionStore.shared (Current State):")
                        .font(.caption.bold())
                    
                    HStack {
                        Text("User:")
                            .foregroundColor(.secondary)
                        Text(session.currentUser).bold()
                        Spacer()
                        Text("Loyalty: \(session.loyaltyPoints) pts")
                            .font(.caption.bold())
                            .foregroundColor(.indigo)
                    }
                    .font(.subheadline)
                    
                    HStack {
                        Text("VIP Membership:")
                            .foregroundColor(.secondary)
                        Text(session.isVipMember ? "Active ⭐" : "Inactive")
                            .font(.caption.bold())
                            .foregroundColor(session.isVipMember ? .green : .red)
                        Spacer()
                    }
                    .font(.subheadline)
                }
                .padding(12)
                .background(Color.indigo.opacity(0.08))
                .cornerRadius(10)
                
                Divider()
                
                Text("Modify Singleton from 'Screen A':")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
                
                HStack {
                    TextField("New User Name", text: $newUserNameInput)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Update") {
                        if !newUserNameInput.isEmpty {
                            session.currentUser = newUserNameInput
                            newUserNameInput = ""
                        }
                    }
                    .font(.caption.bold())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(AppTheme.primary)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                HStack(spacing: 10) {
                    Button("+50 Points") {
                        session.loyaltyPoints += 50
                    }
                    .font(.caption.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.indigo.opacity(0.15))
                    .foregroundColor(.indigo)
                    .cornerRadius(8)
                    
                    Button("Toggle VIP") {
                        session.isVipMember.toggle()
                    }
                    .font(.caption.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.indigo.opacity(0.15))
                    .foregroundColor(.indigo)
                    .cornerRadius(8)
                    
                    Button("Reset Store") {
                        session.reset()
                    }
                    .font(.caption.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.red.opacity(0.12))
                    .foregroundColor(.red)
                    .cornerRadius(8)
                }
            }
        }
        
        // Code Block
        CodeBlockView(
            title: "Proper Swift Singleton Structure",
            code: """
// ─── Thread-Safe Swift Singleton ───
final class NetworkManager {
    // 1. Thread-safe static constant initialized only once (lazy by default)
    static let shared = NetworkManager()

    // 2. PRIVATE init guarantees no one can instantiate NetworkManager() elsewhere!
    private init() {
        print("NetworkManager initialized once")
    }

    func fetchData(from url: URL) {
        // Networking logic
    }
}

// ─── Usage Anywhere in the App ───
// No need to pass NetworkManager through initializers:
NetworkManager.shared.fetchData(from: myURL)
"""
        )
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - TAB 8: INTERVIEW QUESTIONS & CHEAT SHEET
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @ViewBuilder
    private var interviewQuestionsSection: some View {
        ConceptCard(
            title: "Top 5 iOS Data Sharing Interview Questions",
            subtitle: "Must-know answers for Junior to Senior iOS Developer interviews",
            icon: "questionmark.bubble.fill",
            iconColor: AppTheme.secondary
        ) {
            VStack(alignment: .leading, spacing: 16) {
                interviewQuestionCard(
                    number: "Q1",
                    question: "Why must delegate properties in Swift be marked 'weak'?",
                    answer: "Because Parent views or ViewControllers hold a strong reference to their child views. If the child view also holds a strong reference back to the parent via its delegate, both objects retain each other. Neither object's retain count will ever drop to 0, causing a permanent Retain Cycle and Memory Leak! Marking the delegate 'weak' ensures it does not increment retain count, and automatically sets the delegate to nil when the parent is deallocated."
                )
                
                interviewQuestionCard(
                    number: "Q2",
                    question: "When should you choose a Delegate vs a Closure?",
                    answer: "Use a Closure when there is a single event or completion callback (e.g., download completed, sheet dismissed, button tapped). Closures keep code inline and readable. Use a Delegate when there are MULTIPLE distinct events or lifecycle methods (e.g. UITableViewDelegate has 10+ methods for selection, header heights, deletion). Protocols also provide clean contracts that are easy to mock in unit testing."
                )
                
                interviewQuestionCard(
                    number: "Q3",
                    question: "What is the difference between @State, @Binding, and @EnvironmentObject in SwiftUI?",
                    answer: "• @State: Owns the data memory within the local view (Source of Truth).\n• @Binding: Creates a two-way read/write reference to a @State property owned by an ancestor without duplicating storage.\n• @EnvironmentObject: Provides tree-wide dependency injection. Data is injected at the root of a view hierarchy and accessible by any deep child view without passing props through intermediate views."
                )
                
                interviewQuestionCard(
                    number: "Q4",
                    question: "What are the drawbacks of using NotificationCenter?",
                    answer: "1. No compiler type checking: Payload values are passed in a loose dictionary `[AnyHashable: Any]`, leading to runtime casting errors.\n2. Invisible control flow: It is hard to know who is broadcasting and who is observing just by reading the code.\n3. Debugging nightmare: Tracing where a bug originated is difficult in large projects.\n4. Performance: Broadcasting to dozens of observers synchronously on the main thread can cause UI hitching."
                )
                
                interviewQuestionCard(
                    number: "Q5",
                    question: "How do you make a Singleton testable in Swift?",
                    answer: "Introduce a Protocol! Instead of components calling `NetworkManager.shared` directly, define `protocol NetworkManaging { func fetch() }`. Make `NetworkManager` conform to `NetworkManaging`. Then use Initializer Dependency Injection: `init(network: NetworkManaging = NetworkManager.shared)`. In production, it defaults to the singleton, but in unit tests you can inject a `MockNetworkManager`!"
                )
            }
        }
    }
    
    // MARK: - Helper UI Builders
    
    private func directionCard(title: String, mechanism: String, analogy: String, icon: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .padding(.top, 2)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(title).font(.subheadline.bold())
                    Spacer()
                    Text(mechanism)
                        .font(.system(size: 9, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(color.opacity(0.12))
                        .foregroundColor(color)
                        .cornerRadius(4)
                }
                Text("Analogy: \(analogy)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(10)
        .background(Color(.tertiarySystemGroupedBackground))
        .cornerRadius(10)
    }
    
    private func matrixRow(pattern: String, direction: String, cardinality: String, coupling: String, leakRisk: String, bestFor: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(pattern).font(.subheadline.bold()).foregroundColor(.primary)
                Spacer()
                Text(direction)
                    .font(.caption.bold())
                    .foregroundColor(AppTheme.primary)
            }
            
            HStack(spacing: 8) {
                Label(cardinality, systemImage: "arrow.triangle.branch")
                Label("Leak Risk: \(leakRisk)", systemImage: "shield.slash")
                    .foregroundColor(leakRisk.contains("High") ? .red : .secondary)
            }
            .font(.system(size: 10))
            .foregroundColor(.secondary)
            
            Text("Best for: \(bestFor)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
    }
    
    private func interviewQuestionCard(number: String, question: String, answer: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(number)
                    .font(.caption.bold())
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.orange.opacity(0.15))
                    .foregroundColor(.orange)
                    .cornerRadius(4)
                Text(question)
                    .font(.subheadline.bold())
                    .foregroundColor(.primary)
            }
            
            Text(answer)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.tertiarySystemGroupedBackground))
                .cornerRadius(8)
        }
    }
    
    private func calloutBox(text: String, icon: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.subheadline)
                .padding(.top, 2)
            Text(text)
                .font(.caption)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - Reusable Mini Child Components for Demos
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// 1. Injected Props Child
private struct ChildProfileCard: View {
    let name: String
    let role: String
    let unreadCount: Int

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(Color.blue.opacity(0.15)).frame(width: 44, height: 44)
                Image(systemName: "person.fill")
                    .foregroundColor(.blue)
                    .font(.title3)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name.isEmpty ? "Unnamed User" : name)
                    .font(.subheadline.bold())
                Text(role)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if unreadCount > 0 {
                Text("\(unreadCount) Badges")
                    .font(.system(size: 10, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding(12)
        .background(Color(.tertiarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// 2. Closure Child
private struct ChildFeedbackView: View {
    @Binding var rating: Int
    let onSubmit: (Int, String) -> Void
    @State private var commentText = "Great user experience!"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Select Rating:")
                    .font(.caption.bold())
                Spacer()
                HStack(spacing: 4) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .foregroundColor(.orange)
                            .onTapGesture {
                                rating = star
                            }
                    }
                }
            }
            
            TextField("Add a comment...", text: $commentText)
                .textFieldStyle(.roundedBorder)
            
            Button {
                onSubmit(rating, commentText)
            } label: {
                Label("Submit Feedback via Closure", systemImage: "checkmark.circle.fill")
                    .font(.caption.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding(12)
        .background(Color(.tertiarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// 3. Two-Way Binding Child
private struct ChildAudioController: View {
    @Binding var volumeBinding: Double
    @Binding var muteBinding: Bool
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Child View (@Binding Receiver):")
                    .font(.caption.bold())
                Spacer()
                Text("Direct Sync: \(Int(volumeBinding))%")
                    .font(.caption.monospacedDigit().bold())
            }
            
            HStack(spacing: 12) {
                Button {
                    volumeBinding = max(0, volumeBinding - 10)
                } label: {
                    Image(systemName: "speaker.minus.fill")
                        .font(.title3)
                        .padding(8)
                        .background(Color.teal.opacity(0.15))
                        .foregroundColor(.teal)
                        .cornerRadius(8)
                }
                
                Slider(value: $volumeBinding, in: 0...100)
                    .accentColor(accentColor)
                    .disabled(muteBinding)
                
                Button {
                    volumeBinding = min(100, volumeBinding + 10)
                } label: {
                    Image(systemName: "speaker.plus.fill")
                        .font(.title3)
                        .padding(8)
                        .background(Color.teal.opacity(0.15))
                        .foregroundColor(.teal)
                        .cornerRadius(8)
                }
            }
            
            Button {
                muteBinding.toggle()
            } label: {
                Text(muteBinding ? "Child Button: Unmute Audio 🔈" : "Child Button: Mute Audio 🔇")
                    .font(.caption.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(muteBinding ? Color.red.opacity(0.15) : Color.teal.opacity(0.15))
                    .foregroundColor(muteBinding ? .red : .teal)
                    .cornerRadius(6)
            }
        }
        .padding(12)
        .background(Color.teal.opacity(0.08))
        .cornerRadius(12)
    }
}
