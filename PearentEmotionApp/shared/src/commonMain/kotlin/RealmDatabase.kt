import io.realm.kotlin.Realm
import io.realm.kotlin.RealmConfiguration
import Emotion.Emotion

object RealmDatabase {
    private val config = RealmConfiguration.Builder(schema = setOf(Emotion::class))
        .name("emotion_database")
        .build()

    val realm: Realm by lazy {
        Realm.open(config)
    }
}