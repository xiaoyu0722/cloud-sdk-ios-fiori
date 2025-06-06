// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import SwiftUI

public struct _WelcomeScreen<Title: View, DescriptionText: View, Subtitle: View, Footnote: View, Icon: View, TextInputView: View, ActionView: View, SecondaryActionView: View> {
    @Environment(\.titleModifier) private var titleModifier
	@Environment(\.descriptionTextModifier) private var descriptionTextModifier
	@Environment(\.subtitleModifier) private var subtitleModifier
	@Environment(\.footnoteModifier) private var footnoteModifier
	@Environment(\.iconModifier) private var iconModifier
	@Environment(\.textInputModifier) private var textInputModifier
	@Environment(\.actionModifier) private var actionModifier
	@Environment(\.secondaryActionModifier) private var secondaryActionModifier
	@Environment(\.horizontalSizeClass) var horizontalSizeClass

    let _title: Title
	let _descriptionText: DescriptionText
	let _subtitle: Subtitle
	let _footnote: Footnote
	let _icon: Icon
	let _textInput: TextInputView
	let _action: ActionView
	let _secondaryAction: SecondaryActionView
	

    private var isModelInit: Bool = false
	private var isDescriptionTextNil: Bool = false
	private var isSubtitleNil: Bool = false
	private var isFootnoteNil: Bool = false
	private var isIconNil: Bool = false
	private var isTextInputNil: Bool = false
	private var isActionNil: Bool = false
	private var isSecondaryActionNil: Bool = false

    public init(
        @ViewBuilder title: () -> Title,
		@ViewBuilder descriptionText: () -> DescriptionText,
		@ViewBuilder subtitle: () -> Subtitle,
		@ViewBuilder footnote: () -> Footnote,
		@ViewBuilder icon: () -> Icon,
		@ViewBuilder textInput: () -> TextInputView,
		@ViewBuilder action: () -> ActionView,
		@ViewBuilder secondaryAction: () -> SecondaryActionView
        ) {
            self._title = title()
			self._descriptionText = descriptionText()
			self._subtitle = subtitle()
			self._footnote = footnote()
			self._icon = icon()
			self._textInput = textInput()
			self._action = action()
			self._secondaryAction = secondaryAction()
    }

    @ViewBuilder var title: some View {
        if isModelInit {
            _title.modifier(titleModifier.concat(Fiori._WelcomeScreen.title).concat(Fiori._WelcomeScreen.titleCumulative))
        } else {
            _title.modifier(titleModifier.concat(Fiori._WelcomeScreen.title))
        }
    }
	@ViewBuilder var descriptionText: some View {
        if isModelInit {
            _descriptionText.modifier(descriptionTextModifier.concat(Fiori._WelcomeScreen.descriptionText).concat(Fiori._WelcomeScreen.descriptionTextCumulative))
        } else {
            _descriptionText.modifier(descriptionTextModifier.concat(Fiori._WelcomeScreen.descriptionText))
        }
    }
	@ViewBuilder var subtitle: some View {
        if isModelInit {
            _subtitle.modifier(subtitleModifier.concat(Fiori._WelcomeScreen.subtitle).concat(Fiori._WelcomeScreen.subtitleCumulative))
        } else {
            _subtitle.modifier(subtitleModifier.concat(Fiori._WelcomeScreen.subtitle))
        }
    }
	@ViewBuilder var footnote: some View {
        if isModelInit {
            _footnote.modifier(footnoteModifier.concat(Fiori._WelcomeScreen.footnote).concat(Fiori._WelcomeScreen.footnoteCumulative))
        } else {
            _footnote.modifier(footnoteModifier.concat(Fiori._WelcomeScreen.footnote))
        }
    }
	@ViewBuilder var icon: some View {
        if isModelInit {
            _icon.modifier(iconModifier.concat(Fiori._WelcomeScreen.icon).concat(Fiori._WelcomeScreen.iconCumulative))
        } else {
            _icon.modifier(iconModifier.concat(Fiori._WelcomeScreen.icon))
        }
    }
	@ViewBuilder var textInput: some View {
        if isModelInit {
            _textInput.modifier(textInputModifier.concat(Fiori._WelcomeScreen.textInput).concat(Fiori._WelcomeScreen.textInputCumulative))
        } else {
            _textInput.modifier(textInputModifier.concat(Fiori._WelcomeScreen.textInput))
        }
    }
	@ViewBuilder var action: some View {
        if isModelInit {
            _action.modifier(actionModifier.concat(Fiori._WelcomeScreen.action).concat(Fiori._WelcomeScreen.actionCumulative))
        } else {
            _action.modifier(actionModifier.concat(Fiori._WelcomeScreen.action))
        }
    }
	@ViewBuilder var secondaryAction: some View {
        if isModelInit {
            _secondaryAction.modifier(secondaryActionModifier.concat(Fiori._WelcomeScreen.secondaryAction).concat(Fiori._WelcomeScreen.secondaryActionCumulative))
        } else {
            _secondaryAction.modifier(secondaryActionModifier.concat(Fiori._WelcomeScreen.secondaryAction))
        }
    }
    
