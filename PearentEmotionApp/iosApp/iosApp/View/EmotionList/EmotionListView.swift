import SwiftUI

class EmotionStore: ObservableObject {
    @Published var emotions: [Emotion] = []

    func addEmotion(title: String) {
        let newItem = Emotion(
            title: title,
            type: .anger,
            childBehavior: "",
            myBehavior: "",
            relatedContext: .past,
            relatedDetail: ""
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
                    Text(item.title)
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
