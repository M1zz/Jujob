//
//  JujobTipJar.swift
//  Jujob
//
//  앱의 계약(JujobSpec), 개발자 응원하기(팁), 백업 금고.
//

import SwiftUI
import LeeoKit

/// ⚠️ 여기서 bootstrap · 피드백 · 분석을 켜지 않는다 — 계약을 채우는 값일 뿐이다.
/// 도는 것은 백업 금고(`LeeoVault.start`), 팁, Pro(`JujobPro`) 셋이다 (→ JujobApp).
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
    /// **주접은 전부 무료, 위젯을 내 홈 화면에 어울리게 꾸미는 것은 Pro.**
    ///
    /// 무료 · Pro 두 칸. Pro 는 주 · 월 · 연 구독(한 구독 그룹)과 평생, 구독 졸업 평생.
    /// 무엇이 열리는지는 `ProGate`, 상품 ID 는 `ProProduct`, 열려 있는지는 `JujobPro.isOpen` 한 곳에 있다.
    /// 유료 다운로드(₩3,300)였던 1.0.5(빌드 5)까지 받은 사람은 Pro 평생이다(`JujobPro.lastPaidBuild`).
    static let monetization = LeeoMonetization.freemiumSubscription(
        LeeoSubscriptionConfig(
            productIDs: ProProduct.all,
            // 자체 약관이 없으므로 애플 표준 사용권 계약(EULA)을 건다.
            termsURL: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!,
            gate: LeeoGatePolicy(proOnly: Set(ProGate.allCases.map(\.rawValue))),
            cacheSuiteName: "group.com.leeo.JuJob"))

    /// 백업 금고가 함께 떠 두는 공유 저장소 (위젯과 나누는 설정 · 기록).
    static let appGroups = ["group.com.leeo.JuJob"]
    /// 고마운 사람이 조금 더 내고 싶을 때 내는 곳. 소모성 상품 셋, 작은 것부터.
    /// Pro 의 LeeoStore 와 따로 혼자 받는다 — 지금까지 센 팁이 이 기기의 기본 저장소에 있다.
    /// ⚠️ 기능을 여는 상품이 아니다 — `ProProduct` 에 넣지 않는다.
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
                                Button { showTipJar = false } label: { Label("닫기", systemImage: "xmark") }
                            }
                        }
                }
            }
        }
    }
}

/// '개발자에게 문의' 묶음에 서는 백업 및 복원 줄. 응원하기 줄처럼 시트로 연다.
struct JujobVaultRow: View {
    @State private var showVault = false

    var body: some View {
        VStack(spacing: 20) {
            Divider().background(Color.white)
            Button {
                showVault = true
            } label: {
                HStack {
                    Image(systemName: "externaldrive.badge.timemachine")
                        .font(.system(size: 18))
                        .foregroundColor(.green)
                        .frame(width: 28)
                    Text(LeeoVaultText.entry)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
        }
        .sheet(isPresented: $showVault) {
            NavigationStack {
                LeeoVaultView(appName: JujobSpec.displayName)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button { showVault = false } label: { Label("닫기", systemImage: "xmark") }
                        }
                    }
            }
        }
    }
}
