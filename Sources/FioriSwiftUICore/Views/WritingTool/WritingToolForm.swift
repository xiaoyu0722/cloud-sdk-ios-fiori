import Combine
import FioriThemeManager
import SwiftUI

struct WritingToolForm: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var context: AIWritingContext
    @Environment(\.isEnabled) private var isEnabled
    
    let sections: [WritingToolSection] = [
        WritingToolSection(header: true, items: [
            WritingToolItem(title: "Enhance Writing", iconName: "fiori.write.new", type: .enhance),
            WritingToolItem(title: "Make Shorter", iconName: "fiori.increase.line.height", type: .shorter),
            WritingToolItem(title: "Make Longer", iconName: "fiori.decrease.line.height", type: .longer),
            WritingToolItem(title: "Make Bullet List", iconName: "fiori.bullet.text", type: .bulletedList),
            WritingToolItem(title: "Analyze Text", iconName: "fiori.business.objects.experience", type: .analyze)
        ]),
        WritingToolSection(header: false, items: [
            WritingToolItem(title: "Change Tone", type: .changeTone(.none)),
            WritingToolItem(title: "Translate", type: .translate)
        ])
    ]
    
    var body: some View {
        NavigationStack {
            if #available(iOS 18.0, *) {
                List(selection: $context.selection) {
                    ForEach(sections) { section in
                        Section {
                            ForEach(section.items) { item in
                                row(item)
                            }
                        } header: {
                            if context.rewriteTextSet.count > 1, section.header {
                                WritingToolHeader()
                                    .textCase(nil)
                                    .environmentObject(context)
                                    .frame(height: 60)
                                    .listRowInsets(EdgeInsets())
                            } else {
                                EmptyView()
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        topLeadingButton
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        topTrailingButton
                    }
                }
                .toolbarBackgroundVisibility(.visible, for: .navigationBar)
                .toolbarBackground(Color.white, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Write with AI")
                            .foregroundColor(Color.preferredColor(isEnabled ? .primaryLabel : .quaternaryLabel))
                            .font(Font.fiori(forTextStyle: .subheadline, weight: .black))
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            } else {}
        }
    }
    
    var topLeadingButton: some View {
        Button {
            self.context.cancelAction()
            self.isPresented = false
        } label: {
            Text("Cancel")
                .foregroundStyle(Color.preferredColor(self.isEnabled ? .tintColor : .quaternaryLabel))
                .font(Font.fiori(forTextStyle: .body, weight: .semibold))
        }
    }
    
    var topTrailingButton: some View {
        Button {
            self.context.aiWritingDone()
            self.isPresented = false
        } label: {
            Text("Done")
                .foregroundStyle(Color.preferredColor(self.isEnabled ? .tintColor : .quaternaryLabel))
                .font(Font.fiori(forTextStyle: .body, weight: .semibold))
        }
    }

    @State var tone: AIWritingCommand.Tone = .none
    
    @ViewBuilder func row(_ item: WritingToolItem) -> some View {
        if item.type == .changeTone(.none) {
            ListPickerItem(title: {
                Text(item.title)
            }, value: {
                Text("\(self.tone.description)")
            }) {
                if #available(iOS 18.0, *) {
                    ListPickerDestination(AIWritingCommand.Tone.availableCases,
                                          id: \.self,
                                          selection: $tone,
                                          isTrackingLiveChanges: true)
                    {
                        Text($0.description)
                    }
                    .autoDismissDestination(true)
                    .cancelActionStyle { _ in
                        Button {} label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .font(Font.fiori(forTextStyle: .body, weight: .semibold))
                            .foregroundStyle(Color.preferredColor(.tintColor))
                        }
                    }
                    .applyActionStyle { _ in
                        Text("Done")
                            .padding([.leading, .top, .bottom])
                            .foregroundStyle(Color.preferredColor(self.isEnabled ? .tintColor : .quaternaryLabel))
                            .font(Font.fiori(forTextStyle: .body, weight: .semibold))
                    }
                    .toolbarBackgroundVisibility(.visible, for: .navigationBar)
                    .toolbarBackground(Color.white, for: .navigationBar)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Change Tone")
                                .foregroundColor(Color.preferredColor(isEnabled ? .primaryLabel : .quaternaryLabel))
                                .font(Font.fiori(forTextStyle: .subheadline, weight: .black))
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                } else {
                    // Fallback on earlier versions
                }
            }
            .titleStyle {
                $0.title
                    .foregroundStyle(Color.preferredColor(self.isEnabled ? .primaryLabel : .quaternaryLabel))
                    .font(Font.fiori(forTextStyle: .body))
            }
            .valueStyle {
                $0.value
                    .foregroundStyle(Color.preferredColor(self.isEnabled ? .primaryLabel : .quaternaryLabel))
                    .font(Font.fiori(forTextStyle: .body))
            }
            .onChange(of: self.tone) { _, newValue in
                self.context.selection = .changeTone(newValue)
            }
        } else if item.type == .translate {
            NavigationLink {
                ZStack {
                    Color.cyan
                    Text("Translate").font(.title3)
                }
            } label: {
                Text(item.title)
                    .foregroundStyle(Color.preferredColor(self.isEnabled ? .primaryLabel : .quaternaryLabel))
                    .font(Font.fiori(forTextStyle: .body))
            }
        } else {
            HStack {
                Text(item.title)
                Spacer()
                if let iconName = item.iconName {
                    Image(fioriName: iconName)
                }
            }
            .foregroundStyle(Color.preferredColor(self.isEnabled ? .primaryLabel : .quaternaryLabel))
            .font(Font.fiori(forTextStyle: .body))
            .tag(item.type)
        }
    }
}

