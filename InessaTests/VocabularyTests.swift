import XCTest
@testable import Inessa

final class VocabularyTests: XCTestCase {
    func testWordsAreUniqueAndNonEmpty() {
        XCTAssertGreaterThanOrEqual(Vocabulary.all.count, 90)
        XCTAssertEqual(Set(Vocabulary.all.map(\.id)).count, Vocabulary.all.count)

        for word in Vocabulary.all {
            XCTAssertFalse(word.polish.isEmpty)
            XCTAssertFalse(word.english.isEmpty)
            XCTAssertFalse(word.examplePolish.isEmpty)
            XCTAssertFalse(word.exampleEnglish.isEmpty)
        }
    }

    func testEveryLevelHasWords() {
        for level in PolishLevel.allCases {
            XCTAssertGreaterThanOrEqual(Vocabulary.words(level: level).count, 10)
        }
    }

    func testDailyWordIsStableForSameDate() {
        let date = Date(timeIntervalSince1970: 1_780_000_000)
        XCTAssertEqual(DailyWord.word(for: date), DailyWord.word(for: date))
    }

    func testNextRefreshIsInFuture() {
        let now = Date()
        XCTAssertGreaterThan(DailyWord.nextRefresh(after: now), now)
    }
}
