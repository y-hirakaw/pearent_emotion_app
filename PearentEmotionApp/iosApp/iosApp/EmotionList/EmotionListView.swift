import SwiftUI

struct Emotion: Identifiable {
    let id = UUID()
    let name: String
}

class EmotionStore: ObservableObject {
    @Published var emotions: [Emotion] = []

    func addEmotion(name: String) {
        let newItem = Emotion(name: name)
        emotions.append(newItem)
    }
}

struct EmotionListView: View {
    @StateObject var emotionStore = EmotionStore()

    var body: some View {
        NavigationView {
            VStack {
                List(emotionStore.emotions) { item in
                    Text(item.name)
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

struct AddEmotionView: View {
    @ObservedObject var emotionStore: EmotionStore
    @Environment(\.presentationMode) var presentationMode
    @State private var emotionName: String = ""

    var body: some View {
        VStack {
            TextField("Emotion Name", text: $emotionName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                emotionStore.addEmotion(name: emotionName)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
            }
        }
        .navigationTitle("Add Emotion")
        .padding()
    }
}

//struct EmotionListView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmotionListView()
//    }
//}
