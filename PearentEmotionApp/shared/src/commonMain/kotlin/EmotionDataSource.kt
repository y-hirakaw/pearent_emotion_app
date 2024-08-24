import Emotion.Emotion
import io.realm.kotlin.ext.query
import io.realm.kotlin.notifications.ResultsChange
import io.realm.kotlin.query.RealmResults
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.toList

class EmotionDataSource {

    private val realm = RealmDatabase.realm

    suspend fun addEmotion(emotion: Emotion) {
        realm.write {
            copyToRealm(emotion)
        }
    }

    fun getEmotionById(id: String): Emotion? {
        return realm.query<Emotion>("id == $0", id).first().find()
    }

    fun getAllEmotions(): RealmResults<Emotion> {
        return realm.query<Emotion>().find()
    }

    suspend fun updateEmotion(id: String, update: Emotion.() -> Unit) {
        realm.write {
            val emotion = query<Emotion>("id == $0", id).first().find()
            emotion?.apply(update)
        }
    }

    suspend fun deleteEmotion(id: String) {
        realm.write {
            val emotion = query<Emotion>("id == $0", id).first().find()
            emotion?.let { delete(it) }
        }
    }
}