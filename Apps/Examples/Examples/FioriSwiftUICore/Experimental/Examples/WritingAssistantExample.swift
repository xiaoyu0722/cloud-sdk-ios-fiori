import FioriSwiftUICore
import FioriThemeManager
import SwiftUI

public struct WritingAssistantExample: View {
    @State private var text = "Improve efficiency and work-life balance"
    @State var showAIAssistant: Bool = false
    
    let formatter = DateFormatter()
    
    public init() {}
    
    private func fetchData(for command: AIWritingCommand) async -> String {
        self.formatter.dateFormat = "yyyy h:mm:ss"
        try? await Task.sleep(nanoseconds: 500000000)
        return "Mock Async - \(command) at \(self.formatter.string(from: Date.now))"
    }

    public var body: some View {
        ScrollView {
            VStack {
                Spacer().frame(height: 100)
                
                FioriTextEditor(text: self.$text) { command in
                    await self.fetchData(for: command)
                }
                .frame(height: 100)
//                .clipShape(.rect(cornerRadius: 8))
//                .background {
//                    RoundedRectangle(cornerRadius: 8).stroke(Color.preferredColor(.separator))
//                }
                Spacer()
            }
            .padding()
        }
    }
}
