import SwiftUI

struct EmotionListView: View {
    @State private var items = ["アイテム1", "アイテム2", "アイテム3"]

    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    Text(item)
                }
            }
        }
    }
}

//struct EmotionListView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmotionListView()
//    }
//}
