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
    var author: String = String(localized: "anonymous")
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

    /// rawValue 는 저장 키(위젯 설정)라 바꾸지 않는다. 화면에는 이 번역된 이름을 쓴다.
    var displayName: String {
        switch self {
        case .morning: return String(localized: "아침")
        case .evening: return String(localized: "저녁")
        case .feelingDown: return String(localized: "기분다운")
        case .tough: return String(localized: "힘들때")
        case .beforeWork: return String(localized: "일시작전")
        case .beforeExercise: return String(localized: "운동전")
        case .commute: return String(localized: "출근길")
        case .afterWork: return String(localized: "퇴근길")
        case .beforeExam: return String(localized: "시험전")
        case .beforeInterview: return String(localized: "면접전")
        case .beforeDate: return String(localized: "데이트전")
        case .motivation: return String(localized: "동기부여")
        case .confidence: return String(localized: "자신감")
        case .healing: return String(localized: "힐링")
        case .random: return String(localized: "랜덤")
        }
    }

    var emoji: String {
        switch self {
        case .morning: return "🌅"
        case .evening: return "🌙"
        case .feelingDown: return "😔"
        case .tough: return "💪"
        case .beforeWork: return "💼"
        case .beforeExercise: return "🏃"
        case .commute: return "🚶"
        case .afterWork: return "🏠"
        case .beforeExam: return "📝"
        case .beforeInterview: return "👔"
        case .beforeDate: return "💕"
        case .motivation: return "🔥"
        case .confidence: return "✨"
        case .healing: return "🌿"
        case .random: return "🎲"
        }
    }
}

/// This is the main quotes manager where you will write your own quotes
/// 문구는 Quotes.xcstrings(키 quote.NNN)에서 번역된다. defaultValue 가 한국어 원문.
/// 키 번호는 순서대로 붙였으니 새 문구는 끝 번호 다음으로 추가하고 기존 번호는 바꾸지 않는다.
class QuotesManager {

