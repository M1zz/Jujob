//
//  JujobApp.swift
//  Jujob
//
//  Created by hyunho lee on 2023/07/04.
//

import SwiftUI
import WidgetKit
import LeeoKit

@main
struct JujobApp: App {
    var body: some Scene {
        return WindowGroup {
            MainContentView(manager: WidgetManager())
                // 아이폰 듀오: 창 크기로 접힘을 재서 아래로 흘린다. 시트 · 알림창도 접힌 선을 비킨다 (LeeoKit Fold).
                .foldAware()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    WidgetCenter.shared.reloadAllTimelines()
                }
                // 팁 상품을 불러오고 끝나지 않은 팁을 마저 센다 (LeeoStore 없이 혼자)
                .task { await JujobSpec.tipJar.startStandalone() }
        }
    }
}
