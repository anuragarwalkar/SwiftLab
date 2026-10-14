import SwiftUI

// MARK: - Interactive Concept Knowledge Quiz & Flashcards

struct QuizQuestion: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
    let topicTag: String
}

struct QuizView: View {
    @State private var currentIndex = 0
    @State private var selectedOption: Int?
    @State private var showAnswer = false
    @State private var score = 0
    @State private var isQuizFinished = false

    private let questions: [QuizQuestion] = [
        QuizQuestion(
            question: "What happens when you read an 'unowned' reference that has already been deallocated?",
            options: [
                "It safely returns nil",
                "It crashes immediately with a fatal runtime error",
                "It allocates a new default instance",
                "It waits until memory is available"
            ],
            correctIndex: 1,
            explanation: "Unlike 'weak' which zeroes out to nil, 'unowned' does not zero out. Reading a dangling unowned reference causes an instant fatal memory crash.",
            topicTag: "Memory & ARC"
        ),
        QuizQuestion(
            question: "Why should a static library (.a) NOT be marked as 'Embed & Sign' in Xcode?",
            options: [
                "Because static libraries can only be run on macOS",
                "Because its code is already merged directly into the app binary at compile time",
                "Because DYLD only accepts dynamic frameworks",
                "Because Apple requires code signing to be skipped"
            ],
            correctIndex: 1,
            explanation: "Static libraries are copied directly into the app executable binary during compile time. Embedding them separately would bloat the bundle with duplicate binaries.",
            topicTag: "DYLD & Libraries"
        ),
        QuizQuestion(
            question: "In SwiftUI, what happens to a view's 'Bounds' when it is rotated by 45 degrees?",
            options: [
                "Its bounds width and height increase to form a diamond",
                "Its bounds width and height remain completely unchanged",
                "Its bounds origin shifts to (-1, -1)",
                "Its bounds turn into an optional value"
            ],
            correctIndex: 1,
            explanation: "Bounds is the view's internal coordinate system. Rotating a view changes its 'Frame' in the superview, but its 'Bounds' dimensions remain completely unchanged!",
            topicTag: "Bounds vs Frame"
        ),
        QuizQuestion(
            question: "What happens when you execute 'DispatchQueue.main.sync { }' from the Main Thread?",
            options: [
                "It executes instantly with top priority",
                "It switches automatically to global queue",
                "It causes an instant DEADLOCK and freezes the app",
                "It defers execution until the runloop sleeps"
            ],
            correctIndex: 2,
            explanation: "Calling main.sync from the main thread causes a mutual deadlock because the main thread blocks waiting for the sync closure, but the closure cannot start until the main thread unblocks.",
            topicTag: "GCD & Concurrency"
        ),
        QuizQuestion(
            question: "Which Core Data Delete Rule automatically removes child records when the parent is deleted?",
            options: [
                "Nullify",
                "Deny",
                "No Action",
                "Cascade"
            ],
            correctIndex: 3,
            explanation: "'Cascade' propagates deletion down to all related destination records automatically.",
            topicTag: "Core Data"
        ),
        QuizQuestion(
            question: "Why does Public Key Pinning (SPKI) have an advantage over Certificate Pinning?",
            options: [
                "It uses less CPU power to compute SHA-256",
                "The app doesn't break when the server certificate is renewed using the same key pair",
                "It requires no URLSessionDelegate",
                "It bypasses Apple's App Transport Security (ATS)"
            ],
            correctIndex: 1,
            explanation: "When a TLS certificate expires, the server can issue a new certificate using the same private key. Since the public key hash remains identical, the app continues to work without an App Store update.",
            topicTag: "SSL Pinning"
        ),
        QuizQuestion(
            question: "What happens to data stored in Keychain when the user uninstalls and deletes the app?",
            options: [
                "It is wiped out immediately with the sandbox",
                "It is transferred to iCloud automatically",
                "It PERSISTS in the Keychain across app reinstalls",
                "It is moved to UserDefaults"
            ],
            correctIndex: 2,
            explanation: "Keychain items are managed by the system securityd daemon and persist even after the app is uninstalled. If the app is reinstalled, it can access existing keychain items with matching bundle credentials.",
            topicTag: "Storage & Security"
        ),
        QuizQuestion(
            question: "Which VIPER component is responsible for containing pure business logic and network API calls?",
            options: [
                "Presenter",
                "Router",
                "Interactor",
                "Entity"
            ],
            correctIndex: 2,
            explanation: "The Interactor contains pure business logic, database queries, and network requests, completely decoupled from any UI.",
            topicTag: "VIPER"
        )
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "graduationcap.fill")
                            .font(.largeTitle)
                            .foregroundColor(AppTheme.accent)
                        Text("iOS Mastery Quiz")
                            .font(.title2.bold())
                    }
                    Text("Test your mastery on ARC, DYLD, Bounds/Frame, VIPER, Concurrency, and Core Data.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.accent.opacity(0.08))
                .cornerRadius(16)

                if !isQuizFinished {
                    // Question Card
                    let q = questions[currentIndex]
                    ConceptCard(
                        title: "Question \(currentIndex + 1) of \(questions.count)",
                        subtitle: q.topicTag,
                        icon: "questionmark.circle.fill",
                        iconColor: AppTheme.primary
                    ) {
                        VStack(alignment: .leading, spacing: 14) {
                            Text(q.question)
                                .font(.headline)
                                .fixedSize(horizontal: false, vertical: true)

                            VStack(spacing: 8) {
                                ForEach(Array(q.options.enumerated()), id: \.offset) { index, option in
                                    Button {
                                        guard !showAnswer else { return }
                                        selectedOption = index
                                        showAnswer = true
                                        if index == q.correctIndex {
                                            score += 1
                                        }
                                    } label: {
                                        HStack {
                                            Text(option)
                                                .font(.subheadline)
                                                .multilineTextAlignment(.leading)
                                                .foregroundColor(optionTextColor(for: index, correct: q.correctIndex))
                                            Spacer()
                                            if showAnswer {
                                                if index == q.correctIndex {
                                                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                                                } else if selectedOption == index {
                                                    Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                                                }
                                            }
                                        }
                                        .padding(12)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(optionBackground(for: index, correct: q.correctIndex))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(optionBorder(for: index, correct: q.correctIndex), lineWidth: 1.5)
                                        )
                                    }
                                }
                            }

                            if showAnswer {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Explanation:")
                                        .font(.caption.bold())
                                        .foregroundColor(AppTheme.primary)
                                    Text(q.explanation)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(10)
                                .background(AppTheme.primary.opacity(0.08))
                                .cornerRadius(8)

                                Button {
                                    nextQuestion()
                                } label: {
                                    Text(currentIndex == questions.count - 1 ? "Finish Quiz" : "Next Question")
                                        .font(.subheadline.bold())
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(AppTheme.primary)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                } else {
                    // Result Summary Card
                    ConceptCard(
                        title: "Quiz Completed!",
                        subtitle: "Your Results",
                        icon: "trophy.fill",
                        iconColor: AppTheme.warning
                    ) {
                        VStack(spacing: 16) {
                            Text("\(score) / \(questions.count)")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(score >= 6 ? .green : .orange)

                            Text(score >= 6 ? "🌟 Outstanding iOS Engineering Mastery!" : "Keep revising the concept tabs to solidify your foundations!")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)

                            Button("Restart Quiz") {
                                currentIndex = 0
                                selectedOption = nil
                                showAnswer = false
                                score = 0
                                isQuizFinished = false
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Quiz & Practice")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func nextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
            selectedOption = nil
            showAnswer = false
        } else {
            isQuizFinished = true
        }
    }

    private func optionTextColor(for index: Int, correct: Int) -> Color {
        if !showAnswer { return .primary }
        if index == correct { return .green }
        if selectedOption == index { return .red }
        return .secondary
    }

    private func optionBackground(for index: Int, correct: Int) -> Color {
        if !showAnswer { return Color(.secondarySystemGroupedBackground) }
        if index == correct { return Color.green.opacity(0.12) }
        if selectedOption == index { return Color.red.opacity(0.12) }
        return Color(.secondarySystemGroupedBackground)
    }

    private func optionBorder(for index: Int, correct: Int) -> Color {
        if !showAnswer { return Color.clear }
        if index == correct { return Color.green }
        if selectedOption == index { return Color.red }
        return Color.clear
    }
}
