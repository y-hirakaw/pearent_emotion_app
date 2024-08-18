//import Foundation
//
//struct Emotion: Identifiable {
//    let id = UUID()
//    /// 感情種別
//    let type: EmotionType
//    /// 子供はどう行動したのか
//    let childBehavior: String
//    /// 自分はどう行動したのか
//    let myBehavior: String
//    /// 関連の種類
//    let relatedContext: RelatedContext
//    /// 関連の詳細
//    let relatedDetail: String?
//    /// タイトル
//    let title: String?
//    /// 日時（自動設定）必要に応じて変更できるようにする
//    var date: Date = Date()
//}
//
///// 関連の種類
//enum RelatedContext {
//    /// 自分の過去
//    case past
//    /// 今の子供
//    case currentChild
//    /// その他
//    case other
//
//    var description: String {
//        switch self {
//        case .past: return "自分の過去"
//        case .currentChild: return "今の子供"
//        case .other: return "その他"
//        }
//    }
//}
//
///// 感情種別
//enum EmotionType: Int, CaseIterable, Identifiable {
//    /// 怒り
//    case anger = 1
//    /// 苛立ち
//    case frustration = 2
//    /// 恐れ
//    case fear = 3
//    /// 罪悪感
//    case guilt = 4
//    /// 悲しみ
//    case sadness = 5
//    /// 失望
//    case disappointment = 6
//    /// 無力感
//    case helplessness = 7
//    /// 恥
//    case shame = 8
//    /// 防衛心
//    case defensiveness = 9
//    /// 嫉妬
//    case jealousy = 10
//
//    var id: Int { self.rawValue }
//
//    var name: String {
//        switch self {
//        case .anger: return "怒り"
//        case .frustration: return "苛立ち"
//        case .fear: return "恐れ"
//        case .guilt: return "罪悪感"
//        case .sadness: return "悲しみ"
//        case .disappointment: return "失望"
//        case .helplessness: return "無力感"
//        case .shame: return "恥"
//        case .defensiveness: return "防衛心"
//        case .jealousy: return "嫉妬"
//        }
//    }
//
//    var description: String {
//        switch self {
//        case .anger: return "子供の行動に対する強い怒り。過去のトラウマや未解決の感情が原因になること。"
//        case .frustration: return "子供が自分の期待通りに動かないときに感じる苛立ち。"
//        case .fear: return "子供の行動や状況が、過去の経験を思い出させることで生じる不安や恐れ。"
//        case .guilt: return "自分の過去の行動や過ちが原因で、現在の子供に対してネガティブな感情を抱いてしまったときの罪悪感。"
//        case .sadness: return "子供の行動が、自分の過去の痛みや悲しみを呼び起こしたときに感じる感情。"
//        case .disappointment: return "子供が過去の自分と似た行動を取ったときに、失望を感じること。"
//        case .helplessness: return "過去にうまく対処できなかった状況が、今の子供との関係に影響を与えていると感じるときの無力感。"
//        case .shame: return "自分が親として過去にうまくやれなかったことが、現在の状況に反映されていると感じたときの恥。"
//        case .defensiveness: return "自分の過去の傷を守るために、子供に対して防衛的になってしまう感情。"
//        case .jealousy: return "自分が過去に持っていなかったものを子供が持っているときに感じる嫉妬。"
//        }
//    }
//
//    var emoji: String {
//        switch self {
//        case .anger: return "😡"
//        case .frustration: return "😖"
//        case .fear: return "😨"
//        case .guilt: return "😔"
//        case .sadness: return "😢"
//        case .disappointment: return "😞"
//        case .helplessness: return "😩"
//        case .shame: return "😳"
//        case .defensiveness: return "😤"
//        case .jealousy: return "😒"
//        }
//    }
//}
