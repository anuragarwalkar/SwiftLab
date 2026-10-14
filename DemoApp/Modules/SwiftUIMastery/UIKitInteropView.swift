import SwiftUI
import UIKit

// MARK: - UIViewControllerRepresentable & UIHostingController

// Live UIKit Color Picker Controller bridged to SwiftUI
struct UIKitColorPickerWrapper: UIViewControllerRepresentable {
    @Binding var selectedColor: Color

    func makeUIViewController(context: Context) -> UIColorPickerViewController {
        let picker = UIColorPickerViewController()
        picker.selectedColor = UIColor(selectedColor)
        picker.supportsAlpha = true
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIColorPickerViewController, context: Context) {
        uiViewController.selectedColor = UIColor(selectedColor)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIColorPickerViewControllerDelegate {
        let parent: UIKitColorPickerWrapper

        init(_ parent: UIKitColorPickerWrapper) {
            self.parent = parent
        }

        func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            parent.selectedColor = Color(viewController.selectedColor)
        }

        func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
            parent.selectedColor = Color(color)
        }
    }
}

struct UIKitInteropView: View {
    @State private var currentColor: Color = .blue
    @State private var showColorPicker = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "arrow.left.arrow.right.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.primary)
                        Text("UIKit & SwiftUI Interop")
                            .font(.title2.bold())
                    }
                    Text("Seamlessly bridge legacy UIKit components into modern SwiftUI via UIViewControllerRepresentable, and host SwiftUI views in UIKit via UIHostingController.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.primary.opacity(0.08))
                .cornerRadius(16)

                // Live UIViewControllerRepresentable Interactive Demo
                ConceptCard(
                    title: "Live UIViewControllerRepresentable",
                    subtitle: "Embedded UIKit UIColorPickerViewController",
                    icon: "paintpalette.fill",
                    iconColor: currentColor
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Current Bridge Color:")
                                .font(.caption.bold())
                            Spacer()
                            Circle()
                                .fill(currentColor)
                                .frame(width: 24, height: 24)
                                .overlay(Circle().stroke(Color.primary.opacity(0.2), lineWidth: 1))
                        }

                        Button {
                            showColorPicker = true
                        } label: {
                            Label("Open Native UIKit Color Picker", systemImage: "eyedropper")
                                .font(.subheadline.bold())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(currentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }

                // UIViewControllerRepresentable Breakdown
                ConceptCard(
                    title: "UIViewControllerRepresentable Protocol",
                    subtitle: "UIKit -> SwiftUI Bridge",
                    icon: "arrow.turn.up.right",
                    iconColor: AppTheme.secondary
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        BulletPoint(text: "makeUIViewController(context:): Instantiates and configures the UIKit view controller.")
                        BulletPoint(text: "updateUIViewController(_:context:): Called whenever SwiftUI view state changes so UIKit can sync.")
                        BulletPoint(text: "makeCoordinator(): Optional coordinator class that acts as the UIKit delegate/target-action receiver and forwards events back to SwiftUI bindings.")

                        CodeBlockView(
                            title: "UIViewControllerRepresentable Pattern",
                            code: """
struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ controller: SFSafariViewController, context: Context) {
        // Update controller on SwiftUI state mutation
    }
}
"""
                        )
                    }
                }

                // UIHostingController Breakdown
                ConceptCard(
                    title: "UIHostingController",
                    subtitle: "SwiftUI -> UIKit Bridge",
                    icon: "arrow.turn.down.left",
                    iconColor: AppTheme.purple
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        BulletPoint(text: "A UIKit UIViewController subclass that hosts a SwiftUI View hierarchy.", color: AppTheme.purple)
                        BulletPoint(text: "rootView: The SwiftUI view provided in the initializer: `UIHostingController(rootView: MySwiftUIView())`.", color: AppTheme.purple)
                        BulletPoint(text: "Allows incremental adoption: Embed modern SwiftUI screens or cells into an existing UIKit storyboard or navigation stack.", color: AppTheme.purple)

                        CodeBlockView(
                            title: "Hosting SwiftUI in UIKit",
                            code: """
// Inside a UIKit UIViewController:
func didTapOpenProfile() {
    let swiftUIView = ProfileSwiftUIView(userId: "42")
    let hostingController = UIHostingController(rootView: swiftUIView)
    navigationController?.pushViewController(hostingController, animated: true)
}
"""
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle("UIKit Interop")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showColorPicker) {
            UIKitColorPickerWrapper(selectedColor: $currentColor)
        }
    }
}
