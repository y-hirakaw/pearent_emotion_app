import SwiftUI
import Shared

class EmotionStore: ObservableObject {
    @Published var emotions: [Emotion] = []

    func addEmotion(emotion: Emotion) {
        emotions.append(emotion)
    }
}

struct EmotionListView: View {
    @StateObject var emotionStore = EmotionStore()

    var body: some View {
        NavigationView {
            VStack {
                List(emotionStore.emotions, id: \.id) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            let date = Date(
                                timeIntervalSince1970: Double(item.date)
                            )
                            Text(stringFromDate(date: date, format: "yyyy-MM-dd"))
                                .font(.headline)
                            Text(EmotionType.Companion.shared.create(id: item.type)?.title ?? "")
                                .font(.headline)
                            // TODO: titleはEmotionTypeのように取得できるようにする
//                            Text(item.relatedContext.title)
//                                .font(.headline)
                        }
                        Text("子供: " + item.childBehavior.prefix(10) + "...")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("自分: " + item.myBehavior.prefix(10) + "...")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }

                NavigationLink(destination: AddEmotionView(emotionStore: emotionStore)) {
                    Text("感情を追加")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                }
            }
            .navigationTitle("一覧")
        }
    }

    func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}



//struct EmotionListView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmotionListView()
//    }
//}
