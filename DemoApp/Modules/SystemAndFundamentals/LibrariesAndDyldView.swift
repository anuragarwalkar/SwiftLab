import SwiftUI

// MARK: - Static vs Dynamic Libraries, DYLD & XCFrameworks

struct LibrariesAndDyldView: View {
    @State private var dyldStep = 0
    @State private var dyldLogs: [String] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "cpu.fill")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.primary)
                        Text("Libraries, DYLD & Frameworks")
                            .font(.title2.bold())
                    }
                    Text("Deep dive into how code is compiled, linked, packaged, and loaded into iOS memory: Static vs Dynamic libraries, DYLD runtime linker, and .xcframework architecture.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.primary.opacity(0.08))
                .cornerRadius(16)

                // Static vs Dynamic Comparison Card
                ConceptCard(
                    title: "Static vs Dynamic Library",
                    subtitle: "Compile-time embedding vs Runtime linking",
                    icon: "arrow.triangle.merge",
                    iconColor: AppTheme.secondary
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        // Static Library
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Static Library (.a / static framework)")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.primary)
                                Spacer()
                                Text("Compile-Time")
                                    .font(.caption2.bold())
                                    .padding(4)
                                    .background(AppTheme.primary.opacity(0.12))
                                    .cornerRadius(4)
                            }
                            BulletPoint(text: "Linked at compile time: object code (.o) is copied directly into the app's executable binary.")
                            BulletPoint(text: "Embedding: Do NOT embed and sign in Xcode (already part of main binary).")
                            BulletPoint(text: "App Launch: Faster launch time (no DYLD resolution required at startup).")
                            BulletPoint(text: "App Binary Size: Larger main executable binary file.")
                        }

                        Divider()

                        // Dynamic Library
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Dynamic Library (.dylib / dynamic framework)")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.accent)
                                Spacer()
                                Text("Runtime")
                                    .font(.caption2.bold())
                                    .padding(4)
                                    .background(AppTheme.accent.opacity(0.12))
                                    .cornerRadius(4)
                            }
                            BulletPoint(text: "Linked at build time, but loaded into memory at RUNTIME by DYLD.", color: AppTheme.accent)
                            BulletPoint(text: "Embedding: MUST be embedded & signed ('Embed & Sign' in Xcode) so it exists in Frameworks/ bundle.", color: AppTheme.accent)
                            BulletPoint(text: "App Launch: Slower launch time if you have many dylibs (DYLD must load and rebase each).", color: AppTheme.accent)
                            BulletPoint(text: "App Binary Size: Main executable remains smaller; code is modularized.", color: AppTheme.accent)
                        }
                    }
                }

                // DYLD Runtime Simulator
                ConceptCard(
                    title: "DYLD (Dynamic Link Editor) Lifecycle",
                    subtitle: "What happens when your app launches",
                    icon: "play.circle.fill",
                    iconColor: AppTheme.purple
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("DYLD is the macOS/iOS system loader responsible for locating and loading dynamic frameworks that a program needs at runtime and linking library symbols with the program.")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Button {
                            simulateDYLD()
                        } label: {
                            Label("Simulate DYLD Launch Steps", systemImage: "sparkles")
                                .font(.subheadline.bold())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(AppTheme.purple)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        InteractiveLogBox(logs: dyldLogs, onClear: {
                            dyldLogs.removeAll()
                            dyldStep = 0
                        })
                    }
                }

                // .framework vs .xcframework Card
                ConceptCard(
                    title: ".framework vs .xcframework",
                    subtitle: "Single binary vs Multi-platform wrapper",
                    icon: "shippingbox.and.arrow.backward.fill",
                    iconColor: AppTheme.warning
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("1. .framework (Legacy)")
                                .font(.headline)
                                .foregroundColor(AppTheme.warning)
                            BulletPoint(text: "Contains a single binary build for a single target architecture.", color: AppTheme.warning)
                            BulletPoint(text: "Caused architecture conflicts when combining Device (arm64) and Simulator (arm64/x86_64) using lipo.", color: AppTheme.warning)
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 4) {
                            Text("2. .xcframework (Apple Modern Standard)")
                                .font(.headline)
                                .foregroundColor(AppTheme.success)
                            BulletPoint(text: "Introduced by Apple to solve architecture conflicts permanently.", color: AppTheme.success)
                            BulletPoint(text: "Acts as a multi-platform wrapper containing separate slices for iOS Device, iOS Simulator, macOS, Catalyst, and visionOS.", color: AppTheme.success)
                            BulletPoint(text: "Now the official and recommended format for distributing compiled binary frameworks.", color: AppTheme.success)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Libraries & DYLD")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func simulateDYLD() {
        dyldLogs.removeAll()
        dyldLogs.append("🚀 [DYLD Phase 1] App binary executed by Kernel -> Spawning dyld...")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.dyldLogs.append("📦 [DYLD Phase 2] Parsing Mach-O header & load commands (LC_LOAD_DYLIB)")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.dyldLogs.append("🔍 [DYLD Phase 3] Locating & mapping dynamic libraries into virtual address space")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            self.dyldLogs.append("📍 [DYLD Phase 4] Rebasing (adjusting internal pointers due to ASLR)")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            self.dyldLogs.append("🔗 [DYLD Phase 5] Binding external symbol references to library addresses")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.dyldLogs.append("⚡ [DYLD Phase 6] Running initializers (+load methods & global constructors)")
            self.dyldLogs.append("🏁 [DYLD Complete] Handing execution over to main()!")
        }
    }
}
