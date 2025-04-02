import FioriThemeManager
import SwiftUI

public struct FioriTextEditor: View {
    @Binding var text: String
    let aiWritingCommandHandler: (AIWritingCommand) async -> String
    @State var showAIAssistant: Bool = false
    @StateObject private var context: AIWritingContext
    @FocusState private var isFocused: Bool
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    public init(text: Binding<String>,
                aiWritingCommandHandler: @escaping (AIWritingCommand) async -> String)
    {
        _context = StateObject(wrappedValue: AIWritingContext(originalValue: text.wrappedValue))
        _text = text
        self.aiWritingCommandHandler = aiWritingCommandHandler
    }
    
    var useSheet: Bool {
        self.horizontalSizeClass == nil || self.horizontalSizeClass == .some(.compact)
    }
    
    public var body: some View {
        TextViewRepresentable {
            self.isFocused = false
            self.showAIAssistant = true
        }
        .environmentObject(self.context)
        .clipShape(.rect(cornerRadius: 8))
        .background {
            RoundedRectangle(cornerRadius: 8).stroke(Color.preferredColor(self.context.textIsChanged ? .tintColor : .separator))
        }
        .focused(self.$isFocused)
        .popover(isPresented: self.$showAIAssistant, attachmentAnchor: .point(.center)) {
            WritingToolForm(isPresented: self.$showAIAssistant)
                .frame(idealWidth: 400, idealHeight: 400)
                .environmentObject(self.context)
                .presentationCompactAdaptation(.sheet)
                .presentationDetents([.medium, .fraction(0.5)])
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                .interactiveDismissDisabled()
                .disabled(self.context.inProgress)
        }
        .onChange(of: self.context.selection) { _, newValue in
            if let newValue {
                self.context.inProgress = true
                Task {
                    let response = await aiWritingCommandHandler(newValue)
                    self.context.inProgress = false
                    self.context.addNewValue(response, for: newValue)
                }
                self.context.aiCommandHandler(newValue)
            }
        }
        .onChange(of: self.context.originalValue) { _, _ in
            self.text = self.context.originalValue
        }
        .onChange(of: self.showAIAssistant) { _, newValue in
            self.context.isPresented = newValue
            if newValue {
                self.isFocused = false
            } else {
                self.context.aiWritingDone()
                self.isFocused = true
            }
        }
        .onChange(of: self.isFocused) { _, newValue in
            if newValue {
                self.context.aiWritingDone()
                self.showAIAssistant = false
            }
        }
    }
}

struct TextViewRepresentable: UIViewRepresentable {
    var actionHandler: () -> Void
    @EnvironmentObject var writingContext: AIWritingContext
    @FocusState private var isFocused: Bool
    let textView = UITextView()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        self.textView.inputAccessoryView = context.coordinator.makeToolbar()
        self.textView.delegate = context.coordinator
        self.textView.attributedText = self.writingContext.displayedValue
        return self.textView
    }
    
    func updateUIView(_ textView: UITextView, context: Context) {
        textView.attributedText = self.writingContext.displayedValue
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        let parent: TextViewRepresentable
        init(parent: TextViewRepresentable) {
            self.parent = parent
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            if !self.parent.writingContext.isPresented {
                DispatchQueue.main.async {
                    self.parent.writingContext.originalSelectedRange = textView.selectedRange
                    self.parent.writingContext.selectedRange = textView.selectedRange
                }
            }
        }
        
//        func textView(_ textView: UITextView, editMenuForTextIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
//            let translateAction = UIAction(title: "AI Writing", image: nil) { [weak self] _ in
//                guard let self else { return }
//                DispatchQueue.main.async {
//                    self.parent.writingContext.selectedRange = range
//                    self.parent.writingContext.originalSelectedRange = range
//                    textView.resignFirstResponder()
//                    self.parent.actionHandler()
//                }
//            }
//            var actions = suggestedActions
//            if actions.count > 2 {
//                actions.insert(translateAction, at: 1)
//            }
//            return UIMenu(children: actions)
//        }
        
        func makeToolbar() -> UIToolbar {
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let hostVC = UIHostingController(rootView: writingButton)
            if let button = hostVC.view {
                button.frame = CGRect(origin: .zero, size: button.intrinsicContentSize)
                button.backgroundColor = .clear
                let barButtonItem = UIBarButtonItem(customView: hostVC.view)
                toolBar.items = [flexibleSpace, barButtonItem]
            }
            return toolBar
        }
        
        @objc func aiWritingTapped() {
            self.parent.textView.resignFirstResponder()
            self.parent.actionHandler()
        }
        
        var writingButton: some View {
            Button {
                self.aiWritingTapped()
            } label: {
                HStack {
                    FioriIcon.actions.ai
                    Text("AI Writing")
                }
                .foregroundStyle(Color.preferredColor(.tintColor))
                .font(Font.fiori(forTextStyle: .body, weight: .semibold))
                .padding([.leading, .top, .bottom])
            }
        }
    }
}
