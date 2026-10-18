import Foundation
import SwiftUI

struct StudySnapshot: Codable {
    var learnedIDs: Set<String> = []
    var favoriteIDs: Set<String> = []
    var answers: Int = 0
    var correctAnswers: Int = 0
    var dailyAnswers: Int = 0
    var dailyCorrect: Int = 0
    var streak: Int = 0
    var lastStudyDate: Date?
    var dailyGoal: Int = 5
}

@MainActor
final class StudyStore: ObservableObject {
    @Published private(set) var snapshot: StudySnapshot

    private let storageKey = "inessa.study.v1"

    init() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let saved = try? JSONDecoder().decode(StudySnapshot.self, from: data) {
            snapshot = saved
        } else {
            snapshot = StudySnapshot()
        }
    }

    var learnedCount: Int { snapshot.learnedIDs.count }
    var favoriteCount: Int { snapshot.favoriteIDs.count }
    var streak: Int { snapshot.streak }
    var goal: Int { snapshot.dailyGoal }
    var answers: Int { snapshot.answers }
    var correctAnswers: Int { snapshot.correctAnswers }
    var todayCorrect: Int {
        guard let date = snapshot.lastStudyDate, Calendar.current.isDateInToday(date) else { return 0 }
        return snapshot.dailyCorrect
    }
    var todayProgress: Double { min(Double(todayCorrect) / Double(max(goal, 1)), 1) }
    var accuracy: Int {
        guard answers > 0 else { return 0 }
        return Int((Double(correctAnswers) / Double(answers) * 100).rounded())
    }

    func isLearned(_ word: PolishWord) -> Bool { snapshot.learnedIDs.contains(word.id) }
    func isFavorite(_ word: PolishWord) -> Bool { snapshot.favoriteIDs.contains(word.id) }

    func toggleLearned(_ word: PolishWord) {
        if snapshot.learnedIDs.contains(word.id) {
            snapshot.learnedIDs.remove(word.id)
        } else {
            snapshot.learnedIDs.insert(word.id)
            recordActivity(correct: true, countsAsAnswer: false)
        }
        save()
    }

    func toggleFavorite(_ word: PolishWord) {
        if snapshot.favoriteIDs.contains(word.id) {
            snapshot.favoriteIDs.remove(word.id)
        } else {
            snapshot.favoriteIDs.insert(word.id)
        }
        save()
    }

    func recordQuizAnswer(correct: Bool) {
        recordActivity(correct: correct, countsAsAnswer: true)
        save()
    }

    func setGoal(_ newGoal: Int) {
        snapshot.dailyGoal = min(max(newGoal, 1), 20)
        save()
    }

    private func recordActivity(correct: Bool, countsAsAnswer: Bool) {
        let today = Date()
        if let last = snapshot.lastStudyDate {
            if !Calendar.current.isDateInToday(last) {
                snapshot.streak = Calendar.current.isDateInYesterday(last) ? snapshot.streak + 1 : 1
                snapshot.dailyAnswers = 0
                snapshot.dailyCorrect = 0
            }
        } else {
            snapshot.streak = 1
        }
        snapshot.lastStudyDate = today
        snapshot.dailyAnswers += 1
        if correct { snapshot.dailyCorrect += 1 }
        if countsAsAnswer {
            snapshot.answers += 1
            if correct { snapshot.correctAnswers += 1 }
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
