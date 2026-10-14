import SwiftUI

// MARK: - Main Application Dashboard

struct ConceptTopicItem: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let icon: String
    let color: Color
    let summary: String
    let destination: AnyView
    let tags: [String]
}

struct ContentView: View {
    @State private var searchText = ""

    private var allTopics: [ConceptTopicItem] {
        [
            ConceptTopicItem(
                title: "Memory Management & ARC",
                category: "Memory",
                icon: "memorychip",
                color: AppTheme.primary,
                summary: "Strong, Weak, Unowned, retain cycles, and live deallocation simulator",
                destination: AnyView(MemoryManagementView()),
                tags: ["ARC", "Retain Cycle", "Weak", "Unowned", "Dealloc", "Leaks"]
            ),
            ConceptTopicItem(
                title: "Struct vs Class vs Actor",
                category: "Types",
                icon: "square.stack.3d.up.fill",
                color: AppTheme.secondary,
                summary: "Value vs Reference, Stack vs Heap, live Copy-on-Write address inspector",
                destination: AnyView(ClassStructActorView()),
                tags: ["Struct", "Class", "Actor", "COW", "Stack", "Heap", "Thread Safety"]
            ),
            ConceptTopicItem(
                title: "Closures In-Depth",
                category: "Closures",
                icon: "curlybraces",
                color: AppTheme.purple,
                summary: "Non-escaping, @escaping, @autoclosure, and capture list copy semantics",
                destination: AnyView(ClosuresView()),
                tags: ["Escaping", "Autoclosure", "Capture List", "Weak Self"]
            ),
            ConceptTopicItem(
                title: "Defer & Lazy Properties",
                category: "Scope",
                icon: "arrow.uturn.forward.circle.fill",
                color: AppTheme.warning,
                summary: "Scope exit guarantees, LIFO execution order, and deferred lazy initialization",
                destination: AnyView(DeferAndLazyView()),
                tags: ["Defer", "Lazy", "LIFO", "Cleanup", "Performance"]
            ),
            ConceptTopicItem(
                title: "SOLID Principles",
                category: "Architecture",
                icon: "square.3.layers.3d.top.filled",
                color: AppTheme.pink,
                summary: "SRP, OCP, LSP, ISP, and DIP with interactive good vs bad code tabs",
                destination: AnyView(SOLIDView()),
                tags: ["SOLID", "SRP", "OCP", "LSP", "ISP", "DIP", "Clean Code"]
            ),
            ConceptTopicItem(
                title: "VIPER Architecture",
                category: "Architecture",
                icon: "square.split.diagonal.2x2.fill",
                color: Color.indigo,
                summary: "View, Interactor, Presenter, Entity, Router interactive lifecycle simulation",
                destination: AnyView(VIPERView()),
                tags: ["VIPER", "Interactor", "Presenter", "Router", "Clean Architecture"]
            ),
            ConceptTopicItem(
                title: "Design Patterns (GoF)",
                category: "Architecture",
                icon: "puzzlepiece.extension.fill",
                color: AppTheme.accent,
                summary: "Singleton, Factory, Builder, Adapter, Decorator, Facade, Observer & Delegate",
                destination: AnyView(DesignPatternsView()),
                tags: ["Singleton", "Factory", "Builder", "Adapter", "Decorator", "Facade", "Delegate"]
            ),
            ConceptTopicItem(
                title: "Bounds vs Frame",
                category: "UI Coordinates",
                icon: "viewfinder",
                color: AppTheme.primary,
                summary: "Interactive 360° rotation canvas showing real-time coordinate transformations",
                destination: AnyView(BoundsVsFrameView()),
                tags: ["Bounds", "Frame", "Rotation", "Coordinates", "Geometry"]
            ),
            ConceptTopicItem(
                title: "Concurrency & GCD",
                category: "Concurrency",
                icon: "arrow.triangle.2.circlepath",
                color: AppTheme.warning,
                summary: "DispatchQueue sync/async, deadlock alert, async/await, Task, and @MainActor",
                destination: AnyView(ConcurrencyView()),
                tags: ["GCD", "Async", "Await", "Task", "MainActor", "Deadlock", "DispatchQueue"]
            ),
            ConceptTopicItem(
                title: "Combine Framework",
                category: "Reactive",
                icon: "point.3.filled.connected.trianglepath.dotted",
                color: AppTheme.purple,
                summary: "Publishers, Just, PassthroughSubject, CurrentValueSubject live stream",
                destination: AnyView(CombineView()),
                tags: ["Combine", "Publisher", "Subject", "Passthrough", "CurrentValue", "Sink"]
            ),
            ConceptTopicItem(
                title: "SwiftUI Property Wrappers",
                category: "SwiftUI",
                icon: "cube.transparent.fill",
                color: AppTheme.accent,
                summary: "@State, @Binding, @ObservedObject, @StateObject, @EnvironmentObject",
                destination: AnyView(PropertyWrappersView()),
                tags: ["State", "Binding", "ObservedObject", "StateObject", "EnvironmentObject"]
            ),
            ConceptTopicItem(
                title: "SwiftUI View Lifecycle",
                category: "SwiftUI",
                icon: "clock.arrow.circlepath",
                color: Color.blue,
                summary: "onAppear, onDisappear, .task with cancellation, onChange, onReceive, self vs Self",
                destination: AnyView(ViewLifecycleView()),
                tags: ["onAppear", "onDisappear", "Task", "onChange", "onReceive", "self", "Self"]
            ),
            ConceptTopicItem(
                title: "SwiftUI Layout & Internals",
                category: "SwiftUI",
                icon: "rectangle.3.group.fill",
                color: AppTheme.secondary,
                summary: "ViewThatFits responsive slider, AnyView type-erasure, @ViewBuilder, TupleView",
                destination: AnyView(SwiftUILayoutView()),
                tags: ["ViewThatFits", "AnyView", "ViewBuilder", "TupleView"]
            ),
            ConceptTopicItem(
                title: "UIKit & SwiftUI Interop",
                category: "Interop",
                icon: "arrow.left.arrow.right.circle.fill",
                color: AppTheme.primary,
                summary: "Live UIViewControllerRepresentable bridge and UIHostingController",
                destination: AnyView(UIKitInteropView()),
                tags: ["UIViewControllerRepresentable", "UIHostingController", "Coordinator", "Bridge"]
            ),
            ConceptTopicItem(
                title: "Libraries & DYLD",
                category: "System",
                icon: "cpu.fill",
                color: Color.indigo,
                summary: "Static vs Dynamic libraries, DYLD runtime linking steps, .framework vs .xcframework",
                destination: AnyView(LibrariesAndDyldView()),
                tags: ["Static", "Dynamic", "DYLD", "Framework", "XCFramework", "Linking"]
            ),
            ConceptTopicItem(
                title: "Storage & Security",
                category: "Storage",
                icon: "lock.shield.fill",
                color: Color.orange,
                summary: "UserDefaults (@AppStorage) vs Keychain, sandbox storage & uninstall persistence",
                destination: AnyView(StorageAndSecurityView()),
                tags: ["UserDefaults", "Keychain", "AppStorage", "Security", "Encryption"]
            ),
            ConceptTopicItem(
                title: "SSL / TLS Pinning",
                category: "Security",
                icon: "checkmark.shield.fill",
                color: Color.teal,
                summary: "Certificate vs Public Key Pinning (SPKI), URLSessionDelegate, MITM attack test",
                destination: AnyView(SSLPinningView()),
                tags: ["SSL", "TLS", "Pinning", "Public Key", "SPKI", "MITM", "ServerTrust"]
            ),
            ConceptTopicItem(
                title: "Core Data Delete Rules",
                category: "Persistence",
                icon: "cylinder.split.1x2.fill",
                color: Color.red,
                summary: "Nullify, Cascade, Deny, and No Action interactive deletion simulator",
                destination: AnyView(CoreDataDeleteRulesView()),
                tags: ["Core Data", "Nullify", "Cascade", "Deny", "No Action", "Relationships"]
            ),
            ConceptTopicItem(
                title: "Codable & KVC / KVO",
                category: "Foundation",
                icon: "doc.text.magnifyingglass",
                color: AppTheme.primary,
                summary: "JSON snake_case, dateDecodingStrategy, KVC value(forKey:), and live KVO observer",
                destination: AnyView(CodableAndKVCView()),
                tags: ["Codable", "Decodable", "Encodable", "KVC", "KVO", "SnakeCase", "JSON"]
            ),
            ConceptTopicItem(
                title: "Types, Inits & Access",
                category: "Language",
                icon: "slider.horizontal.3",
                color: AppTheme.purple,
                summary: "Designated, Convenience & Failable inits, Optionals (? vs !), Any vs some, Access Specifiers",
                destination: AnyView(TypeSystemAndInitView()),
                tags: ["Init", "Convenience", "Failable", "Optional", "Any", "some", "Private", "Open", "Equatable", "Hashable"]
            )
        ]
    }

