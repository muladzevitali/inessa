import SwiftUI

struct TodayView: View {
    @EnvironmentObject private var store: StudyStore
    let onStartLearning: () -> Void
    let onPractice: () -> Void

    private var word: PolishWord { DailyWord.word() }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        Eyebrow(text: Date.now.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                        Text("Cześć, learner!")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(AppTheme.ink)
                        Text("A little Polish, every day.")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.muted)
                    }
                    Spacer()
                    Text("🇵🇱")
                        .font(.system(size: 37))
                        .padding(12)
                        .background(.white, in: RoundedRectangle(cornerRadius: 20))
                }

                HStack(spacing: 12) {
                    Image(systemName: "flame.fill")
                        .font(.title2)
                        .foregroundStyle(AppTheme.coral)
                        .frame(width: 52, height: 52)
                        .background(AppTheme.cream, in: RoundedRectangle(cornerRadius: 16))

                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(store.streak) day streak")
                            .font(.headline)
                            .foregroundStyle(AppTheme.ink)
                        Text("Keep showing up. It adds up.")
                            .font(.caption)
                            .foregroundStyle(AppTheme.muted)
                    }
                    Spacer()
                }
                .padding(16)
                .background(.white, in: RoundedRectangle(cornerRadius: 22))

                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Eyebrow(text: "Your daily goal")
                        Spacer()
                        Text("\(store.todayCorrect) / \(store.goal)")
                            .font(.callout.bold())
                            .foregroundStyle(AppTheme.green)
                    }

                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Capsule().fill(AppTheme.mint)
                            Capsule()
                                .fill(AppTheme.green)
                                .frame(width: geometry.size.width * store.todayProgress)
                        }
                    }
                    .frame(height: 10)

                    Text(store.todayCorrect >= store.goal ? "Goal reached. Świetna robota! 🎉" : "Learn words or answer quiz questions to make progress.")
                        .font(.caption)
                        .foregroundStyle(AppTheme.muted)
                }
                .padding(20)
                .background(.white, in: RoundedRectangle(cornerRadius: 22))

                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Label("WORD OF THE DAY", systemImage: "sparkle")
                            .font(.system(size: 11, weight: .bold))
                            .tracking(1.4)
                        Spacer()
                        Text(word.level.rawValue)
                            .font(.caption.bold())
                            .padding(.horizontal, 11)
                            .padding(.vertical, 6)
                            .background(.white.opacity(0.45), in: Capsule())
                    }
                    .foregroundStyle(AppTheme.green)

                    VStack(alignment: .leading, spacing: 7) {
                        HStack(alignment: .center) {
                            Text(word.polish)
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .minimumScaleFactor(0.6)
                                .lineLimit(2)
                            Spacer()
                            Button {
                                PronunciationService.shared.speak(word.polish)
                            } label: {
                                Image(systemName: "speaker.wave.2.fill")
                                    .font(.title3)
                                    .foregroundStyle(AppTheme.green)
                                    .frame(width: 44, height: 44)
                                    .background(.white.opacity(0.75), in: Circle())
                            }
                            .accessibilityLabel("Pronounce \(word.polish)")
                        }
                        Text(word.english)
                            .font(.title3)
                            .foregroundStyle(AppTheme.green)
                    }
                    .foregroundStyle(AppTheme.ink)

                    Divider().overlay(AppTheme.green.opacity(0.1))

                    VStack(alignment: .leading, spacing: 8) {
                        Eyebrow(text: "In a sentence")
                        Text(word.examplePolish)
                            .font(.body.weight(.medium))
                            .foregroundStyle(AppTheme.ink)
                        Text(word.exampleEnglish)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.muted)
                    }

                    Button {
                        store.toggleLearned(word)
                    } label: {
                        Label(store.isLearned(word) ? "Learned - tap to undo" : "Mark as learned",
                              systemImage: store.isLearned(word) ? "checkmark.circle.fill" : "checkmark.circle")
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(AppTheme.green)
                }
                .padding(24)
                .background(AppTheme.mint, in: RoundedRectangle(cornerRadius: 28))

                VStack(alignment: .leading, spacing: 14) {
                    Text("Make it a habit")
                        .font(.title2.bold())
                        .foregroundStyle(AppTheme.ink)

                    Button(action: onStartLearning) {
                        HStack(spacing: 14) {
                            Image(systemName: "rectangle.on.rectangle.angled")
                                .font(.title2)
                                .frame(width: 52, height: 52)
                                .foregroundStyle(AppTheme.green)
                                .background(AppTheme.mint, in: RoundedRectangle(cornerRadius: 16))
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Study flashcards").font(.headline)
                                Text("Learn at your own pace").font(.caption).foregroundStyle(AppTheme.muted)
                            }
                            Spacer()
                            Image(systemName: "arrow.up.right")
                        }
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(AppTheme.ink)
                    .padding(16)
                    .background(.white, in: RoundedRectangle(cornerRadius: 22))

                    Button(action: onPractice) {
                        HStack(spacing: 14) {
                            Image(systemName: "brain.head.profile")
                                .font(.title2)
                                .frame(width: 52, height: 52)
                                .foregroundStyle(AppTheme.coral)
                                .background(AppTheme.cream, in: RoundedRectangle(cornerRadius: 16))
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Quick practice").font(.headline)
                                Text("10 questions, instant feedback").font(.caption).foregroundStyle(AppTheme.muted)
                            }
                            Spacer()
                            Image(systemName: "arrow.up.right")
                        }
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(AppTheme.ink)
                    .padding(16)
                    .background(.white, in: RoundedRectangle(cornerRadius: 22))
                }
            }
            .padding(20)
            .padding(.bottom, 14)
        }
        .background(AppTheme.canvas.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }
}
