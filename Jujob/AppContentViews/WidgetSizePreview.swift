//
//  WidgetSizePreview.swift
//  Quotes
//
//  Created by Apps4World on 10/10/20.
//

import SwiftUI

/// Tab view to preview all 3 widget sizes
struct WidgetSizePreview: View {
    @ObservedObject var manager: WidgetManager
    private let previewSize = UIScreen.main.bounds.width/1.1

    var body: some View {
        TabView {
            WidgetPreview(scale: CGSize(width: 1.7, height: 1.7))
            WidgetPreview(scale: CGSize(width: 1.0, height: 1.8))
            WidgetPreview(scale: CGSize(width: 1.2, height: 1.2))
        }
        .frame(width: UIScreen.main.bounds.width, height: previewSize/1.2)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
    
    private func WidgetPreview(scale: CGSize) -> some View {
        WidgetView(entry: QuoteEntry(date: Date(), quote: nil), manager: manager)
            .cornerRadius(30).padding(20)
            .frame(width: previewSize/scale.width, height: previewSize/scale.height)
            .contentShape(Rectangle()).shadow(radius: 10)
    }
}

// MARK: - Render preview UI
struct WidgetSizePreview_Previews: PreviewProvider {
    static var previews: some View {
        WidgetSizePreview(manager: WidgetManager())
    }
}
