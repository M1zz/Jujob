//
//  WidgetView.swift
//  Quotes
//
//  Created by Apps4World on 10/8/20.
//

import SwiftUI
import WidgetKit

/// Main widget view UI
struct WidgetView: View {
    var entry: Provider.Entry
    @ObservedObject var manager: WidgetManager
    var isPreview: Bool = false // 앱 내 프리뷰용 플래그

    var body: some View {
        if #available(iOS 17.0, *), !isPreview {
            // iOS 17+: 실제 위젯에서는 배경을 containerBackground로 처리
            contentView
        } else {
            // iOS 16 이하 또는 앱 내 프리뷰: 기존 방식
            ZStack {
                LinearGradient(gradient: Gradient(colors: manager.selectedBackgroundColor), startPoint: .top, endPoint: .bottom)
                if !manager.backgroundImageName.isEmpty {
                    GeometryReader { _ in
                        Image(uiImage: UIImage(named: manager.backgroundImageName)!)
                            .resizable().aspectRatio(contentMode: .fill)
                    }
                }
                contentView
            }
        }
    }

    /// 위젯의 텍스트 콘텐츠
    private var contentView: some View {
        VStack(alignment: manager.contentAlignment) {
            Spacer()

            Text(entry.quote?.text ?? manager.currentQuote.text)

            if manager.showQuoteAuthor {
                Spacer().frame(height: 10)
                Divider()
                Text("— \(entry.quote?.author ?? manager.currentQuote.author)")
                    .font(.custom(manager.selectedFont, size: manager.textFontSize / 1.5))
            }

            Spacer()
        }
        .multilineTextAlignment(textAlignment)
        .font(.custom(manager.selectedFont, size: manager.textFontSize))
        .foregroundColor(manager.selectedTextColor)
        .lineSpacing(manager.textLineSpacing ?? 0)
        .minimumScaleFactor(0.2)
        .padding()
    }
    
    /// Returns the text alignment based on the overall content alignment
    private var textAlignment: TextAlignment {
        switch manager.contentAlignment {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        default:
            return .center
        }
    }
}

/// Rounded corner shape by providing which corners to be rounded
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// MARK: - Render preview UI
struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 17.0, *) {
            WidgetView(entry: QuoteEntry(date: Date(), quote: nil), manager: WidgetManager())
                .containerBackground(for: .widget) {
                    let manager = WidgetManager()
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: manager.selectedBackgroundColor), startPoint: .top, endPoint: .bottom)
                        if !manager.backgroundImageName.isEmpty {
                            GeometryReader { _ in
                                Image(uiImage: UIImage(named: manager.backgroundImageName)!)
                                    .resizable().aspectRatio(contentMode: .fill)
                            }
                        }
                    }
                }
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        } else {
            WidgetView(entry: QuoteEntry(date: Date(), quote: nil), manager: WidgetManager())
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}

// MARK: - Timeline entry and provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> QuoteEntry {
        QuoteEntry(date: Date(), quote: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> ()) {
        let entry = QuoteEntry(date: Date(), quote: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteEntry>) -> ()) {
        let widgetManager = WidgetManager()
        
        guard let offset = widgetManager.timelineOffset else {
            print("No Timeline Offset found\n\n")
            completion(Timeline(entries: [QuoteEntry(date: Date(), quote: nil)], policy: .atEnd))
            return
        }
        
        var entries: [QuoteEntry] = []
        var currentDate = Date()
        
        /// Create the timeline entries
        for _ in 0..<10 {
            let quote = widgetManager.currentQuote
            currentDate = Calendar.current.date(byAdding: offset.component, value: offset.value, to: currentDate)!
            entries.append(QuoteEntry(date: currentDate, quote: quote))
            widgetManager.loadNextQuote()
            if AppConfig.showScheduledQuotesLogs {
                print("==========\nScheduled Quote:\n\(quote.text)\n\nAt Time:\n\(currentDate)\n==========\n\n\n")
            }
        }
        
        /// Add the default timeline with image placeholders if the timeline failed to build new entries
        if entries.count == 0 {
            entries.append(QuoteEntry(date: Date(), quote: nil))
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct QuoteEntry: TimelineEntry {
    let date: Date
    let quote: Quote?
}
