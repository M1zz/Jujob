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
    case morning = "아침"
    case evening = "저녁"
    case feelingDown = "기분다운"
    case tough = "힘들때"
    case beforeWork = "일시작전"
    case beforeExercise = "운동전"
    case commute = "출근길"
    case afterWork = "퇴근길"
    case beforeExam = "시험전"
    case beforeInterview = "면접전"
    case beforeDate = "데이트전"
    case motivation = "동기부여"
    case confidence = "자신감"
    case healing = "힐링"
    case random = "랜덤"

    var id: Int { hashValue }

    var displayName: String {
        return self.rawValue
    }
}

/// This is the main quotes manager where you will write your own quotes
class QuotesManager {

    static let quotes: [Quote] = [
        // 아침용
        Quote(text: "오늘도 빛나는 하루의 시작!\n당신은 이미 충분히 멋져요.", category: .morning),
        Quote(text: "아침 해처럼 빛나는 당신,\n오늘도 최고의 하루 될 거예요!", category: .morning),
        Quote(text: "일어난 것만으로도 대단해요!\n오늘 하루도 화이팅!", category: .morning),
        Quote(text: "당신의 아침은 세상에서\n가장 아름다운 시작이에요.", category: .morning),
        Quote(text: "오늘 하루도 당신이\n주인공이에요!", category: .morning),
        Quote(text: "눈을 뜬 순간부터\n당신은 이미 승리자!", category: .morning),
        Quote(text: "커피보다 달콤한 당신의\n아침 미소!", category: .morning),
        Quote(text: "오늘도 당신답게,\n그게 최고예요!", category: .morning),

        // 저녁용
        Quote(text: "오늘 하루도 고생했어요!\n당신은 정말 대단해요.", category: .evening),
        Quote(text: "하루를 마무리하는 당신의 모습,\n정말 멋져요!", category: .evening),
        Quote(text: "오늘도 최선을 다한 당신,\n자랑스러워요!", category: .evening),
        Quote(text: "피곤하지만 그래도\n오늘 하루 잘 버텼어요!", category: .evening),
        Quote(text: "당신의 하루는 언제나\n가치 있어요.", category: .evening),
        Quote(text: "오늘도 무사히 마쳤다는 것,\n그것만으로 충분해요!", category: .evening),
        Quote(text: "밤하늘의 별처럼\n당신도 빛나요!", category: .evening),

        // 기분 다운됐을 때
        Quote(text: "괜찮아요, 힘든 날도 있는 거예요.\n당신은 충분히 잘하고 있어요.", category: .feelingDown),
        Quote(text: "지금은 힘들어도\n당신은 이겨낼 수 있어요!", category: .feelingDown),
        Quote(text: "완벽하지 않아도 돼요.\n있는 그대로의 당신이 최고예요!", category: .feelingDown),
        Quote(text: "힘들 때는 쉬어가도 돼요.\n당신의 속도로 가면 돼요.", category: .feelingDown),
        Quote(text: "당신은 생각보다\n훨씬 강한 사람이에요!", category: .feelingDown),
        Quote(text: "이 또한 지나갈 거예요.\n당신은 할 수 있어요!", category: .feelingDown),
        Quote(text: "기분이 다운되어도\n당신의 가치는 변하지 않아요!", category: .feelingDown),
        Quote(text: "슬픔도 당신의 일부예요.\n모든 감정을 느껴도 괜찮아요.", category: .feelingDown),

        // 힘들 때
        Quote(text: "지금은 힘들지만,\n당신은 반드시 해낼 거예요!", category: .tough),
        Quote(text: "어려운 순간일수록\n당신의 진가가 드러나요!", category: .tough),
        Quote(text: "포기하지 마세요.\n당신은 충분히 강해요!", category: .tough),
        Quote(text: "힘든 시기를 견디는 당신,\n정말 대단해요!", category: .tough),
        Quote(text: "오늘의 고난은 내일의\n성장 밑거름이에요!", category: .tough),
        Quote(text: "당신은 생각보다\n훨씬 더 많이 견딜 수 있어요!", category: .tough),
        Quote(text: "이 힘든 순간도\n곧 추억이 될 거예요!", category: .tough),

        // 일 시작 전
        Quote(text: "오늘도 당신은 할 수 있어요!\n자신감 있게 시작해봐요!", category: .beforeWork),
        Quote(text: "당신의 능력을 믿어요!\n오늘도 멋진 하루 될 거예요!", category: .beforeWork),
        Quote(text: "준비된 당신,\n이미 성공의 반이에요!", category: .beforeWork),
        Quote(text: "오늘 할 일도\n당신이라면 문제없어요!", category: .beforeWork),
        Quote(text: "당신의 열정이\n오늘을 빛낼 거예요!", category: .beforeWork),
        Quote(text: "파이팅! 오늘도\n당신답게 해내봐요!", category: .beforeWork),
        Quote(text: "일 시작 전 당신의 모습,\n이미 프로페셔널이에요!", category: .beforeWork),

        // 운동 전
        Quote(text: "운동하는 당신,\n이미 멋진 사람이에요!", category: .beforeExercise),
        Quote(text: "오늘도 건강을 챙기는 당신,\n정말 대단해요!", category: .beforeExercise),
        Quote(text: "당신의 몸은\n당신이 가장 잘 알아요!", category: .beforeExercise),
        Quote(text: "운동 시작한 것만으로도\n충분히 자랑스러워요!", category: .beforeExercise),
        Quote(text: "땀 흘리는 당신의 모습,\n정말 아름다워요!", category: .beforeExercise),
        Quote(text: "당신의 건강이\n가장 중요해요!", category: .beforeExercise),
        Quote(text: "오늘도 자신을 위해\n시간을 내는 당신, 최고!", category: .beforeExercise),

        // 출근길
        Quote(text: "출근길 당신의 모습,\n정말 프로페셔널해요!", category: .commute),
        Quote(text: "아침부터 움직이는 당신,\n정말 대단해요!", category: .commute),
        Quote(text: "오늘도 출근하는 당신,\n이미 승리자예요!", category: .commute),
        Quote(text: "당신의 발걸음 하나하나가\n가치 있어요!", category: .commute),
        Quote(text: "출근길도 당신이 함께라면\n특별해요!", category: .commute),
        Quote(text: "오늘도 책임감 있게\n출근하는 당신, 멋져요!", category: .commute),

        // 퇴근길
        Quote(text: "오늘 하루도 고생했어요!\n집에 가서 푹 쉬어요.", category: .afterWork),
        Quote(text: "퇴근하는 당신의 뒷모습,\n정말 멋져요!", category: .afterWork),
        Quote(text: "하루를 마치고 돌아가는 길,\n당신은 최고예요!", category: .afterWork),
        Quote(text: "오늘도 무사히 마쳤어요!\n자랑스러워요!", category: .afterWork),
        Quote(text: "이제 당신만의 시간이에요.\n충분히 쉬세요!", category: .afterWork),
        Quote(text: "퇴근 후 당신을 위한\n시간을 가져요!", category: .afterWork),

        // 시험 전
        Quote(text: "지금까지 준비한 당신,\n충분히 잘할 거예요!", category: .beforeExam),
        Quote(text: "당신의 노력은\n배신하지 않아요!", category: .beforeExam),
        Quote(text: "긴장해도 괜찮아요.\n당신은 이미 준비됐어요!", category: .beforeExam),
        Quote(text: "시험은 당신의 가치를\n결정하지 못해요!", category: .beforeExam),
        Quote(text: "최선을 다한 당신,\n이미 성공이에요!", category: .beforeExam),
        Quote(text: "당신이라면 충분히\n해낼 수 있어요!", category: .beforeExam),
        Quote(text: "깊게 숨 쉬고,\n당신의 실력을 믿어요!", category: .beforeExam),

        // 면접 전
        Quote(text: "당신의 진가를 보여줄\n시간이에요!", category: .beforeInterview),
        Quote(text: "면접관도 당신을 만나서\n행운이에요!", category: .beforeInterview),
        Quote(text: "당신의 경험과 열정이\n빛날 시간이에요!", category: .beforeInterview),
        Quote(text: "긴장해도 괜찮아요.\n당신은 충분히 멋져요!", category: .beforeInterview),
        Quote(text: "자신감 있게!\n당신은 이미 준비됐어요!", category: .beforeInterview),
        Quote(text: "당신의 이야기를\n당당하게 들려주세요!", category: .beforeInterview),
        Quote(text: "면접은 서로를 알아가는 시간,\n편안하게 임해요!", category: .beforeInterview),

        // 데이트 전
        Quote(text: "오늘의 당신,\n정말 빛나요!", category: .beforeDate),
        Quote(text: "그대로의 당신이\n가장 매력적이에요!", category: .beforeDate),
        Quote(text: "당신과 함께하는 사람은\n정말 행운이에요!", category: .beforeDate),
        Quote(text: "자신감 넘치는 당신,\n정말 멋져요!", category: .beforeDate),
        Quote(text: "오늘 당신의 미소가\n최고의 무기예요!", category: .beforeDate),
        Quote(text: "있는 그대로의 당신,\n그게 최고예요!", category: .beforeDate),
        Quote(text: "당신의 매력은\n숨길 수 없어요!", category: .beforeDate),

        // 동기부여
        Quote(text: "당신은 할 수 있어요!\n언제나 응원해요!", category: .motivation),
        Quote(text: "작은 발걸음도\n위대한 여정의 시작이에요!", category: .motivation),
        Quote(text: "포기하지 마세요.\n당신의 꿈은 이루어질 거예요!", category: .motivation),
        Quote(text: "오늘의 노력이\n내일의 성공을 만들어요!", category: .motivation),
        Quote(text: "당신의 열정이\n세상을 바꿀 거예요!", category: .motivation),
        Quote(text: "실패는 성공의 어머니!\n계속 도전해봐요!", category: .motivation),
        Quote(text: "당신의 가능성은\n무한해요!", category: .motivation),
        Quote(text: "오늘 하루도\n최선을 다해봐요!", category: .motivation),

        // 자신감
        Quote(text: "당신은 충분히\n가치 있는 사람이에요!", category: .confidence),
        Quote(text: "있는 그대로의 당신,\n그게 완벽해요!", category: .confidence),
        Quote(text: "당신의 존재 자체가\n이미 특별해요!", category: .confidence),
        Quote(text: "자신감 있게!\n당신은 멋진 사람이에요!", category: .confidence),
        Quote(text: "당신은 생각보다\n훨씬 강해요!", category: .confidence),
        Quote(text: "당신의 개성이\n당신을 빛나게 해요!", category: .confidence),
        Quote(text: "자신을 믿어요.\n당신은 할 수 있어요!", category: .confidence),

        // 힐링
        Quote(text: "오늘은 그냥\n편안하게 쉬어요.", category: .healing),
        Quote(text: "당신에게도\n휴식이 필요해요.", category: .healing),
        Quote(text: "아무것도 안 해도\n괜찮은 하루예요.", category: .healing),
        Quote(text: "당신의 마음이\n가장 중요해요.", category: .healing),
        Quote(text: "천천히, 당신의 속도로\n가면 돼요.", category: .healing),
        Quote(text: "오늘은 당신을 위한\n시간을 가져요.", category: .healing),
        Quote(text: "휴식도 생산적인\n활동이에요!", category: .healing),

        // 랜덤 (기존 주접들 + 새로운 주접)
        Quote(text: "완벽하지만 구멍 하나 있네요.\n황홀(hole).", category: .random, author: "Leeo"),
        Quote(text: "엠비티아이 검사결과\n큐트라며?", category: .random, author: "Leeo"),
        Quote(text: "네가 귀엽다고 생각하는 사람 손 들어주세요 하니까\n지구가 성게 모양이 됐어요.", category: .random, author: "Leeo"),
        Quote(text: "너를 음계로 표현하면 레야..\n도를 지나쳐서 미치기 직전이니까.", category: .random, author: "Leeo"),
        Quote(text: "경마장 가면 안 되겠다.\n너무 완벽해서 말이 안 나와.", category: .random, author: "Leeo"),
        Quote(text: "너보고 예쁠 때마다 이마를 쳤더니\n거북목이 완치됐어.", category: .random, author: "Leeo"),
        Quote(text: "제가 주유소만 가면 넣는 기름이 있어요.\n바로 온리유.", category: .random, author: "Leeo"),
        Quote(text: "너 때문에 비가 올 것 같아.\n심장마비.", category: .random, author: "Leeo"),
        Quote(text: "혹시 종교 있으세요?\n뭘 믿고 그렇게 예뻐요?", category: .random, author: "Leeo"),
        Quote(text: "다 좋은데 뭔가 허전하지 않아?\n명불허전.", category: .random, author: "Leeo"),
        Quote(text: "그 짐좀 내려놔요.\n멋짐.", category: .random, author: "Leeo"),
        Quote(text: "너한테선 벽이 느껴져.\n완벽.", category: .random, author: "Leeo"),
        Quote(text: "비주얼 솔직히 거품 아닌가요?\n언빌리버블.", category: .random, author: "Leeo"),
        Quote(text: "너는 영어를 못하는구나.\n하지만 영문 없이도 귀엽다.", category: .random, author: "Leeo")
    ]
}
