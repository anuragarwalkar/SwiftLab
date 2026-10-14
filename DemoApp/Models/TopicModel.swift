import SwiftUI

// MARK: - Learning Roadmap Levels & Topic Models

struct RoadmapLevel: Identifiable {
    let id: Int
    let levelNumber: Int
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let topics: [RoadmapTopic]
}

struct RoadmapTopic: Identifiable {
    let id = UUID()
    let title: String
    let summary: String
    let icon: String
    let color: Color
    let destination: AnyView
    let keyInterviewConcept: String
    let tags: [String]
}

// MARK: - Topic and Category Models (Reference Mode)

enum TopicCategory: String, CaseIterable, Identifiable {
    case foundations = "Foundations"
    case communication = "Data Sharing"
    case memory = "Memory & ARC"
    case closuresAndScope = "Closures & Scope"
    case architecture = "Architecture & Patterns"
    case swiftUI = "SwiftUI & Layout"
    case concurrency = "Concurrency & Combine"
    case system = "System & Frameworks"
    case storage = "Storage & Security"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .foundations: return "book.fill"
        case .communication: return "arrow.triangle.swap"
        case .memory: return "memorychip"
        case .closuresAndScope: return "curlybraces"
        case .architecture: return "square.3.layers.3d.top.filled"
        case .swiftUI: return "paintbrush.fill"
        case .concurrency: return "arrow.triangle.2.circlepath"
        case .system: return "cpu"
        case .storage: return "lock.shield.fill"
        }
    }

    var color: Color {
        switch self {
        case .foundations: return Color.blue
        case .communication: return Color.orange
        case .memory: return AppTheme.primary
        case .closuresAndScope: return AppTheme.purple
        case .architecture: return AppTheme.pink
        case .swiftUI: return AppTheme.accent
        case .concurrency: return AppTheme.warning
        case .system: return Color.indigo
        case .storage: return Color.green
        }
    }
}
