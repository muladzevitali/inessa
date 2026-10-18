import SwiftUI

@main
struct InessaApp: App {
    @StateObject private var studyStore = StudyStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(studyStore)
        }
    }
}

private enum InessaTab: Hashable {
    case today, learn, practice, library, progress
}

struct RootView: View {
    @State private var tab: InessaTab = .today

    var body: some View {
        TabView(selection: $tab) {
            NavigationStack {
                TodayView(onStartLearning: { tab = .learn }, onPractice: { tab = .practice })
            }
            .tabItem { Label("Today", systemImage: "sun.max.fill") }
            .tag(InessaTab.today)

            NavigationStack { FlashcardsView() }
                .tabItem { Label("Learn", systemImage: "rectangle.on.rectangle.angled") }
                .tag(InessaTab.learn)

            NavigationStack { QuizView() }
                .tabItem { Label("Practice", systemImage: "checkmark.circle.fill") }
                .tag(InessaTab.practice)

            NavigationStack { LibraryView() }
                .tabItem { Label("Words", systemImage: "books.vertical.fill") }
                .tag(InessaTab.library)

            NavigationStack { InsightsView() }
                .tabItem { Label("Progress", systemImage: "chart.bar.fill") }
                .tag(InessaTab.progress)
        }
        .tint(AppTheme.green)
        .onOpenURL { url in
            if url.scheme == "inessa" { tab = .today }
        }
    }
}
