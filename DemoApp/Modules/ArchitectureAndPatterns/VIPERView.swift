import SwiftUI

// MARK: - VIPER Architecture Interactive Visualizer

struct VIPERView: View {
    @State private var activeStep = 0
    @State private var flowLogs: [String] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "square.split.diagonal.2x2.fill")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.primary)
                        Text("VIPER Architecture")
                            .font(.title2.bold())
                    }
                    Text("Clean Architecture tailored for iOS: View, Interactor, Presenter, Entity, and Router. Enforces strict unidirectional boundaries.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.primary.opacity(0.08))
                .cornerRadius(16)

                // Interactive Architecture Diagram
                ConceptCard(
                    title: "VIPER Communication Flow",
                    subtitle: "Tap 'Simulate Flow' to trace request & response",
                    icon: "arrow.triangle.branch",
                    iconColor: AppTheme.secondary
                ) {
                    VStack(spacing: 12) {
                        // Flow steps visualization
                        HStack(spacing: 8) {
                            viperPill(title: "View", role: "UI & Touch", step: 1, active: activeStep == 1 || activeStep == 5)
                            Image(systemName: "arrow.right").font(.caption).foregroundColor(.secondary)
                            viperPill(title: "Presenter", role: "Orchestrator", step: 2, active: activeStep == 2 || activeStep == 4)
                            Image(systemName: "arrow.right").font(.caption).foregroundColor(.secondary)
                            viperPill(title: "Interactor", role: "Business / API", step: 3, active: activeStep == 3)
                        }

                        HStack(spacing: 20) {
                            viperPill(title: "Entity", role: "Plain Model", step: 0, active: activeStep == 3)
                            viperPill(title: "Router", role: "Navigation", step: 0, active: false)
                        }

                        Button {
                            runViperSimulation()
                        } label: {
                            Label("Simulate User Action (e.g. Fetch Order)", systemImage: "play.circle.fill")
                                .font(.subheadline.bold())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(AppTheme.primary)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        InteractiveLogBox(logs: flowLogs, onClear: {
                            flowLogs.removeAll()
                            activeStep = 0
                        })
                    }
                }

                // VIPER Responsibilities Breakdown
                ConceptCard(
                    title: "VIPER Components & Contracts",
                    subtitle: "Individual component responsibilities",
                    icon: "list.clipboard.fill",
                    iconColor: AppTheme.purple
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        viperRoleRow(
                            badge: "V",
                            title: "View",
                            color: .blue,
                            summary: "Displays UI and captures user taps. Totally passive; forwards user actions to the Presenter via protocol."
                        )

                        Divider()

                        viperRoleRow(
                            badge: "I",
                            title: "Interactor",
                            color: .green,
                            summary: "Contains Pure Business Logic, API networking, and CoreData/DB queries. Has zero knowledge of UI. Returns Entities."
                        )

                        Divider()

                        viperRoleRow(
                            badge: "P",
                            title: "Presenter",
                            color: .orange,
                            summary: "The brain! Receives user events from View, asks Interactor for data, transforms raw Entity models into formatted ViewModels, and commands Router."
                        )

                        Divider()

                        viperRoleRow(
                            badge: "E",
                            title: "Entity",
                            color: .purple,
                            summary: "Plain Swift Structs or Models representing the domain (e.g. Order, User, Product). No business logic."
                        )

                        Divider()

                        viperRoleRow(
                            badge: "R",
                            title: "Router (Wireframe)",
                            color: .red,
                            summary: "Handles screen navigation, push/pop transitions, and assembling VIPER modules with Dependency Injection."
                        )
                    }
                }

                // Sample Code Contracts
                CodeBlockView(
                    title: "VIPER Protocols Skeleton",
                    code: """
// 1. View Protocol
protocol OrderViewProtocol: AnyObject {
    func displayOrder(title: String, formattedPrice: String)
}

// 2. Presenter Protocol
protocol OrderPresenterProtocol: AnyObject {
    func didTapFetchOrder()
    func didLoadOrder(order: OrderEntity)
}

// 3. Interactor Protocol
protocol OrderInteractorProtocol: AnyObject {
    func fetchOrderFromAPI()
}

// 4. Router Protocol
protocol OrderRouterProtocol: AnyObject {
    func navigateToReceipt(for orderId: String)
}
"""
                )
            }
            .padding()
        }
        .navigationTitle("VIPER Architecture")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func viperPill(title: String, role: String, step: Int, active: Bool) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.caption.bold())
                .foregroundColor(active ? .white : .primary)
            Text(role)
                .font(.system(size: 9))
                .foregroundColor(active ? .white.opacity(0.85) : .secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(active ? AppTheme.primary : Color(.tertiarySystemGroupedBackground))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(active ? AppTheme.primary : Color.clear, lineWidth: 2)
        )
    }

    private func viperRoleRow(badge: String, title: String, color: Color, summary: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            ZStack {
                Circle().fill(color.opacity(0.15)).frame(width: 28, height: 28)
                Text(badge).font(.caption.bold()).foregroundColor(color)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline.bold()).foregroundColor(.primary)
                Text(summary).font(.caption).foregroundColor(.secondary)
            }
        }
    }

    private func runViperSimulation() {
        flowLogs.removeAll()
        activeStep = 1
        flowLogs.append("1. [View] User tapped 'Fetch Order' button -> notifies Presenter")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            activeStep = 2
            flowLogs.append("2. [Presenter] Receives action -> delegates to Interactor for data fetch")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            activeStep = 3
            flowLogs.append("3. [Interactor] Executes network request, parses JSON into Entity(id: 42, total: $89.00)")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            activeStep = 4
            flowLogs.append("4. [Presenter] Formats Entity into UI-ready string 'Order #42 • $89.00'")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            activeStep = 5
            flowLogs.append("5. [View] Receives formatted text and renders update to user!")
        }
    }
}
