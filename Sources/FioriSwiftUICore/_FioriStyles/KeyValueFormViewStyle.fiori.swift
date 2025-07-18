import FioriThemeManager
import Foundation
import SwiftUI

/// The base layout style for `KeyValueFormView`.
public struct KeyValueFormViewBaseStyle: KeyValueFormViewStyle {
    @Environment(\.isLoading) var isLoading
    public func makeBody(_ configuration: KeyValueFormViewConfiguration) -> some View {
        SkeletonLoadingContainer {
            VStack(alignment: .leading) {
                self.getTitle(configuration)
                configuration._noteFormView
            }
            .accessibilityElement(children: .combine)
        }
    }
    
    func getTitle(_ configuration: KeyValueFormViewConfiguration) -> some View {
        if self.isLoading {
            return Text("KeyValueFormView title").typeErased
        } else {
            return configuration.title.typeErased
        }
    }
}
    
// Default fiori styles
extension KeyValueFormViewFioriStyle {
    struct ContentFioriStyle: KeyValueFormViewStyle {
        @FocusState var isFocused: Bool
        func makeBody(_ configuration: KeyValueFormViewConfiguration) -> some View {
            KeyValueFormView(configuration)
                .titleStyle { titleConf in
                    Title(titleConf)
                        .foregroundStyle(self.getTitleColor(configuration))
                        .font(.fiori(forTextStyle: .subheadline, weight: .semibold))
                }
                .focused(self.$isFocused)
        }

        private func getTitleColor(_ configuration: KeyValueFormViewConfiguration) -> Color {
            TextInputFormViewConfiguration(configuration, isFocused: self.isFocused).getTitleColor()
        }

        private func getMandatoryIndicatorColor(_ configuration: KeyValueFormViewConfiguration) -> Color {
            TextInputFormViewConfiguration(configuration, isFocused: false).getTitleColor()
        }
    }

    struct TitleFioriStyle: TitleStyle {
        let keyValueFormViewConfiguration: KeyValueFormViewConfiguration

        func makeBody(_ configuration: TitleConfiguration) -> some View {
            Title(configuration)
                .foregroundStyle(self.getTitleColor(self.keyValueFormViewConfiguration))
                .font(.fiori(forTextStyle: .subheadline, weight: .semibold))
                .padding(.bottom, -4)
                .padding(.top, 11)
        }
        
        private func getTitleColor(_ configuration: KeyValueFormViewConfiguration) -> Color {
            TextInputFormViewConfiguration(configuration, isFocused: false).getTitleColor()
        }
        
        private func isDisabled(_ configuration: KeyValueFormViewConfiguration) -> Bool {
            configuration.controlState == .disabled
        }

        private func isErrorStyle(_ configuration: KeyValueFormViewConfiguration) -> Bool {
            TextInputFormViewConfiguration(configuration, isFocused: false).isErrorStyle()
        }
    }

    struct TextViewFioriStyle: TextViewStyle {
        let keyValueFormViewConfiguration: KeyValueFormViewConfiguration
        
        func makeBody(_ configuration: TextViewConfiguration) -> some View {
            TextView(configuration)
        }
    }

    struct PlaceholderFioriStyle: PlaceholderStyle {
        let keyValueFormViewConfiguration: KeyValueFormViewConfiguration
        
        func makeBody(_ configuration: PlaceholderConfiguration) -> some View {
            Placeholder(configuration)
        }
    }

    struct NoteFormViewFioriStyle: NoteFormViewStyle {
        let keyValueFormViewConfiguration: KeyValueFormViewConfiguration
        
        func makeBody(_ configuration: NoteFormViewConfiguration) -> some View {
            NoteFormView(configuration)
        }
    }
}
