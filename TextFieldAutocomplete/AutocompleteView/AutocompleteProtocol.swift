//
//  AutocompleteSearchManager.swift
//  Interface
//
//  Created by TELHA LUANA on 15/01/2023.
//

import Foundation
import UIKit

public protocol AutocompleteProtocol: AnyObject {
    var searchText: String? { get }
    var textFieldContainerView: UIView { get }
    var textFieldContainerFrame: CGRect { get }
    var cellType: UITableViewCell.Type { get }
    var additionalItemType: UITableViewCell.Type? { get }
    var heightForCells: CGFloat { get }
    var heightForAdditionalItem: CGFloat? { get }
    var onItemSelection: ((_ item: AutocompleteSearchableItemProtocol) -> Void)? { get }
    var onAdditionalItemSelection: ((String?) -> Void)? { get }
    func cell(_ tableView: UITableView, in indexPath: IndexPath, with item: AutocompleteSearchableItemProtocol?) -> UITableViewCell
    func additionalCell(_ tableView: UITableView, in indexPath: IndexPath) -> UITableViewCell
}

extension AutocompleteProtocol {
    var additionalItemType: UITableViewCell.Type? { nil }
    var heightForAdditionalItem: CGFloat? { .zero }
    var onAdditionalItemSelection: ((String?) -> Void)? { nil }
    
    func additionalCell(_ tableView: UITableView, in indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

public protocol AutocompleteSearchableItemProtocol {
    func search(_ searchText: String) -> Bool
}

public struct AutocompleteModel {
    public let items: [AutocompleteSearchableItemProtocol]
}

extension AutocompleteModel {
    static var empty: AutocompleteModel {
        .init(items: [])
    }
}
