import Testing
import Foundation
@testable import 親の感情ノート

struct EmotionListViewTest {

    @Test func stringFromDate() throws {
        let listView = EmotionListView()
        let nowDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: nowDate)
        let act = listView.stringFromDate(date: nowDate, format: "yyyy-MM-dd")
        let expected = String(format: "%04d-%02d-%02d", components.year!, components.month!, components.day!)
        #expect(act == expected)
    }

}
