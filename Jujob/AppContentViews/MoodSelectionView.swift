//
//  MoodSelectionView.swift
//  Jujob
//
//  Created by hyunho lee on 2024/11/24.
//

import SwiftUI

struct MoodSelectionView: View {
    @ObservedObject var manager: WidgetManager
    @Environment(\.presentationMode) var presentationMode

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Color(#colorLiteral(red: 0.1350388601, green: 0.1350388601, blue: 0.1350388601, alpha: 1))
                    .edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack(spacing: 20) {
                        HeaderSection

                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(QuoteCategory.allCases) { category in
                                CategoryCard(
                                    category: category,
                                    isSelected: manager.currentQuoteCategory == category
                                ) {
                                    manager.currentQuoteCategory = category
                                    manager.updateCurrentQuote()
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                }
            }
        }
    }

    private var HeaderSection: some View {
        VStack(spacing: 10) {
            Text("오늘 기분이 어때요?")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)

            Text("기분이나 상황에 맞는\n주접을 골라드릴게요!")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
}

struct CategoryCard: View {
    let category: QuoteCategory
    let isSelected: Bool
    let action: () -> Void

    private var categoryEmoji: String {
        switch category {
        case .morning: return "🌅"
        case .evening: return "🌙"
        case .feelingDown: return "😔"
        case .tough: return "💪"
        case .beforeWork: return "💼"
        case .beforeExercise: return "🏃"
        case .commute: return "🚶"
        case .afterWork: return "🏠"
        case .beforeExam: return "📝"
        case .beforeInterview: return "👔"
        case .beforeDate: return "💕"
        case .motivation: return "🔥"
        case .confidence: return "✨"
        case .healing: return "🌿"
        case .random: return "🎲"
        }
    }

    private var categoryColor: Color {
        switch category {
        case .morning: return Color(#colorLiteral(red: 1, green: 0.8, blue: 0.4, alpha: 1))
        case .evening: return Color(#colorLiteral(red: 0.3, green: 0.3, blue: 0.6, alpha: 1))
        case .feelingDown: return Color(#colorLiteral(red: 0.6, green: 0.7, blue: 0.9, alpha: 1))
        case .tough: return Color(#colorLiteral(red: 0.9, green: 0.4, blue: 0.4, alpha: 1))
        case .beforeWork: return Color(#colorLiteral(red: 0.5, green: 0.6, blue: 0.8, alpha: 1))
        case .beforeExercise: return Color(#colorLiteral(red: 0.4, green: 0.8, blue: 0.4, alpha: 1))
        case .commute: return Color(#colorLiteral(red: 0.7, green: 0.7, blue: 0.7, alpha: 1))
        case .afterWork: return Color(#colorLiteral(red: 0.9, green: 0.7, blue: 0.5, alpha: 1))
        case .beforeExam: return Color(#colorLiteral(red: 0.6, green: 0.5, blue: 0.9, alpha: 1))
        case .beforeInterview: return Color(#colorLiteral(red: 0.4, green: 0.6, blue: 0.9, alpha: 1))
        case .beforeDate: return Color(#colorLiteral(red: 1, green: 0.6, blue: 0.7, alpha: 1))
        case .motivation: return Color(#colorLiteral(red: 1, green: 0.5, blue: 0.3, alpha: 1))
        case .confidence: return Color(#colorLiteral(red: 0.9, green: 0.8, blue: 0.3, alpha: 1))
        case .healing: return Color(#colorLiteral(red: 0.5, green: 0.8, blue: 0.7, alpha: 1))
        case .random: return Color(#colorLiteral(red: 0.7, green: 0.5, blue: 0.9, alpha: 1))
        }
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Text(categoryEmoji)
                    .font(.system(size: 40))

                Text(category.displayName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        isSelected
                        ? LinearGradient(
                            colors: [categoryColor, categoryColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        : LinearGradient(
                            colors: [Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)), Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
            )
            .shadow(color: isSelected ? categoryColor.opacity(0.5) : Color.clear, radius: 10, x: 0, y: 5)
        }
    }
}

struct MoodSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        MoodSelectionView(manager: WidgetManager())
    }
}
