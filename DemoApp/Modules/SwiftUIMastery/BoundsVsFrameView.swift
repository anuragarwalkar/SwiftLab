import SwiftUI

// MARK: - Bounds vs Frame Interactive Visualizer

struct BoundsVsFrameView: View {
    @State private var rotationAngle: Double = 30.0 // Degrees
    @State private var viewWidth: CGFloat = 140
    @State private var viewHeight: CGFloat = 80

    // Frame bounding box calculation under rotation
    private var frameWidth: CGFloat {
        let rad = rotationAngle * .pi / 180.0
        let w = Double(viewWidth)
        let h = Double(viewHeight)
        return CGFloat(abs(w * Darwin.cos(rad)) + abs(h * Darwin.sin(rad)))
    }

    private var frameHeight: CGFloat {
        let rad = rotationAngle * .pi / 180.0
        let w = Double(viewWidth)
        let h = Double(viewHeight)
        return CGFloat(abs(w * Darwin.sin(rad)) + abs(h * Darwin.cos(rad)))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "viewfinder")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.primary)
                        Text("Bounds vs Frame")
                            .font(.title2.bold())
                    }
                    Text("The classic iOS coordinate interview question. See the difference between a view's internal coordinate system (Bounds) and its superview footprint (Frame).")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.primary.opacity(0.08))
                .cornerRadius(16)

                // Interactive Coordinate Canvas
                ConceptCard(
                    title: "Interactive Geometry Canvas",
                    subtitle: "Rotate view to see Frame expand while Bounds stay identical",
                    icon: "rotate.right.fill",
                    iconColor: AppTheme.accent
                ) {
                    VStack(spacing: 16) {
                        // Sliders
                        VStack(spacing: 8) {
                            HStack {
                                Text("Rotation Angle: \(Int(rotationAngle))°")
                                    .font(.caption.bold())
                                Spacer()
                                Text("Frame Expands!")
                                    .font(.caption2.bold())
                                    .foregroundColor(rotationAngle != 0 ? .orange : .secondary)
                            }
                            Slider(value: $rotationAngle, in: 0...180, step: 1)
                        }

                        // Geometry Canvas
                        ZStack {
                            // Canvas Background
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.tertiarySystemGroupedBackground))
                                .frame(height: 240)

                            // Frame Bounding Box (Red dashed outline in superview)
                            Rectangle()
                                .stroke(Color.red, style: StrokeStyle(lineWidth: 1.5, dash: [5]))
                                .frame(width: frameWidth, height: frameHeight)
                                .overlay(
                                    Text("Superview Frame Box")
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundColor(.red)
                                        .padding(2),
                                    alignment: .topLeading
                                )

                            // The View Itself (Rotated)
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppTheme.primaryGradient)
                                .frame(width: viewWidth, height: viewHeight)
                                .rotationEffect(.degrees(rotationAngle))
                                .overlay(
                                    VStack(spacing: 2) {
                                        Text("Rotated View")
                                            .font(.caption.bold())
                                            .foregroundColor(.white)
                                        Text("Bounds: \(Int(viewWidth)) x \(Int(viewHeight))")
                                            .font(.system(size: 10, design: .monospaced))
                                            .foregroundColor(.white.opacity(0.9))
                                    }
                                    .rotationEffect(.degrees(rotationAngle))
                                )
                        }

                        // Real-time Coordinates Display
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Circle().fill(Color.blue).frame(width: 8, height: 8)
                                    Text("Bounds (Internal)")
                                        .font(.caption.bold())
                                }
                                Text("Origin: (0, 0)")
                                    .font(.system(size: 11, design: .monospaced))
                                Text("Size: \(Int(viewWidth)) × \(Int(viewHeight)) pt")
                                    .font(.system(size: 11, design: .monospaced))
                                Text("Status: Unchanged by rotation")
                                    .font(.system(size: 9))
                                    .foregroundColor(.green)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(8)

                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Circle().fill(Color.red).frame(width: 8, height: 8)
                                    Text("Frame (In Superview)")
                                        .font(.caption.bold())
                                }
                                Text("Origin: Relative to parent")
                                    .font(.system(size: 11, design: .monospaced))
                                Text("Size: \(Int(frameWidth)) × \(Int(frameHeight)) pt")
                                    .font(.system(size: 11, design: .monospaced))
                                    .foregroundColor(.red)
                                Text("Status: Dynamically expands")
                                    .font(.system(size: 9))
                                    .foregroundColor(.red)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(8)
                        }
                    }
                }

                // Comparison & Interview Answers
                ConceptCard(
                    title: "Interview Quick Reference",
                    subtitle: "Key distinctions to articulate",
                    icon: "questionmark.circle.fill",
                    iconColor: AppTheme.secondary
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Bounds:")
                                .font(.headline)
                                .foregroundColor(AppTheme.primary)
                            BulletPoint(text: "Expressed in the view's OWN coordinate system.")
                            BulletPoint(text: "Default origin is (x: 0, y: 0) (modifying origin scrolls internal content, like in UIScrollView).")
                            BulletPoint(text: "Size represents the view's actual internal dimensions.")
                            BulletPoint(text: "Rotating the view has ZERO effect on its bounds size!")
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Frame:")
                                .font(.headline)
                                .foregroundColor(AppTheme.error)
                            BulletPoint(text: "Expressed in its SUPERVIEW's coordinate system.", color: AppTheme.error)
                            BulletPoint(text: "Origin represents the top-left position inside the parent container.", color: AppTheme.error)
                            BulletPoint(text: "Size represents the smallest upright bounding box enclosing the view.", color: AppTheme.error)
                            BulletPoint(text: "When a view is rotated, its frame width and height change dramatically to fit the tilted geometry!", color: AppTheme.error)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Bounds vs Frame")
        .navigationBarTitleDisplayMode(.inline)
    }
}
