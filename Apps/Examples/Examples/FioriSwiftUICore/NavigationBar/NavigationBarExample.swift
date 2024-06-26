import FioriThemeManager
import SwiftUI

struct NavigationBarExample: View {
    @State private var isPresented = false
    
    var body: some View {
        List {
            HStack {
                Text("FioriStyle Version")
                Spacer()
                NavigationLink {
                    EmptyView()
                } label: {
                    EmptyView()
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.isPresented.toggle()
            }
            .sheet(isPresented: self.$isPresented) {
                NavigationBarFioriStyle()
            }
            
            NavigationLink {
                NavigationBarPopover()
            } label: {
                Text("Long title and subtitle for TitleView (Long press to show popover)")
            }
            
            NavigationLink {
                NavigationBarCustomItem()
            } label: {
                Text("Custom Nav Bar with custom buttons (expanded touch area and highlighted state)")
            }
        }
        .navigationTitle("NavigationBar Test")
    }
}

#Preview {
    NavigationStack {
        NavigationBarExample()
    }
}
