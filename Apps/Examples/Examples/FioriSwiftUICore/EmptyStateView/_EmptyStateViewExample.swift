import FioriSwiftUICore
import SwiftUI

struct _EmptyStateViewExample: View {
    let data: [EmptyViewShowType] = [.title, .titleAndIcon, .titleAndDescription, .titleAndIconAndDescription, .all, .custom]
    
    var body: some View {
        Group {
            List(self.data, id: \.self) { item in
                NavigationLink(
                    destination: _EmptyContentViewExample(type: item),
                    label: {
                        Text(item.rawValue)
                    }
                )
            }
        }
        .navigationTitle("_EmptyStateViewExample")
    }
}

enum EmptyViewShowType: String {
    case title
    case titleAndIcon
    case titleAndDescription
    case titleAndIconAndDescription
    case all
    case custom
}

struct _EmptyContentViewExample: View {
    struct Ocean: Identifiable {
        let name: String
        let id = UUID()
    }

    private var oceans = [
        Ocean(name: "Pacific"),
        Ocean(name: "Atlantic"),
        Ocean(name: "Indian"),
        Ocean(name: "Southern"),
        Ocean(name: "Arctic")
    ]
    
    @State var isEmpty = true
    
    var type: EmptyViewShowType
    
    init(type: EmptyViewShowType) {
        self.type = type
    }
    
    var body: some View {
        Group {
            if self.isEmpty == false {
                List(self.oceans) { ocean in
                    Text(ocean.name)
                }
            } else {
                switch self.type {
                case .title:
                    _EmptyStateView(title: "This is a placeholder title")
                case .titleAndIcon:
                    _EmptyStateView(title: "This is a placeholder title",
                                    detailImage: Image("rw"))
                case .titleAndDescription:
                    _EmptyStateView(title: "This is a placeholder title",
                                    descriptionText: "This is a very long description text, maximum line number is 3.")
                case .titleAndIconAndDescription:
                    _EmptyStateView(title: "This is a placeholder title",
                                    descriptionText: "This is a very long description text, maximum line number is 3.",
                                    detailImage: Image("rw"))
                case .all:
                    _EmptyStateView(title: "This is a placeholder title",
                                    descriptionText: "This is a very long description text, maximum line number is 3.",
                                    detailImage: Image("rw").resizable(),
                                    action: _Action(actionText: "Refresh", didSelectAction: {
                                        self.isEmpty.toggle()
                                    }))
                case .custom:
                    _EmptyStateView {
                        Text("custom title")
                            .font(Font.title)
                            .foregroundColor(Color.red)
                            .background(Color.green)
                    } descriptionText: {
                        Text("custom description")
                            .font(Font.subheadline)
                            .foregroundColor(Color.green)
                            .background(Color.red)
                    } detailImage: {
                        Image("rw")
                            .resizable()
                            .cornerRadius(10)
                    } action: {
                        _Action(actionText: "Clear", didSelectAction: {
                            self.isEmpty.toggle()
                        })
                    }
                }
            }
        }
        .navigationBarItems(trailing: Button("Clear") {
            self.isEmpty.toggle()
        })
    }
}

struct _EmptyStateViewExample_Previews: PreviewProvider {
    static var previews: some View {
        _EmptyStateViewExample()
    }
}
