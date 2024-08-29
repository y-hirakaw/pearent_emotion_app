import SwiftUI

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
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)
            .onChange(of: text) {
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
