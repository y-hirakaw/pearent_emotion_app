import SwiftUI
import Shared

struct EmotionView: View {
    @ObservedObject var viewModel: EmotionViewModel
    @Environment(\.presentationMode) var presentationMode

    // Realmオブジェクトをバインディングせず、ローカルで管理する
    @State private var localEmotion: EmotionModel
    @State private var isDetailInputVisible: Bool = false
    private let edgeInsets = EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

    let columns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(viewModel: EmotionViewModel, emotion: Emotion?) {
        self.viewModel = viewModel
        // Realmのオブジェクトをコピーして保持
        if let emotion = emotion {
            self._localEmotion = State(initialValue: EmotionModel(emotion: emotion))
        } else {
            self._localEmotion = State(initialValue: EmotionModel())
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                EmotionTypeSelectionView(
                    selectedType: $localEmotion.type,
                    title: localEmotion.title,
                    detailText: localEmotion.relatedDetail,
                    columns: columns
                )

                Section(header: Text("子供の行動")) {
                    AutoSizingTextEditor(text: $localEmotion.childBehavior)
                }
                .listRowInsets(
                    edgeInsets
                )

                Section(header: Text("自分の行動")) {
                    AutoSizingTextEditor(text: $localEmotion.myBehavior)
                }
                .listRowInsets(
                    edgeInsets
                )

                Section(header: Text("感情は何に関連するか")) {
                    Picker("関連", selection: $localEmotion.relatedContext) {
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
                                AutoSizingTextEditor(text: $localEmotion.relatedDetail)
                            }
                            Section(header: Text("タイトル")) {
                                AutoSizingTextEditor(text: $localEmotion.title)
                            }
                            DatePicker("日時", selection: $localEmotion.date, displayedComponents: .date)
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
        }
        .navigationTitle("感情詳細")
        .navigationBarItems(
            trailing: Button("保存") {
                // ローカルのデータをRealmに書き戻す処理
                Task {
                    do {
                        // Realmに保存
                        try await viewModel.updateEmotion(localEmotion)
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        // TODO: エラーハンドリング
                    }
                }
            }
        )
    }
}

struct EmotionModel {
    var type: EmotionType
    var childBehavior: String
    var myBehavior: String
    var relatedContext: RelatedContext
    var relatedDetail: String
    var title: String
    var date: Date

    init() {
        self.type = .anger  // デフォルトのEmotionTypeを設定

        // 他のプロパティも個別に初期化
        self.childBehavior = ""
        self.myBehavior = ""
        self.relatedContext = .past
        self.relatedDetail = ""
        self.title = ""
        self.date = Date()
    }

    init(emotion: Emotion) {
        // typeの変換処理を分割して簡潔にする
        let emotionTypeId: Int32 = emotion.type
        if let resolvedType = EmotionType.fromId(emotionTypeId) {
            self.type = resolvedType
        } else {
            self.type = .anger  // デフォルトのEmotionTypeを設定
        }

        // 他のプロパティも個別に初期化
        self.childBehavior = emotion.childBehavior
        self.myBehavior = emotion.myBehavior
        self.relatedContext = RelatedContext.fromId(emotion.relatedContext) ?? .other
        self.relatedDetail = emotion.relatedDetail
        self.title = emotion.title

        // dateの変換も分割して処理
        let timeInterval = TimeInterval(emotion.date)
        self.date = Date(timeIntervalSince1970: timeInterval)
    }
}

extension EmotionType {
    static func fromId(_ id: Int32) -> EmotionType? {
        return EmotionType.allCases.first { $0.id == id }
    }
}

extension RelatedContext {
    static func fromId(_ id: Int32) -> RelatedContext? {
        return RelatedContext.allCases.first { $0.id == id }
    }
}

struct EmotionTypeSelectionView: View {
    @Binding var selectedType: EmotionType
    let title: String
    let detailText: String
    let columns: [GridItem]

    var body: some View {
        Section(header: Text("感情")) {
            LazyVGrid(columns: columns) {
                ForEach(EmotionType.allCases, id: \.self) { emotionType in
                    Button(action: {
                        selectedType = emotionType
                    }) {
                        ZStack {
                            Circle()
                                .fill(selectedType == emotionType ? Color.yellow : Color.clear)
                                .frame(width: 50, height: 50)
                            Text(emotionType.emoji)
                                .font(.system(size: 30))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())  // 不要なハイライト効果を防ぐ
                    .frame(width: 50, height: 50)      // クリック領域を制限
                }
            }
            Text(
                "【" + title + "】" + detailText
            )
            .font(.subheadline)
            .foregroundColor(.gray)
        }
    }
}
