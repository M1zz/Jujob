//
//  UserPreferencesManager.swift
//  Jujob
//
//  Created by hyunho lee on 2024/11/24.
//

import Foundation
import SwiftUI

// MARK: - QuoteHistory Model
struct QuoteHistory: Codable, Identifiable {
    let id: UUID
    let quoteText: String
    let viewedAt: Date
    let category: String

    init(quoteText: String, category: String) {
        self.id = UUID()
        self.quoteText = quoteText
        self.viewedAt = Date()
        self.category = category
    }
}

// MARK: - QuoteFeedback Model (좋아요/싫어요)
struct QuoteFeedback: Codable {
    let quoteText: String
    var isLiked: Bool // true = 좋아요, false = 싫어요
    let feedbackDate: Date
}

// MARK: - DailyStreak Model
struct DailyStreak: Codable {
    var currentStreak: Int
    var longestStreak: Int
    var lastViewDate: Date?
    var totalDaysViewed: Int

    init() {
        self.currentStreak = 0
        self.longestStreak = 0
        self.lastViewDate = nil
        self.totalDaysViewed = 0
    }
}

// MARK: - Achievement Model
struct Achievement: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let requirement: Int // 7일, 30일, 100일 등
    var isUnlocked: Bool
    var unlockedDate: Date?
    let specialQuotes: [String] // 언락 시 받는 특별 주접들

    static let allAchievements: [Achievement] = [
        Achievement(
            id: "streak_7",
            title: "일주일 달성!",
            description: "7일 연속으로 주접을 확인했어요!",
            requirement: 7,
            isUnlocked: false,
            unlockedDate: nil,
            specialQuotes: [
                "일주일 동안 꾸준히 찾아와준 당신,\n정말 자랑스러워요!",
                "7일의 여정을 함께한 우리,\n앞으로도 계속 함께해요!"
            ]
        ),
        Achievement(
            id: "streak_30",
            title: "한 달 달성!",
            description: "30일 연속으로 주접을 확인했어요!",
            requirement: 30,
            isUnlocked: false,
            unlockedDate: nil,
            specialQuotes: [
                "한 달 동안 함께한 우리,\n당신은 정말 특별한 사람이에요!",
                "30일이라는 긴 시간 동안\n꾸준히 찾아와준 당신, 최고예요!"
            ]
        ),
        Achievement(
            id: "streak_100",
            title: "백일 달성!",
            description: "100일 연속으로 주접을 확인했어요!",
            requirement: 100,
            isUnlocked: false,
            unlockedDate: nil,
            specialQuotes: [
                "100일이라는 놀라운 여정을 함께한 우리,\n당신은 정말 대단한 사람이에요!",
                "백일 동안 매일 찾아와준 당신,\n이 세상에서 가장 소중한 사람이에요!",
                "100일의 기적! 당신의 꾸준함이\n세상을 변화시켰어요!"
            ]
        ),
        Achievement(
            id: "total_50",
            title: "주접 마스터",
            description: "총 50개의 주접을 확인했어요!",
            requirement: 50,
            isUnlocked: false,
            unlockedDate: nil,
            specialQuotes: [
                "50개의 주접을 모두 확인한 당신,\n정말 열정적이에요!"
            ]
        ),
        Achievement(
            id: "total_100",
            title: "주접 그랜드 마스터",
            description: "총 100개의 주접을 확인했어요!",
            requirement: 100,
            isUnlocked: false,
            unlockedDate: nil,
            specialQuotes: [
                "100개의 주접을 모두 경험한 당신,\n이제 진정한 마스터예요!"
            ]
        )
    ]
}

// MARK: - UserPreferencesManager
class UserPreferencesManager: ObservableObject {
    static let shared = UserPreferencesManager()

    private let appGroupId = AppConfig.appGroupId
    private let userDefaults: UserDefaults

    // Published properties
    @Published var userName: String = ""
    @Published var favoriteQuotes: Set<String> = []
    @Published var quoteHistory: [QuoteHistory] = []
    @Published var quoteFeedbacks: [String: QuoteFeedback] = [:] // quoteText를 키로 사용
    @Published var dailyStreak: DailyStreak = DailyStreak()
    @Published var achievements: [Achievement] = Achievement.allAchievements

