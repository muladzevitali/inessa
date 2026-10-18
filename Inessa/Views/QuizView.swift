import SwiftUI

private struct QuizQuestion {
    let word: PolishWord
    let options: [String]
}

struct QuizView: View {
    @EnvironmentObject private var store: StudyStore
    @State private var level: PolishLevel = .a1
    @State private var questions: [QuizQuestion] = []
    @State private var index = 0
    @State private var selectedAnswer: String?
    @State private var score = 0
    @State private var complete = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow(text: "Practice makes progress")
                    Text("Quick quiz")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(AppTheme.ink)
                    Text("Choose the correct English translation.")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.muted)
                }

                Picker("Level", selection: $level) {
                    ForEach(PolishLevel.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: level) { _, _ in startQuiz() }

                if questions.isEmpty {
                    Text("Preparing your quiz…").foregroundStyle(AppTheme.muted)
                } else if complete {
                    results
                } else {
                    questionCard
                }
            }
            .padding(20)
        }
        .background(AppTheme.canvas.ignoresSafeArea())
        .navigationTitle("Practice")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { if questions.isEmpty { startQuiz() } }
    }

    private var questionCard: some View {
        let question = questions[index]
        return VStack(alignment: .leading, spacing: 22) {
            HStack {
                Eyebrow(text: "Question \(index + 1) / \(questions.count)")
                Spacer()
                Label("\(score) correct", systemImage: "checkmark.circle.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppTheme.green)
            }

            VStack(spacing: 12) {
                Text("What does this mean?")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.muted)
                Text(question.word.polish)
                    .font(.system(size: 35, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.ink)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.65)
                Button {
                    PronunciationService.shared.speak(question.word.polish)
                } label: {
                    Label("Listen", systemImage: "speaker.wave.2.fill")
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(AppTheme.green)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 35)
            .background(AppTheme.mint, in: RoundedRectangle(cornerRadius: 24))

            VStack(spacing: 12) {
                ForEach(question.options, id: \.self) { option in
                    Button {
                        guard selectedAnswer == nil else { return }
                        selectedAnswer = option
                        let correct = option == question.word.english
                        if correct { score += 1 }
                        store.recordQuizAnswer(correct: correct)
                    } label: {
                        HStack(spacing: 12) {
                            Text(option)
                                .font(.body.weight(.medium))
                                .multilineTextAlignment(.leading)
                            Spacer()
                            if selectedAnswer != nil && option == question.word.english {
                                Image(systemName: "checkmark.circle.fill")
                            } else if selectedAnswer == option {
                                Image(systemName: "xmark.circle.fill")
                            } else {
                                Image(systemName: "circle")
                            }
                        }
                        .foregroundStyle(answerColor(for: option, correct: question.word.english))
                        .padding(18)
                        .background(answerBackground(for: option, correct: question.word.english),
                                    in: RoundedRectangle(cornerRadius: 17))
                    }
                    .buttonStyle(.plain)
                    .disabled(selectedAnswer != nil)
                }
            }

            if let selectedAnswer {
                Text(selectedAnswer == question.word.english ? "Świetnie! That's correct." : "Not quite. The answer is “\(question.word.english)”.")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(selectedAnswer == question.word.english ? AppTheme.green : AppTheme.coral)

                PrimaryButton(
                    title: index + 1 == questions.count ? "See results" : "Next question",
                    icon: "arrow.right"
                ) {
                    if index + 1 == questions.count {
                        complete = true
                    } else {
                        index += 1
                        self.selectedAnswer = nil
                    }
                }
            }
        }
    }

    private var results: some View {
        VStack(spacing: 20) {
            Image(systemName: score >= 7 ? "trophy.fill" : "sparkles")
                .font(.system(size: 54))
                .foregroundStyle(AppTheme.coral)
                .padding(.top, 22)
            Text("\(score) / \(questions.count)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.ink)
            Text(score >= 7 ? "Świetna robota!" : "Every attempt helps you learn.")
                .font(.title3.weight(.semibold))
                .foregroundStyle(AppTheme.ink)
            Text("Your answers are saved in your learning progress.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(AppTheme.muted)
            PrimaryButton(title: "Practice again", icon: "arrow.clockwise", action: startQuiz)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(.white, in: RoundedRectangle(cornerRadius: 24))
    }

    private func answerColor(for option: String, correct: String) -> Color {
        guard selectedAnswer != nil else { return AppTheme.ink }
        if option == correct { return AppTheme.green }
        if selectedAnswer == option { return AppTheme.coral }
        return AppTheme.muted
    }

    private func answerBackground(for option: String, correct: String) -> Color {
        guard selectedAnswer != nil else { return .white }
        if option == correct { return AppTheme.mint }
        if selectedAnswer == option { return AppTheme.cream }
        return .white
    }

    private func startQuiz() {
        let pool = Vocabulary.words(level: level)
        questions = Array(pool.shuffled().prefix(10)).map { word in
            let wrong = Array(pool.filter { $0.id != word.id }
                .shuffled()
                .prefix(3))
                .map(\.english)
            return QuizQuestion(word: word, options: ([word.english] + wrong).shuffled())
        }
        index = 0
        score = 0
        selectedAnswer = nil
        complete = false
    }
}
