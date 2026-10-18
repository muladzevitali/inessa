import SwiftUI

struct LibraryView: View {
    @EnvironmentObject private var store: StudyStore
    @State private var search = ""
    @State private var level: PolishLevel?
    @State private var favoritesOnly = false

    private var filtered: [PolishWord] {
        Vocabulary.all.filter { word in
            (level == nil || word.level == level)
                && (!favoritesOnly || store.isFavorite(word))
                && (search.isEmpty
                    || word.polish.localizedCaseInsensitiveContains(search)
                    || word.english.localizedCaseInsensitiveContains(search))
        }
    }

    private var grouped: [(String, [PolishWord])] {
        let sections = Dictionary(grouping: filtered, by: \.category)
        return sections.keys.sorted().map { ($0, (sections[$0] ?? []).sorted { $0.polish < $1.polish }) }
    }

    var body: some View {
        List {
            Section {
                HStack(spacing: 8) {
                    levelButton("All", selected: level == nil) { level = nil }
                    ForEach(PolishLevel.allCases) { option in
                        levelButton(option.rawValue, selected: level == option) { level = option }
                    }
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 6, trailing: 0))

                Toggle(isOn: $favoritesOnly) {
                    Label("Favorites only", systemImage: "heart.fill")
                        .foregroundStyle(AppTheme.ink)
                }
                .tint(AppTheme.green)
            }

            if filtered.isEmpty {
                ContentUnavailableView.search(text: search)
                    .listRowBackground(Color.clear)
            } else {
                ForEach(grouped, id: \.0) { category, words in
                    Section(category) {
                        ForEach(words) { word in
                            VStack(alignment: .leading, spacing: 9) {
                                HStack(alignment: .top, spacing: 10) {
                                    VStack(alignment: .leading, spacing: 5) {
                                        HStack(spacing: 8) {
                                            Text(word.polish)
                                                .font(.headline)
                                                .foregroundStyle(AppTheme.ink)
                                            if store.isLearned(word) {
                                                Image(systemName: "checkmark.seal.fill")
                                                    .foregroundStyle(AppTheme.green)
                                            }
                                        }
                                        Text(word.english)
                                            .font(.subheadline)
                                            .foregroundStyle(AppTheme.muted)
                                    }
                                    Spacer()
                                    Button {
                                        PronunciationService.shared.speak(word.polish)
                                    } label: {
                                        Image(systemName: "speaker.wave.2")
                                    }
                                    .buttonStyle(.plain)
                                    .accessibilityLabel("Pronounce \(word.polish)")

                                    Button {
                                        store.toggleFavorite(word)
                                    } label: {
                                        Image(systemName: store.isFavorite(word) ? "heart.fill" : "heart")
                                            .foregroundStyle(AppTheme.coral)
                                    }
                                    .buttonStyle(.plain)
                                    .accessibilityLabel(store.isFavorite(word) ? "Remove favorite" : "Add favorite")
                                }

                                Text(word.examplePolish)
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.ink)
                                HStack {
                                    Text(word.level.rawValue)
                                        .font(.caption2.bold())
                                        .foregroundStyle(AppTheme.green)
                                    Spacer()
                                    Button(store.isLearned(word) ? "Mark as new" : "Mark learned") {
                                        store.toggleLearned(word)
                                    }
                                    .font(.caption.weight(.medium))
                                    .buttonStyle(.plain)
                                    .foregroundStyle(AppTheme.green)
                                }
                            }
                            .padding(.vertical, 7)
                            .listRowBackground(Color.white)
                        }
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.canvas)
        .searchable(text: $search, prompt: "Search Polish or English")
        .navigationTitle("Word library")
    }

    private func levelButton(_ title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(selected ? .white : AppTheme.ink)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 11)
                .background(selected ? AppTheme.green : .white, in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
