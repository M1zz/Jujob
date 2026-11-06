//
//  JujobPro.swift
//  Jujob
//
//  오늘의 주접 Pro — 무료 · Pro 두 칸. **속은 전부 LeeoKit 의 `LeeoStore` 다.**
//
//  주접 281개, 기분 선택, 이름 넣기, 즐겨찾기 · 히스토리, 연속 기록 · 업적, 위젯 세 크기는 끝까지 무료다.
//  위젯을 내 홈 화면에 어울리게 꾸미는 것(글꼴 13종 · 배경 이미지 · 배경 색 · 글자 색 · 행간)만 Pro 다.
//
//  이 파일이 정하는 것:
//   · 상품 ID (`ProProduct`) — App Store Connect · Products.storekit 과 같아야 한다.
//   · 지금 열려 있는가 (`JujobPro.isOpen`) — 위젯에도 App Group 으로 같은 답을 비춘다.
//   · 페이월을 띄울 순간 (`ProMoment`)
//
//  ⚠️ 상품 로드 · 구매 · 복원 · 거래 리스너(다른 기기, 가족 공유, 환불, 만료)는 LeeoStore 안에 있다.
//     여기서 StoreKit 을 직접 쥐지 않는다.
//

import Foundation
import Combine
import StoreKit
import SwiftUI
import WidgetKit
import LeeoKit

// MARK: - 상품

/// App Store Connect · Products.storekit 과의 계약 — 한 번 정하면 바꾸지 않는다.
/// 주 · 월 · 연 구독은 구독 그룹 "Daily Hype Pro" 하나에 둔다.
enum ProProduct {
    private static let base = "com.leeo.JuJob.pro"
    static let weekly   = base + ".weekly"
    static let monthly  = base + ".monthly"
    static let yearly   = base + ".yearly"
    static let lifetime = base + ".lifetime"
    /// 구독 졸업 — 구독 중인 사람에게만 보이는 평생가.
    static let graduate = base + ".graduate"

    static let subscriptions: Set<String> = [weekly, monthly, yearly]
    static let lifetimes: Set<String> = [lifetime, graduate]

    /// 불러올 순서. 팁 상품은 여기 넣지 않는다 — 팁은 아무것도 열지 않는다.
    static let all: [String] = [yearly, lifetime, monthly, weekly, graduate]
}

/// Pro 에서만 열리는 것 (계약의 게이트 선언과 같은 이름).
enum ProGate: String, CaseIterable {
    case fonts, backgroundImage, colors, lineSpacing
}

// MARK: - 페이월을 띄울 순간

/// 어디서 페이월이 떴는가. 머리 한 줄 · 미리보기 · 비교표 강조 · 기본으로 고를 길이 여기서 정해진다.
enum ProMoment: Hashable {
    /// 글꼴 목록에서 잠긴 글꼴을 눌렀다. 미리보기를 그 글꼴로 그린다.
    case font(String)
    /// 배경 이미지를 눌렀다.
    case backgroundImage
    /// 배경 색 · 글자 색을 바꾸려 했다.
    case colors
    /// 행간을 움직이려 했다.
    case lineSpacing
    /// 7일 연속 기록이 열린 날, 나의 기록의 작은 카드에서.
    case streak
    /// 위젯 꾸미기 아래 '오늘의 주접 Pro' 줄.
    case settings

    /// 비교표에서 강조할 줄.
    var gate: ProGate? {
        switch self {
        case .font: .fonts
        case .backgroundImage: .backgroundImage
        case .colors: .colors
        case .lineSpacing: .lineSpacing
        case .streak, .settings: nil
        }
    }

    /// 매일 챙겨 보는 습관이 된 날은 평생이 맞고, 나머지는 연 구독부터 보인다.
    var defaultTerm: LeeoPlanTerm { self == .streak ? .lifetime : .yearly }
}

// MARK: - 권한

@MainActor
final class JujobPro: ObservableObject {

    static let shared = JujobPro()

    let store: LeeoStore

