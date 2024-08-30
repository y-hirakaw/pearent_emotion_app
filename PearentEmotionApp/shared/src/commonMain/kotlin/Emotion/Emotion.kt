package Emotion

import io.realm.kotlin.types.RealmObject
import io.realm.kotlin.types.RealmUUID
import io.realm.kotlin.types.annotations.PrimaryKey
import kotlinx.datetime.Clock

open class Emotion: RealmObject {
    @PrimaryKey
    var emotionId: String = RealmUUID.random().toString()
    var type: Int = EmotionType.ANGER.id
    var childBehavior: String = ""
    var myBehavior: String = ""
    var relatedContext: Int = RelatedContext.PAST.id
    var relatedDetail: String = ""
    var title: String = ""
    var date: Long = Clock.System.now().toEpochMilliseconds()
}

enum class RelatedContext(val id: Int, val title: String) {
    PAST(1, "自分の過去"),
    CURRENT_CHILD(2, "今の子供"),
    OTHER(3, "その他")
}

enum class EmotionType(val id: Int, val title: String, val detailText: String, val emoji: String) {
    ANGER(1, "怒り", "子供の行動に対する強い怒り。過去のトラウマや未解決の感情が原因になること。", "😡"),
    FRUSTRATION(2, "苛立ち", "子供が自分の期待通りに動かないときに感じる苛立ち。", "😖"),
    FEAR(3, "恐れ", "子供の行動や状況が、過去の経験を思い出させることで生じる不安や恐れ。", "😨"),
    GUILT(4, "罪悪感", "自分の過去の行動や過ちが原因で、現在の子供に対してネガティブな感情を抱いてしまったときの罪悪感。", "😔"),
    SADNESS(5, "悲しみ", "子供の行動が、自分の過去の痛みや悲しみを呼び起こしたときに感じる感情。", "😢"),
    DISAPPOINTMENT(6, "失望", "子供が過去の自分と似た行動を取ったときに、失望を感じること。", "😞"),
    HELPLESSNESS(7, "無力感", "過去にうまく対処できなかった状況が、今の子供との関係に影響を与えていると感じるときの無力感。", "😩"),
    SHAME(8, "恥", "自分が親として過去にうまくやれなかったことが、現在の状況に反映されていると感じたときの恥。", "😳"),
    DEFENSIVENESS(9, "防衛心", "自分の過去の傷を守るために、子供に対して防衛的になってしまう感情。", "😤"),
    JEALOUSY(10, "嫉妬", "自分が過去に持っていなかったものを子供が持っているときに感じる嫉妬。", "😒");

    companion object {
        fun create(id: Int): EmotionType? {
            return when (id) {
                1 -> ANGER
                2 -> FRUSTRATION
                3 -> FEAR
                4 -> GUILT
                5 -> SADNESS
                6 -> DISAPPOINTMENT
                7 -> HELPLESSNESS
                8 -> SHAME
                9 -> DEFENSIVENESS
                10 -> JEALOUSY
                else -> null
            }
        }
    }
}