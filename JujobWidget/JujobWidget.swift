//
//  JujobWidget.swift
//  JujobWidget
//
//  Created by hyunho lee on 2023/07/04.
//

import WidgetKit
import SwiftUI



struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct JujobWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

struct JujobWidget: Widget {
    let kind: String = "JujobWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            JujobWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct JujobWidget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView(entry: QuoteEntry(date: Date(), quote: nil), manager: WidgetManager())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
