//
//  CheerIntents.swift
//  Jujob
//
//  "오늘의 주접 하나" — Siri 가 주접 한마디를 읽어 준다. 낮 2시 전에는 아침용, 그 뒤로는 저녁용에서 고른다.
//  Spotlight: 즐겨찾기한 주접을 싣는다(iOS 18+). 누르면 즐겨찾기 화면이 열린다.
//

import AppIntents
import CoreSpotlight
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

// MARK: - 즐겨찾는 주접

/// 앱 화면으로 넘기는 요청. MainContentView 가 즐겨찾기 시트를 열고 내린다.
final class JujobRouter: ObservableObject {
    static let shared = JujobRouter()
    @Published var showFavorites = false
}

struct FavoriteCheerEntity: AppEntity {
    static let typeDisplayRepresentation = TypeDisplayRepresentation(
        name: LocalizedStringResource("즐겨찾는 주접", comment: "Siri/Spotlight: a compliment the user saved to favorites")
    )
    static let defaultQuery = FavoriteCheerQuery()

    /// 주접 글 그대로 (즐겨찾기는 글로 저장된다).
    let id: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(id.replacingOccurrences(of: "\n", with: " "))")
    }

    static var all: [FavoriteCheerEntity] {
        UserPreferencesManager.shared.favoriteQuotes.sorted().map(FavoriteCheerEntity.init)
    }

    /// Spotlight 에 싣는 주접을 이 즐겨찾기에 맞춘다. 앱을 열 때와 즐겨찾기를 바꿀 때 부른다.
    static func reindex(_ favorites: Set<String>) {
        guard #available(iOS 18.0, *) else { return }
        let entities = favorites.sorted().map(FavoriteCheerEntity.init)
        Task {
            let index = CSSearchableIndex.default()
            try? await index.deleteAppEntities(ofType: FavoriteCheerEntity.self)
            try? await index.indexAppEntities(entities)
        }
    }
}

@available(iOS 18.0, *)
extension FavoriteCheerEntity: IndexedEntity {}

struct FavoriteCheerQuery: EntityStringQuery {
    func entities(for identifiers: [String]) async throws -> [FavoriteCheerEntity] {
        let wanted = Set(identifiers)
        return FavoriteCheerEntity.all.filter { wanted.contains($0.id) }
    }

    func entities(matching string: String) async throws -> [FavoriteCheerEntity] {
        FavoriteCheerEntity.all.filter { $0.id.localizedCaseInsensitiveContains(string) }
    }

    func suggestedEntities() async throws -> [FavoriteCheerEntity] {
        FavoriteCheerEntity.all
    }
}

/// 즐겨찾기 화면을 연다. Spotlight · Siri 결과를 누르면 여기로 온다.
struct OpenFavoriteCheerIntent: OpenIntent {
    static let title = LocalizedStringResource("즐겨찾는 주접 열기", comment: "Siri/Spotlight: open a saved compliment")
    static let description = IntentDescription(
        LocalizedStringResource("즐겨찾기한 주접을 앱에서 엽니다.", comment: "Siri: open saved compliment description")
    )

    @Parameter(title: LocalizedStringResource("즐겨찾는 주접", comment: "Siri/Spotlight: a compliment the user saved to favorites"),
               description: LocalizedStringResource("열어 볼 즐겨찾는 주접", comment: "Siri: saved compliment parameter description"))
    var target: FavoriteCheerEntity

    init() {}

    @MainActor
    func perform() async throws -> some IntentResult {
        JujobRouter.shared.showFavorites = true
        return .result()
    }
}

// MARK: - Siri 문구

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