struct WritingToolHeader: View {
    @EnvironmentObject var context: AIWritingContext
    
    var body: some View {
        HStack(spacing: 8) {
            Button {
                self.context.revertToPreviousValue()
            } label: {
                Image(fioriName: "fiori.slim.arrow.down")
                    .frame(width: 38, height: 38)
            }
            .disabled(!self.context.revertIsEnabled)

            Button {
                self.context.forwardToNextValue()
            } label: {
                Image(fioriName: "fiori.slim.arrow.up")
                    .frame(width: 38, height: 38)
            }
            .disabled(!self.context.forwardIsEnabled)
            
            Spacer()
            
            NavigationLink {
                ZStack {
                    Color.cyan
                    Text("Feedback")
                }
            } label: {
                Image(fioriName: "fiori.feedback")
                    .frame(width: 38, height: 38)
            }
            
            Button {
                self.context.rewriteAction()
            } label: {
                HStack(spacing: 4) {
                    Image(fioriName: "fiori.refresh")
                    Text("Rewrite")
                }
                .padding(.horizontal)
                .frame(height: 38)
            }
        }
        .buttonStyle(WritingToolButtonStyle())
    }
}

struct WritingToolSection: Hashable, Identifiable {
    let id = UUID()
    let header: Bool
    let items: [WritingToolItem]
}

public enum AIWritingCommand: Hashable {
    public enum Tone: Hashable, CaseIterable {
        case none
        case profession
        case friendly
        case excited
        case casual
        case confident
        case thoughtful
        case funny
        
        var description: String {
            switch self {
            case .none:
                return "N/A"
            case .profession:
                return "Professional"
            case .friendly:
                return "Friendly"
            case .excited:
                return "Excited"
            case .casual:
                return "Casual"
            case .confident:
                return "Confident"
            case .thoughtful:
                return "Thoughtful"
            case .funny:
                return "Funny"
            }
        }
        
        static let availableCases: [Tone] = [.profession, .friendly, .excited, .casual, .confident, .thoughtful, .funny]
    }
    
    case enhance
    case shorter
    case longer
    case bulletedList
    case changeTone(Tone)
    case translate
    case analyze
}

struct WritingToolItem: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let iconName: String?
    let type: AIWritingCommand
    let children: [WritingToolItem]?
    
    init(title: String, iconName: String? = nil, type: AIWritingCommand, children: [WritingToolItem]? = nil) {
        self.title = title
        self.iconName = iconName
        self.type = type
        self.children = children
    }
}

struct WritingToolButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.fiori(forTextStyle: .body, weight: .semibold))
            .foregroundColor(.preferredColor(configuration.isPressed || !self.isEnabled ? .quaternaryLabel : .secondaryLabel))
            .background {
                Color.preferredColor(configuration.isPressed || !self.isEnabled ? .quaternaryFill : .tertiaryFill)
                    .clipShape(.rect(cornerRadius: 8))
            }
    }
}