    // Keys for UserDefaults
    private let userNameKey = "userName"
    private let favoriteQuotesKey = "favoriteQuotes"
    private let quoteHistoryKey = "quoteHistory"
    private let quoteFeedbacksKey = "quoteFeedbacks"
    private let dailyStreakKey = "dailyStreak"
    private let achievementsKey = "achievements"

    private init() {
        self.userDefaults = UserDefaults(suiteName: appGroupId) ?? UserDefaults.standard
        loadAllData()
    }

    // MARK: - Load Data
    private func loadAllData() {
        loadUserName()
        loadFavoriteQuotes()
        loadQuoteHistory()
        loadQuoteFeedbacks()
        loadDailyStreak()
        loadAchievements()
    }

    private func loadUserName() {
        userName = userDefaults.string(forKey: userNameKey) ?? ""
    }

    private func loadFavoriteQuotes() {
        if let data = userDefaults.data(forKey: favoriteQuotesKey),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            favoriteQuotes = decoded
        }
    }

    private func loadQuoteHistory() {
        if let data = userDefaults.data(forKey: quoteHistoryKey),
           let decoded = try? JSONDecoder().decode([QuoteHistory].self, from: data) {
            quoteHistory = decoded
        }
    }

    private func loadQuoteFeedbacks() {
        if let data = userDefaults.data(forKey: quoteFeedbacksKey),
           let decoded = try? JSONDecoder().decode([String: QuoteFeedback].self, from: data) {
            quoteFeedbacks = decoded
        }
    }

    private func loadDailyStreak() {
        if let data = userDefaults.data(forKey: dailyStreakKey),
           let decoded = try? JSONDecoder().decode(DailyStreak.self, from: data) {
            dailyStreak = decoded
        }
    }

    private func loadAchievements() {
        if let data = userDefaults.data(forKey: achievementsKey),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = decoded
        }
    }

    // MARK: - Save Data
    func saveUserName(_ name: String) {
        userName = name
        userDefaults.set(name, forKey: userNameKey)
        userDefaults.synchronize()
    }

    func toggleFavorite(quoteText: String) {
        if favoriteQuotes.contains(quoteText) {
            favoriteQuotes.remove(quoteText)
        } else {
            favoriteQuotes.insert(quoteText)
        }
        saveFavoriteQuotes()
    }

    private func saveFavoriteQuotes() {
        if let encoded = try? JSONEncoder().encode(favoriteQuotes) {
            userDefaults.set(encoded, forKey: favoriteQuotesKey)
            userDefaults.synchronize()
        }
    }

    func isFavorite(quoteText: String) -> Bool {
        return favoriteQuotes.contains(quoteText)
    }

    func addToHistory(quote: Quote) {
        let history = QuoteHistory(quoteText: quote.text, category: quote.category.rawValue)
        quoteHistory.insert(history, at: 0)

        // 최대 100개까지만 저장
        if quoteHistory.count > 100 {
            quoteHistory = Array(quoteHistory.prefix(100))
        }

        saveQuoteHistory()
        updateDailyStreak()
    }

    private func saveQuoteHistory() {
        if let encoded = try? JSONEncoder().encode(quoteHistory) {
            userDefaults.set(encoded, forKey: quoteHistoryKey)
            userDefaults.synchronize()
        }
    }

    func setFeedback(quoteText: String, isLiked: Bool) {
        let feedback = QuoteFeedback(quoteText: quoteText, isLiked: isLiked, feedbackDate: Date())
        quoteFeedbacks[quoteText] = feedback
        saveQuoteFeedbacks()
    }

    private func saveQuoteFeedbacks() {
        if let encoded = try? JSONEncoder().encode(quoteFeedbacks) {
            userDefaults.set(encoded, forKey: quoteFeedbacksKey)
            userDefaults.synchronize()
        }
    }

    func getFeedback(quoteText: String) -> QuoteFeedback? {
        return quoteFeedbacks[quoteText]
    }

    // MARK: - Daily Streak Management
    private func updateDailyStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastDate = dailyStreak.lastViewDate {
            let lastViewDay = calendar.startOfDay(for: lastDate)
            let daysDifference = calendar.dateComponents([.day], from: lastViewDay, to: today).day ?? 0

            if daysDifference == 0 {
                // 오늘 이미 확인함 - 아무것도 안 함
                return
            } else if daysDifference == 1 {
                // 연속 달성!
                dailyStreak.currentStreak += 1
                dailyStreak.totalDaysViewed += 1

                if dailyStreak.currentStreak > dailyStreak.longestStreak {
                    dailyStreak.longestStreak = dailyStreak.currentStreak
                }
            } else {
                // 연속 끊김
                dailyStreak.currentStreak = 1
                dailyStreak.totalDaysViewed += 1
            }
        } else {
            // 처음 시작
            dailyStreak.currentStreak = 1
            dailyStreak.longestStreak = 1
            dailyStreak.totalDaysViewed = 1
        }

        dailyStreak.lastViewDate = today
        saveDailyStreak()
        checkAchievements()
    }

    private func saveDailyStreak() {
        if let encoded = try? JSONEncoder().encode(dailyStreak) {
            userDefaults.set(encoded, forKey: dailyStreakKey)
            userDefaults.synchronize()
        }
    }

    // MARK: - Achievement Management
    private func checkAchievements() {
        var updated = false

        for index in achievements.indices {
            if !achievements[index].isUnlocked {
                let achievement = achievements[index]

                if achievement.id.starts(with: "streak_") {
                    if dailyStreak.currentStreak >= achievement.requirement {
                        achievements[index].isUnlocked = true
                        achievements[index].unlockedDate = Date()
                        updated = true
                    }
                } else if achievement.id.starts(with: "total_") {
                    if dailyStreak.totalDaysViewed >= achievement.requirement {
                        achievements[index].isUnlocked = true
                        achievements[index].unlockedDate = Date()
                        updated = true
                    }
                }
            }
        }

        if updated {
            saveAchievements()
        }
    }

    private func saveAchievements() {
        if let encoded = try? JSONEncoder().encode(achievements) {
            userDefaults.set(encoded, forKey: achievementsKey)
            userDefaults.synchronize()
        }
    }

    func getUnlockedSpecialQuotes() -> [String] {
        var specialQuotes: [String] = []
        for achievement in achievements where achievement.isUnlocked {
            specialQuotes.append(contentsOf: achievement.specialQuotes)
        }
        return specialQuotes
    }

    // MARK: - Personalized Recommendations
    func getRecommendedQuotes(from allQuotes: [Quote]) -> [Quote] {
        // 좋아요 많이 받은 카테고리 파악
        var categoryLikes: [String: Int] = [:]

        for feedback in quoteFeedbacks.values where feedback.isLiked {
            // 해당 주접의 카테고리 찾기
            if let quote = allQuotes.first(where: { $0.text == feedback.quoteText }) {
                let categoryName = quote.category.rawValue
                categoryLikes[categoryName, default: 0] += 1
            }
        }

        // 가장 좋아하는 카테고리 찾기
        let sortedCategories = categoryLikes.sorted { $0.value > $1.value }

        if let topCategory = sortedCategories.first?.key {
            // 해당 카테고리에서 아직 안 본 주접 추천
            let topCategoryQuotes = allQuotes.filter { $0.category.rawValue == topCategory }
            let unseenQuotes = topCategoryQuotes.filter { quote in
                !quoteHistory.contains(where: { $0.quoteText == quote.text })
            }

            if !unseenQuotes.isEmpty {
                return unseenQuotes
            }
        }

        // 기본: 랜덤 추천
        return allQuotes.shuffled()
    }

    // MARK: - Customize Quote with User Name
    func customizeQuote(_ quoteText: String) -> String {
        if userName.isEmpty {
            return quoteText
        }

        // "당신" -> 사용자 이름으로 변경
        return quoteText.replacingOccurrences(of: "당신", with: userName)
    }
}
