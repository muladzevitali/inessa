import WidgetKit
import SwiftUI

struct PolishWordEntry: TimelineEntry {
    let date: Date
    let word: PolishWord
}

struct PolishWordProvider: TimelineProvider {
    func placeholder(in context: Context) -> PolishWordEntry {
        PolishWordEntry(date: .now, word: Vocabulary.all[0])
    }

    func getSnapshot(in context: Context, completion: @escaping (PolishWordEntry) -> Void) {
        completion(PolishWordEntry(date: .now, word: DailyWord.word()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PolishWordEntry>) -> Void) {
        let now = Date()
        let entry = PolishWordEntry(date: now, word: DailyWord.word(for: now))
        completion(Timeline(entries: [entry], policy: .after(DailyWord.nextRefresh(after: now))))
    }
}

struct PolishWordWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: PolishWordEntry

    private let forest = Color(red: 0.19, green: 0.40, blue: 0.30)
    private let paleGreen = Color(red: 0.88, green: 0.94, blue: 0.88)

    var body: some View {
        Group {
            switch family {
            case .accessoryInline:
                Text("🇵🇱 \(entry.word.polish) · \(entry.word.english)")
                    .lineLimit(1)
            case .accessoryCircular:
                VStack(spacing: 2) {
                    Text("PL").font(.caption2.bold())
                    Image(systemName: "text.book.closed.fill")
                        .font(.title3)
                }
            case .accessoryRectangular:
                VStack(alignment: .leading, spacing: 4) {
                    Text("🇵🇱 POLISH OF THE DAY")
                        .font(.system(size: 9, weight: .bold))
                        .lineLimit(1)
                    Text(entry.word.polish)
                        .font(.headline)
                        .minimumScaleFactor(0.65)
                        .lineLimit(1)
                    Text(entry.word.english)
                        .font(.caption)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            case .systemMedium:
                homeWidget
            case .systemSmall:
                homeWidget
            default:
                homeWidget
            }
        }
        .widgetURL(URL(string: "inessa://today"))
    }

    private var homeWidget: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Text("🇵🇱  INESSA")
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .tracking(1.3)
                Spacer()
                Image(systemName: "sparkle")
            }
            Spacer(minLength: 4)
            Text(entry.word.polish)
                .font(.system(size: 25, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.6)
                .lineLimit(2)
            Text(entry.word.english)
                .font(.system(size: 13, weight: .medium))
                .lineLimit(2)
            Spacer(minLength: 4)
            Text("A WORD A DAY")
                .font(.system(size: 9, weight: .bold))
                .tracking(1)
                .opacity(0.7)
        }
        .foregroundStyle(forest)
        .containerBackground(for: .widget) { paleGreen }
    }
}

struct InessaDailyWidget: Widget {
    let kind = "InessaDailyPolish"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PolishWordProvider()) { entry in
            PolishWordWidgetView(entry: entry)
        }
        .configurationDisplayName("Daily Polish")
        .description("A fresh Polish word on your Lock Screen or Home Screen every day.")
        .supportedFamilies([
            .accessoryInline, .accessoryRectangular, .accessoryCircular,
            .systemSmall, .systemMedium
        ])
    }
}

@main
struct InessaWidgets: WidgetBundle {
    var body: some Widget {
        InessaDailyWidget()
    }
}
