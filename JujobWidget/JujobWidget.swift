//
//  JujobWidget.swift
//  JujobWidget
//
//  Created by hyunho lee on 2023/07/04.
//

import WidgetKit
import SwiftUI

struct JujobWidget: Widget {
    let kind: String = "JujobWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WidgetView(entry: entry, manager: WidgetManager())
                    .containerBackground(for: .widget) { WidgetBackground(manager: WidgetManager()) }
            } else {
                WidgetView(entry: entry, manager: WidgetManager())
            }
        }
        .configurationDisplayName("주접 위젯")
        .description("매일 매일 나를 사랑해요")
    }
}

struct JujobWidget_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 17.0, *) {
            WidgetView(entry: QuoteEntry(date: Date(), quote: nil), manager: WidgetManager())
                .containerBackground(for: .widget) { WidgetBackground(manager: WidgetManager()) }
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        } else {
            WidgetView(entry: QuoteEntry(date: Date(), quote: nil), manager: WidgetManager())
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
