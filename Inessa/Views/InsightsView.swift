import SwiftUI

struct InsightsView: View {
    @EnvironmentObject private var store: StudyStore

    private var goalBinding: Binding<Int> {
        Binding(get: { store.goal }, set: { store.setGoal($0) })
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow(text: "Your journey")
                    Text("Small steps. Big progress.")
                        .font(.system(size: 29, weight: .bold, design: .rounded))
                        .foregroundStyle(AppTheme.ink)
                    Text("All progress is saved on this iPhone.")
                        .foregroundStyle(AppTheme.muted)
                }

                HStack(spacing: 12) {
                    metric("\(store.learnedCount)", label: "Words learned", icon: "book.closed.fill")
                    metric("\(store.streak)", label: "Day streak", icon: "flame.fill")
                }
                HStack(spacing: 12) {
                    metric("\(store.accuracy)%", label: "Quiz accuracy", icon: "target")
                    metric("\(store.favoriteCount)", label: "Saved words", icon: "heart.fill")
                }

                InessaCard {
                    VStack(alignment: .leading, spacing: 13) {
                        Text("Today's progress")
                            .font(.headline)
                            .foregroundStyle(AppTheme.ink)
                        ProgressView(value: store.todayProgress)
                            .tint(AppTheme.green)
                        Text("\(store.todayCorrect) of \(store.goal) daily learning actions")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.muted)
                        Stepper(value: goalBinding, in: 1...20) {
                            Label("Daily goal: \(store.goal)", systemImage: "slider.horizontal.3")
                                .font(.subheadline.weight(.semibold))
                        }
                        .tint(AppTheme.green)
                    }
                }

                InessaCard {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Vocabulary by level")
                            .font(.headline)
                            .foregroundStyle(AppTheme.ink)

                        ForEach(PolishLevel.allCases) { level in
                            let words = Vocabulary.words(level: level)
                            let learned = words.filter { store.isLearned($0) }.count
                            VStack(alignment: .leading, spacing: 9) {
                                HStack {
                                    Text("\(level.rawValue) · \(level.description)")
                                        .font(.subheadline.weight(.medium))
                                    Spacer()
                                    Text("\(learned) / \(words.count)")
                                        .font(.caption)
                                        .foregroundStyle(AppTheme.muted)
                                }
                                ProgressView(value: Double(learned), total: Double(words.count))
                                    .tint(AppTheme.green)
                            }
                        }
                    }
                }

                Text("Tip: Add the Inessa widget to your Lock Screen for a new Polish word every day.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.muted)
                    .padding(.horizontal, 5)
            }
            .padding(20)
        }
        .background(AppTheme.canvas.ignoresSafeArea())
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func metric(_ value: String, label: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(AppTheme.green)
            Text(value)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.ink)
            Text(label)
                .font(.caption)
                .foregroundStyle(AppTheme.muted)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 22))
    }
}
