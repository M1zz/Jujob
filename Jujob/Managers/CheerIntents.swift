//
//  CheerIntents.swift
//  Jujob
//
//  "오늘의 주접 하나" — Siri 가 주접 한마디를 읽어 준다. 낮 2시 전에는 아침용, 그 뒤로는 저녁용에서 고른다.
//

import AppIntents
import Foundation

struct DailyCheerIntent: AppIntent {
    static let title = LocalizedStringResource("주접 한마디", comment: "Siri: read one cheerful compliment")
    static let description = IntentDescription(
        LocalizedStringResource("지금 시간에 맞는 주접 한마디를 읽어 줍니다.", comment: "Siri: daily cheer description")
    )

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let hour = Calendar.current.component(.hour, from: .now)
        // 무료로 열린 아침 · 저녁 주접에서만 고른다(앱의 잠금과 같은 범위).
        let mood: QuoteCategory = hour < 14 ? .morning : .evening
        let pool = QuotesManager.quotes.filter { $0.category == mood }
        guard let quote = (pool.isEmpty ? QuotesManager.quotes : pool).randomElement() else {
            return .result(dialog: "")
        }
        return .result(dialog: IntentDialog(stringLiteral: quote.text.replacingOccurrences(of: "\n", with: " ")))
    }
}

struct JujobShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: DailyCheerIntent(),
            phrases: ["Cheer me up with \(.applicationName)", "\(.applicationName) one line"],
            shortTitle: "A Little Cheer",
            systemImageName: "heart"
        )
    }
}
