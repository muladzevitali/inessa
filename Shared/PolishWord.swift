import Foundation

enum PolishLevel: String, CaseIterable, Codable, Identifiable {
    case a1 = "A1"
    case a2 = "A2"
    case b1 = "B1"

    var id: String { rawValue }

    var description: String {
        switch self {
        case .a1: "Beginner"
        case .a2: "Elementary"
        case .b1: "Intermediate"
        }
    }
}

struct PolishWord: Identifiable, Hashable, Codable {
    let polish: String
    let english: String
    let examplePolish: String
    let exampleEnglish: String
    let level: PolishLevel
    let category: String

    var id: String { polish.lowercased() }

    init(
        _ polish: String,
        _ english: String,
        _ examplePolish: String,
        _ exampleEnglish: String,
        level: PolishLevel = .a1,
        category: String
    ) {
        self.polish = polish
        self.english = english
        self.examplePolish = examplePolish
        self.exampleEnglish = exampleEnglish
        self.level = level
        self.category = category
    }
}

enum DailyWord {
    static func word(for date: Date = .now) -> PolishWord {
        let day = Calendar.current.ordinality(of: .day, in: .era, for: date) ?? 0
        return Vocabulary.all[day % Vocabulary.all.count]
    }

    static func nextRefresh(after date: Date) -> Date {
        Calendar.current.nextDate(
            after: date,
            matching: DateComponents(hour: 0, minute: 0),
            matchingPolicy: .nextTime
        ) ?? date.addingTimeInterval(86_400)
    }
}
