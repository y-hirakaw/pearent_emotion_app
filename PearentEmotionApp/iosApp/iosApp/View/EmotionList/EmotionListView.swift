import SwiftUI

class EmotionStore: ObservableObject {
    @Published var emotions: [Emotion] = []

    func addEmotion(title: String) {
        let newItem = Emotion(
            type: .anger,
            childBehavior: "",
            myBehavior: "",
            relatedContext: .past,
            relatedDetail: "",
            title: title,
            date: Date()
        )
        emotions.append(newItem)
    }
}

struct EmotionListView: View {
    @StateObject var emotionStore = EmotionStore()

    var body: some View {
        NavigationView {
            VStack {
                List(emotionStore.emotions) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(item.date, style: .date)
                                .font(.headline)
                            Text(item.type.name)
                                .font(.headline)
                            Text(item.relatedContext.description)
                                .font(.headline)
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
                    Text("Add Emotion")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                }
            }
            .navigationTitle("Emotions")
        }
    }
}



//struct EmotionListView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmotionListView()
//    }
//}
