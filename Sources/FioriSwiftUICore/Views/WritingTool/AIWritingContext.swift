import FioriThemeManager
import Foundation
import os.log
import SwiftUI

class AIWritingContext: ObservableObject {
    @Published var originalValue: NSAttributedString
    @Published var displayedValue: NSMutableAttributedString
    
    @Published private var originalSelectedRange: NSRange? = nil
    @Published private var selectedRange: NSRange? = nil
    
    @Published var inProgress: Bool = false
    @Published var isPresented: Bool = false
    
    @Published var isFocused: Bool = false

    @Published var rewriteTextSet: [NSAttributedString] = []
    
    @Published var selection: AIWritingCommand? = nil
    
    // rewrite by last selection
    @Published var lastSelection: AIWritingCommand? = nil
    
    var indexOfCurrentValue: Int = -1
    
    var textIsChanged: Bool {
        self.displayedValue.string != self.originalValue.string
    }
    
    init(originalValue: NSAttributedString) {
        self.originalValue = originalValue
        self.rewriteTextSet = [originalValue]
        self.indexOfCurrentValue = 0
        self.displayedValue = NSMutableAttributedString(attributedString: originalValue)
    }
    
    func setSelectedRange(_ range: NSRange) {
        self.originalSelectedRange = range
        self.selectedRange = range
    }
    
    func removeSelection(_ actionType: AIWritingCommand) {
        self.lastSelection = actionType
        self.selection = nil
    }
    
    func addNewValue(_ value: String, for actionType: AIWritingCommand) {
        self.rewriteTextSet.append(NSAttributedString(string: value))
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
    
    func modifyRange(_ range: NSRange, withString string: NSAttributedString) {
        self.displayedValue.replaceCharacters(in: range, with: string)
        let newRange = NSRange(location: range.location, length: string.length)
        self.selectedRange = newRange
        self.highlightAIText(newRange)
    }
    
    func revertToOriginalValue() {
        self.selectedRange = self.originalSelectedRange
        self.displayedValue = NSMutableAttributedString(attributedString: self.originalValue)
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
        self.isPresented = false
    }
    
    func aiWritingDone() {
        self.styleHighlightedAIText()
        // trigger displayed value update manually
        self.displayedValue = self.displayedValue
        if let value = self.displayedValue.copy() as? NSAttributedString {
            self.originalValue = value
        } else {
            os_log("copy of display value should not be failed in AIWritingContext", log: OSLog.coreLogger, type: .error)
        }
        self.refreshContext()
        self.isPresented = false
    }
    
    func refreshContext() {
        self.originalSelectedRange = nil
        self.selectedRange = nil
        self.rewriteTextSet = [self.originalValue]
        self.indexOfCurrentValue = 0
        self.selection = nil
        self.lastSelection = nil
    }
    
    func highlightAIText(_ tintedRange: NSRange) {
        self.displayedValue.setAttributes([.foregroundColor: UIColor(Color.preferredColor(.tintColor)),
                                           .font: UIFont.preferredFioriFont(forTextStyle: .body)],
                                          range: tintedRange)
    }
    
    func styleHighlightedAIText() {
        if let range = self.selectedRange {
            self.displayedValue.setAttributes([.foregroundColor: UIColor(Color.preferredColor(.primaryLabel)),
                                               .font: UIFont.preferredFioriFont(forTextStyle: .body)],
                                              range: range)
        }
    }
}