	var isDescriptionTextEmptyView: Bool {
        ((isModelInit && isDescriptionTextNil) || DescriptionText.self == EmptyView.self) ? true : false
    }

	var isSubtitleEmptyView: Bool {
        ((isModelInit && isSubtitleNil) || Subtitle.self == EmptyView.self) ? true : false
    }

	var isFootnoteEmptyView: Bool {
        ((isModelInit && isFootnoteNil) || Footnote.self == EmptyView.self) ? true : false
    }

	var isIconEmptyView: Bool {
        ((isModelInit && isIconNil) || Icon.self == EmptyView.self) ? true : false
    }

	var isTextInputEmptyView: Bool {
        ((isModelInit && isTextInputNil) || TextInputView.self == EmptyView.self) ? true : false
    }

	var isActionEmptyView: Bool {
        ((isModelInit && isActionNil) || ActionView.self == EmptyView.self) ? true : false
    }

	var isSecondaryActionEmptyView: Bool {
        ((isModelInit && isSecondaryActionNil) || SecondaryActionView.self == EmptyView.self) ? true : false
    }
}

extension _WelcomeScreen where Title == Text,
		DescriptionText == _ConditionalContent<Text, EmptyView>,
		Subtitle == _ConditionalContent<Text, EmptyView>,
		Footnote == _ConditionalContent<Text, EmptyView>,
		Icon == _ConditionalContent<Image, EmptyView>,
		TextInputView == _ConditionalContent<_TextInput, EmptyView>,
		ActionView == _ConditionalContent<_Action, EmptyView>,
		SecondaryActionView == _ConditionalContent<_Action, EmptyView> {

    public init(model: _WelcomeScreenModel) {
        self.init(title: model.title, descriptionText: model.descriptionText, subtitle: model.subtitle, footnote: model.footnote, icon: model.icon, textInput: model.textInput != nil ? _TextInput(model: model.textInput!) : nil, action: model.action != nil ? _Action(model: model.action!) : nil, secondaryAction: model.secondaryAction != nil ? _Action(model: model.secondaryAction!) : nil)
    }

    public init(title: String, descriptionText: String? = nil, subtitle: String? = nil, footnote: String? = nil, icon: Image? = nil, textInput: _TextInput? = nil, action: _Action? = nil, secondaryAction: _Action? = nil) {
        self._title = Text(title)
		self._descriptionText = descriptionText != nil ? ViewBuilder.buildEither(first: Text(descriptionText!)) : ViewBuilder.buildEither(second: EmptyView())
		self._subtitle = subtitle != nil ? ViewBuilder.buildEither(first: Text(subtitle!)) : ViewBuilder.buildEither(second: EmptyView())
		self._footnote = footnote != nil ? ViewBuilder.buildEither(first: Text(footnote!)) : ViewBuilder.buildEither(second: EmptyView())
		self._icon = icon != nil ? ViewBuilder.buildEither(first: icon!) : ViewBuilder.buildEither(second: EmptyView())
		self._textInput = textInput != nil ? ViewBuilder.buildEither(first: textInput!) : ViewBuilder.buildEither(second: EmptyView())
		self._action = action != nil ? ViewBuilder.buildEither(first: action!) : ViewBuilder.buildEither(second: EmptyView())
		self._secondaryAction = secondaryAction != nil ? ViewBuilder.buildEither(first: secondaryAction!) : ViewBuilder.buildEither(second: EmptyView())

		isModelInit = true
		isDescriptionTextNil = descriptionText == nil ? true : false
		isSubtitleNil = subtitle == nil ? true : false
		isFootnoteNil = footnote == nil ? true : false
		isIconNil = icon == nil ? true : false
		isTextInputNil = textInput == nil ? true : false
		isActionNil = action == nil ? true : false
		isSecondaryActionNil = secondaryAction == nil ? true : false
    }
}
