import SwiftUI

struct FlashcardsView: View {
    @EnvironmentObject private var store: StudyStore
    @State private var level: PolishLevel = .a1
    @State private var index = 0
    @State private var revealed = false

    private var words: [PolishWord] { Vocabulary.words(level: level) }
    private var word: PolishWord { words[index % words.count] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 5) {
                    Eyebrow(text: "Learn Polish")
                    Text("Your flashcards")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(AppTheme.ink)
                    Text("Tap a card to reveal its meaning.")
                        .foregroundStyle(AppTheme.muted)
                }

                HStack(spacing: 8) {
                    ForEach(PolishLevel.allCases) { option in
                        Button {
                            level = option
                            index = 0
                            revealed = false
                        } label: {
                            VStack(spacing: 3) {
                                Text(option.rawValue).font(.headline)
                                Text(option.description).font(.system(size: 10))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(option == level ? AppTheme.green : .white, in: RoundedRectangle(cornerRadius: 14))
                            .foregroundStyle(option == level ? .white : AppTheme.ink)
                        }
                        .buttonStyle(.plain)
                    }
                }

                HStack {
                    Text("Card \(index + 1) of \(words.count)")
                        .font(.subheadline.weight(.semibold))
                    Spacer()
                    Label("\(words.filter { store.isLearned($0) }.count) learned", systemImage: "checkmark.circle")
                        .font(.caption)
                        .foregroundStyle(AppTheme.green)
                }
                .foregroundStyle(AppTheme.muted)

                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { revealed.toggle() }
                } label: {
                    VStack(spacing: 19) {
                        HStack {
                            Text(level.rawValue + "  ·  " + word.category)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(AppTheme.green)
                            Spacer()
                            Image(systemName: "hand.tap")
                                .foregroundStyle(AppTheme.muted)
                        }

                        Spacer(minLength: 24)
                        Text(word.polish)
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(AppTheme.ink)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.65)
                            .lineLimit(3)

                        Text(revealed ? word.english : "Tap to reveal")
                            .font(.title3.weight(.medium))
                            .foregroundStyle(revealed ? AppTheme.green : AppTheme.muted)

                        if revealed {
                            VStack(spacing: 7) {
                                Text(word.examplePolish).font(.subheadline.weight(.medium))
                                Text(word.exampleEnglish)
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.muted)
                            }
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)
                            .transition(.opacity)
                        }
                        Spacer(minLength: 24)

                        Label(revealed ? "Tap to hide translation" : "Show translation",
                              systemImage: revealed ? "eye.slash" : "eye")
                            .font(.caption)
                            .foregroundStyle(AppTheme.muted)
                    }
                    .padding(25)
                    .frame(maxWidth: .infinity)
                    .frame(height: 360)
                    .background(AppTheme.mint, in: RoundedRectangle(cornerRadius: 28))
                    .contentShape(RoundedRectangle(cornerRadius: 28))
                }
                .buttonStyle(.plain)

                HStack(spacing: 12) {
                    Button {
                        PronunciationService.shared.speak(word.polish)
                    } label: {
                        Label("Listen", systemImage: "speaker.wave.2.fill")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(AppTheme.green)
                    .background(.white, in: RoundedRectangle(cornerRadius: 16))

                    Button {
                        store.toggleLearned(word)
                        if store.isLearned(word) { nextCard() }
                    } label: {
                        Label(store.isLearned(word) ? "Unlearn" : "Got it", systemImage: "checkmark")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.white)
                    .background(AppTheme.green, in: RoundedRectangle(cornerRadius: 16))
                }
                Button(action: nextCard) {
                    HStack {
                        Text("Next card")
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    .font(.headline)
                    .foregroundStyle(AppTheme.ink)
                    .padding(18)
                    .background(.white, in: RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
            }
            .padding(20)
        }
        .background(AppTheme.canvas.ignoresSafeArea())
        .navigationTitle("Learn")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func nextCard() {
        withAnimation(.easeInOut(duration: 0.2)) {
            index = (index + 1) % words.count
            revealed = false
        }
    }
}
