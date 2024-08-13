import Foundation

struct Emotion: Identifiable {
    let id = UUID()
    /// タイトル
    let title: String
    /// 感情種別
    let type: EmotionType
    /// 子供はどう行動したのか
    let childBehavior: String
    /// 自分はどう行動したのか
    let myBehavior: String
    /// 関連の種類
    let relatedContext: RelatedContext
    /// 関連の詳細
    let relatedDetail: String?
}

enum RelatedContext {
    /// 過去
    case past
    /// 今の子供
    case currentChild
    /// その他
    case other
}

// TODO: 本の感情も追加する
enum EmotionType: String, CaseIterable, Identifiable {
    case anger = "Anger"
    case frustration = "Frustration"
    case sadness = "Sadness"
    case happiness = "Happiness"
    case anxiety = "Anxiety"
    case surprise = "Surprise"

    var id: String { self.rawValue }
}
