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
        Quote(text: "아침부터 그렇게 예뻐도 돼요?\n범죄예요, 얼굴 범죄.", category: .morning),
        Quote(text: "굿모닝? 노노!\n당신이 있어서 베스트모닝!", category: .morning),
        Quote(text: "일어나자마자 보는 당신,\n눈호강 제대로 하네요.", category: .morning),
        Quote(text: "오늘 아침에도 세상에서\n제일 빛나는 사람 발견!", category: .morning),

        // 저녁용
        Quote(text: "오늘 하루도 고생했어요!\n당신은 정말 대단해요.", category: .evening),
        Quote(text: "하루를 마무리하는 당신의 모습,\n정말 멋져요!", category: .evening),
        Quote(text: "오늘도 최선을 다한 당신,\n자랑스러워요!", category: .evening),
        Quote(text: "피곤하지만 그래도\n오늘 하루 잘 버텼어요!", category: .evening),
        Quote(text: "당신의 하루는 언제나\n가치 있어요.", category: .evening),
        Quote(text: "오늘도 무사히 마쳤다는 것,\n그것만으로 충분해요!", category: .evening),
        Quote(text: "밤하늘의 별처럼\n당신도 빛나요!", category: .evening),
        Quote(text: "저녁인데도 여전히 빛나네요.\n어떻게 하루종일 예뻐요?", category: .evening),
        Quote(text: "하루 종일 수고했어요.\n당신이라서 다행이에요.", category: .evening),
        Quote(text: "오늘도 당신 덕분에\n세상이 아름다웠어요.", category: .evening),
        Quote(text: "밤에 봐도 레전드,\n낮에 봐도 레전드.", category: .evening),

        // 기분 다운됐을 때
        Quote(text: "괜찮아요, 힘든 날도 있는 거예요.\n당신은 충분히 잘하고 있어요.", category: .feelingDown),
        Quote(text: "지금은 힘들어도\n당신은 이겨낼 수 있어요!", category: .feelingDown),
        Quote(text: "완벽하지 않아도 돼요.\n있는 그대로의 당신이 최고예요!", category: .feelingDown),
        Quote(text: "힘들 때는 쉬어가도 돼요.\n당신의 속도로 가면 돼요.", category: .feelingDown),
        Quote(text: "당신은 생각보다\n훨씬 강한 사람이에요!", category: .feelingDown),
        Quote(text: "이 또한 지나갈 거예요.\n당신은 할 수 있어요!", category: .feelingDown),
        Quote(text: "기분이 다운되어도\n당신의 가치는 변하지 않아요!", category: .feelingDown),
        Quote(text: "슬픔도 당신의 일부예요.\n모든 감정을 느껴도 괜찮아요.", category: .feelingDown),
        Quote(text: "힘들 때 더 빛나는 거 알아요?\n다이아몬드도 압력을 받아야 생기잖아요.", category: .feelingDown),
        Quote(text: "우울하면 저 보세요.\n당신한테 미쳐서 저도 우울해요.", category: .feelingDown),
        Quote(text: "기분 다운? 그럴 때일수록\n당신은 세상에서 제일 소중해요.", category: .feelingDown),
        Quote(text: "슬퍼도 예쁘고,\n울어도 예뻐요. 어쩔 거예요?", category: .feelingDown),
        Quote(text: "지금 힘들어도\n당신이라는 존재 자체가 기적이에요.", category: .feelingDown),

        // 힘들 때
        Quote(text: "지금은 힘들지만,\n당신은 반드시 해낼 거예요!", category: .tough),
        Quote(text: "어려운 순간일수록\n당신의 진가가 드러나요!", category: .tough),
        Quote(text: "포기하지 마세요.\n당신은 충분히 강해요!", category: .tough),
        Quote(text: "힘든 시기를 견디는 당신,\n정말 대단해요!", category: .tough),
        Quote(text: "오늘의 고난은 내일의\n성장 밑거름이에요!", category: .tough),
        Quote(text: "당신은 생각보다\n훨씬 더 많이 견딜 수 있어요!", category: .tough),
        Quote(text: "이 힘든 순간도\n곧 추억이 될 거예요!", category: .tough),
        Quote(text: "힘들어도 당신은 빛나요.\n다이아도 깎여야 빛나잖아요.", category: .tough),
        Quote(text: "지금 힘들다고요?\n그래도 당신은 세상에서 제일 예뻐요.", category: .tough),
        Quote(text: "당신이 버티는 게\n누군가에겐 희망이에요.", category: .tough),
        Quote(text: "힘들어 죽겠어도\n예쁜 건 어쩔 수 없네요.", category: .tough),

        // 일 시작 전
        Quote(text: "오늘도 당신은 할 수 있어요!\n자신감 있게 시작해봐요!", category: .beforeWork),
        Quote(text: "당신의 능력을 믿어요!\n오늘도 멋진 하루 될 거예요!", category: .beforeWork),
        Quote(text: "준비된 당신,\n이미 성공의 반이에요!", category: .beforeWork),
        Quote(text: "오늘 할 일도\n당신이라면 문제없어요!", category: .beforeWork),
        Quote(text: "당신의 열정이\n오늘을 빛낼 거예요!", category: .beforeWork),
        Quote(text: "파이팅! 오늘도\n당신답게 해내봐요!", category: .beforeWork),
        Quote(text: "일 시작 전 당신의 모습,\n이미 프로페셔널이에요!", category: .beforeWork),
        Quote(text: "일하기 싫다고요?\n그래도 당신 얼굴은 열일 중이에요.", category: .beforeWork),
        Quote(text: "오늘도 출근길 비주얼 미쳤어요.\n회사가 당신 덕분에 빛나네요.", category: .beforeWork),
        Quote(text: "당신이 일하는 모습,\n그게 바로 아트예요.", category: .beforeWork),
        Quote(text: "일 시작도 전에\n벌써 완벽한 당신.", category: .beforeWork),

        // 운동 전
        Quote(text: "운동하는 당신,\n이미 멋진 사람이에요!", category: .beforeExercise),
        Quote(text: "오늘도 건강을 챙기는 당신,\n정말 대단해요!", category: .beforeExercise),
        Quote(text: "당신의 몸은\n당신이 가장 잘 알아요!", category: .beforeExercise),
        Quote(text: "운동 시작한 것만으로도\n충분히 자랑스러워요!", category: .beforeExercise),
        Quote(text: "땀 흘리는 당신의 모습,\n정말 아름다워요!", category: .beforeExercise),
        Quote(text: "당신의 건강이\n가장 중요해요!", category: .beforeExercise),
        Quote(text: "오늘도 자신을 위해\n시간을 내는 당신, 최고!", category: .beforeExercise),
        Quote(text: "운동복 입은 당신,\n화보 찍어도 되겠는데요?", category: .beforeExercise),
        Quote(text: "헬스장이 당신 덕분에\n천국이 됐어요.", category: .beforeExercise),
        Quote(text: "운동할 때도 빛나는 당신,\n어떻게 항상 그렇게 멋져요?", category: .beforeExercise),
        Quote(text: "땀 흘려도 예쁜 사람 있다?\n바로 당신이에요.", category: .beforeExercise),

        // 출근길
        Quote(text: "출근길 당신의 모습,\n정말 프로페셔널해요!", category: .commute),
        Quote(text: "아침부터 움직이는 당신,\n정말 대단해요!", category: .commute),
        Quote(text: "오늘도 출근하는 당신,\n이미 승리자예요!", category: .commute),
        Quote(text: "당신의 발걸음 하나하나가\n가치 있어요!", category: .commute),
        Quote(text: "출근길도 당신이 함께라면\n특별해요!", category: .commute),
        Quote(text: "오늘도 책임감 있게\n출근하는 당신, 멋져요!", category: .commute),
        Quote(text: "출근길 당신 때문에\n지하철이 런웨이가 됐어요.", category: .commute),
        Quote(text: "버스 안에서도 빛나는 당신,\n오늘도 화보 찍나요?", category: .commute),
        Quote(text: "출근하는 당신 보면\n아침이 행복해져요.", category: .commute),
        Quote(text: "걷는 것만으로도 멋진 사람,\n당신이에요.", category: .commute),

        // 퇴근길
        Quote(text: "오늘 하루도 고생했어요!\n집에 가서 푹 쉬어요.", category: .afterWork),
        Quote(text: "퇴근하는 당신의 뒷모습,\n정말 멋져요!", category: .afterWork),
        Quote(text: "하루를 마치고 돌아가는 길,\n당신은 최고예요!", category: .afterWork),
        Quote(text: "오늘도 무사히 마쳤어요!\n자랑스러워요!", category: .afterWork),
        Quote(text: "이제 당신만의 시간이에요.\n충분히 쉬세요!", category: .afterWork),
        Quote(text: "퇴근 후 당신을 위한\n시간을 가져요!", category: .afterWork),
        Quote(text: "퇴근하는 당신,\n오늘도 고생 많았어요. 수고했어요!", category: .afterWork),
        Quote(text: "집 가는 길도 예쁜 사람,\n오늘 하루 정말 멋졌어요.", category: .afterWork),
        Quote(text: "퇴근길 당신 보면\n오늘 하루가 보람차 보여요.", category: .afterWork),
        Quote(text: "힘들었던 하루였지만\n당신은 역시 최고예요!", category: .afterWork),

        // 시험 전
        Quote(text: "지금까지 준비한 당신,\n충분히 잘할 거예요!", category: .beforeExam),
        Quote(text: "당신의 노력은\n배신하지 않아요!", category: .beforeExam),
        Quote(text: "긴장해도 괜찮아요.\n당신은 이미 준비됐어요!", category: .beforeExam),
        Quote(text: "시험은 당신의 가치를\n결정하지 못해요!", category: .beforeExam),
        Quote(text: "최선을 다한 당신,\n이미 성공이에요!", category: .beforeExam),
        Quote(text: "당신이라면 충분히\n해낼 수 있어요!", category: .beforeExam),
        Quote(text: "깊게 숨 쉬고,\n당신의 실력을 믿어요!", category: .beforeExam),
        Quote(text: "시험 잘 보세요!\n당신은 충분히 준비됐어요.", category: .beforeExam),
        Quote(text: "걱정하지 마세요.\n당신이라면 다 맞출 거예요!", category: .beforeExam),
        Quote(text: "긴장된다고요?\n그래도 당신은 최고예요!", category: .beforeExam),
        Quote(text: "시험지도 당신 얼굴 보고\n감탄할 거예요.", category: .beforeExam),

        // 면접 전
        Quote(text: "당신의 진가를 보여줄\n시간이에요!", category: .beforeInterview),
        Quote(text: "면접관도 당신을 만나서\n행운이에요!", category: .beforeInterview),
        Quote(text: "당신의 경험과 열정이\n빛날 시간이에요!", category: .beforeInterview),
        Quote(text: "긴장해도 괜찮아요.\n당신은 충분히 멋져요!", category: .beforeInterview),
        Quote(text: "자신감 있게!\n당신은 이미 준비됐어요!", category: .beforeInterview),
        Quote(text: "당신의 이야기를\n당당하게 들려주세요!", category: .beforeInterview),
        Quote(text: "면접은 서로를 알아가는 시간,\n편안하게 임해요!", category: .beforeInterview),
        Quote(text: "면접관이 당신을 안 뽑으면\n그 회사 손해예요.", category: .beforeInterview),
        Quote(text: "당신 스펙이 화려한 게 아니라\n당신 자체가 화려해요.", category: .beforeInterview),
        Quote(text: "면접장 들어가는 순간부터\n이미 합격이에요.", category: .beforeInterview),
        Quote(text: "당신의 첫인상만으로도\n반은 먹고 들어갔어요!", category: .beforeInterview),

        // 데이트 전
        Quote(text: "오늘의 당신,\n정말 빛나요!", category: .beforeDate),
        Quote(text: "그대로의 당신이\n가장 매력적이에요!", category: .beforeDate),
        Quote(text: "당신과 함께하는 사람은\n정말 행운이에요!", category: .beforeDate),
        Quote(text: "자신감 넘치는 당신,\n정말 멋져요!", category: .beforeDate),
        Quote(text: "오늘 당신의 미소가\n최고의 무기예요!", category: .beforeDate),
        Quote(text: "있는 그대로의 당신,\n그게 최고예요!", category: .beforeDate),
        Quote(text: "당신의 매력은\n숨길 수 없어요!", category: .beforeDate),
        Quote(text: "오늘 데이트?\n상대방이 심장 떨어뜨릴 것 같은데요.", category: .beforeDate),
        Quote(text: "당신 만나는 사람,\n복 터졌네요.", category: .beforeDate),
        Quote(text: "데이트 룩 완벽해요.\n화보 찍어도 되겠는데?", category: .beforeDate),
        Quote(text: "오늘 당신 보면\n사랑에 빠질 것 같아요.", category: .beforeDate),
        Quote(text: "데이트 전인데 벌써 예뻐요.\n상대방 심장 어쩔 거예요?", category: .beforeDate),

        // 동기부여
        Quote(text: "당신은 할 수 있어요!\n언제나 응원해요!", category: .motivation),
        Quote(text: "작은 발걸음도\n위대한 여정의 시작이에요!", category: .motivation),
        Quote(text: "포기하지 마세요.\n당신의 꿈은 이루어질 거예요!", category: .motivation),
        Quote(text: "오늘의 노력이\n내일의 성공을 만들어요!", category: .motivation),
        Quote(text: "당신의 열정이\n세상을 바꿀 거예요!", category: .motivation),
        Quote(text: "실패는 성공의 어머니!\n계속 도전해봐요!", category: .motivation),
        Quote(text: "당신의 가능성은\n무한해요!", category: .motivation),
        Quote(text: "오늘 하루도\n최선을 다해봐요!", category: .motivation),
        Quote(text: "당신이 노력하는 모습,\n누군가에겐 동기부여예요.", category: .motivation),
        Quote(text: "당신이라면 다 잘될 거예요.\n진짜로요!", category: .motivation),
        Quote(text: "포기하지 말아요.\n당신은 충분히 멋진 사람이에요.", category: .motivation),
        Quote(text: "오늘도 화이팅!\n당신은 해낼 수 있어요!", category: .motivation),
        Quote(text: "당신의 노력을 아는 사람은\n당신을 응원할 거예요.", category: .motivation),

        // 자신감
        Quote(text: "당신은 충분히\n가치 있는 사람이에요!", category: .confidence),
        Quote(text: "있는 그대로의 당신,\n그게 완벽해요!", category: .confidence),
        Quote(text: "당신의 존재 자체가\n이미 특별해요!", category: .confidence),
        Quote(text: "자신감 있게!\n당신은 멋진 사람이에요!", category: .confidence),
        Quote(text: "당신은 생각보다\n훨씬 강해요!", category: .confidence),
        Quote(text: "당신의 개성이\n당신을 빛나게 해요!", category: .confidence),
        Quote(text: "자신을 믿어요.\n당신은 할 수 있어요!", category: .confidence),
        Quote(text: "당신은 그 자체로\n완벽한 사람이에요.", category: .confidence),
        Quote(text: "자신감 넘치는 당신,\n세상에서 제일 멋져요!", category: .confidence),
        Quote(text: "당신이 생각하는 것보다\n당신은 훨씬 대단해요!", category: .confidence),
        Quote(text: "당신은 이미\n충분히 잘하고 있어요.", category: .confidence),
        Quote(text: "당신의 매력을 모르는 사람은\n눈이 없는 거예요.", category: .confidence),

        // 힐링
        Quote(text: "오늘은 그냥\n편안하게 쉬어요.", category: .healing),
        Quote(text: "당신에게도\n휴식이 필요해요.", category: .healing),
        Quote(text: "아무것도 안 해도\n괜찮은 하루예요.", category: .healing),
        Quote(text: "당신의 마음이\n가장 중요해요.", category: .healing),
        Quote(text: "천천히, 당신의 속도로\n가면 돼요.", category: .healing),
        Quote(text: "오늘은 당신을 위한\n시간을 가져요.", category: .healing),
        Quote(text: "휴식도 생산적인\n활동이에요!", category: .healing),
        Quote(text: "쉬는 것도 당신의 권리예요.\n오늘은 편히 쉬세요.", category: .healing),
        Quote(text: "힐링하는 당신,\n그것도 아름다워요.", category: .healing),
        Quote(text: "오늘은 당신을 위해\n시간을 써도 괜찮아요.", category: .healing),
        Quote(text: "편하게 쉬면서도\n당신은 빛나요.", category: .healing),
        Quote(text: "힐링 중인 당신도\n세상에서 제일 예뻐요.", category: .healing),

        // 랜덤 주접 (기존 + 강력한 아이돌/연예인 스타일)
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
        Quote(text: "너는 영어를 못하는구나.\n하지만 영문 없이도 귀엽다.", category: .random, author: "Leeo"),
        Quote(text: "너 혼혈이라면서?\n한국과 천국.", category: .random, author: "Leeo"),
        Quote(text: "그거 아세요?\n이목구비가 제 미래보다 뚜렷해요.", category: .random, author: "Leeo"),
        Quote(text: "너는 베를린이야.\n내 마음에 치명적인 독일수도.", category: .random, author: "Leeo"),
        Quote(text: "너는 C급이야.\n문화재 제정 시급.", category: .random, author: "Leeo"),
        Quote(text: "너 잘 때 셋이서 잔다면서?\n칭찬과 명성이 자자해서...", category: .random, author: "Leeo"),
        Quote(text: "왜 일하고 있어요?\n이미 미모가 열일하는데.", category: .random, author: "Leeo"),
        Quote(text: "날 그만 좋아해 \"뭐?\"\n날 그만 좋아하라고\n\"그거 어떻게 하는건데.\"", category: .random, author: "Musk"),

        // 강력한 아이돌/연예인 스타일 주접
        Quote(text: "얼굴이 국보급이라\n국립중앙박물관에 전시 예정입니다.", category: .random),
        Quote(text: "시상식 가면 안 되겠어요.\n대상은 당신 얼굴이니까.", category: .random),
        Quote(text: "화보 찍으세요?\n아니면 그냥 걸어다니는 화보예요?", category: .random),
        Quote(text: "당신은 아이돌이에요.\n내 심장의 1위 아티스트.", category: .random),
        Quote(text: "팬싸인회 열어주세요.\n매일 당신한테 사인받고 싶어요.", category: .random),
        Quote(text: "데뷔하세요.\n이미 내 마음 속에서 센터예요.", category: .random),
        Quote(text: "음방 1위 축하해요.\n당신의 비주얼이 매일 1위니까.", category: .random),
        Quote(text: "포토타임 하나 갖죠.\n당신 얼굴 매일 찍고 싶어요.", category: .random),
        Quote(text: "컴백했어요?\n내 심장을 comeback 시켰네요.", category: .random),
        Quote(text: "직캠 찍어도 돼요?\n당신의 모든 순간이 명장면이니까.", category: .random),
        Quote(text: "뮤직비디오 나오세요?\n이미 제 인생의 주인공인데.", category: .random),
        Quote(text: "리얼리티 프로그램 찍으세요?\n당신의 실제 모습이 더 완벽해요.", category: .random),
        Quote(text: "비주얼 센터 맞죠?\n어디서든 제일 빛나니까.", category: .random),
        Quote(text: "올해의 얼굴상 받으셔야 해요.\n역대급이거든요.", category: .random),
        Quote(text: "광고 모델 하세요?\n당신만 보면 다 사고 싶어져요.", category: .random),
        Quote(text: "잡지 표지 모델이시죠?\n매달 표지를 장식해야 할 얼굴.", category: .random),
        Quote(text: "무대 위 카리스마 실화예요?\n일상도 무대처럼 빛나네요.", category: .random),
        Quote(text: "포토카드 교환해요?\n당신 얼굴로만 풀 세트 모으고 싶어요.", category: .random),
        Quote(text: "팬미팅 언제 해요?\n매일 만나고 싶은데.", category: .random),
        Quote(text: "안무 영상 올려주세요.\n당신의 모든 움직임이 예술이에요.", category: .random),
        Quote(text: "티저 영상 보는 것 같아요.\n당신을 볼 때마다 설레니까.", category: .random),
        Quote(text: "월드투어 가시나요?\n제 마음을 전 세계로 흔들어놓으셨는데.", category: .random),
        Quote(text: "앨범 사인해주세요.\n당신의 존재 자체가 한정판이에요.", category: .random),
        Quote(text: "펜라이트 켤게요.\n당신을 향해 평생 응원할게요.", category: .random),
        Quote(text: "떡상했네요.\n원래부터 레전드였는데 뭘.", category: .random),
        Quote(text: "콘서트 티켓 구해야겠어요.\n당신을 보는 게 제 일상 콘서트니까.", category: .random),
        Quote(text: "인기가요 1위 하셨죠?\n당신은 제 인생 1위 곡이에요.", category: .random),
        Quote(text: "앵콜 무대 하나 더요.\n당신은 봐도봐도 또 보고 싶으니까.", category: .random),
        Quote(text: "비하인드 컷도 완벽해요.\n어느 순간도 빠짐없이 레전드.", category: .random),
        Quote(text: "최애 바꿔야겠어요.\n당신 외에는 못 보겠어요.", category: .random),

        // 아이돌 팬덤 감성 주접
        Quote(text: "입덕했어요.\n당신한테 영원히 덕질할게요.", category: .random),
        Quote(text: "최애 공개합니다.\n그게 바로 당신이에요.", category: .random),
        Quote(text: "굿즈 다 샀어요.\n당신이라는 존재 자체가 굿즈예요.", category: .random),
        Quote(text: "평생 팬할게요.\n당신은 제 영원한 아티스트.", category: .random),
        Quote(text: "본진 박았어요.\n당신이 제 본진이에요.", category: .random),
        Quote(text: "덕질 시작합니다.\n당신한테 올인할게요.", category: .random),
        Quote(text: "홈마 할게요.\n당신의 모든 순간을 기록하고 싶어요.", category: .random),
        Quote(text: "야자타임이에요.\n당신과 함께하는 시간은 다 황금시간.", category: .random),
        Quote(text: "생일 광고 할게요.\n매일이 당신 생일이었으면 좋겠어요.", category: .random),
        Quote(text: "평생 응원합니다.\n당신의 팬이라는 게 자랑스러워요.", category: .random),

        // 실제 인터넷에서 많이 쓰이는 주접들
        Quote(text: "당신 때문에 심장이\n두근두근대요.", category: .random),
        Quote(text: "당신만 보면\n세상이 아름다워요.", category: .random),
        Quote(text: "당신은 내 행복의\n비타민이에요.", category: .random),
        Quote(text: "당신이 웃으면\n나도 덩달아 행복해요.", category: .random),
        Quote(text: "당신은 내가 본\n가장 빛나는 별이에요.", category: .random),
        Quote(text: "당신의 하루하루가\n내 마음속 축제예요.", category: .random),
        Quote(text: "당신 목소리만 들어도\n기분이 좋아져요.", category: .random),
        Quote(text: "당신은 내 인생의\n최고의 행운이에요.", category: .random),
        Quote(text: "당신이 있어서\n오늘도 웃을 수 있어요.", category: .random),
        Quote(text: "당신은 세상에서\n가장 소중한 사람이에요.", category: .random),
        Quote(text: "당신 생각하면\n저절로 미소가 나와요.", category: .random),
        Quote(text: "당신은 내 마음의\n평화예요.", category: .random),
        Quote(text: "당신과 함께하는 시간은\n항상 특별해요.", category: .random),
        Quote(text: "당신은 내가 아는\n가장 멋진 사람이에요.", category: .random),
        Quote(text: "당신의 존재만으로도\n충분히 감사해요.", category: .random),
        Quote(text: "당신은 내 하루의\n하이라이트예요.", category: .random),
        Quote(text: "당신 덕분에 매일매일이\n특별해져요.", category: .random),
        Quote(text: "당신을 보면\n세상이 밝아져요.", category: .random),
        Quote(text: "당신은 내 인생의\n최고의 선물이에요.", category: .random),
        Quote(text: "당신이 있어서\n세상이 더 아름다워요.", category: .random),
        Quote(text: "당신 없는 하루는\n상상도 할 수 없어요.", category: .random),
        Quote(text: "당신은 내 마음속\n영원한 1등이에요.", category: .random),
        Quote(text: "당신과 함께라면\n뭐든 할 수 있을 것 같아요.", category: .random),
        Quote(text: "당신은 내가 매일\n감사하는 존재예요.", category: .random),
        Quote(text: "당신의 미소는\n세상 어떤 것보다 아름다워요.", category: .random),
        Quote(text: "당신은 내 인생의\n가장 큰 축복이에요.", category: .random),
        Quote(text: "당신을 생각하면\n하루가 행복해져요.", category: .random),
        Quote(text: "당신은 내 마음의\n홈이에요.", category: .random),
        Quote(text: "당신과 함께하는 순간\n모든 게 완벽해요.", category: .random),
        Quote(text: "당신은 내가 꿈꾸던\n이상형 그 자체예요.", category: .random),

        // 더 강력하고 유머러스한 주접들
        Quote(text: "당신 보면 심장이\n고장 난 것 같아요.", category: .random),
        Quote(text: "당신은 걷는 위인전이에요.\n역사에 남을 사람.", category: .random),
        Quote(text: "당신 매력에\n계속 당하고 싶어요.", category: .random),
        Quote(text: "당신한테만 집중하다가\n목 디스크 올 것 같아요.", category: .random),
        Quote(text: "당신 볼 때마다\n심장 박동수가 올라가요.", category: .random),
        Quote(text: "당신은 내 눈의\n레전드 화보예요.", category: .random),
        Quote(text: "당신 때문에\n매일이 최애의 날이에요.", category: .random),
        Quote(text: "당신은 살아있는\n기적이에요.", category: .random),
        Quote(text: "당신만 보면\n세상이 슬로우모션이 돼요.", category: .random),
        Quote(text: "당신은 내 인생의\nVIP 멤버십이에요.", category: .random),
        Quote(text: "당신 보는 게\n내 일상의 하이라이트예요.", category: .random),
        Quote(text: "당신은 내 마음의\n프리미엄 콘텐츠예요.", category: .random),
        Quote(text: "당신 때문에\n세상이 HD로 보여요.", category: .random),
        Quote(text: "당신은 내 인생의\n골든타임이에요.", category: .random),
        Quote(text: "당신만 생각하면\n자동으로 미소가 나와요.", category: .random),
        Quote(text: "당신은 내 마음의\n특급 호텔이에요.", category: .random),
        Quote(text: "당신 덕분에\n매일이 프리미엄 데이예요.", category: .random),
        Quote(text: "당신은 내 인생의\n메인 이벤트예요.", category: .random),
        Quote(text: "당신 보면\n심장이 춤을 춰요.", category: .random),
        Quote(text: "당신은 내 눈의\n4K 화질이에요.", category: .random),
        Quote(text: "당신만 보면\n세상이 빛나 보여요.", category: .random),
        Quote(text: "당신은 내 마음의\nVVIP예요.", category: .random),
        Quote(text: "당신 때문에\n하루가 특별해져요.", category: .random),
        Quote(text: "당신은 내 인생의\n히든 카드예요.", category: .random),
        Quote(text: "당신만 생각하면\n기분이 업그레이드돼요.", category: .random),
        Quote(text: "당신은 내 마음속\n명예의 전당 1호예요.", category: .random),
        Quote(text: "당신 덕분에\n인생이 풀컬러예요.", category: .random),
        Quote(text: "당신은 내 눈의\n올타임 레전드예요.", category: .random),
        Quote(text: "당신만 보면\n세상이 슬로우 비디오 같아요.", category: .random),
        Quote(text: "당신은 내 인생의\n프리미엄 패스예요.", category: .random),
    ]
}
