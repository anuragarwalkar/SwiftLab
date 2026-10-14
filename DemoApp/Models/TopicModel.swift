import SwiftUI

// MARK: - Topic and Category Models

enum TopicCategory: String, CaseIterable, Identifiable {
    case memory = "Memory & ARC"
    case swiftTypes = "Types & OOP"
    case closuresAndScope = "Closures & Scope"
    case architecture = "Architecture & Patterns"
    case swiftUI = "SwiftUI & Layout"
    case concurrency = "Concurrency & Combine"
    case system = "System & Frameworks"
    case storage = "Storage & Security"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .memory: return "memorychip"
        case .swiftTypes: return "square.stack.3d.up.fill"
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
        case .memory: return AppTheme.primary
        case .swiftTypes: return AppTheme.secondary
        case .closuresAndScope: return AppTheme.purple
        case .architecture: return AppTheme.pink
        case .swiftUI: return AppTheme.accent
        case .concurrency: return AppTheme.warning
        case .system: return Color.indigo
        case .storage: return Color.orange
        }
    }

    var description: String {
        switch self {
        case .memory:
            return "Strong, Weak, Unowned, retain cycles, ARC, and deallocations"
        case .swiftTypes:
            return "Struct vs Class vs Actor, COW, Initializers, Any vs some, Protocols"
        case .closuresAndScope:
            return "Escaping, non-escaping, autoclosures, capture lists, defer & lazy"
        case .architecture:
            return "SOLID principles, VIPER architecture, GoF design patterns"
        case .swiftUI:
            return "Property wrappers, view lifecycle, ViewThatFits, UIHosting, Bounds vs Frame"
        case .concurrency:
            return "GCD sync/async, async/await, Task, @MainActor, Combine subjects"
        case .system:
            return "Static vs Dynamic libraries, DYLD, .framework vs .xcframework, Core Data delete rules"
        case .storage:
            return "UserDefaults vs Keychain, SSL Pinning, KVC & KVO, Codable"
        }
    }
}

struct ConceptItem: Identifiable {
    let id = UUID()
    let title: String
    let category: TopicCategory
    let icon: String
    let summary: String
    let tags: [String]
}
