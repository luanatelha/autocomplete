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
    
    var model: AutocompleteModel
    var hasAdditionalItem: Bool {
        model.hasAdditionalItem ?? false
    }
    var items: [AutocompleteSearchableItemProtocol] {
        get {
            model.items ?? []
        }

        set {
            model.items = newValue
        }
    }
    var additionalItemType: UITableViewCell.Type {
        model.additionalItemType ?? UITableViewCell.self
    }
    var heightForAdditionalItem: CGFloat { model.heightForAdditionalItem ?? 0 }
    var onItemSelection: ((_ item: AutocompleteSearchableItemProtocol) -> Void) {
        model.onItemSelection ?? { _ in }
    }
    var onAdditionalItemSelection: (() -> Void) {
        model.onAdditionalItemSelection ?? {}
    }
    var setupAdditionalCell: ((UITableView, IndexPath) -> UITableViewCell) {
        model.setupAdditionalCell ?? { _, _ in UITableViewCell() }
    }
    
    // MARK: - Initialize
    
    public init(model: AutocompleteModel) {
        self.model = model
        setupBinding()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        input.search = { text in
            let newItems = self.filterItems(self.items, with: text)
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
        
    var numberOfRows: Int { items.count + hasAdditionalItem.intValue }
    
    var numberOfSections: Int { (items.count > 0 || hasAdditionalItem) ? 1 : 0 }
    
    func itemForIndex(_ indexPath: IndexPath) -> AutocompleteSearchableItemProtocol? {
        guard indexPath.row < items.count else { return .none }
        return items[indexPath.row]
    }
    
    func isAdditonalItem(_ indexPath: IndexPath) -> Bool {
        items.count == indexPath.row
    }
    
}

extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}
