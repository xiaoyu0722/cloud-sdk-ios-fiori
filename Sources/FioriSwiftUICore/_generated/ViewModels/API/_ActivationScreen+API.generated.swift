// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import SwiftUI

public struct _ActivationScreen<Title: View, DescriptionText: View, Footnote: View, ActionView: View, SecondaryActionView: View, TextInputView: View> {
    @Environment(\.titleModifier) private var titleModifier
	@Environment(\.descriptionTextModifier) private var descriptionTextModifier
	@Environment(\.footnoteModifier) private var footnoteModifier
	@Environment(\.actionModifier) private var actionModifier
	@Environment(\.secondaryActionModifier) private var secondaryActionModifier
	@Environment(\.textInputModifier) private var textInputModifier

    let _title: Title
	let _descriptionText: DescriptionText
	let _footnote: Footnote
	let _action: ActionView
	let _secondaryAction: SecondaryActionView
	let _textInput: TextInputView
	

    private var isModelInit: Bool = false
	private var isDescriptionTextNil: Bool = false
	private var isFootnoteNil: Bool = false
	private var isActionNil: Bool = false
	private var isSecondaryActionNil: Bool = false
	private var isTextInputNil: Bool = false

    public init(
        @ViewBuilder title: () -> Title,
		@ViewBuilder descriptionText: () -> DescriptionText,
		@ViewBuilder footnote: () -> Footnote,
		@ViewBuilder action: () -> ActionView,
		@ViewBuilder secondaryAction: () -> SecondaryActionView,
		@ViewBuilder textInput: () -> TextInputView
        ) {
            self._title = title()
			self._descriptionText = descriptionText()
			self._footnote = footnote()
			self._action = action()
			self._secondaryAction = secondaryAction()
			self._textInput = textInput()
    }

    @ViewBuilder var title: some View {
        if isModelInit {
            _title.modifier(titleModifier.concat(Fiori._ActivationScreen.title).concat(Fiori._ActivationScreen.titleCumulative))
        } else {
            _title.modifier(titleModifier.concat(Fiori._ActivationScreen.title))
        }
    }
	@ViewBuilder var descriptionText: some View {
        if isModelInit {
            _descriptionText.modifier(descriptionTextModifier.concat(Fiori._ActivationScreen.descriptionText).concat(Fiori._ActivationScreen.descriptionTextCumulative))
        } else {
            _descriptionText.modifier(descriptionTextModifier.concat(Fiori._ActivationScreen.descriptionText))
        }
    }
	@ViewBuilder var footnote: some View {
        if isModelInit {
            _footnote.modifier(footnoteModifier.concat(Fiori._ActivationScreen.footnote).concat(Fiori._ActivationScreen.footnoteCumulative))
        } else {
            _footnote.modifier(footnoteModifier.concat(Fiori._ActivationScreen.footnote))
        }
    }
	@ViewBuilder var action: some View {
        if isModelInit {
            _action.modifier(actionModifier.concat(Fiori._ActivationScreen.action).concat(Fiori._ActivationScreen.actionCumulative))
        } else {
            _action.modifier(actionModifier.concat(Fiori._ActivationScreen.action))
        }
    }
	@ViewBuilder var secondaryAction: some View {
        if isModelInit {
            _secondaryAction.modifier(secondaryActionModifier.concat(Fiori._ActivationScreen.secondaryAction).concat(Fiori._ActivationScreen.secondaryActionCumulative))
        } else {
            _secondaryAction.modifier(secondaryActionModifier.concat(Fiori._ActivationScreen.secondaryAction))
        }
    }
	@ViewBuilder var textInput: some View {
        if isModelInit {
            _textInput.modifier(textInputModifier.concat(Fiori._ActivationScreen.textInput).concat(Fiori._ActivationScreen.textInputCumulative))
        } else {
            _textInput.modifier(textInputModifier.concat(Fiori._ActivationScreen.textInput))
        }
    }
    
	var isDescriptionTextEmptyView: Bool {
        ((isModelInit && isDescriptionTextNil) || DescriptionText.self == EmptyView.self) ? true : false
    }

	var isFootnoteEmptyView: Bool {
        ((isModelInit && isFootnoteNil) || Footnote.self == EmptyView.self) ? true : false
    }

	var isActionEmptyView: Bool {
        ((isModelInit && isActionNil) || ActionView.self == EmptyView.self) ? true : false
    }

	var isSecondaryActionEmptyView: Bool {
        ((isModelInit && isSecondaryActionNil) || SecondaryActionView.self == EmptyView.self) ? true : false
    }

	var isTextInputEmptyView: Bool {
        ((isModelInit && isTextInputNil) || TextInputView.self == EmptyView.self) ? true : false
    }
}

extension _ActivationScreen where Title == Text,
		DescriptionText == _ConditionalContent<Text, EmptyView>,
		Footnote == _ConditionalContent<Text, EmptyView>,
		ActionView == _ConditionalContent<_Action, EmptyView>,
		SecondaryActionView == _ConditionalContent<_Action, EmptyView>,
		TextInputView == _ConditionalContent<_TextInput, EmptyView> {

    public init(model: _ActivationScreenModel) {
        self.init(title: model.title, descriptionText: model.descriptionText, footnote: model.footnote, action: model.action != nil ? _Action(model: model.action!) : nil, secondaryAction: model.secondaryAction != nil ? _Action(model: model.secondaryAction!) : nil, textInput: model.textInput != nil ? _TextInput(model: model.textInput!) : nil)
    }

    public init(title: String, descriptionText: String? = nil, footnote: String? = nil, action: _Action? = nil, secondaryAction: _Action? = nil, textInput: _TextInput? = nil) {
        self._title = Text(title)
		self._descriptionText = descriptionText != nil ? ViewBuilder.buildEither(first: Text(descriptionText!)) : ViewBuilder.buildEither(second: EmptyView())
		self._footnote = footnote != nil ? ViewBuilder.buildEither(first: Text(footnote!)) : ViewBuilder.buildEither(second: EmptyView())
		self._action = action != nil ? ViewBuilder.buildEither(first: action!) : ViewBuilder.buildEither(second: EmptyView())
		self._secondaryAction = secondaryAction != nil ? ViewBuilder.buildEither(first: secondaryAction!) : ViewBuilder.buildEither(second: EmptyView())
		self._textInput = textInput != nil ? ViewBuilder.buildEither(first: textInput!) : ViewBuilder.buildEither(second: EmptyView())

		isModelInit = true
		isDescriptionTextNil = descriptionText == nil ? true : false
		isFootnoteNil = footnote == nil ? true : false
		isActionNil = action == nil ? true : false
		isSecondaryActionNil = secondaryAction == nil ? true : false
		isTextInputNil = textInput == nil ? true : false
    }
}
