import SwiftUI

// MARK: - SwiftCraft: iOS Engineering Mastery Hub

struct ContentView: View {
    @State private var viewMode: Int = 0 // 0: Roadmap Path (From Scratch), 1: All Topics & Search
    @State private var searchText: String = ""

    // MARK: - 10 Structured Roadmap Levels (From Scratch to Staff Engineer)
    private var roadmapLevels: [RoadmapLevel] {
        [
            RoadmapLevel(
                id: 1,
                levelNumber: 1,
                title: "Swift Foundations",
                subtitle: "Data Types, Mutability, Optionals & Control Flow",
                icon: "1.circle.fill",
                color: Color.blue,
                topics: [
                    RoadmapTopic(
                        title: "Data Types & Variables",
                        summary: "Int, Double, Float, String, Bool, Tuples, and let vs var",
                        icon: "number.circle.fill",
                        color: Color.blue,
                        destination: AnyView(SwiftFundamentalsView()),
                        keyInterviewConcept: "Immutability & Type Inference",
                        tags: ["Int", "Double", "String", "Tuples", "let", "var"]
                    ),
                    RoadmapTopic(
                        title: "Optionals & Safety",
                        summary: "Why optionals exist, if let, guard let, ?? coalesce, and force unwrap (!)",
                        icon: "questionmark.circle.fill",
                        color: Color.teal,
                        destination: AnyView(SwiftFundamentalsView()),
                        keyInterviewConcept: "Bypassing the billion-dollar mistake",
                        tags: ["Optionals", "if let", "guard let", "??", "!"]
                    )
                ]
            ),
            RoadmapLevel(
                id: 2,
                levelNumber: 2,
                title: "Custom Types & Object-Oriented Swift",
                subtitle: "Enums, Initializers, Properties & Access Levels",
                icon: "2.circle.fill",
                color: Color.purple,
                topics: [
                    RoadmapTopic(
                        title: "Enums & Property Observers",
                        summary: "Associated values, raw values, computed properties, and willSet / didSet",
                        icon: "thermometer.medium",
                        color: Color.purple,
                        destination: AnyView(CustomTypesAndPropertiesView()),
                        keyInterviewConcept: "Pattern Matching & Reactive State Observers",
                        tags: ["Enums", "Associated Values", "willSet", "didSet", "Computed"]
                    ),
                    RoadmapTopic(
                        title: "Initializers & Access Specifiers",
                        summary: "Designated, Convenience, Failable (init?), private, fileprivate, public, open",
                        icon: "slider.horizontal.3",
                        color: AppTheme.secondary,
                        destination: AnyView(TypeSystemAndInitView()),
                        keyInterviewConcept: "Class Initializer Delegation Rules & Encapsulation",
                        tags: ["Designated", "Convenience", "init?", "private", "open", "final"]
                    )
                ]
            ),
            RoadmapLevel(
                id: 3,
                levelNumber: 3,
                title: "Functional Swift & Scope",
                subtitle: "Closures, Capture Lists & Scope Guarantees",
                icon: "3.circle.fill",
                color: AppTheme.purple,
                topics: [
                    RoadmapTopic(
                        title: "Closures In-Depth",
                        summary: "Non-escaping, @escaping, @autoclosure, and capture list [copy] semantics",
                        icon: "curlybraces",
                        color: AppTheme.purple,
                        destination: AnyView(ClosuresView()),
                        keyInterviewConcept: "Escaping memory lifecycle & copy vs ref captures",
                        tags: ["Escaping", "Autoclosure", "Capture List", "Closures"]
                    ),
                    RoadmapTopic(
                        title: "Defer & Lazy Properties",
                        summary: "Guaranteed scope cleanup (LIFO) and deferred lazy initialization",
                        icon: "arrow.uturn.forward.circle.fill",
                        color: AppTheme.warning,
                        destination: AnyView(DeferAndLazyView()),
                        keyInterviewConcept: "Resource cleanup guarantees & memory optimization",
                        tags: ["Defer", "Lazy", "LIFO", "Scope"]
                    )
                ]
            ),
            RoadmapLevel(
                id: 4,
                levelNumber: 4,
                title: "Data Sharing Ways in iOS",
                subtitle: "All 8 Core Communication Patterns",
                icon: "4.circle.fill",
                color: Color.orange,
                topics: [
                    RoadmapTopic(
                        title: "All 8 Data Sharing Patterns",
                        summary: "Props, Delegate (weak), Closures, NotificationCenter, Combine, @Binding, Singleton",
                        icon: "arrow.triangle.swap",
                        color: Color.orange,
                        destination: AnyView(DataSharingWaysView()),
                        keyInterviewConcept: "1-to-1 vs 1-to-Many vs Reactive State Pipelines",
                        tags: ["Delegate", "Closure", "NotificationCenter", "Combine", "@Binding", "Singleton"]
                    )
                ]
            ),
            RoadmapLevel(
                id: 5,
                levelNumber: 5,
                title: "Memory Management & ARC",
                subtitle: "Automatic Reference Counting, Leaks & COW",
                icon: "5.circle.fill",
                color: AppTheme.primary,
                topics: [
                    RoadmapTopic(
                        title: "ARC & Retain Cycle Simulator",
                        summary: "Strong, Weak (zeroing), Unowned (crash on nil), retain cycles, deinit triggers",
                        icon: "memorychip",
                        color: AppTheme.primary,
                        destination: AnyView(MemoryManagementView()),
                        keyInterviewConcept: "Preventing Memory Leaks & Breaking Retain Cycles",
                        tags: ["ARC", "Retain Cycle", "Weak", "Unowned", "Dealloc"]
                    ),
                    RoadmapTopic(
                        title: "Struct vs Class vs Actor & COW",
                        summary: "Stack vs Heap, value vs reference, Actor thread isolation, live COW buffer inspector",
                        icon: "square.stack.3d.up.fill",
                        color: AppTheme.secondary,
                        destination: AnyView(ClassStructActorView()),
                        keyInterviewConcept: "Copy-on-Write optimization & Actor Data Races",
                        tags: ["Struct", "Class", "Actor", "COW", "Stack", "Heap"]
                    )
                ]
            ),
            RoadmapLevel(
                id: 6,
                levelNumber: 6,
                title: "Concurrency & Reactive Programming",
                subtitle: "GCD, Modern async/await & Combine",
                icon: "6.circle.fill",
                color: AppTheme.warning,
                topics: [
                    RoadmapTopic(
                        title: "Concurrency: GCD & Swift Tasks",
                        summary: "DispatchQueue sync/async, Deadlock trap, async/await, Task, @MainActor",
                        icon: "arrow.triangle.2.circlepath",
                        color: AppTheme.warning,
                        destination: AnyView(ConcurrencyView()),
                        keyInterviewConcept: "Why main.sync Deadlocks & Structured Concurrency",
                        tags: ["GCD", "Async", "Await", "Task", "Deadlock", "@MainActor"]
                    ),
                    RoadmapTopic(
                        title: "Combine Framework",
                        summary: "Publishers, Just, PassthroughSubject vs CurrentValueSubject live event streams",
                        icon: "point.3.filled.connected.trianglepath.dotted",
                        color: AppTheme.purple,
                        destination: AnyView(CombineView()),
                        keyInterviewConcept: "Stateless vs Stateful Event Streaming",
                        tags: ["Combine", "Publisher", "Subject", "Passthrough", "CurrentValue"]
                    )
                ]
            ),
            RoadmapLevel(
                id: 7,
                levelNumber: 7,
                title: "UI Engineering & SwiftUI Mechanics",
                subtitle: "Coordinates, Property Wrappers & Lifecycle",
                icon: "7.circle.fill",
                color: AppTheme.accent,
                topics: [
                    RoadmapTopic(
                        title: "Bounds vs Frame",
                        summary: "360° rotation canvas: internal coordinate system vs superview bounding box",
                        icon: "viewfinder",
                        color: AppTheme.primary,
                        destination: AnyView(BoundsVsFrameView()),
                        keyInterviewConcept: "Why Rotation Changes Frame but NOT Bounds",
                        tags: ["Bounds", "Frame", "Rotation", "Coordinates"]
                    ),
                    RoadmapTopic(
                        title: "SwiftUI Property Wrappers",
                        summary: "@State, @Binding, @ObservedObject, @StateObject, @EnvironmentObject",
                        icon: "cube.transparent.fill",
                        color: AppTheme.accent,
                        destination: AnyView(PropertyWrappersView()),
                        keyInterviewConcept: "StateObject ownership vs ObservedObject recreation",
                        tags: ["State", "Binding", "StateObject", "ObservedObject"]
                    ),
                    RoadmapTopic(
                        title: "View Lifecycle & Events",
                        summary: "onAppear, onDisappear, .task with auto-cancellation, onChange, onReceive, self vs Self",
                        icon: "clock.arrow.circlepath",
                        color: Color.blue,
                        destination: AnyView(ViewLifecycleView()),
                        keyInterviewConcept: "Structured Task cancellation on view unmount",
                        tags: ["onAppear", "onDisappear", "Task", "onChange", "Self"]
                    ),
                    RoadmapTopic(
                        title: "Layout & Internals",
                        summary: "ViewThatFits responsive slider, AnyView performance cost, @ViewBuilder & TupleView",
                        icon: "rectangle.3.group.fill",
                        color: AppTheme.secondary,
                        destination: AnyView(SwiftUILayoutView()),
                        keyInterviewConcept: "Why AnyView hurts performance & structural identity",
                        tags: ["ViewThatFits", "AnyView", "ViewBuilder", "TupleView"]
                    ),
                    RoadmapTopic(
                        title: "UIKit & SwiftUI Interop",
                        summary: "UIViewControllerRepresentable with Coordinator & UIHostingController rootView",
                        icon: "arrow.left.arrow.right.circle.fill",
                        color: AppTheme.primary,
                        destination: AnyView(UIKitInteropView()),
                        keyInterviewConcept: "Bridging delegates and views between UI frameworks",
                        tags: ["UIViewControllerRepresentable", "UIHostingController", "Coordinator"]
                    )
                ]
            ),
            RoadmapLevel(
                id: 8,
                levelNumber: 8,
                title: "Persistence, Security & Networking",
                subtitle: "Storage, SSL Pinning & Core Data Rules",
                icon: "8.circle.fill",
                color: Color.green,
                topics: [
                    RoadmapTopic(
                        title: "UserDefaults vs Keychain",
                        summary: "Unencrypted .plist vs hardware AES-256; why Keychain persists after app uninstall",
                        icon: "lock.shield.fill",
                        color: Color.orange,
                        destination: AnyView(StorageAndSecurityView()),
                        keyInterviewConcept: "Security & Sandbox lifecycle persistence differences",
                        tags: ["UserDefaults", "Keychain", "AppStorage", "Security"]
                    ),
                    RoadmapTopic(
                        title: "SSL / TLS Pinning",
                        summary: "Certificate vs Public Key (SPKI) pinning, URLSessionDelegate, MITM attack defense",
                        icon: "checkmark.shield.fill",
                        color: Color.teal,
                        destination: AnyView(SSLPinningView()),
                        keyInterviewConcept: "Public Key Pinning vs Cert Expiration Disasters",
                        tags: ["SSL", "TLS", "Pinning", "Public Key", "MITM", "ServerTrust"]
                    ),
                    RoadmapTopic(
                        title: "Core Data Delete Rules",
                        summary: "Nullify, Cascade, Deny, and No Action interactive deletion simulator",
                        icon: "cylinder.split.1x2.fill",
                        color: Color.red,
                        destination: AnyView(CoreDataDeleteRulesView()),
                        keyInterviewConcept: "Foreign relationship constraints & cascade propagation",
                        tags: ["Core Data", "Nullify", "Cascade", "Deny", "No Action"]
                    ),
                    RoadmapTopic(
                        title: "Codable, KVC & KVO",
                        summary: "JSON snake_case, dateDecodingStrategy, KVC value(forKey:), and live KVO observer",
                        icon: "doc.text.magnifyingglass",
                        color: AppTheme.primary,
                        destination: AnyView(CodableAndKVCView()),
                        keyInterviewConcept: "Dynamic runtime introspection vs type-safe serialization",
                        tags: ["Codable", "Decodable", "KVC", "KVO", "SnakeCase"]
                    )
                ]
            ),
            RoadmapLevel(
                id: 9,
                levelNumber: 9,
                title: "Architecture & System Internals",
                subtitle: "SOLID, VIPER, Design Patterns & DYLD",
                icon: "9.circle.fill",
                color: Color.pink,
                topics: [
                    RoadmapTopic(
                        title: "SOLID Principles",
                        summary: "S, O, L, I, D principles with bad anti-patterns vs good refactored code tabs",
                        icon: "square.3.layers.3d.top.filled",
                        color: AppTheme.pink,
                        destination: AnyView(SOLIDView()),
                        keyInterviewConcept: "Dependency Inversion, LSP Violations & Protocol Abstractions",
                        tags: ["SOLID", "SRP", "OCP", "LSP", "ISP", "DIP"]
                    ),
                    RoadmapTopic(
                        title: "VIPER Architecture",
                        summary: "View, Interactor, Presenter, Entity, Router interactive step-by-step trace",
                        icon: "square.split.diagonal.2x2.fill",
                        color: Color.indigo,
                        destination: AnyView(VIPERView()),
                        keyInterviewConcept: "Decoupling business logic from UI & testability",
                        tags: ["VIPER", "Interactor", "Presenter", "Router"]
                    ),
                    RoadmapTopic(
                        title: "GoF Design Patterns",
                        summary: "Singleton, Factory, Builder, Adapter, Decorator, Facade, Observer, Delegate",
                        icon: "puzzlepiece.extension.fill",
                        color: AppTheme.accent,
                        destination: AnyView(DesignPatternsView()),
                        keyInterviewConcept: "Creational, Structural & Behavioural Pattern Selection",
                        tags: ["Singleton", "Factory", "Builder", "Adapter", "Decorator", "Facade"]
                    ),
                    RoadmapTopic(
                        title: "Libraries & DYLD",
                        summary: "Static vs Dynamic libraries, DYLD runtime linking steps, .framework vs .xcframework",
                        icon: "cpu.fill",
                        color: Color.indigo,
                        destination: AnyView(LibrariesAndDyldView()),
                        keyInterviewConcept: "Compile-time bundling vs Runtime dynamic link resolution",
                        tags: ["Static", "Dynamic", "DYLD", "XCFramework", "Linking"]
                    )
                ]
            ),
            RoadmapLevel(
                id: 10,
                levelNumber: 10,
                title: "Interview Readiness Arena",
                subtitle: "Mock Technical Quiz & Scenario Flashcards",
                icon: "10.circle.fill",
                color: AppTheme.warning,
                topics: [
                    RoadmapTopic(
                        title: "Senior iOS Knowledge Quiz",
                        summary: "Multi-choice scenario challenges with instant explanations and score tracker",
                        icon: "graduationcap.fill",
                        color: AppTheme.warning,
                        destination: AnyView(QuizView()),
                        keyInterviewConcept: "Real technical interview questions from top tech companies",
                        tags: ["Quiz", "Interview", "Test", "Flashcards", "Scoring"]
                    )
                ]
            )
        ]
    }

