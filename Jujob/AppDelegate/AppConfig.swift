//
//  AppConfig.swift
//  Quotes
//
//  Created by Apps4World on 10/8/20.
//

import SwiftUI
import Foundation

/// Basic app configurations
class AppConfig {

    /// App Group name/id
    static let appGroupId: String = "group.com.leeo.JuJob"
    
    /// Premium version details
    static let productId: String = "proVersion"
    
    /// How many categories can user select for free version
    static let freeCategoriesSelectionCount: Int = 2
    
    /// This is for testing purposes only. Set it to `true` if you want to bypass the in-app purchases or remove in-app purchases completely
    static let bypassInAppPurchases: Bool = false
    
    /// Show scheduled quotes in the logs. You must run the `QuotesWidgetExtension`
    static let showScheduledQuotesLogs: Bool = false
}

// MARK: - Main widget configurator class
open class WidgetConfigurator: NSObject {
    
    public override init() {
        super.init()
        fetchLocalImages()
        setup2DArrayOfImages()
    }
    
    /// This is the app group id. You must override this variable and provide your own value
    open func appGroupId() -> String { return "" }
    
    /// This is the local image prefix. By default it's set to `local`
    open func localImagePrefix() -> String { return "local" }
    
    /// Get & Save color for a given key
    internal func getColor(forKey key: String) -> Color? {
        guard let components = UserDefaults(suiteName: appGroupId())?.array(forKey: key) as? [CGFloat] else {
            return nil
        }
        if let r = components.first, let opacity = components.last, components.count == 4 {
            return Color(red: Double(r), green: Double(components[1]), blue: Double(components[2]), opacity: Double(opacity))
        }
        return nil
    }
    
    internal func saveColor(_ color: Color, forKey key: String) {
        if let components = color.cgColor?.components {
            UserDefaults(suiteName: appGroupId())?.setValue(components, forKey: key)
            UserDefaults(suiteName: appGroupId())?.synchronize()
        }
    }
    
    /// Returns the gradient colors set by the user
    public var gradientColors: [Color] {
        set {
            if let first = newValue.first { saveColor(first, forKey: "firstColor") }
            if let second = newValue.last { saveColor(second, forKey: "secondColor") }
        }
        get {
            return [getColor(forKey: "firstColor") ?? Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)), getColor(forKey: "secondColor") ?? Color(#colorLiteral(red: 0.9529411793, green: 0.5576358299, blue: 0.1333333403, alpha: 1))]
        }
    }

    /// Refresh interval set by the user
    public var interval: String {
        set {
            UserDefaults(suiteName: appGroupId())?.setValue(newValue, forKey: "refreshInterval")
            UserDefaults(suiteName: appGroupId())?.synchronize()
        }
        get {
            return UserDefaults(suiteName: appGroupId())?.string(forKey: "refreshInterval") ?? "5 minutes"
        }
    }
    
    /// Returns the selected font by the user
    public var fontStyle: String? {
        set {
            UserDefaults(suiteName: appGroupId())?.setValue(newValue, forKey: "fontStyle")
            UserDefaults(suiteName: appGroupId())?.synchronize()
        }
        get {
            return UserDefaults(suiteName: appGroupId())?.string(forKey: "fontStyle")
        }
    }
    
    /// Returns the font color set by the user
    public var fontColor: Color {
        set {
            saveColor(newValue, forKey: "fontColor")
        }
        get {
            return getColor(forKey: "fontColor") ?? Color.white
        }
    }
    
    /// Returns current selected quote/text set by the user
    public var currentTextQuote: String? {
        set {
            UserDefaults(suiteName: appGroupId())?.setValue(newValue, forKey: "currentQuote")
            UserDefaults(suiteName: appGroupId())?.synchronize()
        }
        get {
            return UserDefaults(suiteName: appGroupId())?.string(forKey: "currentQuote")
        }
    }
    
    /// Returns current selected quotes category
    public var currentCategoryQuote: String? {
        set {
            UserDefaults(suiteName: appGroupId())?.setValue(newValue, forKey: "currentCategoryQuote")
            UserDefaults(suiteName: appGroupId())?.synchronize()
        }
        get {
            return UserDefaults(suiteName: appGroupId())?.string(forKey: "currentCategoryQuote")
        }
    }
    
    /// Returns the value of showing/hiding quote's author
    public var shouldShowQuoteAuthor: Bool {
        set {
            UserDefaults(suiteName: appGroupId())?.setValue(newValue, forKey: "quoteAuthor")
            UserDefaults(suiteName: appGroupId())?.synchronize()
        }
        get {
            return UserDefaults(suiteName: appGroupId())?.bool(forKey: "quoteAuthor") ?? false
        }
    }
    
    /// Returns the alignment for the VStack
    public var horizontalAlignment: HorizontalAlignment {
        set {
            UserDefaults(suiteName: appGroupId())?.setValue(newValue.rawValue, forKey: "horizontalAlignment")
            UserDefaults(suiteName: appGroupId())?.synchronize()
        }
        get {
            return HorizontalAlignment.alignment(string: UserDefaults(suiteName: appGroupId())?.string(forKey: "horizontalAlignment") ?? "")
        }
    }
    
    /// Returns the local photo gallery image name
    public var currentImageName: String {
        set {
            UserDefaults(suiteName: appGroupId())?.setValue(newValue, forKey: "currentImageName")
            UserDefaults(suiteName: appGroupId())?.synchronize()
        }
        get {
            return UserDefaults(suiteName: appGroupId())?.string(forKey: "currentImageName") ?? ""
        }
    }
    
    // MARK: - Local images manager
    private var allImages = [UIImage]()
    public var localImages = [[UIImage]]()
    
    private func fetchLocalImages() {
        for index in 0..<INT_MAX {
            if let image = UIImage(named: "\(localImagePrefix())\(index)") {
                image.accessibilityIdentifier = "\(localImagePrefix())\(index)"
                allImages.append(image)
            } else { break }
        }
    }
    
    private func setup2DArrayOfImages() {
        if let firstItem = allImages.first {
            var array = [UIImage]()
            array.append(firstItem)
            if allImages.count > 1 { array.append(allImages[1]) }
            localImages.append(array)
            allImages.removeAll { (image) -> Bool in
                array.contains(where: { $0.accessibilityIdentifier == image.accessibilityIdentifier })
            }
            setup2DArrayOfImages()
        }
    }
    
    // MARK: - Generate 2D array for quotes categories
    public func categories2DArray(_ array: [String]) -> [[String]] {
        var allCategories = array
        var categories = [[String]]()
        
        func setup2DArrayOfCategories() {
            if let firstItem = allCategories.first {
                var array = [String]()
                array.append(firstItem)
                if allCategories.count > 1 { array.append(allCategories[1]) }
                categories.append(array)
                allCategories.removeAll { (item) -> Bool in array.contains(item) }
                setup2DArrayOfCategories()
            }
        }
        
        setup2DArrayOfCategories()
        
        return categories
    }
}

public extension HorizontalAlignment {
    var rawValue: String {
        switch self {
        case .leading:
            return "leading"
        case .trailing:
            return "trailing"
        default:
            return "center"
        }
    }
    
    var indexValue: Int {
        switch self {
        case .leading:
            return 0
        case .trailing:
            return 2
        default:
            return 1
        }
    }
    
    static func alignment(string: String) -> HorizontalAlignment {
        switch string {
        case "leading":
            return .leading
        case "trailing":
            return .trailing
        default:
            return .center
        }
    }
}
