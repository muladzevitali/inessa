import AVFoundation
import Foundation

@MainActor
final class PronunciationService {
    static let shared = PronunciationService()

    private let synthesizer = AVSpeechSynthesizer()

    func speak(_ polish: String) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: polish)
        utterance.voice = AVSpeechSynthesisVoice(language: "pl-PL")
        utterance.rate = 0.47
        utterance.pitchMultiplier = 1.0
        synthesizer.speak(utterance)
    }
}