    private var filteredTopics: [ConceptTopicItem] {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            return allTopics
        } else {
            let query = searchText.lowercased()
            return allTopics.filter { topic in
                topic.title.lowercased().contains(query) ||
                topic.summary.lowercased().contains(query) ||
                topic.category.lowercased().contains(query) ||
                topic.tags.contains(where: { $0.lowercased().contains(query) })
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
                                Text("iOS Engineering Mastery Lab")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.85))
                            }
                            Spacer()
                            Image(systemName: "swift")
                                .font(.system(size: 44))
                                .foregroundColor(.white)
                        }

                        HStack(spacing: 8) {
                            statBadge(icon: "book.fill", text: "\(allTopics.count) Topics")
                            statBadge(icon: "play.circle.fill", text: "Interactive Demos")
                            statBadge(icon: "shield.fill", text: "Interview Ready")
                        }

                        NavigationLink(destination: QuizView()) {
                            HStack {
                                Image(systemName: "graduationcap.fill")
                                Text("Take Knowledge Practice Quiz")
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

                    // Topic Grid / List
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Learning Modules")
                                .font(.title3.bold())
                            Spacer()
                            Text("\(filteredTopics.count) Available")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                        }

                        if filteredTopics.isEmpty {
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
                                ForEach(filteredTopics) { topic in
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
                                                HStack {
                                                    Text(topic.title)
                                                        .font(.headline)
                                                        .foregroundColor(.primary)
                                                        .multilineTextAlignment(.leading)
                                                    Spacer()
                                                    Text(topic.category)
                                                        .font(.system(size: 10, weight: .bold))
                                                        .padding(.horizontal, 6)
                                                        .padding(.vertical, 2)
                                                        .background(topic.color.opacity(0.12))
                                                        .foregroundColor(topic.color)
                                                        .cornerRadius(4)
                                                }

                                                Text(topic.summary)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                    .multilineTextAlignment(.leading)
                                                    .lineLimit(2)

                                                // Tag Pills
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
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .navigationTitle("SwiftCraft Lab")
            .searchable(text: $searchText, prompt: "Search KVO, Bounds, Retain Cycles, DYLD...")
            .background(Color(.systemGroupedBackground))
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
