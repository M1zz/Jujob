//
//  HistoryView.swift
//  Jujob
//
//  Created by hyunho lee on 2024/11/24.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var preferencesManager = UserPreferencesManager.shared
    @ObservedObject var widgetManager: WidgetManager
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                Color(#colorLiteral(red: 0.1350388601, green: 0.1350388601, blue: 0.1350388601, alpha: 1))
                    .edgesIgnoringSafeArea(.all)

                if preferencesManager.quoteHistory.isEmpty {
                    EmptyStateView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(preferencesManager.quoteHistory) { history in
                                HistoryQuoteCard(
                                    history: history,
                                    widgetManager: widgetManager,
                                    preferencesManager: preferencesManager
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("히스토리")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }

    private var EmptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("히스토리가 비어있어요")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("주접을 확인하면\n자동으로 기록돼요!")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }
}

struct HistoryQuoteCard: View {
    let history: QuoteHistory
    @ObservedObject var widgetManager: WidgetManager
    @ObservedObject var preferencesManager: UserPreferencesManager

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter.string(from: history.viewedAt)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(history.category)
                    .font(.system(size: 12))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.blue.opacity(0.3))
                    .cornerRadius(8)
                    .foregroundColor(.white)

                Spacer()

                Text(formattedDate)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }

            Text(history.quoteText)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)

            HStack {
                Spacer()

                Button(action: {
                    // 이 주접으로 설정
                    if let quote = QuotesManager.quotes.first(where: { $0.text == history.quoteText }) {
                        widgetManager.currentQuote = quote
                    }
                }) {
                    Label("이 주접 사용", systemImage: "checkmark.circle")
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                }

                Button(action: {
                    preferencesManager.toggleFavorite(quoteText: history.quoteText)
                }) {
                    Image(systemName: preferencesManager.isFavorite(quoteText: history.quoteText) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
        )
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(widgetManager: WidgetManager())
    }
}
