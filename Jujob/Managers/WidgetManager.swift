//
//  WidgetManager.swift
//  Jujob
//
//  Created by hyunho lee on 2023/07/04.
//

import UIKit
import SwiftUI
import Foundation

// MARK: - This represents the refresh interval for the widget (min is 5 minutes)
enum RefreshInterval: String, CaseIterable, Identifiable {
    case five = "5분"
    case fifteen = "15분"
    case thirty = "30분"
    var id: Int { hashValue }

    /// rawValue 는 저장 키라 바꾸지 않는다. 화면에는 이 번역된 이름을 쓴다.
    var displayName: String {
        switch self {
        case .five: return String(localized: "5분")
        case .fifteen: return String(localized: "15분")
        case .thirty: return String(localized: "30분")
        }
    }
    
    /// Index value that will be used for the segmented control / picker
    var indexValue: Int {
        switch self {
        case .five:
            return 0
        case .fifteen:
            return 1
        default:
            return 2
        }
    }
}

// MARK: - Main manager to handle data for app and widget
class WidgetManager: WidgetConfigurator, ObservableObject {

    /// User preferences manager instance
    private let preferencesManager = UserPreferencesManager.shared

    /// Default initializer will retrieve all configurations
    override init() {
        super.init()
        isPremiumUser = UserDefaults(suiteName: AppConfig.appGroupId)?.object(forKey: Self.styleOpenKey) as? Bool ?? true
        retrieveSavedConfigurations()
    }
    
    /// This is the app group id
    override func appGroupId() -> String {
        AppConfig.appGroupId
    }
    
    /// Retrieve saved configurations
    private func retrieveSavedConfigurations() {
        backgroundImageName = currentImageName
        selectedBackgroundColor = gradientColors
        refreshInterval = RefreshInterval(rawValue: interval) ?? .five
        selectedFont = fontStyle ?? "Arial"
        selectedTextLineSpacing = textLineSpacing ?? 0
        selectedTextColor = fontColor
        contentAlignment = horizontalAlignment
        showQuoteAuthor = shouldShowQuoteAuthor
        currentQuoteCategory = QuoteCategory(rawValue: currentCategoryQuote ?? "") ?? QuoteCategory.allCases.first!
        let quotes = QuotesManager.quotes
        currentQuote = quotes.first(where: { $0.text == currentTextQuote ?? "" }) ?? quotes.first!
    }
    
    /// Font for the widget text elements
    @Published public var selectedFont: String = "Arial" {
        didSet {
            fontStyle = selectedFont
        }
    }
    
