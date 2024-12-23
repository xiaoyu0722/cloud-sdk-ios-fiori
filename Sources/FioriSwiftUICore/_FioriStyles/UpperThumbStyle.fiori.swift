import FioriThemeManager

// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import Foundation
import SwiftUI

/**
 This file provides default fiori style for the component.

 1. Uncomment the following code.
 2. Implement layout and style in corresponding places.
 3. Delete `.generated` from file name.
 4. Move this file to `_FioriStyles` folder under `FioriSwiftUICore`.
 */

// Base Layout style
public struct UpperThumbBaseStyle: UpperThumbStyle {
    @ViewBuilder
    public func makeBody(_ configuration: UpperThumbConfiguration) -> some View {
        // Add default layout here
        configuration.upperThumb
    }
}

// Default fiori styles
public struct UpperThumbFioriStyle: UpperThumbStyle {
    @ViewBuilder
    public func makeBody(_ configuration: UpperThumbConfiguration) -> some View {
        UpperThumb(configuration)
        // Add default style here
        // .foregroundStyle(Color.preferredColor(<#fiori color#>))
        // .font(.fiori(forTextStyle: <#fiori font#>))
    }
}
