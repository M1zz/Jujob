//
//  JujobTipJar.swift
//  Jujob
//
//  개발자 응원하기(팁). LeeoKit 은 이 화면에만 쓴다.
//

import SwiftUI
import LeeoKit

/// ⚠️ 여기서 bootstrap · 피드백 · 분석을 켜지 않는다 — 계약을 채우는 값일 뿐 아무것도 돌지 않는다.
enum JujobSpec: LeeoAppSpec {
    static let appName = "오늘의 주접"
    static let developerEmail = "leeo@kakao.com"
    static let feedback = LeeoFeedbackConfig(
        containerIdentifier: "iCloud.com.Ysoup.FeedbackHub",
        appIdentifier: "com.leeo.JuJob"
    )
    static let legal = LeeoLegalConfig(
        privacyURL: URL(string: "https://m1zz.github.io/Jujob/ko/privacy.html")!,
        supportURL: URL(string: "https://m1zz.github.io/Jujob/ko/support.html")!
    )
    static let monetization = LeeoMonetization.paidUpfront

    /// 고마운 사람이 조금 더 내고 싶을 때 내는 곳. 소모성 상품 셋, 작은 것부터. 기능을 열지 않는다.
    @MainActor static let tipJar = LeeoTipJar(config: LeeoTipJarConfig(productIDs: [
        "com.leeo.JuJob.tip.small",
        "com.leeo.JuJob.tip.medium",
        "com.leeo.JuJob.tip.large",
    ]))
}

/// 팁을 부탁할 만한 순간 — 주접을 받은 날 수. 그날 처음 볼 때 하루씩 는다(`DailyStreak.totalDaysViewed`).
enum JujobTipMoments {
    /// 주접을 받은 날 수. 큰 것부터.
    static let days = [100, 30, 7]

    /// 넘어선 순간, 인상적인 것부터.
    static func reached(daysViewed count: Int) -> [LeeoTipMoment] {
        days.filter { count >= $0 }.map { threshold in
            LeeoTipMoment(id: "days.\(threshold)",
                          message: String(localized: "지금까지 \(count)일 동안 주접을 받았어요",
                                          comment: "Tip ask card: on how many days the person has received their daily compliment"))
        }
    }
}

/// '개발자에게 문의' 묶음에 서는 응원하기 줄. 이 화면에는 내비게이션이 없어 시트로 연다.
/// 판매 중인 팁이 있어야 선다.
struct JujobTipJarRow: View {
    @ObservedObject private var tipJar = JujobSpec.tipJar
    @State private var showTipJar = false

    var body: some View {
        if tipJar.isAvailable {
            VStack(spacing: 20) {
                Divider().background(Color.white)
                Button {
                    showTipJar = true
                } label: {
                    HStack {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.orange)
                            .frame(width: 28)
                        Text(LeeoTipText.entry)
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                }
            }
            .sheet(isPresented: $showTipJar) {
                NavigationStack {
                    LeeoTipJarView<JujobSpec>(tipJar: tipJar)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("닫기") { showTipJar = false }
                            }
                        }
                }
            }
        }
    }
}
