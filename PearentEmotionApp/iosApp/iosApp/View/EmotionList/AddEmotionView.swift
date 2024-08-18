import SwiftUI
import Shared

struct AddEmotionView: View {
    @ObservedObject var emotionStore: EmotionStore
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedEmotion: EmotionType = .anger
    @State private var childBehavior: String = ""
    @State private var myBehavior: String = ""
    @State private var relatedContext: RelatedContext = .past
    @State private var relatedDetail: String = ""
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var isDetailInputVisible: Bool = false
    private let edgeInsets = EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

    let columns = [
        GridItem(.adaptive(minimum: 44))
    ]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("感情")) {
                    LazyVGrid(columns: columns) {
                        ForEach(EmotionType.allCases, id: \.self) { emotion in
                            Button(action: {
                                selectedEmotion = emotion
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(selectedEmotion == emotion ? Color.yellow : Color.clear)
                                        .frame(width: 50, height: 50)
                                    Text(emotion.emoji)
                                        .font(.system(size: 30))
                                }
                            }
                            .buttonStyle(PlainButtonStyle())  // 不要なハイライト効果を防ぐ
                            .frame(width: 50, height: 50)      // クリック領域を制限
                        }
                    }
                    Text(
                        "【" + selectedEmotion.title + "】" + selectedEmotion.detailText
                    )
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .listRowInsets(
                    edgeInsets
                )

                Section(header: Text("子供の行動")) {
                    AutoSizingTextEditor(text: $childBehavior)
                }
                .listRowInsets(
                    edgeInsets
                )

                Section(header: Text("自分の行動")) {
                    AutoSizingTextEditor(text: $myBehavior)
                }
                .listRowInsets(
                    edgeInsets
                )

                Section(header: Text("感情は何に関連するか")) {
                    Picker("関連", selection: $relatedContext) {
                        Text("自分の過去").tag(RelatedContext.past)
                        Text("今の子供").tag(RelatedContext.currentChild)
                        Text("他").tag(RelatedContext.other)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .listRowInsets(
                    edgeInsets
                )

                Section {
                    Button(action: {
                        // 詳細入力フォームの表示切り替え
                        withAnimation {
                            isDetailInputVisible.toggle()
                        }
                    }) {
                        Text(isDetailInputVisible ? "詳細入力−" : "詳細入力＋")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }

                    // 詳細入力フォーム
                    if isDetailInputVisible {
                        VStack {
                            // TODO: 左寄せにしたい
                            Section(header: Text("関連の詳細")) {
                                AutoSizingTextEditor(text: $relatedDetail)
                            }
                            Section(header: Text("タイトル")) {
                                AutoSizingTextEditor(text: $title)
                            }
                            DatePicker("日時", selection: $date, displayedComponents: .date)
                        }
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
                .listRowInsets(
                    edgeInsets
                )
            }
            .navigationTitle("感情追加")
            .navigationBarItems(
            trailing: Button("入力完了") {
                let emotion = Emotion()
                emotion.type = selectedEmotion.id
                emotion.childBehavior = childBehavior
                emotion.myBehavior = myBehavior
                emotion.relatedContext = relatedContext.id
                emotion.relatedDetail = relatedDetail
                emotion.title = title
                emotion.date = Int64(date.timeIntervalSince1970)
//                let emotion = Emotion(
//                    type: selectedEmotion.id,
//                    childBehavior: childBehavior,
//                    myBehavior: myBehavior,
//                    relatedContext: relatedContext.id,
//                    relatedDetail: relatedDetail,
//                    title: title,
//                    date: date.timeIntervalSince1970
//                )
                self.emotionStore.addEmotion(emotion: emotion)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
