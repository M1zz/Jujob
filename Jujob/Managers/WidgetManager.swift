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
    
    /// Default initializer will retrieve all configurations
    override init() {
        super.init()
        isPremiumUser = UserDefaults.standard.bool(forKey: "isPremiumUser")
        if AppConfig.bypassInAppPurchases { isPremiumUser = true }
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

    /// Determine if user purchased the pro version
    @Published public var isPremiumUser: Bool = false {
        didSet {
            UserDefaults.standard.setValue(isPremiumUser, forKey: "isPremiumUser")
            UserDefaults.standard.synchronize()
        }
    }
    
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
        let currentIndex = categoryQuotes.firstIndex(where: { $0.text == currentQuote.text })!
        if categoryQuotes.count > 0 {
            currentQuote = categoryQuotes.randomElement() ?? Quote(text: "완벽하지만 구멍 하나 있네요. \n황홀(hole).", category: .happiness, author: "Leeo")
//            if currentIndex + 1 < categoryQuotes.count {
//                currentQuote = categoryQuotes[currentIndex + 1]
//            } else {
//                currentQuote = categoryQuotes[0]
//            }
        }
    }
    
    // MARK: - Update current quote based on category changes
    func updateCurrentQuote() {
        if let updatedCurrentQuote = QuotesManager.quotes.filter({ $0.category == currentQuoteCategory }).first {
            currentQuote = updatedCurrentQuote
        }
    }
}
