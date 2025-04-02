import FioriThemeManager
import Foundation
import SwiftUI

class AIWritingContext: ObservableObject {
    @Published var originalValue: String
    @Published var displayedValue: NSMutableAttributedString
    @Published var originalSelectedRange: NSRange? = nil
    @Published var selectedRange: NSRange? = nil
    
    @Published var inProgress: Bool = false
    @Published var isPresented: Bool = false
    
    @Published var rewriteTextSet: [String] = []
    
    @Published var selection: AIWritingCommand? = nil
    
    // rewrite by last selection
    @Published var lastSelection: AIWritingCommand? = nil
    
    var indexOfCurrentValue: Int = -1
    
    var textIsChanged: Bool {
        self.displayedValue.string != self.originalValue
    }
    
    init(originalValue: String) {
        self.originalValue = originalValue
        self.rewriteTextSet = [originalValue]
        self.indexOfCurrentValue = 0
        self.displayedValue = NSMutableAttributedString(string: originalValue)
        self.displayedValue.styleAIText()
    }
    
    func aiCommandHandler(_ actionType: AIWritingCommand) {
        self.lastSelection = actionType
        self.selection = nil
    }
    
    func addNewValue(_ value: String, for actionType: AIWritingCommand) {
        self.rewriteTextSet.append(value)
        self.indexOfCurrentValue = self.rewriteTextSet.count - 1
        self.handleDisplayedAttributedString()
        self.lastSelection = actionType
    }
    
    func handleDisplayedAttributedString() {
        let r: NSRange
        if let range = selectedRange, range.length > 0 {
            r = range
        } else {
            r = NSRange(location: 0, length: self.displayedValue.length)
        }
        if self.indexOfCurrentValue > 0,
           self.indexOfCurrentValue < self.rewriteTextSet.count
        {
            let lastModifiedString = self.rewriteTextSet[self.indexOfCurrentValue]
            self.modifyRange(r, withString: lastModifiedString)
        } else if self.indexOfCurrentValue == 0 {
            self.revertToOriginalValue()
        }
    }
    
    func modifyRange(_ range: NSRange, withString string: String) {
        self.displayedValue.replaceCharacters(in: range, with: string)
        let newRange = NSRange(location: range.location, length: string.count)
        self.selectedRange = newRange
        self.displayedValue.styleAIText(newRange)
    }
    
    func revertToOriginalValue() {
        self.selectedRange = self.originalSelectedRange
        self.displayedValue = NSMutableAttributedString(string: self.originalValue)
        self.displayedValue.styleAIText()
    }
    
    func rewriteAction() {
        if let s = lastSelection {
            self.selection = s
        } else {
            print("no last selection stored")
        }
    }
    
    func revertToPreviousValue() {
        if self.indexOfCurrentValue > 0 {
            self.indexOfCurrentValue -= 1
            self.handleDisplayedAttributedString()
        }
    }
    
    func forwardToNextValue() {
        if self.indexOfCurrentValue < self.rewriteTextSet.count - 1 {
            self.indexOfCurrentValue += 1
            self.handleDisplayedAttributedString()
        }
    }
    
    var revertIsEnabled: Bool {
        self.indexOfCurrentValue > 0
    }
    
    var forwardIsEnabled: Bool {
        self.indexOfCurrentValue < self.rewriteTextSet.count - 1
    }
    
    func cancelAction() {
        self.revertToOriginalValue()
        self.refreshContext()
    }
    
    func aiWritingDone() {
        self.displayedValue.styleAIText()
        self.originalValue = self.displayedValue.string
        self.refreshContext()
    }
    
    func refreshContext() {
        self.originalSelectedRange = nil
        self.selectedRange = nil
        self.rewriteTextSet = [self.originalValue]
        self.indexOfCurrentValue = 0
        self.selection = nil
        self.lastSelection = nil
    }
    
    static let enhanceText = "Enhanced aiText"
    static let shorterText = "Shorter aiText"
    static let longerText = "Longer aiText"
}

extension NSMutableAttributedString {
    func styleAIText(_ tintedRange: NSRange? = nil) {
        if let range = tintedRange {
            self.setAttributes([.foregroundColor: UIColor(Color.preferredColor(.primaryLabel)),
                                .font: UIFont.preferredFioriFont(forTextStyle: .body)],
                               range: NSRange(location: 0, length: self.length))
            self.setAttributes([.foregroundColor: UIColor(Color.preferredColor(.tintColor)),
                                .font: UIFont.preferredFioriFont(forTextStyle: .body)], range: range)
        } else {
            self.setAttributes([.foregroundColor: UIColor(Color.preferredColor(.primaryLabel)),
                                .font: UIFont.preferredFioriFont(forTextStyle: .body)],
                               range: NSRange(location: 0, length: self.length))
        }
    }
}
