//
//  UserNameSettingView.swift
//  Jujob
//
//  Created by hyunho lee on 2024/11/24.
//

import SwiftUI

struct UserNameSettingView: View {
    @ObservedObject var preferencesManager = UserPreferencesManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var tempName: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color(#colorLiteral(red: 0.1350388601, green: 0.1350388601, blue: 0.1350388601, alpha: 1))
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 30) {
                    HeaderSection

                    InputSection

                    PreviewSection

                    Spacer()

                    SaveButton
                }
                .padding()
            }
            .navigationTitle("이름 설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                    }
                    .accessibilityLabel(Text("닫기"))
                }
            }
            .onAppear {
                tempName = preferencesManager.userName
            }
        }
    }

    private var HeaderSection: some View {
        VStack(spacing: 15) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
                .accessibilityHidden(true)

            Text("이름을 알려주세요!")
                .font(.system(.title2, weight: .bold))
                .accessibilityAddTraits(.isHeader)
                .foregroundColor(.white)

            Text("주접에서 '당신' 대신\n이름을 넣어드릴게요!")
                .font(.system(.callout))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }

    private var InputSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("이름")
                .font(.system(.callout, weight: .semibold))
                .foregroundColor(.white)

            TextField("이름을 입력하세요", text: $tempName)
                .accessibilityLabel(Text("이름"))
                .font(.system(.title3))
                .foregroundColor(.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                )
        }
    }

    private var PreviewSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("미리보기")
                .font(.system(.callout, weight: .semibold))
                .foregroundColor(.white)

            VStack(spacing: 15) {
                PreviewQuote(
                    original: String(localized: "당신은 충분히\n가치 있는 사람이에요!"),
                    customized: preferencesManager.customizeQuote(String(localized: "당신은 충분히\n가치 있는 사람이에요!")),
                    tempName: tempName
                )

                PreviewQuote(
                    original: String(localized: "오늘도 당신답게,\n그게 최고예요!"),
                    customized: preferencesManager.customizeQuote(String(localized: "오늘도 당신답게,\n그게 최고예요!")),
                    tempName: tempName
                )
            }
        }
    }

    private var SaveButton: some View {
        Button(action: {
            preferencesManager.saveUserName(tempName)
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("저장하기")
                .font(.system(.title3, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue)
                )
        }
    }
}

struct PreviewQuote: View {
    let original: String
    let customized: String
    let tempName: String

    private var displayText: String {
        if tempName.isEmpty {
            return original
        } else {
            return original.replacingOccurrences(of: UserPreferencesManager.nameToken, with: tempName)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(displayText)
                .font(.system(.callout))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
        )
    }
}

struct UserNameSettingView_Previews: PreviewProvider {
    static var previews: some View {
        UserNameSettingView()
    }
}
