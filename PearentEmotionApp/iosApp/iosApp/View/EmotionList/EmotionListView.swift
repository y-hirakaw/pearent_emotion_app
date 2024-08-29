import SwiftUI
import Shared

struct EmotionListView: View {
    @StateObject private var viewModel = EmotionViewModel()
    @Environment(\.scenePhase) private var scenePhase

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
                        Text("子供: " + item.childBehavior.prefix(10) + "...")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("自分: " + item.myBehavior.prefix(10) + "...")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }

                NavigationLink(destination: AddEmotionView(viewModel: viewModel)) {
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
}



//struct EmotionListView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmotionListView()
//    }
//}
