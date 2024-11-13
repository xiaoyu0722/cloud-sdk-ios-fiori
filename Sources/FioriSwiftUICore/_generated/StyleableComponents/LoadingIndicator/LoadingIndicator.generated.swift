// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import Foundation
import SwiftUI

public struct LoadingIndicator {
    let title: any View
    /// The duration in seconds for which the loading indicator is shown. If set to 0, the loading indicator will be displayed continuously. The default is `0`.
    let duration: Double
    @Binding var isPresented: Bool

    @Environment(\.loadingIndicatorStyle) var style

    fileprivate var _shouldApplyDefaultStyle = true

    public init(@ViewBuilder title: () -> any View,
                duration: Double = 0,
                isPresented: Binding<Bool>)
    {
        self.title = Title(title: title)
        self.duration = duration
        self._isPresented = isPresented
    }
}

public extension LoadingIndicator {
    init(title: AttributedString,
         duration: Double = 0,
         isPresented: Binding<Bool>)
    {
        self.init(title: { Text(title) }, duration: duration, isPresented: isPresented)
    }
}

public extension LoadingIndicator {
    init(_ configuration: LoadingIndicatorConfiguration) {
        self.init(configuration, shouldApplyDefaultStyle: false)
    }

    internal init(_ configuration: LoadingIndicatorConfiguration, shouldApplyDefaultStyle: Bool) {
        self.title = configuration.title
        self.duration = configuration.duration
        self._isPresented = configuration.$isPresented
        self._shouldApplyDefaultStyle = shouldApplyDefaultStyle
    }
}

extension LoadingIndicator: View {
    public var body: some View {
        if self._shouldApplyDefaultStyle {
            self.defaultStyle()
        } else {
            self.style.resolve(configuration: .init(title: .init(self.title), duration: self.duration, isPresented: self.$isPresented)).typeErased
                .transformEnvironment(\.loadingIndicatorStyleStack) { stack in
                    if !stack.isEmpty {
                        stack.removeLast()
                    }
                }
        }
    }
}

private extension LoadingIndicator {
    func shouldApplyDefaultStyle(_ bool: Bool) -> some View {
        var s = self
        s._shouldApplyDefaultStyle = bool
        return s
    }

    func defaultStyle() -> some View {
        LoadingIndicator(.init(title: .init(self.title), duration: self.duration, isPresented: self.$isPresented))
            .shouldApplyDefaultStyle(false)
            .loadingIndicatorStyle(LoadingIndicatorFioriStyle.ContentFioriStyle())
            .typeErased
    }
}