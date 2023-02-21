//
//  AutocompleteViewModel.swift
//  Interface
//
//  Created by TELHA LUANA on 15/01/2023.
//

import Foundation
import UIKit

extension AutocompleteViewModel {
    
    // MARK: - Input
    
    public struct AutocompleteViewModelInput {
        var search: ((String?) -> Void)?
    }
    
    // MARK: - Output
    
    public struct AutocompleteViewModelOutput {
        var onSearchResults: (([AutocompleteSearchableItemProtocol], Bool) -> Void)?
    }
    
}

final public class AutocompleteViewModel {
    
    // MARK: - Input, Output
    public var input: AutocompleteViewModelInput = .init()
    public var output: AutocompleteViewModelOutput = .init()
    
    // MARK: - Properties
    
    private var model: AutocompleteModel = .empty
    var hasAdditionalItem: Bool
    
    var items: [AutocompleteSearchableItemProtocol] {
        get {
            model.items
        }

        set {
            model = .init(items: newValue)
        }
    }
    
    // MARK: - Initialize
    
    public init(hasAdditionalItem: Bool = false) {
        self.hasAdditionalItem = hasAdditionalItem
        setupBinding()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        input.search = { text in
            let newItems = self.filterItems(self.model.items, with: text)
            self.output.onSearchResults?(newItems, !(text ?? "").isEmpty)
        }
    }
    
    func boldSearchText(_ pattern: String, in text: String?, with pointSize: CGFloat) -> NSAttributedString? {
        guard let text = text else { return nil }
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        let range: NSRange = .init(location: 0, length: min(text.count, pattern.count))
        var regex = NSRegularExpression()
        do {
            regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options())
            regex.enumerateMatches(in: text.lowercased(), options: NSRegularExpression.MatchingOptions(), range: range) { (textCheckingResult, _, _) in
                let subRange = textCheckingResult?.range
                let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: pointSize)]
                attributedString.addAttributes(attributes, range: subRange!)
            }
        } catch {
            print(error.localizedDescription)
        }
        return attributedString
    }
    
    private func filterItems(_ items: [AutocompleteSearchableItemProtocol], with text: String?) -> [AutocompleteSearchableItemProtocol] {
        guard let text = text, text != "" else { return items }
        return items.filter { (item) -> Bool in
            item.search(text)
        }
    }
    
}

// MARK: - TableView configuration

extension AutocompleteViewModel {
        
    var numberOfRows: Int { model.items.count + hasAdditionalItem.intValue }
    
    var numberOfSections: Int { (model.items.count > 0 || hasAdditionalItem) ? 1 : 0 }
    
    func itemForIndex(_ indexPath: IndexPath) -> AutocompleteSearchableItemProtocol? {
        guard indexPath.row < model.items.count else { return .none }
        return model.items[indexPath.row]
    }
    
    func isAdditonalItem(_ indexPath: IndexPath) -> Bool {
        model.items.count == indexPath.row
    }
    
}

extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}
