import SwiftUI

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

    let columns = [
        GridItem(.adaptive(minimum: 50)) // 50ポイント幅を基準に自動調整
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
                    Text(selectedEmotion.name + ": " + selectedEmotion.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Section(header: Text("子供の行動")) {
                    AutoSizingTextEditor(text: $childBehavior)
                }

                Section(header: Text("自分の行動")) {
                    AutoSizingTextEditor(text: $myBehavior)
                }

                Section(header: Text("感情は何に関連するか")) {
                    Picker("関連", selection: $relatedContext) {
                        Text("自分の過去").tag(RelatedContext.past)
                        Text("今の子供").tag(RelatedContext.currentChild)
                        Text("他").tag(RelatedContext.other)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

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
            }
            .navigationTitle("感情追加")
            .navigationBarItems(
            trailing: Button("入力完了") {
                let emotion = Emotion(
                    type: selectedEmotion,
                    childBehavior: childBehavior,
                    myBehavior: myBehavior,
                    relatedContext: relatedContext,
                    relatedDetail: relatedDetail,
                    title: title,
                    date: date
                )
                self.emotionStore.addEmotion(emotion: emotion)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct AutoSizingTextEditor: View {
    @Binding var text: String
    @State private var dynamicHeight: CGFloat = 66

    private var minHeight: CGFloat
    private var maxHeight: CGFloat

    // 初期化
    init(text: Binding<String>, minHeight: CGFloat = 66, maxHeight: CGFloat = 300) {
        self._text = text
        self.minHeight = minHeight
        self.maxHeight = maxHeight
    }

    var body: some View {
        TextEditor(text: $text)
            .frame(height: dynamicHeight)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .onChange(of: text) { _ in
                adjustTextEditorHeight()
            }
    }

    // テキストの内容に応じて高さを調整する関数
    private func adjustTextEditorHeight() {
        let size = CGSize(width: UIScreen.main.bounds.width - 40, height: .infinity)
        let estimatedHeight = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 17)], context: nil).height

        dynamicHeight = min(max(estimatedHeight + 20, minHeight), maxHeight)
    }
}