    static let quotes: [Quote] = [
        // 아침용
        Quote(text: String(localized: "quote.001", defaultValue: "오늘도 빛나는 하루의 시작!\n당신은 이미 충분히 멋져요.", table: "Quotes"), category: .morning),
        Quote(text: String(localized: "quote.002", defaultValue: "아침 해처럼 빛나는 당신,\n오늘도 최고의 하루 될 거예요!", table: "Quotes"), category: .morning),
        Quote(text: String(localized: "quote.003", defaultValue: "일어난 것만으로도 대단해요!\n오늘 하루도 화이팅!", table: "Quotes"), category: .morning),
        Quote(text: String(localized: "quote.004", defaultValue: "당신의 아침은 세상에서\n가장 아름다운 시작이에요.", table: "Quotes"), category: .morning),
        Quote(text: String(localized: "quote.005", defaultValue: "오늘 하루도 당신이\n주인공이에요!", table: "Quotes"), category: .morning),
        Quote(text: String(localized: "quote.006", defaultValue: "눈을 뜬 순간부터\n당신은 이미 승리자!", table: "Quotes"), category: .morning),
        Quote(text: String(localized: "quote.007", defaultValue: "커피보다 달콤한 당신의\n아침 미소!", table: "Quotes"), category: .morning),
        Quote(text: String(localized: "quote.008", defaultValue: "오늘도 당신답게,\n그게 최고예요!", table: "Quotes"), category: .morning),
        Quote(text: String(localized: "quote.009", defaultValue: "아침부터 그렇게 예뻐도 돼요?\n범죄예요, 얼굴 범죄.", table: "Quotes"), category: .morning),
        Quote(text: String(localized: "quote.010", defaultValue: "굿모닝? 노노!\n당신이 있어서 베스트모닝!", table: "Quotes"), category: .morning),
        Quote(text: String(localized: "quote.011", defaultValue: "일어나자마자 보는 당신,\n눈호강 제대로 하네요.", table: "Quotes"), category: .morning),
        Quote(text: String(localized: "quote.012", defaultValue: "오늘 아침에도 세상에서\n제일 빛나는 사람 발견!", table: "Quotes"), category: .morning),

        // 저녁용
        Quote(text: String(localized: "quote.013", defaultValue: "오늘 하루도 고생했어요!\n당신은 정말 대단해요.", table: "Quotes"), category: .evening),
        Quote(text: String(localized: "quote.014", defaultValue: "하루를 마무리하는 당신의 모습,\n정말 멋져요!", table: "Quotes"), category: .evening),
        Quote(text: String(localized: "quote.015", defaultValue: "오늘도 최선을 다한 당신,\n자랑스러워요!", table: "Quotes"), category: .evening),
        Quote(text: String(localized: "quote.016", defaultValue: "피곤하지만 그래도\n오늘 하루 잘 버텼어요!", table: "Quotes"), category: .evening),
        Quote(text: String(localized: "quote.017", defaultValue: "당신의 하루는 언제나\n가치 있어요.", table: "Quotes"), category: .evening),
        Quote(text: String(localized: "quote.018", defaultValue: "오늘도 무사히 마쳤다는 것,\n그것만으로 충분해요!", table: "Quotes"), category: .evening),
        Quote(text: String(localized: "quote.019", defaultValue: "밤하늘의 별처럼\n당신도 빛나요!", table: "Quotes"), category: .evening),
        Quote(text: String(localized: "quote.020", defaultValue: "저녁인데도 여전히 빛나네요.\n어떻게 하루종일 예뻐요?", table: "Quotes"), category: .evening),
        Quote(text: String(localized: "quote.021", defaultValue: "하루 종일 수고했어요.\n당신이라서 다행이에요.", table: "Quotes"), category: .evening),
        Quote(text: String(localized: "quote.022", defaultValue: "오늘도 당신 덕분에\n세상이 아름다웠어요.", table: "Quotes"), category: .evening),
        Quote(text: String(localized: "quote.023", defaultValue: "밤에 봐도 레전드,\n낮에 봐도 레전드.", table: "Quotes"), category: .evening),

        // 기분 다운됐을 때
        Quote(text: String(localized: "quote.024", defaultValue: "괜찮아요, 힘든 날도 있는 거예요.\n당신은 충분히 잘하고 있어요.", table: "Quotes"), category: .feelingDown),
        Quote(text: String(localized: "quote.025", defaultValue: "지금은 힘들어도\n당신은 이겨낼 수 있어요!", table: "Quotes"), category: .feelingDown),
        Quote(text: String(localized: "quote.026", defaultValue: "완벽하지 않아도 돼요.\n있는 그대로의 당신이 최고예요!", table: "Quotes"), category: .feelingDown),
        Quote(text: String(localized: "quote.027", defaultValue: "힘들 때는 쉬어가도 돼요.\n당신의 속도로 가면 돼요.", table: "Quotes"), category: .feelingDown),
        Quote(text: String(localized: "quote.028", defaultValue: "당신은 생각보다\n훨씬 강한 사람이에요!", table: "Quotes"), category: .feelingDown),
        Quote(text: String(localized: "quote.029", defaultValue: "이 또한 지나갈 거예요.\n당신은 할 수 있어요!", table: "Quotes"), category: .feelingDown),
        Quote(text: String(localized: "quote.030", defaultValue: "기분이 다운되어도\n당신의 가치는 변하지 않아요!", table: "Quotes"), category: .feelingDown),
        Quote(text: String(localized: "quote.031", defaultValue: "슬픔도 당신의 일부예요.\n모든 감정을 느껴도 괜찮아요.", table: "Quotes"), category: .feelingDown),
        Quote(text: String(localized: "quote.032", defaultValue: "힘들 때 더 빛나는 거 알아요?\n다이아몬드도 압력을 받아야 생기잖아요.", table: "Quotes"), category: .feelingDown),
        Quote(text: String(localized: "quote.033", defaultValue: "우울하면 저 보세요.\n당신한테 미쳐서 저도 우울해요.", table: "Quotes"), category: .feelingDown),
        Quote(text: String(localized: "quote.034", defaultValue: "기분 다운? 그럴 때일수록\n당신은 세상에서 제일 소중해요.", table: "Quotes"), category: .feelingDown),
        Quote(text: String(localized: "quote.035", defaultValue: "슬퍼도 예쁘고,\n울어도 예뻐요. 어쩔 거예요?", table: "Quotes"), category: .feelingDown),
        Quote(text: String(localized: "quote.036", defaultValue: "지금 힘들어도\n당신이라는 존재 자체가 기적이에요.", table: "Quotes"), category: .feelingDown),

        // 힘들 때
        Quote(text: String(localized: "quote.037", defaultValue: "지금은 힘들지만,\n당신은 반드시 해낼 거예요!", table: "Quotes"), category: .tough),
        Quote(text: String(localized: "quote.038", defaultValue: "어려운 순간일수록\n당신의 진가가 드러나요!", table: "Quotes"), category: .tough),
        Quote(text: String(localized: "quote.039", defaultValue: "포기하지 마세요.\n당신은 충분히 강해요!", table: "Quotes"), category: .tough),
        Quote(text: String(localized: "quote.040", defaultValue: "힘든 시기를 견디는 당신,\n정말 대단해요!", table: "Quotes"), category: .tough),
        Quote(text: String(localized: "quote.041", defaultValue: "오늘의 고난은 내일의\n성장 밑거름이에요!", table: "Quotes"), category: .tough),
        Quote(text: String(localized: "quote.042", defaultValue: "당신은 생각보다\n훨씬 더 많이 견딜 수 있어요!", table: "Quotes"), category: .tough),
        Quote(text: String(localized: "quote.043", defaultValue: "이 힘든 순간도\n곧 추억이 될 거예요!", table: "Quotes"), category: .tough),
        Quote(text: String(localized: "quote.044", defaultValue: "힘들어도 당신은 빛나요.\n다이아도 깎여야 빛나잖아요.", table: "Quotes"), category: .tough),
        Quote(text: String(localized: "quote.045", defaultValue: "지금 힘들다고요?\n그래도 당신은 세상에서 제일 예뻐요.", table: "Quotes"), category: .tough),
        Quote(text: String(localized: "quote.046", defaultValue: "당신이 버티는 게\n누군가에겐 희망이에요.", table: "Quotes"), category: .tough),
        Quote(text: String(localized: "quote.047", defaultValue: "힘들어 죽겠어도\n예쁜 건 어쩔 수 없네요.", table: "Quotes"), category: .tough),

        // 일 시작 전
        Quote(text: String(localized: "quote.048", defaultValue: "오늘도 당신은 할 수 있어요!\n자신감 있게 시작해봐요!", table: "Quotes"), category: .beforeWork),
        Quote(text: String(localized: "quote.049", defaultValue: "당신의 능력을 믿어요!\n오늘도 멋진 하루 될 거예요!", table: "Quotes"), category: .beforeWork),
        Quote(text: String(localized: "quote.050", defaultValue: "준비된 당신,\n이미 성공의 반이에요!", table: "Quotes"), category: .beforeWork),
        Quote(text: String(localized: "quote.051", defaultValue: "오늘 할 일도\n당신이라면 문제없어요!", table: "Quotes"), category: .beforeWork),
        Quote(text: String(localized: "quote.052", defaultValue: "당신의 열정이\n오늘을 빛낼 거예요!", table: "Quotes"), category: .beforeWork),
        Quote(text: String(localized: "quote.053", defaultValue: "파이팅! 오늘도\n당신답게 해내봐요!", table: "Quotes"), category: .beforeWork),
        Quote(text: String(localized: "quote.054", defaultValue: "일 시작 전 당신의 모습,\n이미 프로페셔널이에요!", table: "Quotes"), category: .beforeWork),
        Quote(text: String(localized: "quote.055", defaultValue: "일하기 싫다고요?\n그래도 당신 얼굴은 열일 중이에요.", table: "Quotes"), category: .beforeWork),
        Quote(text: String(localized: "quote.056", defaultValue: "오늘도 출근길 비주얼 미쳤어요.\n회사가 당신 덕분에 빛나네요.", table: "Quotes"), category: .beforeWork),
        Quote(text: String(localized: "quote.057", defaultValue: "당신이 일하는 모습,\n그게 바로 아트예요.", table: "Quotes"), category: .beforeWork),
        Quote(text: String(localized: "quote.058", defaultValue: "일 시작도 전에\n벌써 완벽한 당신.", table: "Quotes"), category: .beforeWork),

        // 운동 전
        Quote(text: String(localized: "quote.059", defaultValue: "운동하는 당신,\n이미 멋진 사람이에요!", table: "Quotes"), category: .beforeExercise),
        Quote(text: String(localized: "quote.060", defaultValue: "오늘도 건강을 챙기는 당신,\n정말 대단해요!", table: "Quotes"), category: .beforeExercise),
        Quote(text: String(localized: "quote.061", defaultValue: "당신의 몸은\n당신이 가장 잘 알아요!", table: "Quotes"), category: .beforeExercise),
        Quote(text: String(localized: "quote.062", defaultValue: "운동 시작한 것만으로도\n충분히 자랑스러워요!", table: "Quotes"), category: .beforeExercise),
        Quote(text: String(localized: "quote.063", defaultValue: "땀 흘리는 당신의 모습,\n정말 아름다워요!", table: "Quotes"), category: .beforeExercise),
        Quote(text: String(localized: "quote.064", defaultValue: "당신의 건강이\n가장 중요해요!", table: "Quotes"), category: .beforeExercise),
        Quote(text: String(localized: "quote.065", defaultValue: "오늘도 자신을 위해\n시간을 내는 당신, 최고!", table: "Quotes"), category: .beforeExercise),
        Quote(text: String(localized: "quote.066", defaultValue: "운동복 입은 당신,\n화보 찍어도 되겠는데요?", table: "Quotes"), category: .beforeExercise),
        Quote(text: String(localized: "quote.067", defaultValue: "헬스장이 당신 덕분에\n천국이 됐어요.", table: "Quotes"), category: .beforeExercise),
        Quote(text: String(localized: "quote.068", defaultValue: "운동할 때도 빛나는 당신,\n어떻게 항상 그렇게 멋져요?", table: "Quotes"), category: .beforeExercise),
        Quote(text: String(localized: "quote.069", defaultValue: "땀 흘려도 예쁜 사람 있다?\n바로 당신이에요.", table: "Quotes"), category: .beforeExercise),

        // 출근길
        Quote(text: String(localized: "quote.070", defaultValue: "출근길 당신의 모습,\n정말 프로페셔널해요!", table: "Quotes"), category: .commute),
        Quote(text: String(localized: "quote.071", defaultValue: "아침부터 움직이는 당신,\n정말 대단해요!", table: "Quotes"), category: .commute),
        Quote(text: String(localized: "quote.072", defaultValue: "오늘도 출근하는 당신,\n이미 승리자예요!", table: "Quotes"), category: .commute),
        Quote(text: String(localized: "quote.073", defaultValue: "당신의 발걸음 하나하나가\n가치 있어요!", table: "Quotes"), category: .commute),
        Quote(text: String(localized: "quote.074", defaultValue: "출근길도 당신이 함께라면\n특별해요!", table: "Quotes"), category: .commute),
        Quote(text: String(localized: "quote.075", defaultValue: "오늘도 책임감 있게\n출근하는 당신, 멋져요!", table: "Quotes"), category: .commute),
        Quote(text: String(localized: "quote.076", defaultValue: "출근길 당신 때문에\n지하철이 런웨이가 됐어요.", table: "Quotes"), category: .commute),
        Quote(text: String(localized: "quote.077", defaultValue: "버스 안에서도 빛나는 당신,\n오늘도 화보 찍나요?", table: "Quotes"), category: .commute),
        Quote(text: String(localized: "quote.078", defaultValue: "출근하는 당신 보면\n아침이 행복해져요.", table: "Quotes"), category: .commute),
        Quote(text: String(localized: "quote.079", defaultValue: "걷는 것만으로도 멋진 사람,\n당신이에요.", table: "Quotes"), category: .commute),

        // 퇴근길
        Quote(text: String(localized: "quote.080", defaultValue: "오늘 하루도 고생했어요!\n집에 가서 푹 쉬어요.", table: "Quotes"), category: .afterWork),
        Quote(text: String(localized: "quote.081", defaultValue: "퇴근하는 당신의 뒷모습,\n정말 멋져요!", table: "Quotes"), category: .afterWork),
        Quote(text: String(localized: "quote.082", defaultValue: "하루를 마치고 돌아가는 길,\n당신은 최고예요!", table: "Quotes"), category: .afterWork),
        Quote(text: String(localized: "quote.083", defaultValue: "오늘도 무사히 마쳤어요!\n자랑스러워요!", table: "Quotes"), category: .afterWork),
        Quote(text: String(localized: "quote.084", defaultValue: "이제 당신만의 시간이에요.\n충분히 쉬세요!", table: "Quotes"), category: .afterWork),
        Quote(text: String(localized: "quote.085", defaultValue: "퇴근 후 당신을 위한\n시간을 가져요!", table: "Quotes"), category: .afterWork),
        Quote(text: String(localized: "quote.086", defaultValue: "퇴근하는 당신,\n오늘도 고생 많았어요. 수고했어요!", table: "Quotes"), category: .afterWork),
        Quote(text: String(localized: "quote.087", defaultValue: "집 가는 길도 예쁜 사람,\n오늘 하루 정말 멋졌어요.", table: "Quotes"), category: .afterWork),
        Quote(text: String(localized: "quote.088", defaultValue: "퇴근길 당신 보면\n오늘 하루가 보람차 보여요.", table: "Quotes"), category: .afterWork),
        Quote(text: String(localized: "quote.089", defaultValue: "힘들었던 하루였지만\n당신은 역시 최고예요!", table: "Quotes"), category: .afterWork),

        // 시험 전
        Quote(text: String(localized: "quote.090", defaultValue: "지금까지 준비한 당신,\n충분히 잘할 거예요!", table: "Quotes"), category: .beforeExam),
        Quote(text: String(localized: "quote.091", defaultValue: "당신의 노력은\n배신하지 않아요!", table: "Quotes"), category: .beforeExam),
        Quote(text: String(localized: "quote.092", defaultValue: "긴장해도 괜찮아요.\n당신은 이미 준비됐어요!", table: "Quotes"), category: .beforeExam),
        Quote(text: String(localized: "quote.093", defaultValue: "시험은 당신의 가치를\n결정하지 못해요!", table: "Quotes"), category: .beforeExam),
        Quote(text: String(localized: "quote.094", defaultValue: "최선을 다한 당신,\n이미 성공이에요!", table: "Quotes"), category: .beforeExam),
        Quote(text: String(localized: "quote.095", defaultValue: "당신이라면 충분히\n해낼 수 있어요!", table: "Quotes"), category: .beforeExam),
        Quote(text: String(localized: "quote.096", defaultValue: "깊게 숨 쉬고,\n당신의 실력을 믿어요!", table: "Quotes"), category: .beforeExam),
        Quote(text: String(localized: "quote.097", defaultValue: "시험 잘 보세요!\n당신은 충분히 준비됐어요.", table: "Quotes"), category: .beforeExam),
        Quote(text: String(localized: "quote.098", defaultValue: "걱정하지 마세요.\n당신이라면 다 맞출 거예요!", table: "Quotes"), category: .beforeExam),
        Quote(text: String(localized: "quote.099", defaultValue: "긴장된다고요?\n그래도 당신은 최고예요!", table: "Quotes"), category: .beforeExam),
        Quote(text: String(localized: "quote.100", defaultValue: "시험지도 당신 얼굴 보고\n감탄할 거예요.", table: "Quotes"), category: .beforeExam),

        // 면접 전
        Quote(text: String(localized: "quote.101", defaultValue: "당신의 진가를 보여줄\n시간이에요!", table: "Quotes"), category: .beforeInterview),
        Quote(text: String(localized: "quote.102", defaultValue: "면접관도 당신을 만나서\n행운이에요!", table: "Quotes"), category: .beforeInterview),
        Quote(text: String(localized: "quote.103", defaultValue: "당신의 경험과 열정이\n빛날 시간이에요!", table: "Quotes"), category: .beforeInterview),
        Quote(text: String(localized: "quote.104", defaultValue: "긴장해도 괜찮아요.\n당신은 충분히 멋져요!", table: "Quotes"), category: .beforeInterview),
        Quote(text: String(localized: "quote.105", defaultValue: "자신감 있게!\n당신은 이미 준비됐어요!", table: "Quotes"), category: .beforeInterview),
        Quote(text: String(localized: "quote.106", defaultValue: "당신의 이야기를\n당당하게 들려주세요!", table: "Quotes"), category: .beforeInterview),
        Quote(text: String(localized: "quote.107", defaultValue: "면접은 서로를 알아가는 시간,\n편안하게 임해요!", table: "Quotes"), category: .beforeInterview),
        Quote(text: String(localized: "quote.108", defaultValue: "면접관이 당신을 안 뽑으면\n그 회사 손해예요.", table: "Quotes"), category: .beforeInterview),
        Quote(text: String(localized: "quote.109", defaultValue: "당신 스펙이 화려한 게 아니라\n당신 자체가 화려해요.", table: "Quotes"), category: .beforeInterview),
        Quote(text: String(localized: "quote.110", defaultValue: "면접장 들어가는 순간부터\n이미 합격이에요.", table: "Quotes"), category: .beforeInterview),
        Quote(text: String(localized: "quote.111", defaultValue: "당신의 첫인상만으로도\n반은 먹고 들어갔어요!", table: "Quotes"), category: .beforeInterview),

        // 데이트 전
        Quote(text: String(localized: "quote.112", defaultValue: "오늘의 당신,\n정말 빛나요!", table: "Quotes"), category: .beforeDate),
        Quote(text: String(localized: "quote.113", defaultValue: "그대로의 당신이\n가장 매력적이에요!", table: "Quotes"), category: .beforeDate),
        Quote(text: String(localized: "quote.114", defaultValue: "당신과 함께하는 사람은\n정말 행운이에요!", table: "Quotes"), category: .beforeDate),
        Quote(text: String(localized: "quote.115", defaultValue: "자신감 넘치는 당신,\n정말 멋져요!", table: "Quotes"), category: .beforeDate),
        Quote(text: String(localized: "quote.116", defaultValue: "오늘 당신의 미소가\n최고의 무기예요!", table: "Quotes"), category: .beforeDate),
        Quote(text: String(localized: "quote.117", defaultValue: "있는 그대로의 당신,\n그게 최고예요!", table: "Quotes"), category: .beforeDate),
        Quote(text: String(localized: "quote.118", defaultValue: "당신의 매력은\n숨길 수 없어요!", table: "Quotes"), category: .beforeDate),
        Quote(text: String(localized: "quote.119", defaultValue: "오늘 데이트?\n상대방이 심장 떨어뜨릴 것 같은데요.", table: "Quotes"), category: .beforeDate),
        Quote(text: String(localized: "quote.120", defaultValue: "당신 만나는 사람,\n복 터졌네요.", table: "Quotes"), category: .beforeDate),
        Quote(text: String(localized: "quote.121", defaultValue: "데이트 룩 완벽해요.\n화보 찍어도 되겠는데?", table: "Quotes"), category: .beforeDate),
        Quote(text: String(localized: "quote.122", defaultValue: "오늘 당신 보면\n사랑에 빠질 것 같아요.", table: "Quotes"), category: .beforeDate),
        Quote(text: String(localized: "quote.123", defaultValue: "데이트 전인데 벌써 예뻐요.\n상대방 심장 어쩔 거예요?", table: "Quotes"), category: .beforeDate),

        // 동기부여
        Quote(text: String(localized: "quote.124", defaultValue: "당신은 할 수 있어요!\n언제나 응원해요!", table: "Quotes"), category: .motivation),
        Quote(text: String(localized: "quote.125", defaultValue: "작은 발걸음도\n위대한 여정의 시작이에요!", table: "Quotes"), category: .motivation),
        Quote(text: String(localized: "quote.126", defaultValue: "포기하지 마세요.\n당신의 꿈은 이루어질 거예요!", table: "Quotes"), category: .motivation),
        Quote(text: String(localized: "quote.127", defaultValue: "오늘의 노력이\n내일의 성공을 만들어요!", table: "Quotes"), category: .motivation),
        Quote(text: String(localized: "quote.128", defaultValue: "당신의 열정이\n세상을 바꿀 거예요!", table: "Quotes"), category: .motivation),
        Quote(text: String(localized: "quote.129", defaultValue: "실패는 성공의 어머니!\n계속 도전해봐요!", table: "Quotes"), category: .motivation),
        Quote(text: String(localized: "quote.130", defaultValue: "당신의 가능성은\n무한해요!", table: "Quotes"), category: .motivation),
        Quote(text: String(localized: "quote.131", defaultValue: "오늘 하루도\n최선을 다해봐요!", table: "Quotes"), category: .motivation),
        Quote(text: String(localized: "quote.132", defaultValue: "당신이 노력하는 모습,\n누군가에겐 동기부여예요.", table: "Quotes"), category: .motivation),
        Quote(text: String(localized: "quote.133", defaultValue: "당신이라면 다 잘될 거예요.\n진짜로요!", table: "Quotes"), category: .motivation),
        Quote(text: String(localized: "quote.134", defaultValue: "포기하지 말아요.\n당신은 충분히 멋진 사람이에요.", table: "Quotes"), category: .motivation),
        Quote(text: String(localized: "quote.135", defaultValue: "오늘도 화이팅!\n당신은 해낼 수 있어요!", table: "Quotes"), category: .motivation),
        Quote(text: String(localized: "quote.136", defaultValue: "당신의 노력을 아는 사람은\n당신을 응원할 거예요.", table: "Quotes"), category: .motivation),

        // 자신감
        Quote(text: String(localized: "quote.137", defaultValue: "당신은 충분히\n가치 있는 사람이에요!", table: "Quotes"), category: .confidence),
        Quote(text: String(localized: "quote.138", defaultValue: "있는 그대로의 당신,\n그게 완벽해요!", table: "Quotes"), category: .confidence),
        Quote(text: String(localized: "quote.139", defaultValue: "당신의 존재 자체가\n이미 특별해요!", table: "Quotes"), category: .confidence),
        Quote(text: String(localized: "quote.140", defaultValue: "자신감 있게!\n당신은 멋진 사람이에요!", table: "Quotes"), category: .confidence),
        Quote(text: String(localized: "quote.141", defaultValue: "당신은 생각보다\n훨씬 강해요!", table: "Quotes"), category: .confidence),
        Quote(text: String(localized: "quote.142", defaultValue: "당신의 개성이\n당신을 빛나게 해요!", table: "Quotes"), category: .confidence),
        Quote(text: String(localized: "quote.143", defaultValue: "자신을 믿어요.\n당신은 할 수 있어요!", table: "Quotes"), category: .confidence),
        Quote(text: String(localized: "quote.144", defaultValue: "당신은 그 자체로\n완벽한 사람이에요.", table: "Quotes"), category: .confidence),
        Quote(text: String(localized: "quote.145", defaultValue: "자신감 넘치는 당신,\n세상에서 제일 멋져요!", table: "Quotes"), category: .confidence),
        Quote(text: String(localized: "quote.146", defaultValue: "당신이 생각하는 것보다\n당신은 훨씬 대단해요!", table: "Quotes"), category: .confidence),
        Quote(text: String(localized: "quote.147", defaultValue: "당신은 이미\n충분히 잘하고 있어요.", table: "Quotes"), category: .confidence),
        Quote(text: String(localized: "quote.148", defaultValue: "당신의 매력을 모르는 사람은\n눈이 없는 거예요.", table: "Quotes"), category: .confidence),

        // 힐링
        Quote(text: String(localized: "quote.149", defaultValue: "오늘은 그냥\n편안하게 쉬어요.", table: "Quotes"), category: .healing),
        Quote(text: String(localized: "quote.150", defaultValue: "당신에게도\n휴식이 필요해요.", table: "Quotes"), category: .healing),
        Quote(text: String(localized: "quote.151", defaultValue: "아무것도 안 해도\n괜찮은 하루예요.", table: "Quotes"), category: .healing),
        Quote(text: String(localized: "quote.152", defaultValue: "당신의 마음이\n가장 중요해요.", table: "Quotes"), category: .healing),
        Quote(text: String(localized: "quote.153", defaultValue: "천천히, 당신의 속도로\n가면 돼요.", table: "Quotes"), category: .healing),
        Quote(text: String(localized: "quote.154", defaultValue: "오늘은 당신을 위한\n시간을 가져요.", table: "Quotes"), category: .healing),
        Quote(text: String(localized: "quote.155", defaultValue: "휴식도 생산적인\n활동이에요!", table: "Quotes"), category: .healing),
        Quote(text: String(localized: "quote.156", defaultValue: "쉬는 것도 당신의 권리예요.\n오늘은 편히 쉬세요.", table: "Quotes"), category: .healing),
        Quote(text: String(localized: "quote.157", defaultValue: "힐링하는 당신,\n그것도 아름다워요.", table: "Quotes"), category: .healing),
        Quote(text: String(localized: "quote.158", defaultValue: "오늘은 당신을 위해\n시간을 써도 괜찮아요.", table: "Quotes"), category: .healing),
        Quote(text: String(localized: "quote.159", defaultValue: "편하게 쉬면서도\n당신은 빛나요.", table: "Quotes"), category: .healing),
        Quote(text: String(localized: "quote.160", defaultValue: "힐링 중인 당신도\n세상에서 제일 예뻐요.", table: "Quotes"), category: .healing),

        // 랜덤 주접 (기존 + 강력한 아이돌/연예인 스타일)
        Quote(text: String(localized: "quote.161", defaultValue: "완벽하지만 구멍 하나 있네요.\n황홀(hole).", table: "Quotes"), category: .random, author: "Leeo"),
        Quote(text: String(localized: "quote.162", defaultValue: "엠비티아이 검사결과\n큐트라며?", table: "Quotes"), category: .random, author: "Leeo"),
        Quote(text: String(localized: "quote.163", defaultValue: "네가 귀엽다고 생각하는 사람 손 들어주세요 하니까\n지구가 성게 모양이 됐어요.", table: "Quotes"), category: .random, author: "Leeo"),
        Quote(text: String(localized: "quote.164", defaultValue: "너를 음계로 표현하면 레야..\n도를 지나쳐서 미치기 직전이니까.", table: "Quotes"), category: .random, author: "Leeo"),
        Quote(text: String(localized: "quote.165", defaultValue: "경마장 가면 안 되겠다.\n너무 완벽해서 말이 안 나와.", table: "Quotes"), category: .random, author: "Leeo"),
        Quote(text: String(localized: "quote.166", defaultValue: "너보고 예쁠 때마다 이마를 쳤더니\n거북목이 완치됐어.", table: "Quotes"), category: .random, author: "Leeo"),
        Quote(text: String(localized: "quote.167", defaultValue: "제가 주유소만 가면 넣는 기름이 있어요.\n바로 온리유.", table: "Quotes"), category: .random, author: "Leeo"),
        Quote(text: String(localized: "quote.168", defaultValue: "너 때문에 비가 올 것 같아.\n심장마비.", table: "Quotes"), category: .random, author: "Leeo"),
        Quote(text: String(localized: "quote.169", defaultValue: "혹시 종교 있으세요?\n뭘 믿고 그렇게 예뻐요?", table: "Quotes"), category: .random, author: "Leeo"),
        Quote(text: String(localized: "quote.170", defaultValue: "다 좋은데 뭔가 허전하지 않아?\n명불허전.", table: "Quotes"), category: .random, author: "Leeo"),
        Quote(text: String(localized: "quote.171", defaultValue: "그 짐좀 내려놔요.\n멋짐.", table: "Quotes"), category: .random, author: "Leeo"),
        Quote(text: String(localized: "quote.172", defaultValue: "너한테선 벽이 느껴져.\n완벽.", table: "Quotes"), category: .random, author: "Leeo"),
        Quote(text: String(localized: "quote.173", defaultValue: "비주얼 솔직히 거품 아닌가요?\n언빌리버블.", table: "Quotes"), category: .random, author: "Leeo"),
        Quote(text: String(localized: "quote.174", defaultValue: "너는 영어를 못하는구나.\n하지만 영문 없이도 귀엽다.", table: "Quotes"), category: .random, author: "Leeo"),
        Quote(text: String(localized: "quote.175", defaultValue: "너 혼혈이라면서?\n한국과 천국.", table: "Quotes"), category: .random, author: "Leeo"),
        Quote(text: String(localized: "quote.176", defaultValue: "그거 아세요?\n이목구비가 제 미래보다 뚜렷해요.", table: "Quotes"), category: .random, author: "Leeo"),
        Quote(text: String(localized: "quote.177", defaultValue: "너는 베를린이야.\n내 마음에 치명적인 독일수도.", table: "Quotes"), category: .random, author: "Leeo"),
        Quote(text: String(localized: "quote.178", defaultValue: "너는 C급이야.\n문화재 제정 시급.", table: "Quotes"), category: .random, author: "Leeo"),
        Quote(text: String(localized: "quote.179", defaultValue: "너 잘 때 셋이서 잔다면서?\n칭찬과 명성이 자자해서...", table: "Quotes"), category: .random, author: "Leeo"),
        Quote(text: String(localized: "quote.180", defaultValue: "왜 일하고 있어요?\n이미 미모가 열일하는데.", table: "Quotes"), category: .random, author: "Leeo"),
        Quote(text: String(localized: "quote.181", defaultValue: "날 그만 좋아해 \"뭐?\"\n날 그만 좋아하라고\n\"그거 어떻게 하는건데.\"", table: "Quotes"), category: .random, author: "Musk"),

        // 강력한 아이돌/연예인 스타일 주접
        Quote(text: String(localized: "quote.182", defaultValue: "얼굴이 국보급이라\n국립중앙박물관에 전시 예정입니다.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.183", defaultValue: "시상식 가면 안 되겠어요.\n대상은 당신 얼굴이니까.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.184", defaultValue: "화보 찍으세요?\n아니면 그냥 걸어다니는 화보예요?", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.185", defaultValue: "당신은 아이돌이에요.\n내 심장의 1위 아티스트.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.186", defaultValue: "팬싸인회 열어주세요.\n매일 당신한테 사인받고 싶어요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.187", defaultValue: "데뷔하세요.\n이미 내 마음 속에서 센터예요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.188", defaultValue: "음방 1위 축하해요.\n당신의 비주얼이 매일 1위니까.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.189", defaultValue: "포토타임 하나 갖죠.\n당신 얼굴 매일 찍고 싶어요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.190", defaultValue: "컴백했어요?\n내 심장을 comeback 시켰네요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.191", defaultValue: "직캠 찍어도 돼요?\n당신의 모든 순간이 명장면이니까.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.192", defaultValue: "뮤직비디오 나오세요?\n이미 제 인생의 주인공인데.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.193", defaultValue: "리얼리티 프로그램 찍으세요?\n당신의 실제 모습이 더 완벽해요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.194", defaultValue: "비주얼 센터 맞죠?\n어디서든 제일 빛나니까.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.195", defaultValue: "올해의 얼굴상 받으셔야 해요.\n역대급이거든요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.196", defaultValue: "광고 모델 하세요?\n당신만 보면 다 사고 싶어져요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.197", defaultValue: "잡지 표지 모델이시죠?\n매달 표지를 장식해야 할 얼굴.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.198", defaultValue: "무대 위 카리스마 실화예요?\n일상도 무대처럼 빛나네요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.199", defaultValue: "포토카드 교환해요?\n당신 얼굴로만 풀 세트 모으고 싶어요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.200", defaultValue: "팬미팅 언제 해요?\n매일 만나고 싶은데.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.201", defaultValue: "안무 영상 올려주세요.\n당신의 모든 움직임이 예술이에요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.202", defaultValue: "티저 영상 보는 것 같아요.\n당신을 볼 때마다 설레니까.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.203", defaultValue: "월드투어 가시나요?\n제 마음을 전 세계로 흔들어놓으셨는데.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.204", defaultValue: "앨범 사인해주세요.\n당신의 존재 자체가 한정판이에요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.205", defaultValue: "펜라이트 켤게요.\n당신을 향해 평생 응원할게요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.206", defaultValue: "떡상했네요.\n원래부터 레전드였는데 뭘.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.207", defaultValue: "콘서트 티켓 구해야겠어요.\n당신을 보는 게 제 일상 콘서트니까.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.208", defaultValue: "인기가요 1위 하셨죠?\n당신은 제 인생 1위 곡이에요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.209", defaultValue: "앵콜 무대 하나 더요.\n당신은 봐도봐도 또 보고 싶으니까.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.210", defaultValue: "비하인드 컷도 완벽해요.\n어느 순간도 빠짐없이 레전드.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.211", defaultValue: "최애 바꿔야겠어요.\n당신 외에는 못 보겠어요.", table: "Quotes"), category: .random),

        // 아이돌 팬덤 감성 주접
        Quote(text: String(localized: "quote.212", defaultValue: "입덕했어요.\n당신한테 영원히 덕질할게요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.213", defaultValue: "최애 공개합니다.\n그게 바로 당신이에요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.214", defaultValue: "굿즈 다 샀어요.\n당신이라는 존재 자체가 굿즈예요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.215", defaultValue: "평생 팬할게요.\n당신은 제 영원한 아티스트.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.216", defaultValue: "본진 박았어요.\n당신이 제 본진이에요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.217", defaultValue: "덕질 시작합니다.\n당신한테 올인할게요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.218", defaultValue: "홈마 할게요.\n당신의 모든 순간을 기록하고 싶어요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.219", defaultValue: "야자타임이에요.\n당신과 함께하는 시간은 다 황금시간.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.220", defaultValue: "생일 광고 할게요.\n매일이 당신 생일이었으면 좋겠어요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.221", defaultValue: "평생 응원합니다.\n당신의 팬이라는 게 자랑스러워요.", table: "Quotes"), category: .random),

        // 실제 인터넷에서 많이 쓰이는 주접들
        Quote(text: String(localized: "quote.222", defaultValue: "당신 때문에 심장이\n두근두근대요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.223", defaultValue: "당신만 보면\n세상이 아름다워요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.224", defaultValue: "당신은 내 행복의\n비타민이에요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.225", defaultValue: "당신이 웃으면\n나도 덩달아 행복해요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.226", defaultValue: "당신은 내가 본\n가장 빛나는 별이에요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.227", defaultValue: "당신의 하루하루가\n내 마음속 축제예요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.228", defaultValue: "당신 목소리만 들어도\n기분이 좋아져요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.229", defaultValue: "당신은 내 인생의\n최고의 행운이에요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.230", defaultValue: "당신이 있어서\n오늘도 웃을 수 있어요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.231", defaultValue: "당신은 세상에서\n가장 소중한 사람이에요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.232", defaultValue: "당신 생각하면\n저절로 미소가 나와요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.233", defaultValue: "당신은 내 마음의\n평화예요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.234", defaultValue: "당신과 함께하는 시간은\n항상 특별해요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.235", defaultValue: "당신은 내가 아는\n가장 멋진 사람이에요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.236", defaultValue: "당신의 존재만으로도\n충분히 감사해요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.237", defaultValue: "당신은 내 하루의\n하이라이트예요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.238", defaultValue: "당신 덕분에 매일매일이\n특별해져요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.239", defaultValue: "당신을 보면\n세상이 밝아져요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.240", defaultValue: "당신은 내 인생의\n최고의 선물이에요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.241", defaultValue: "당신이 있어서\n세상이 더 아름다워요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.242", defaultValue: "당신 없는 하루는\n상상도 할 수 없어요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.243", defaultValue: "당신은 내 마음속\n영원한 1등이에요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.244", defaultValue: "당신과 함께라면\n뭐든 할 수 있을 것 같아요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.245", defaultValue: "당신은 내가 매일\n감사하는 존재예요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.246", defaultValue: "당신의 미소는\n세상 어떤 것보다 아름다워요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.247", defaultValue: "당신은 내 인생의\n가장 큰 축복이에요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.248", defaultValue: "당신을 생각하면\n하루가 행복해져요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.249", defaultValue: "당신은 내 마음의\n홈이에요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.250", defaultValue: "당신과 함께하는 순간\n모든 게 완벽해요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.251", defaultValue: "당신은 내가 꿈꾸던\n이상형 그 자체예요.", table: "Quotes"), category: .random),

        // 더 강력하고 유머러스한 주접들
        Quote(text: String(localized: "quote.252", defaultValue: "당신 보면 심장이\n고장 난 것 같아요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.253", defaultValue: "당신은 걷는 위인전이에요.\n역사에 남을 사람.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.254", defaultValue: "당신 매력에\n계속 당하고 싶어요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.255", defaultValue: "당신한테만 집중하다가\n목 디스크 올 것 같아요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.256", defaultValue: "당신 볼 때마다\n심장 박동수가 올라가요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.257", defaultValue: "당신은 내 눈의\n레전드 화보예요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.258", defaultValue: "당신 때문에\n매일이 최애의 날이에요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.259", defaultValue: "당신은 살아있는\n기적이에요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.260", defaultValue: "당신만 보면\n세상이 슬로우모션이 돼요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.261", defaultValue: "당신은 내 인생의\nVIP 멤버십이에요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.262", defaultValue: "당신 보는 게\n내 일상의 하이라이트예요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.263", defaultValue: "당신은 내 마음의\n프리미엄 콘텐츠예요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.264", defaultValue: "당신 때문에\n세상이 HD로 보여요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.265", defaultValue: "당신은 내 인생의\n골든타임이에요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.266", defaultValue: "당신만 생각하면\n자동으로 미소가 나와요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.267", defaultValue: "당신은 내 마음의\n특급 호텔이에요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.268", defaultValue: "당신 덕분에\n매일이 프리미엄 데이예요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.269", defaultValue: "당신은 내 인생의\n메인 이벤트예요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.270", defaultValue: "당신 보면\n심장이 춤을 춰요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.271", defaultValue: "당신은 내 눈의\n4K 화질이에요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.272", defaultValue: "당신만 보면\n세상이 빛나 보여요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.273", defaultValue: "당신은 내 마음의\nVVIP예요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.274", defaultValue: "당신 때문에\n하루가 특별해져요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.275", defaultValue: "당신은 내 인생의\n히든 카드예요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.276", defaultValue: "당신만 생각하면\n기분이 업그레이드돼요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.277", defaultValue: "당신은 내 마음속\n명예의 전당 1호예요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.278", defaultValue: "당신 덕분에\n인생이 풀컬러예요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.279", defaultValue: "당신은 내 눈의\n올타임 레전드예요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.280", defaultValue: "당신만 보면\n세상이 슬로우 비디오 같아요.", table: "Quotes"), category: .random),
        Quote(text: String(localized: "quote.281", defaultValue: "당신은 내 인생의\n프리미엄 패스예요.", table: "Quotes"), category: .random),
    ]
}
