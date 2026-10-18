import SwiftUI

enum AppTheme {
    static let ink = Color(red: 0.14, green: 0.20, blue: 0.19)
    static let canvas = Color(red: 0.98, green: 0.97, blue: 0.94)
    static let green = Color(red: 0.22, green: 0.44, blue: 0.34)
    static let mint = Color(red: 0.88, green: 0.94, blue: 0.88)
    static let coral = Color(red: 0.92, green: 0.43, blue: 0.34)
    static let muted = Color(red: 0.48, green: 0.52, blue: 0.49)
    static let cream = Color(red: 1.0, green: 0.95, blue: 0.86)
}

struct InessaCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

struct Eyebrow: View {
    let text: String
    var body: some View {
        Text(text.uppercased())
            .font(.system(size: 11, weight: .bold, design: .rounded))
            .tracking(2)
            .foregroundStyle(AppTheme.muted)
    }
}

struct PrimaryButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 17)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .background(AppTheme.green, in: RoundedRectangle(cornerRadius: 17))
        .accessibilityIdentifier(title)
    }
}
