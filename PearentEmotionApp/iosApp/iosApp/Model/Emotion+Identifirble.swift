import Shared

extension Emotion: @retroactive Identifiable {
    public var id: String {
        return self.emotionId
    }
}
