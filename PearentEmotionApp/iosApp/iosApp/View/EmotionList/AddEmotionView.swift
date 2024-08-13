import SwiftUI

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
                emotionStore.addEmotion(title: emotionName)
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
