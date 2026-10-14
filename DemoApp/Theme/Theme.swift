import SwiftUI

// MARK: - App Design System & Styling

enum AppTheme {
    static let primary = Color(red: 0.22, green: 0.45, blue: 0.95) // Vibrant Royal Blue
    static let secondary = Color(red: 0.43, green: 0.29, blue: 0.90) // Electric Indigo
    static let accent = Color(red: 0.05, green: 0.78, blue: 0.65) // Bright Teal
    static let warning = Color(red: 0.98, green: 0.62, blue: 0.18) // Warm Amber
    static let error = Color(red: 0.94, green: 0.28, blue: 0.35) // Coral Crimson
    static let success = Color(red: 0.16, green: 0.77, blue: 0.46) // Emerald Green
    static let purple = Color(red: 0.65, green: 0.35, blue: 0.95)
    static let pink = Color(red: 0.95, green: 0.30, blue: 0.65)

    static let backgroundGradient = LinearGradient(
        colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let primaryGradient = LinearGradient(
        colors: [primary, secondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let tealGradient = LinearGradient(
        colors: [Color(red: 0.05, green: 0.78, blue: 0.65), Color(red: 0.12, green: 0.58, blue: 0.85)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let orangeGradient = LinearGradient(
        colors: [Color(red: 0.98, green: 0.52, blue: 0.22), Color(red: 0.94, green: 0.28, blue: 0.35)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Reusable UI Components

struct ConceptCard<Content: View>: View {
    let title: String
    let subtitle: String?
    let icon: String
    let iconColor: Color
    @ViewBuilder let content: () -> Content

    init(
        title: String,
        subtitle: String? = nil,
        icon: String,
        iconColor: Color = AppTheme.primary,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.iconColor = iconColor
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 36, height: 36)
                    Image(systemName: icon)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(iconColor)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
            }

            content()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        )
    }
}

struct CodeBlockView: View {
    let title: String
    let code: String
    @State private var copied = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 6) {
                    Circle().fill(Color.red.opacity(0.7)).frame(width: 8, height: 8)
                    Circle().fill(Color.yellow.opacity(0.7)).frame(width: 8, height: 8)
                    Circle().fill(Color.green.opacity(0.7)).frame(width: 8, height: 8)
                    Text(title)
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Button {
                    UIPasteboard.general.string = code
                    copied = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        copied = false
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: copied ? "checkmark" : "doc.on.doc")
                        Text(copied ? "Copied" : "Copy")
                    }
                    .font(.caption2)
                    .foregroundColor(copied ? .green : .secondary)
                }
            }
            .padding(.bottom, 2)

            ScrollView(.horizontal, showsIndicators: false) {
                Text(code)
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                    .foregroundColor(Color.primary)
                    .padding(8)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(.tertiarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }
}

struct BulletPoint: View {
    let text: String
    var icon: String = "checkmark.circle.fill"
    var color: Color = AppTheme.primary

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(color)
                .padding(.top, 2)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct KeyValueRow: View {
    let key: String
    let value: String
    var badgeColor: Color = AppTheme.primary

    var body: some View {
        HStack(alignment: .top) {
            Text(key)
                .font(.subheadline.bold())
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .font(.caption.bold())
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(badgeColor.opacity(0.15))
                .foregroundColor(badgeColor)
                .cornerRadius(6)
        }
    }
}

struct InteractiveLogBox: View {
    let logs: [String]
    let onClear: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Console Output")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
                Spacer()
                Button("Clear", action: onClear)
                    .font(.caption)
                    .foregroundColor(AppTheme.error)
            }

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        if logs.isEmpty {
                            Text("No events yet. Tap the buttons above to interact.")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundColor(.secondary)
                                .italic()
                        } else {
                            ForEach(Array(logs.enumerated()), id: \.offset) { index, log in
                                Text(log)
                                    .font(.system(size: 11, design: .monospaced))
                                    .foregroundColor(.primary)
                                    .id(index)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                }
                .frame(height: 120)
                .background(Color(.tertiarySystemGroupedBackground))
                .cornerRadius(8)
                .onChange(of: logs.count) { _ in
                    if let last = logs.indices.last {
                        proxy.scrollTo(last, anchor: .bottom)
                    }
                }
            }
        }
    }
}
