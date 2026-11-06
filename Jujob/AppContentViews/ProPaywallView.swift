//
//  ProPaywallView.swift
//  Jujob
//
//  오늘의 주접 Pro 를 파는 한 장, 구독 졸업 시트, 위젯 꾸미기 아래의 Pro 칸, 잠긴 꾸밈 줄.
//
//  **무료인 것을 먼저 말한다.** 비교표의 위 여섯 줄은 무료 · Pro 모두 ✓ 다. 이 화면은
//  "안 사면 못 쓴다"가 아니라 "주접은 전부 무료이고, 위젯을 내 홈 화면에 맞게 꾸미는 것만 값을 받는다"는 말이다.
//
//  고르는 길: 연 구독(기본) · 평생, 펼치면 주 · 월. 첫 해 할인(App Store 첫 구독 할인)과
//  "연 구독 N년치" 한 줄은 `LeeoTermPicker` 가 알아서 보인다.
//  스토어에서 불러온 상품만 단추가 된다 — 아직 없는 상품은 서지 않는다.
//

import SwiftUI
import StoreKit
import LeeoKit

struct ProPaywallView: View {
    let moment: ProMoment

    @ObservedObject private var pro = JujobPro.shared
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    /// 결제 시트를 **이 페이월이 떠 있는 창**에 띄운다.
    @Environment(\.purchase) private var purchaseAction

    @State private var term: LeeoPlanTerm
    /// 펼쳐서 고른 주 · 월 구독. 고르면 연 / 평생 대신 이것을 산다.
    @State private var shortPlanID: String?
    @State private var loadingProducts = true

