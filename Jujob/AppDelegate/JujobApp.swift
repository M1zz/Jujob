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
    init() {
        // 백업 금고 — 예약된 복원 적용 · 매일/업데이트 직전 백업. 저장소를 읽기 전에 먼저.
        LeeoVault.start(JujobSpec.self)
    }

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
                // 즐겨찾기한 주접을 Spotlight 에 맞춘다 — 켤 때 한 번, 바꿀 때마다 (→ CheerIntents.swift)
                .onReceive(UserPreferencesManager.shared.$favoriteQuotes) { FavoriteCheerEntity.reindex($0) }
        }
    }
}
