//
//  FavoritesView.swift
//  Jujob
//
//  Created by hyunho lee on 2024/11/24.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var preferencesManager = UserPreferencesManager.shared
    @ObservedObject var widgetManager: WidgetManager
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                Color(#colorLiteral(red: 0.1350388601, green: 0.1350388601, blue: 0.1350388601, alpha: 1))
                    .edgesIgnoringSafeArea(.all)

                if preferencesManager.favoriteQuotes.isEmpty {
                    EmptyStateView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(Array(preferencesManager.favoriteQuotes), id: \.self) { quoteText in
                                FavoriteQuoteCard(
                                    quoteText: quoteText,
                                    widgetManager: widgetManager,
                                    preferencesManager: preferencesManager
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("즐겨찾기")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // 즐겨찾기한 주접을 글로 내보내기 · 공유 (무료)
                if !preferencesManager.favoriteQuotes.isEmpty {
                    ToolbarItem(placement: .navigationBarLeading) {
                        ShareLink(item: favoritesText) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.white)
                        }
                        .accessibilityLabel(Text("즐겨찾기 공유"))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                    }
                    .accessibilityLabel(Text("닫기"))
                }
            }
        }
    }

    /// 즐겨찾기한 주접을 한 줄 띄워 이은 글. 이름을 넣었으면 '당신' 대신 그 이름으로.
    private var favoritesText: String {
        preferencesManager.favoriteQuotes.sorted()
            .map { preferencesManager.customizeQuote($0) }
            .joined(separator: "\n\n")
    }

    private var EmptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "star.fill")
                .font(.system(size: 60))
                .foregroundColor(.yellow)
                .accessibilityHidden(true)

            Text("즐겨찾기가 비어있어요")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("마음에 드는 주접을\n별 버튼을 눌러 저장해보세요!")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }
}

struct FavoriteQuoteCard: View {
    let quoteText: String
    @ObservedObject var widgetManager: WidgetManager
    @ObservedObject var preferencesManager: UserPreferencesManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(quoteText)
                .font(.system(.title3))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)

            HStack {
                Spacer()

                Button(action: {
                    // 이 주접으로 설정
                    if let quote = QuotesManager.quotes.first(where: { $0.text == quoteText }) {
                        widgetManager.currentQuote = quote
                    }
                }) {
                    Label("이 주접 사용", systemImage: "checkmark.circle")
                        .font(.system(.subheadline))
                        .foregroundColor(.blue)
                }

                Button(action: {
                    preferencesManager.toggleFavorite(quoteText: quoteText)
                }) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
                .accessibilityLabel(Text("즐겨찾기"))
                .accessibilityAddTraits(.isSelected)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
        )
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(widgetManager: WidgetManager())
    }
}
