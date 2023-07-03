//
//  TutorialContentView.swift
//  Quotes
//
//  Created by Apps4World on 10/10/20.
//

import SwiftUI

/// Steps for the tutorial screen
enum TutorialStep: String, CaseIterable, Identifiable {
    case stepOne = "1"
    case stepTwo = "2"
    case stepThree = "3"
    
    var id: Int { hashValue }
    
    var description: String {
        switch self {
        case .stepOne:
            return "홈 화면을 길게 눌러 지글 모드로 진입한 후 우측/좌측 상단의 ➕를 탭합니다."
        case .stepTwo:
            return "앱 이름이 나올 때 까지 스크롤 해주세요.\n\"오늘의 주접\""
        case .stepThree:
            return "이제 위젯 크기를 선택하고 \"위젯 추가\" 버튼을 누르기만 하면 됩니다."
        }
    }
}

/// This is the `how to` screen
struct TutorialContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(TutorialStep.allCases) { step in
                    TutorialStepView(step: step)
                }
            }
            .navigationBarTitle(Text("Tutorial"))
        }
    }
    
    private func TutorialStepView(step: TutorialStep) -> some View {
        VStack {
            Text(step.rawValue)
                .font(.system(size: 25)).bold()
                .padding()
                .foregroundColor(.white)
                .background(Circle().foregroundColor(.blue))
            Text(step.description)
                .font(.system(size: 20))
                .padding(30)
                .multilineTextAlignment(.center)
                .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.secondary).opacity(0.15))
        }.padding([.leading, .trailing, .bottom], 22)
    }
}

// MARK: - Render preview UI
struct TutorialContentView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialContentView()
    }
}

/// Get the app name
extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}

