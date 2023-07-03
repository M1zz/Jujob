//
//  QuotesManager.swift
//  Jujob
//
//  Created by hyunho lee on 2023/07/04.
//

import Foundation

/// This is the quote model
struct Quote {
    var text: String
    var category: QuoteCategory
    var author: String = "anonymous"
}

/// This is the list of categories for quotes
enum QuoteCategory: String, CaseIterable, Identifiable {
    case wisdom
    case life
    case love
    case friendship
    case happiness
    var id: Int { hashValue }
}

/// This is the main quotes manager where you will write your own quotes
class QuotesManager {
    
    static let quotes: [Quote] = [
        Quote(text: "완벽하지만 구멍 하나 있네요. \n황홀(hole).", category: .happiness, author: "Leeo"),
        Quote(text: "엠비티아이 검사결과 큐트라며?", category: .happiness, author: "Leeo"),
        Quote(text: "네가 귀엽다고 생각하는 사람 손 들어주세요 하니까 \n지구가 성게 모양이 됐어요.", category: .happiness, author: "Leeo"),
        Quote(text: "너를 음계로 표현하면 레야.. \n도를 지나쳐서 미치기 직전이니까.", category: .happiness, author: "Leeo"),
        Quote(text: "경마장 가면 안 되겠다. \n너무 완벽해서 말이 안 나와.", category: .happiness, author: "Leeo"),
        Quote(text: "너보고 예쁠 때마다 이마를 쳤더니 거북목이 완치됐어.", category: .happiness, author: "Leeo"),
        
        Quote(text: "제가 주유소만 가면 넣는 기름이 있어요. \n바로 온리유.", category: .happiness, author: "Leeo"),
        Quote(text: "너 때문에 비가 올 것 같아. \n심장마비.", category: .happiness, author: "Leeo"),
        Quote(text: "혹시 종교 있으세요. 뭘 믿고 그렇게 예뻐요?", category: .happiness, author: "Leeo"),
        Quote(text: "다 좋은데 뭔가 허전하지 않아? \n명불허전.", category: .happiness, author: "Leeo"),
        Quote(text: "그 짐좀 내려놔요. \n멋짐.", category: .happiness, author: "Leeo"),
        Quote(text: "너한테선 벽이 느껴져. \n완벽.", category: .happiness, author: "Leeo"),
        Quote(text: "비주얼 솔직히 거품 아닌가요? \n언빌리버블.", category: .happiness, author: "Leeo"),
        Quote(text: "너는 영어를 못하는구나. \n하지만 영문 없이도 귀엽다.", category: .happiness, author: "Leeo")
        
        
    ]
}