    /// Selected solid background color
    @Published public var selectedBackgroundColor: [Color] = [Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)), Color(#colorLiteral(red: 0.9529411793, green: 0.5576358299, blue: 0.1333333403, alpha: 1))] {
        didSet {
            gradientColors = selectedBackgroundColor
        }
    }
    
    /// Selected text color
    @Published public var selectedTextLineSpacing: Double = 0 {
        didSet {
            textLineSpacing = selectedTextLineSpacing
        }
    }
    
    /// Selected text color
    @Published public var selectedTextColor: Color = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)) {
        didSet {
            fontColor = selectedTextColor
        }
    }
    
    /// Currently selected quote
    @Published public var currentQuote: Quote = QuotesManager.quotes.first! {
        didSet {
            currentTextQuote = currentQuote.text
        }
    }
    
    /// Currently selected quote category
    @Published public var currentQuoteCategory: QuoteCategory = QuoteCategory.allCases.first! {
        didSet {
            currentCategoryQuote = currentQuoteCategory.rawValue
        }
    }

    /// Refresh interval for the widget
    @Published var refreshInterval: RefreshInterval = .five {
        didSet {
            interval = refreshInterval.rawValue
        }
    }

    // MARK: - Pro 꾸밈 (글꼴 13종 · 배경 이미지 · 색 · 행간)

    /// 꾸밈이 열려 있는가. **권한은 앱의 `JujobPro` 한 곳이 정하고** App Group 에 적는다 — 위젯은 그 값을 읽기만 한다.
    /// 한 번도 적히지 않았으면 열린 것으로 본다. 업데이트 직후 앱을 열기 전에 이미 꾸민 위젯이 바뀌지 않게.
    @Published public var isPremiumUser: Bool = true

    /// App Group 에 적는 열림 값의 키.
    static let styleOpenKey = "pro.styleOpen"

    /// 무료로 쓰는 글꼴 3종 (`fonts` 의 앞 셋).
    static let freeFontCount = 3

    /// 무료 위젯의 모양 — 주황 그라데이션 · 흰 글자 · 기본 행간 · 배경 이미지 없음.
    static let defaultBackgroundColors = [Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)), Color(#colorLiteral(red: 0.9529411793, green: 0.5576358299, blue: 0.1333333403, alpha: 1))]
    static let defaultTextColor = Color.white

    /// 이 글꼴이 Pro 에서만 열리는가.
    func isFontLocked(_ font: String) -> Bool {
        !isPremiumUser && !fonts.prefix(Self.freeFontCount).contains(font)
    }

    // 위젯과 미리보기는 아래 값으로 그린다. 권한이 없어지면 **고른 값은 남기고** 기본 모양으로 그린다 —
    // 다시 Pro 가 되면 고른 모양이 그대로 돌아온다.
    var displayFont: String { isFontLocked(selectedFont) ? fonts[0] : selectedFont }
    var displayBackgroundColors: [Color] { isPremiumUser ? selectedBackgroundColor : Self.defaultBackgroundColors }
    var displayTextColor: Color { isPremiumUser ? selectedTextColor : Self.defaultTextColor }
    var displayLineSpacing: Double { isPremiumUser ? selectedTextLineSpacing : 0 }
    var displayBackgroundImageName: String { isPremiumUser ? backgroundImageName : "" }
    
    /// Hide Show quote author
    @Published public var showQuoteAuthor: Bool = false {
        didSet {
            shouldShowQuoteAuthor = showQuoteAuthor
        }
    }
    
    /// Content alignment
    @Published public var contentAlignment: HorizontalAlignment = .leading {
        didSet {
            horizontalAlignment = contentAlignment
        }
    }
    
    /// Background image
    @Published public var backgroundImageName: String = "" {
        didSet {
            currentImageName = backgroundImageName
        }
    }
    
    /// Default font size for the widget
    let textFontSize: CGFloat = 22
    
    /// Main fonts for the widget text elements
    var fonts: [String] {[
        "Arial", "Papyrus", "Kefa", "Futura", "Party LET", "Copperplate", "Gill Sans", "Marker Felt", "Courier New",
        "Georgia", "Arial Rounded MT Bold", "Chalkboard SE", "Academy Engraved LET"
    ]}
    
    // MARK: - Get the timeline offset based on the widget refresh interval
    var timelineOffset: (component: Calendar.Component, value: Int)? {
        switch refreshInterval {
        case .five: return (Calendar.Component.minute, 5)
        case .fifteen: return (Calendar.Component.minute, 15)
        case .thirty: return (Calendar.Component.minute, 30)
        }
    }
    
    // MARK: - Load next quote for a given category
    func loadNextQuote() {
        let categoryQuotes = QuotesManager.quotes//.filter({ $0.category == currentQuoteCategory })
        if categoryQuotes.count > 0 {
            currentQuote = categoryQuotes.randomElement() ?? categoryQuotes[0]
//            if currentIndex + 1 < categoryQuotes.count {
//                currentQuote = categoryQuotes[currentIndex + 1]
//            } else {
//                currentQuote = categoryQuotes[0]
//            }

            // 히스토리에 추가 및 스트릭 업데이트
            preferencesManager.addToHistory(quote: currentQuote)
        }
    }

    /// Get customized quote text with user's name
    func getCustomizedQuoteText() -> String {
        return preferencesManager.customizeQuote(currentQuote.text)
    }
    
    // MARK: - Update current quote based on category changes
    func updateCurrentQuote() {
        if let updatedCurrentQuote = QuotesManager.quotes.filter({ $0.category == currentQuoteCategory }).first {
            currentQuote = updatedCurrentQuote
        }
    }
}
