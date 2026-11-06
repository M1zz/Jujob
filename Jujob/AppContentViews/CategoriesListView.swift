//
//  CategoriesListView.swift
//  Quotes
//
//  Created by Apps4World on 10/10/20.
//

import SwiftUI

/// Shows a list of quote categories
struct CategoriesListView: View {
    @ObservedObject var manager: WidgetManager
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                Spacer(minLength: 20)
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(0..<categories.count, id: \.self, content: { row in
                        HStack(spacing: 20) {
                            ForEach(0..<categories[row].count, id: \.self, content: { item in
                                CategoryView(row: row, item: item)
                            })
                        }
                    })
                    Spacer(minLength: 80)
                }
                .padding(5)
            }
            .navigationTitle("Select a category")
        }
    }
    
    private var categories: [[String]] {
        manager.categories2DArray(QuoteCategory.allCases.compactMap({ $0.rawValue }))
    }
    
    private func CategoryView(row: Int, item: Int) -> some View {
        let tileWidth = UIScreen.main.bounds.width / 2
        return ZStack {
            Color(#colorLiteral(red: 0.8759310233, green: 0.8759310233, blue: 0.8759310233, alpha: 1))
            GeometryReader { _ in
                Image(uiImage: UIImage(named: categories[row][item])!)
                    .resizable().aspectRatio(contentMode: .fill)
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.9), Color.black.opacity(0), Color.black.opacity(0)]), startPoint: .bottom, endPoint: .top).layoutPriority(1)
            }
            VStack {
                Spacer()
                Text(QuoteCategory(rawValue: categories[row][item])?.displayName ?? categories[row][item]).foregroundColor(.white).bold().padding()
            }
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: manager.currentQuoteCategory.rawValue != categories[row][item] ? "circle" : "largecircle.fill.circle")
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 25).background(Circle().foregroundColor(.white))
                }
                Spacer()
            }
            .padding(10)
        }
        .frame(width: tileWidth/1.2, height: tileWidth)
        .contentShape(Rectangle())
        .clipped().cornerRadius(20)
        .onTapGesture(perform: {
            manager.currentQuoteCategory = QuoteCategory(rawValue: categories[row][item])!
            manager.updateCurrentQuote()
            presentation.wrappedValue.dismiss()
        })
    }
}

// MARK: - Render preview UI
struct CategoriesListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesListView(manager: WidgetManager())
    }
}