    /// 산 것 · 구독 중인 것 · 무료 전환 전에 산 사람.
    @Published private(set) var hasPro = false
    /// 꾸밈을 지금 써도 되는가. 아직 팔지 않는 기기에서는 막지 않는다.
    @Published private(set) var isOpen = true
    @Published private(set) var products: [Product] = []
    @Published private(set) var ownedProductIDs: Set<String> = []
    /// 지금 살아 있는 구독. 있으면 '평생으로 바꾸기' 가 선다.
    @Published private(set) var subscription: LeeoGraduation.Subscription?
    @Published private(set) var isWorking = false
    /// 사다가 막혔을 때 화면에 그대로 보여 줄 말.
    @Published private(set) var failureMessage: String?

    /// 페이월을 띄워 달라는 부탁. 본 화면(MainContentView)이 받아 시트로 띄운다 —
    /// 글꼴 목록 같은 다른 시트에서 불러도 그 시트를 페이월로 바꿔 띄운다.
    let paywallRequests = PassthroughSubject<ProMoment, Never>()
    /// 구독 졸업 제안을 띄울 차례.
    let graduationRequests = PassthroughSubject<Void, Never>()

    /// **이 기기가 스토어에서 Pro 상품을 한 번이라도 불러왔는가.**
    ///
    /// 상품을 App Store Connect 에 만들기 전에 빌드가 나가면 아무도 살 수 없다. 그때 막으면
    /// 사지도 못하고 막히기만 한다. 그래서 한 번도 못 불러온 기기는 막지 않는다.
    /// 한 번 불러온 기기는 그 뒤 잠깐 네트워크가 끊겨도 다시 막는다(살 수 있는 상품이 있다는 걸 안다).
    private(set) var sellsPro: Bool

    /// 무료 전환 전(1.0.5 빌드 5까지)에 돈을 내고 받은 사람. 한 번 true 면 바뀌지 않는다.
    private(set) var boughtBeforeFree: Bool

    private let defaults = UserDefaults.standard
    private var observation: AnyCancellable?

    private static let sellsProKey = "pro.sellsPro"
    private static let legacyKey = "pro.boughtBeforeFree"

    private init() {
        guard let config = JujobSpec.paywall else {
            preconditionFailure("계약에 페이월이 없다. JujobSpec.monetization 을 확인할 것")
        }
        sellsPro = defaults.bool(forKey: Self.sellsProKey)
        boughtBeforeFree = defaults.bool(forKey: Self.legacyKey)
        store = LeeoStore(config: config)
        // ⚠️ objectWillChange 는 값이 바뀌기 **직전**에 온다. 다음 차례로 미뤄서 읽는다.
        observation = store.objectWillChange.sink { [weak self] _ in
            Task { @MainActor in self?.pull() }
        }
        pull()
    }

    /// 평생 Pro(평생 · 구독 졸업)를 가졌는가.
    var ownsLifetime: Bool { !ownedProductIDs.isDisjoint(with: ProProduct.lifetimes) }

    func product(_ id: String) -> Product? { products.first { $0.id == id } }

    // MARK: 페이월 띄우기

    /// 막힌 자리에서 페이월을 띄운다.
    func present(_ moment: ProMoment) {
        paywallRequests.send(moment)
    }

    // MARK: 상태 맞추기

    /// 영수증을 다시 읽고 상품을 불러온다. 앱이 켜질 때와 다시 앞에 올 때마다 부른다.
    ///
    /// ⚠️ 순서가 중요하다. 산 사람인지 **먼저** 알아본 뒤에 상품을 불러온다.
    ///    거꾸로 하면 상품이 보인 순간 잠깐 막혀서, 이미 꾸며 둔 위젯이 한 번 기본 모양으로 돌아갔다 온다.
    func refresh() async {
        if !boughtBeforeFree, await Self.checkBoughtBeforeFree() {
            boughtBeforeFree = true
            defaults.set(true, forKey: Self.legacyKey)
        }
        await store.refreshEntitlements()
        await store.loadProducts()
        subscription = await LeeoGraduation.currentSubscription(among: ProProduct.subscriptions)
        pull()
        if graduationIsDue { graduationRequests.send() }
    }

    func loadProducts() async {
        await store.loadProducts()
        pull()
    }

