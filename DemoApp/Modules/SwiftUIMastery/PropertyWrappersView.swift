import SwiftUI
import Combine

// MARK: - SwiftUI Property Wrappers

class UserSessionModel: ObservableObject {
    @Published var username: String = "Anurag"
    @Published var loginCount: Int = 1
}

struct PropertyWrappersView: View {
    // 1. @State: Owned local state
    @State private var localCounter = 0
    @State private var showChildView = false

    // 2. @StateObject: Lifecycle owned by this view instance
    @StateObject private var session = UserSessionModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "cube.transparent.fill")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.accent)
                        Text("Property Wrappers")
                            .font(.title2.bold())
                    }
                    Text("SwiftUI's reactive state engine: @State, @Binding, @ObservedObject, @StateObject, and @EnvironmentObject.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.accent.opacity(0.08))
                .cornerRadius(16)

                // Interactive State & Binding Playground
                ConceptCard(
                    title: "Live State & Binding Demo",
                    subtitle: "Two-way data binding between Parent and Child",
                    icon: "link.circle.fill",
                    iconColor: AppTheme.primary
                ) {
                    VStack(spacing: 12) {
                        HStack {
                            Text("Parent @State Counter: \(localCounter)")
                                .font(.subheadline.bold())
                            Spacer()
                            Button("+ Increment") {
                                localCounter += 1
                            }
                            .font(.caption.bold())
                            .buttonStyle(.borderedProminent)
                        }

                        Divider()

                        // Child View receiving @Binding
                        ChildBindingView(childBindingCounter: $localCounter)
                    }
                }

                // StateObject vs ObservedObject Lifecycle Card
                ConceptCard(
                    title: "@StateObject vs @ObservedObject",
                    subtitle: "Crucial difference in lifecycle ownership",
                    icon: "arrow.triangle.swap",
                    iconColor: AppTheme.purple
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Session User: \(session.username)")
                                    .font(.subheadline.bold())
                                Text("Login count: \(session.loginCount)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button("Bump Count") {
                                session.loginCount += 1
                            }
                            .font(.caption.bold())
                            .buttonStyle(.bordered)
                        }
                        .padding(10)
                        .background(Color(.tertiarySystemGroupedBackground))
                        .cornerRadius(8)

                        VStack(alignment: .leading, spacing: 6) {
                            BulletPoint(text: "@StateObject: Instantiates and OWNS the model. Persists through view re-renders.", color: AppTheme.purple)
                            BulletPoint(text: "@ObservedObject: Does NOT own the model. If used for instantiation, it gets DESTROYED and recreated whenever the parent view redraws!", color: AppTheme.error)
                            BulletPoint(text: "Golden Rule: Use @StateObject where the object is created; use @ObservedObject when passed down from a parent.", color: AppTheme.purple)
                        }
                    }
                }

                // Summary Table
                ConceptCard(
                    title: "Property Wrapper Cheat Sheet",
                    subtitle: "When to use each wrapper",
                    icon: "tablecells",
                    iconColor: AppTheme.secondary
                ) {
                    VStack(spacing: 10) {
                        KeyValueRow(key: "@State", value: "Local view private state (value types)", badgeColor: AppTheme.primary)
                        KeyValueRow(key: "@Binding", value: "Two-way pass-through without owning", badgeColor: AppTheme.accent)
                        KeyValueRow(key: "@StateObject", value: "Owner of ObservableObject lifecycle", badgeColor: AppTheme.purple)
                        KeyValueRow(key: "@ObservedObject", value: "Subscribes to external ObservableObject", badgeColor: AppTheme.warning)
                        KeyValueRow(key: "@EnvironmentObject", value: "Global shared model in view tree", badgeColor: AppTheme.pink)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Property Wrappers")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Child view with @Binding
private struct ChildBindingView: View {
    @Binding var childBindingCounter: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Child View (Consuming @Binding)")
                .font(.caption.bold())
                .foregroundColor(.secondary)

            HStack {
                Text("Value in Child: \(childBindingCounter)")
                    .font(.caption.bold())
                    .foregroundColor(AppTheme.accent)
                Spacer()
                Button("Decrement from Child") {
                    childBindingCounter -= 1
                }
                .font(.caption)
                .buttonStyle(.bordered)
                .tint(AppTheme.accent)
            }
        }
        .padding(10)
        .background(AppTheme.accent.opacity(0.08))
        .cornerRadius(8)
    }
}
