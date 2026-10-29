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
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    WidgetCenter.shared.reloadAllTimelines()
                }
                // 팁 상품을 불러오고 끝나지 않은 팁을 마저 센다 (LeeoStore 없이 혼자)
                .task { await JujobSpec.tipJar.startStandalone() }
        }
    }
}
