import SwiftUI
import Shared

struct EmotionListView: View {
    @StateObject private var viewModel = EmotionViewModel()
    @Environment(\.scenePhase) private var scenePhase
    @State private var selectedEmotion: Emotion?

    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.emotions, id: \.id) { item in
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
                        Text("子供: " + item.childBehavior)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(1)  // 1行に制限
                            .truncationMode(.tail)  // はみ出した場合、末尾に省略記号を表示

                        Text("自分: " + item.myBehavior)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    .padding(.vertical, 4)
                    .onTapGesture {
                        selectedEmotion = item
                    }
                }

                NavigationLink(destination: EmotionView(viewModel: viewModel, emotion: nil)) {
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
            .sheet(item: $selectedEmotion) { emotion in
                EmotionView(viewModel: viewModel, emotion: emotion)
//                EmotionDetailView(viewModel: viewModel, emotion: .constant(emotion))
            }
        }
        .onAppear() {
            Task {
                await viewModel.fetchEmotions()
            }
        }
    }

    func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

class EmotionViewModel: ObservableObject {
    private let dataSource = EmotionDataSource()

    @Published var emotions: [Emotion] = []

    func fetchEmotions() async {
        let emotions = dataSource.getAllEmotions()
        DispatchQueue.main.async {
            self.emotions = emotions
        }
    }

    func addEmotion(_ emotion: Emotion) async throws {
        try await dataSource.addEmotion(emotion: emotion)
    }

    func updateEmotion(_ emotionModel: EmotionModel) async throws {
        let emotion = Emotion()
        emotion.type = Int32(emotionModel.type.hashValue)
        emotion.childBehavior = emotionModel.childBehavior
        emotion.myBehavior = emotionModel.myBehavior
        emotion.relatedContext = Int32(emotionModel.relatedContext.hashValue)
        emotion.relatedDetail = emotionModel.relatedDetail
        emotion.title = emotionModel.title
        emotion.date = Int64(emotionModel.date.timeIntervalSince1970)
        Task {
            do {
                try await addEmotion(emotion)
                await fetchEmotions()
            } catch {
                // TODO: 失敗時の動作
            }

        }
    }
}



//struct EmotionListView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmotionListView()
//    }
//}
