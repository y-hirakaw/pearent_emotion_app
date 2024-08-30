import SwiftUI
import Shared

struct EmotionDetailView: View {
    @ObservedObject var viewModel: EmotionViewModel
    @Binding var emotion: Emotion
    @Environment(\.presentationMode) var presentationMode

    // TODO: Bindingしてしまうと、Realmをスレッドセーフでは無い状態で編集することになってしまうので、表示、編集と更新は別にする
    var body: some View {
        Form {
            Section(header: Text("感情の種類")) {
                Text(EmotionType.Companion.shared.create(id: emotion.type)?.title ?? "")
                    .font(.headline)
            }

            Section(header: Text("子供の行動")) {
                TextEditor(text: $emotion.childBehavior)
                    .frame(height: 100)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }

            Section(header: Text("自分の行動")) {
                TextEditor(text: $emotion.myBehavior)
                    .frame(height: 100)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }

            Section(header: Text("関連する文脈")) {
                Picker("関連", selection: $emotion.relatedContext) {
                    Text("自分の過去").tag(RelatedContext.past.id)
                    Text("今の子供").tag(RelatedContext.currentChild.id)
                    Text("他").tag(RelatedContext.other.id)
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section(header: Text("関連の詳細")) {
                TextEditor(text: $emotion.relatedDetail)
                    .frame(height: 100)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            Section(header: Text("タイトル")) {
                TextEditor(text: $emotion.title)
                    .frame(height: 50)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }

            Section(header: Text("日付")) {
                DatePicker("日付", selection: Binding(
                    get: {
                        Date(timeIntervalSince1970: Double(emotion.date))
                    },
                    set: { newValue in
                        emotion.date = Int64(newValue.timeIntervalSince1970)
                    }
                ), displayedComponents: .date)
            }
        }
        .navigationTitle("感情の詳細")
        .navigationBarItems(
            trailing: Button("保存") {
                Task {
                    do {
                        try await viewModel.addEmotion(emotion)
                        await viewModel.fetchEmotions()
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        // TODO: 保存失敗時の処理
                    }
                }
            }
        )
    }
}