    init(moment: ProMoment) {
        self.moment = moment
        _term = State(initialValue: moment.defaultTerm)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    comparison
                    if pro.hasPro {
                        Label("오늘의 주접 Pro를 쓰고 있어요. 고마워요.", systemImage: "checkmark.seal.fill")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(.orange)
                    } else {
                        plans
                    }
                    if let message = pro.failureMessage, !pro.products.isEmpty {
                        Label(message, systemImage: "exclamationmark.triangle")
                            .font(.body)
                            .foregroundStyle(.orange)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    legal
                }
                .padding(24)
                .frame(maxWidth: 640)
                .frame(maxWidth: .infinity)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("오늘의 주접 Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("나중에", systemImage: "xmark") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("구매 복원") {
                        Task {
                            await pro.restore()
                            if pro.hasPro { dismiss() }
                        }
                    }
                    .disabled(pro.isWorking)
                }
            }
            .task { await loadPlans() }
        }
        .tint(.orange)
    }

    // MARK: 머리

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let lead = momentLead {
                Text(lead)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.orange)
                    .fixedSize(horizontal: false, vertical: true)
            }
            ProPreviewCard(moment: moment)
            Text("오늘의 주접 Pro")
                .font(.largeTitle.bold())
                .accessibilityAddTraits(.isHeader)
            Text("내 홈 화면에 어울리는 주접 위젯으로. 연 구독이나 평생 중에 고르세요.")
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    /// 막혀서 들어왔으면 무엇이 막혔는지, 쌓아 온 것이 있으면 그것을 먼저 말한다.
    private var momentLead: String? {
        switch moment {
        case .font:
            String(localized: "이 글꼴은 Pro에서 쓸 수 있어요.", comment: "Paywall lead: tapped a locked font in the font list")
        case .backgroundImage:
            String(localized: "배경 이미지는 Pro에서 고를 수 있어요.", comment: "Paywall lead: tapped the background image picker")
        case .colors:
            String(localized: "배경 색과 글자 색은 Pro에서 직접 고를 수 있어요.", comment: "Paywall lead: tried to change the widget background or text color")
        case .lineSpacing:
            String(localized: "행간 조절은 Pro에서 열려요.", comment: "Paywall lead: tried to change the widget line spacing")
        case .streak:
            String(localized: "7일 연속으로 주접을 받았어요. 오래 둘 위젯, 한 번에 꾸며 두세요.", comment: "Paywall lead: opened from the card shown on the day the 7-day streak achievement unlocks")
        case .settings:
            nil
        }
    }

    // MARK: 비교표

    private var comparison: some View {
        Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 10) {
            GridRow {
                Text("기능")
                Text("무료").gridColumnAlignment(.center)
                Text(verbatim: "Pro").gridColumnAlignment(.center)
            }
            .font(.body.weight(.semibold))
            .foregroundStyle(.secondary)
            .accessibilityHidden(true)
            Divider()
            freeRow("주접 위젯")
            freeRow("주접 281개 · 기분 선택")
            freeRow("이름 넣기")
            freeRow("즐겨찾기 · 히스토리")
            freeRow("연속 기록 · 업적")
            freeRow("정렬 · 새로고침 주기")
            proRow("글꼴", gate: .fonts, free: Text("3종"), pro: Text("13종"))
            proRow("배경 이미지", gate: .backgroundImage)
            proRow("배경 색 · 글자 색", gate: .colors, free: Text("기본 색"), pro: Text("직접 고르기"))
            proRow("행간", gate: .lineSpacing)
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func freeRow(_ title: LocalizedStringKey) -> some View {
        GridRow {
            Text(title).fixedSize(horizontal: false, vertical: true)
            check
            check
        }
        .font(.body)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(title))
        .accessibilityValue(Text("무료"))
    }

    /// Pro 줄. 칸에 글(3종 · 13종 같은)이 없으면 무료는 –, Pro 는 ✓.
    private func proRow(_ title: LocalizedStringKey, gate: ProGate, free: Text? = nil, pro: Text? = nil) -> some View {
        let highlighted = gate == moment.gate
        return GridRow {
            Text(title).fixedSize(horizontal: false, vertical: true)
            Group {
                if let free {
                    free.foregroundStyle(.secondary)
                } else {
                    Image(systemName: "minus").foregroundStyle(.secondary)
                }
            }
            .frame(minWidth: 44)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            Group {
                if let pro {
                    pro.foregroundStyle(.orange)
                } else {
                    check
                }
            }
            .frame(minWidth: 44)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
        }
        .font(.body.weight(highlighted ? .semibold : .regular))
        .foregroundStyle(highlighted ? Color.orange : .primary)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(title))
        .accessibilityValue(Text("Pro에서 열려요"))
    }

    private var check: some View {
        Image(systemName: "checkmark")
            .font(.body.weight(.bold))
            .foregroundStyle(.orange)
            .frame(minWidth: 44)
    }

    // MARK: 요금제

    @ViewBuilder
    private var plans: some View {
        let yearly = pro.product(ProProduct.yearly)
        let lifetime = pro.product(ProProduct.lifetime)
        if yearly == nil && lifetime == nil {
            plansStatus
        } else {
            VStack(alignment: .leading, spacing: 12) {
                LeeoTermPicker(term: Binding(get: { term }, set: { term = $0; shortPlanID = nil }),
                               yearly: yearly, lifetime: lifetime)
                    .opacity(shortPlanID == nil ? 1 : 0.5)
                shortPlans
                buyButton
            }
        }
    }

    /// 주 · 월 구독. 연 구독이 기본이라 펼쳐야 보인다. 불러온 상품만 줄이 선다.
    @ViewBuilder
    private var shortPlans: some View {
        let short = [pro.product(ProProduct.monthly), pro.product(ProProduct.weekly)].compactMap { $0 }
        if !short.isEmpty {
            DisclosureGroup("주 · 월 구독 보기") {
                VStack(spacing: 4) {
                    ForEach(short, id: \.id) { shortPlanRow($0) }
                }
                .padding(.top, 6)
            }
            .font(.body)
        }
    }

    private func shortPlanRow(_ product: Product) -> some View {
        let selected = shortPlanID == product.id
        let title = product.id == ProProduct.weekly
            ? String(localized: "주 구독 · \(product.displayPrice) / 주", comment: "Paywall: weekly plan row. %@ = price")
            : String(localized: "월 구독 · \(product.displayPrice) / 월", comment: "Paywall: monthly plan row. %@ = price")
        return Button {
            shortPlanID = selected ? nil : product.id
        } label: {
            HStack {
                Text(title).foregroundStyle(.primary)
                Spacer()
                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(selected ? Color.orange : .secondary)
                    .accessibilityHidden(true)
            }
            .frame(minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(selected ? .isSelected : [])
    }

    /// 지금 고른 상품.
    private var chosen: Product? {
        if let shortPlanID { return pro.product(shortPlanID) }
        return pro.product(term == .yearly ? ProProduct.yearly : ProProduct.lifetime)
    }

    private var buyTitle: String {
        switch shortPlanID {
        case ProProduct.weekly?:  String(localized: "주 구독 시작")
        case ProProduct.monthly?: String(localized: "월 구독 시작")
        default: term == .yearly ? String(localized: "연 구독 시작") : String(localized: "평생으로 사기")
        }
    }

    private var buyButton: some View {
        Button {
            guard let chosen else { return }
            Task {
                await pro.purchase(chosen, using: purchaseAction)
                if pro.hasPro { dismiss() }
            }
        } label: {
            Group {
                if pro.isWorking {
                    ProgressView().tint(.white)
                } else {
                    Text(buyTitle).font(.headline)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 32)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(pro.isWorking || chosen == nil)
    }

    @ViewBuilder
    private var plansStatus: some View {
        if loadingProducts {
            HStack(spacing: 10) {
                ProgressView()
                Text("요금제를 불러오는 중…").font(.body).foregroundStyle(.secondary)
            }
        } else {
            // 한 번 실패하면 죽은 단추로 남지 않게, 그 자리에서 다시 청한다.
            VStack(alignment: .leading, spacing: 10) {
                Text("요금제를 불러오지 못했어요. 인터넷 연결을 확인하고 다시 불러와 주세요.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                Button {
                    Task { await loadPlans() }
                } label: {
                    Label("다시 불러오기", systemImage: "arrow.clockwise").font(.body.weight(.semibold))
                }
                .buttonStyle(.bordered)
            }
        }
    }

    /// 첫 조회가 비어 오면 한 번 더 청한다. 샌드박스(심사 환경)는 첫 조회가 빈손으로 오는 일이 잦다.
    private func loadPlans() async {
        loadingProducts = true
        await pro.loadProducts()
        if pro.products.isEmpty {
            try? await Task.sleep(for: .seconds(1.5))
            await pro.loadProducts()
        }
        loadingProducts = false
    }

    // MARK: 약관 (구독을 파는 앱의 심사 필수 항목)

    private var legal: some View {
        VStack(alignment: .leading, spacing: 10) {
            if pro.products.contains(where: { $0.subscription != nil }) {
                Text("구독은 기간이 끝나기 24시간 전까지 해지하지 않으면 같은 요금으로 자동 갱신되며, Apple 계정으로 결제돼요. 처음 연 구독을 시작하면 첫 해는 할인된 값으로 결제되고, 그 뒤에는 정가로 갱신돼요. 해지와 관리는 App Store 계정 설정에서 할 수 있어요. 평생은 구독이 아니라 한 번 결제예요.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            HStack(spacing: 20) {
                if let terms = JujobSpec.monetization.subscriptionTermsURL {
                    Button("이용약관") { openURL(terms) }
                }
                Button("개인정보 처리방침") { openURL(JujobSpec.legal.privacyURL) }
            }
            .font(.body)
        }
    }
}

// MARK: - 미리보기

/// 사기 전에 무엇이 달라지는지 그림으로 보인다. 오늘의 주접을 차분한 색 · 손글씨 글꼴로 꾸민 작은 위젯.
/// 잠긴 글꼴을 눌러 왔으면 그 글꼴로, 배경 이미지를 눌러 왔으면 첫 배경 이미지로 그린다.
private struct ProPreviewCard: View {
    let moment: ProMoment

    /// 지금 위젯에 걸린 주접 (WidgetManager 가 App Group 에 적어 둔 것).
    private var quote: String {
        UserDefaults(suiteName: AppConfig.appGroupId)?.string(forKey: "currentQuote") ?? QuotesManager.quotes[0].text
    }

    private var font: String {
        if case .font(let name) = moment { return name }
        return "Chalkboard SE"
    }

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                LinearGradient(colors: [Color(red: 0.16, green: 0.2, blue: 0.3), Color(red: 0.36, green: 0.3, blue: 0.42)],
                               startPoint: .top, endPoint: .bottom)
                if moment == .backgroundImage, let image = UIImage(named: "local0") {
                    Image(uiImage: image).resizable().aspectRatio(contentMode: .fill)
                }
                Text(UserPreferencesManager.shared.customizeQuote(quote))
                    .font(.custom(font, size: 17, relativeTo: .body))
                    .foregroundStyle(Color(red: 1, green: 0.93, blue: 0.82))
                    .lineSpacing(6)
                    .minimumScaleFactor(0.4)
                    .padding(14)
            }
            .frame(width: 150, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .shadow(color: .black.opacity(0.15), radius: 8, y: 2)
            .accessibilityHidden(true)
            Text("글꼴 · 배경 · 색 · 행간을 바꿔 홈 화면의 다른 위젯과 어울리게 꾸며요.")
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - 구독 졸업

/// 구독 중인 사람에게 평생으로 옮겨 갈 값을 보인다. 사면 구독 관리 화면으로 해지를 돕는다.
struct ProGraduationSheet: View {
    @ObservedObject private var pro = JujobPro.shared

    var body: some View {
        LeeoGraduationOfferView(graduate: pro.product(ProProduct.graduate)) {
            await pro.refreshEntitlements()
        }
        .task { if pro.product(ProProduct.graduate) == nil { await pro.loadProducts() } }
    }
}

// MARK: - 위젯 꾸미기 아래의 Pro 칸

/// 오늘의 주접 Pro. 무료면 페이월로, 구독 중이면 구독 관리와 '평생으로 바꾸기', 복원은 늘.
/// 본 화면의 다른 칸처럼 어두운 판에 줄을 세운다.
struct ProSettingsSection: View {
    @ObservedObject private var pro = JujobPro.shared
    /// '평생으로 바꾸기' — 본 화면이 구독 졸업 시트를 띄운다.
    let showGraduation: () -> Void
    @State private var showManage = false
    @State private var restoreMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            if !pro.hasPro {
                Button { pro.present(.settings) } label: {
                    row(icon: "sparkles", color: .orange) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("오늘의 주접 Pro").font(.body.weight(.semibold))
                            Text("글꼴 13종 · 배경 이미지 · 배경 색 · 글자 색 · 행간")
                                .font(.body)
                                .foregroundColor(.gray)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            } else if pro.ownsLifetime {
                status("오늘의 주접 Pro 평생 사용 중")
            } else if pro.subscription != nil {
                status("오늘의 주접 Pro 구독 중")
                Divider().background(Color.white)
                Button { showManage = true } label: {
                    row(icon: "creditcard", color: .blue) { Text("구독 관리") }
                }
                Divider().background(Color.white)
                Button(action: showGraduation) {
                    row(icon: "graduationcap", color: .orange) { Text(LeeoLadderText.switchToLifetimeEntry) }
                }
            } else {
                // 유료 다운로드로 산 사람 · 가족 공유로 받은 사람.
                status("오늘의 주접 Pro 사용 중")
            }
            Divider().background(Color.white)
            Button {
                Task {
                    await pro.restore()
                    restoreMessage = pro.hasPro ? nil : pro.failureMessage
                }
            } label: {
                row(icon: "arrow.clockwise", color: .green) { Text("구매 복원") }
            }
            .disabled(pro.isWorking)
            if let restoreMessage {
                Text(restoreMessage)
                    .font(.body)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .foregroundColor(.white)
        .manageSubscriptionsSheet(isPresented: $showManage)
    }

    private func status(_ title: LocalizedStringKey) -> some View {
        HStack {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 18))
                .foregroundColor(.orange)
                .frame(width: 28)
                .accessibilityHidden(true)
            Text(title).font(.body.weight(.semibold))
            Spacer()
        }
    }

    private func row<Label: View>(icon: String, color: Color, @ViewBuilder label: () -> Label) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
                .frame(width: 28)
                .accessibilityHidden(true)
            label()
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.gray)
                .accessibilityHidden(true)
        }
        .contentShape(Rectangle())
    }
}

// MARK: - 잠긴 꾸밈 표시

/// 잠긴 꾸밈 옆에 서는 'Pro' 표시. 읽기 도구는 "Pro에서 열려요" 로 읽는다.
struct ProBadge: View {
    var body: some View {
        Label {
            Text(verbatim: "Pro")
        } icon: {
            Image(systemName: "lock.fill")
        }
        .font(.body.weight(.semibold))
        .foregroundColor(.orange)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Pro에서 열려요"))
    }
}
