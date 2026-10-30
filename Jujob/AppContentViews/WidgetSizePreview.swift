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
    /// 미리보기가 들어갈 판 크기. 없으면 화면 폭으로 잰다(접힌 화면 · 보통 아이폰, 지금 그대로).
    /// 아이폰 듀오를 펴면 화면 폭이 접힌 선을 넘으므로 결과 쪽 판 크기를 받는다.
    var fitting: CGSize? = nil

    private var width: CGFloat { fitting?.width ?? UIScreen.main.bounds.width }
    /// 가장 큰 미리보기(정사각, 1.2)가 판 높이 안에 들도록 폭과 높이 중 작은 쪽에 맞춘다.
    private var previewSize: CGFloat {
        guard let fitting else { return UIScreen.main.bounds.width/1.1 }
        return min(fitting.width, fitting.height * 1.2)/1.1
    }

    var body: some View {
        TabView {
            WidgetPreview(scale: CGSize(width: 1.7, height: 1.7))
            WidgetPreview(scale: CGSize(width: 1.0, height: 1.8))
            WidgetPreview(scale: CGSize(width: 1.2, height: 1.2))
        }
        .frame(width: width)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }

    private func WidgetPreview(scale: CGSize) -> some View {
        WidgetView(entry: QuoteEntry(date: Date(), quote: nil), manager: manager, isPreview: true)
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