    // Flat list for search
    private var allTopicsFlat: [RoadmapTopic] {
        roadmapLevels.flatMap { $0.topics }
    }

    private var searchFilteredTopics: [RoadmapTopic] {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            return allTopicsFlat
        } else {
            let q = searchText.lowercased()
            return allTopicsFlat.filter { topic in
                topic.title.lowercased().contains(q) ||
                topic.summary.lowercased().contains(q) ||
                topic.keyInterviewConcept.lowercased().contains(q) ||
                topic.tags.contains(where: { $0.lowercased().contains(q) })
            }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Hero Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("SwiftCraft")
                                    .font(.system(size: 28, weight: .black, design: .rounded))
                                    .foregroundColor(.white)
                                Text("Zero to Staff iOS Engineer Roadmap")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.85))
                            }
                            Spacer()
                            Image(systemName: "swift")
                                .font(.system(size: 44))
                                .foregroundColor(.white)
                        }

                        HStack(spacing: 8) {
                            statBadge(icon: "ladder", text: "10 Progressive Levels")
                            statBadge(icon: "bolt.fill", text: "From Scratch")
                            statBadge(icon: "play.circle.fill", text: "Live Simulators")
                        }

                        NavigationLink(destination: QuizView()) {
                            HStack {
                                Image(systemName: "graduationcap.fill")
                                Text("Take Mock Interview Quiz (Level 10)")
                                    .font(.subheadline.bold())
                                Spacer()
                                Image(systemName: "arrow.right")
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .foregroundColor(AppTheme.primary)
                            .cornerRadius(10)
                        }
                    }
                    .padding(20)
                    .background(AppTheme.primaryGradient)
                    .cornerRadius(20)
                    .shadow(color: AppTheme.primary.opacity(0.3), radius: 12, x: 0, y: 6)

                    // Mode Switcher: Step-by-Step Roadmap vs Quick Search Library
                    Picker("Learning Mode", selection: $viewMode) {
                        Text("🪜 Roadmap Path (From Scratch)").tag(0)
                        Text("🔍 Search & Library").tag(1)
                    }
                    .pickerStyle(.segmented)

                    if viewMode == 0 {
                        // MARK: - Progressive Roadmap View
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Curriculum Ladder")
                                    .font(.title3.bold())
                                Spacer()
                                Text("Sequential Progression")
                                    .font(.caption.bold())
                                    .foregroundColor(.secondary)
                            }

                            LazyVStack(spacing: 16) {
                                ForEach(roadmapLevels) { level in
                                    roadmapLevelCard(level: level)
                                }
                            }
                        }
                    } else {
                        // MARK: - Search & Flat Topic Library
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Concept Library")
                                    .font(.title3.bold())
                                Spacer()
                                Text("\(searchFilteredTopics.count) Topics")
                                    .font(.caption.bold())
                                    .foregroundColor(.secondary)
                            }

                            if searchFilteredTopics.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.largeTitle)
                                        .foregroundColor(.secondary)
                                    Text("No matching concepts found for '\(searchText)'")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                            } else {
                                LazyVStack(spacing: 12) {
                                    ForEach(searchFilteredTopics) { topic in
                                        topicCard(topic: topic)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .navigationTitle("SwiftCraft Lab")
            .searchable(text: $searchText, prompt: "Search Data Types, Data Sharing, KVO, DYLD...")
            .background(Color(.systemGroupedBackground))
        }
    }

    // MARK: - Level Card (Roadmap Mode)
    private func roadmapLevelCard(level: RoadmapLevel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Level Header
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(level.color.opacity(0.15))
                        .frame(width: 36, height: 36)
                    Text("L\(level.levelNumber)")
                        .font(.system(size: 14, weight: .black, design: .rounded))
                        .foregroundColor(level.color)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(level.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(level.subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }

            Divider()

            // Topics within Level
            VStack(spacing: 8) {
                ForEach(level.topics) { topic in
                    NavigationLink(destination: topic.destination) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(topic.color.opacity(0.12))
                                    .frame(width: 34, height: 34)
                                Image(systemName: topic.icon)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(topic.color)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(topic.title)
                                    .font(.subheadline.bold())
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)

                                Text(topic.summary)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)

                                HStack(spacing: 4) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 8))
                                        .foregroundColor(level.color)
                                    Text("Interview Key: \(topic.keyInterviewConcept)")
                                        .font(.system(size: 9, weight: .semibold))
                                        .foregroundColor(level.color)
                                        .lineLimit(1)
                                }
                                .padding(.top, 2)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.caption.bold())
                                .foregroundColor(Color(.tertiaryLabel))
                        }
                        .padding(10)
                        .background(Color(.tertiarySystemGroupedBackground))
                        .cornerRadius(10)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        )
    }

    // MARK: - Topic Card (Search Mode)
    private func topicCard(topic: RoadmapTopic) -> some View {
        NavigationLink(destination: topic.destination) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(topic.color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: topic.icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(topic.color)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(topic.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)

                    Text(topic.summary)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            ForEach(topic.tags.prefix(3), id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(.system(size: 9, weight: .medium))
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 1)
                                    .background(Color(.tertiarySystemGroupedBackground))
                                    .cornerRadius(3)
                            }
                        }
                    }
                    .padding(.top, 2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundColor(Color(.tertiaryLabel))
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
                    .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
            )
        }
    }

    private func statBadge(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
            Text(text)
                .font(.system(size: 10, weight: .semibold))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.white.opacity(0.2))
        .foregroundColor(.white)
        .cornerRadius(6)
    }
}

#Preview {
    ContentView()
}