    /// **구독 졸업을 제안할 때인가.** 6개월째와 갱신 7일 전에 한 번씩 (→ LeeoGraduation).
    /// 이미 평생을 가졌으면 제안하지 않는다. 띄운 쪽이 `markGraduationOffered()` 를 부른다.
    var graduationIsDue: Bool {
        guard let subscription, !ownsLifetime, product(ProProduct.graduate) != nil else { return false }
        return LeeoGraduation.isDue(subscription, lastOffered: LeeoGraduation.lastOffered())
    }

    func markGraduationOffered() { LeeoGraduation.markOffered() }

    // MARK: 사기 / 되찾기

    /// ⚠️ `action` 은 페이월의 `@Environment(\.purchase)` 다. 결제 시트가 이 창에 뜬다
    ///    (아이패드에서 엉뚱한 창에 뜨면 결제가 오류로 끝난다).
    func purchase(_ product: Product, using action: PurchaseAction) async {
        _ = await store.purchase(product) { try await action($0) }
        subscription = await LeeoGraduation.currentSubscription(among: ProProduct.subscriptions)
        pull()
    }

    /// 기기를 바꿨거나 앱을 지웠다 받은 사람이 되찾는 길. 심사에서도 요구한다.
    func restore() async {
        await store.restore()
        subscription = await LeeoGraduation.currentSubscription(among: ProProduct.subscriptions)
        pull()
        if !hasPro, failureMessage == nil {
            failureMessage = String(localized: "이 Apple 계정에서 구매한 기록을 찾지 못했어요.",
                                    comment: "Restore purchases: nothing found")
        }
    }

    /// 구독 졸업을 산 뒤 권한을 다시 읽는다.
    func refreshEntitlements() async {
        await store.refreshEntitlements()
        subscription = await LeeoGraduation.currentSubscription(among: ProProduct.subscriptions)
        pull()
    }

    // MARK: -

    private func pull() {
        hasPro = boughtBeforeFree || store.hasPro
        products = store.products
        ownedProductIDs = store.purchasedProductIDs
        isWorking = store.purchasingProductID != nil || store.isRestoring
        failureMessage = store.lastError
        // 팔 수 있는 Pro 상품이 하나라도 보였으면 그때부터 막는다.
        if !sellsPro, products.contains(where: { ProProduct.all.contains($0.id) }) {
            sellsPro = true
            defaults.set(true, forKey: Self.sellsProKey)
        }
        let open = !sellsPro || hasPro
        if isOpen != open { isOpen = open }
        mirrorToWidgets()
    }

    /// 위젯은 앱 밖에서 돈다. 같은 답을 App Group 에 적고, 바뀌었을 때만 위젯을 다시 그린다.
    private func mirrorToWidgets() {
        let shared = UserDefaults(suiteName: AppConfig.appGroupId)
        guard shared?.object(forKey: WidgetManager.styleOpenKey) as? Bool != isOpen else { return }
        shared?.set(isOpen, forKey: WidgetManager.styleOpenKey)
        WidgetCenter.shared.reloadAllTimelines()
    }

    // MARK: - 무료 전환 전에 산 사람

    /// 유료 다운로드(₩3,300)였던 마지막 빌드(1.0.5 빌드 5). 이 빌드까지 받은 사람은 돈을 내고 받았으므로 Pro 평생이다.
    /// 무료로 바뀐 첫 빌드는 6 이상이어야 한다.
    nonisolated static let lastPaidBuild = 5

    /// App Store 가 서명한 최초 다운로드 빌드로 알아본다. 지웠다 다시 받아도, 기기를 바꿔도 같다.
    /// 시험 환경(Xcode · 샌드박스)은 최초 빌드가 엉뚱하게 오므로 출시 영수증만 믿는다.
    private static func checkBoughtBeforeFree() async -> Bool {
        guard case .verified(let app)? = try? await AppTransaction.shared,
              app.environment == .production else { return false }
        return isPaidBuild(app.originalAppVersion)
    }

    /// `originalAppVersion` 은 iOS 에서 CFBundleVersion(빌드 번호)이다.
    nonisolated static func isPaidBuild(_ originalAppVersion: String) -> Bool {
        guard let build = Int(originalAppVersion.split(separator: ".").first ?? "") else { return false }
        return build <= lastPaidBuild
    }
}
