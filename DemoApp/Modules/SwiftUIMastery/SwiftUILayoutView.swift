import SwiftUI

// MARK: - ViewThatFits, AnyView, @ViewBuilder & TupleView

struct SwiftUILayoutView: View {
    @State private var availableWidth: CGFloat = 300
    @State private var showTypeErased = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "rectangle.3.group.fill")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.accent)
                        Text("SwiftUI Layout & Internals")
                            .font(.title2.bold())
                    }
                    Text("Deep dive into ViewThatFits adaptive layouts, AnyView type-erasure, @ViewBuilder DSL, and TupleView composite representations.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.accent.opacity(0.08))
                .cornerRadius(16)

                // ViewThatFits Live Interactive Card
                ConceptCard(
                    title: "Live ViewThatFits Tester",
                    subtitle: "Resize width to see layout auto-switch",
                    icon: "arrow.left.and.right.circle.fill",
                    iconColor: AppTheme.primary
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Drag the slider to compress available width. ViewThatFits will automatically switch from horizontal row to compact stacked badges without clipping!")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        VStack(alignment: .leading) {
                            Text("Container Width: \(Int(availableWidth)) pt")
                                .font(.caption.bold())
                            Slider(value: $availableWidth, in: 120...320, step: 10)
                        }

                        // Constrained container
                        VStack {
                            ViewThatFits(in: .horizontal) {
                                // 1. Preferred wide layout
                                HStack(spacing: 8) {
                                    badge(text: "⚡ Ultra-Fast", color: .blue)
                                    badge(text: "🔒 Secure", color: .green)
                                    badge(text: "📱 Responsive", color: .purple)
                                }

                                // 2. Compact 2-item fallback
                                HStack(spacing: 8) {
                                    badge(text: "⚡ Fast", color: .blue)
                                    badge(text: "🔒 Secure", color: .green)
                                }

                                // 3. Minimal fallback
                                VStack(spacing: 4) {
                                    badge(text: "⚡ Minimalist Stack", color: .orange)
                                }
                            }
                        }
                        .frame(width: availableWidth)
                        .padding(12)
                        .background(Color(.tertiarySystemGroupedBackground))
                        .cornerRadius(10)
                    }
                }

                // AnyView Breakdown
                ConceptCard(
                    title: "AnyView (Type-Erased View)",
                    subtitle: "Wrapper for heterogeneous view returns",
                    icon: "eye.slash.fill",
                    iconColor: AppTheme.purple
                ) {
                    VStack(alignment: .leading, spacing: 10) {
                        BulletPoint(text: "Wraps any concrete View type into a unified type-erased 'AnyView'.", color: AppTheme.purple)
                        BulletPoint(text: "Use case: Returning different views from functions or heterogeneous collections.", color: AppTheme.purple)
                        BulletPoint(text: "⚠️ Performance Trade-off: Destroys SwiftUI's compile-time static type tree, wiping out structural identity, subtle animations, and view state preservation across re-renders!", color: AppTheme.error)
                        BulletPoint(text: "Best Practice: Prefer @ViewBuilder or Group instead of AnyView whenever possible.", color: AppTheme.purple)

                        CodeBlockView(
                            title: "AnyView vs @ViewBuilder",
                            code: """
// ❌ AnyView (destroys structural identity)
func makeHeader(flag: Bool) -> AnyView {
    if flag { return AnyView(Text("Hello")) }
    else { return AnyView(Image(systemName: "star")) }
}

// ✅ @ViewBuilder (preserves identity & performance)
@ViewBuilder
func makeBetterHeader(flag: Bool) -> some View {
    if flag { Text("Hello") }
    else { Image(systemName: "star") }
}
"""
                        )
                    }
                }

                // @ViewBuilder & TupleView Breakdown
                ConceptCard(
                    title: "@ViewBuilder & TupleView",
                    subtitle: "How SwiftUI translates declarative syntax",
                    icon: "chevron.left.forwardslash.chevron.right",
                    iconColor: AppTheme.secondary
                ) {
                    VStack(alignment: .leading, spacing: 10) {
                        BulletPoint(text: "@ViewBuilder: A Swift result builder that transforms multiple child view statements into a single composite type.")
                        BulletPoint(text: "TupleView: The underlying struct generated by ViewBuilder when you write multiple sibling views inside a { } closure.")
                        BulletPoint(text: "Example: VStack { Text(\"A\"); Text(\"B\") } evaluates its content to `TupleView<(Text, Text)>` at compile time!")
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Layout & Internals")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func badge(text: String, color: Color) -> some View {
        Text(text)
            .font(.caption2.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(6)
    }
}
