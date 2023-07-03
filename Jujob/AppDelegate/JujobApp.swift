//
//  JujobApp.swift
//  Jujob
//
//  Created by hyunho lee on 2023/07/04.
//

import SwiftUI
import WidgetKit

@main
struct JujobApp: App {
    var body: some Scene {
        return WindowGroup {
            MainContentView(manager: WidgetManager())
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    WidgetCenter.shared.reloadAllTimelines()
                }
        }
    }
}
