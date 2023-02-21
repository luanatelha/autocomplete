//
//  AutocompleteSearchManager.swift
//  Interface
//
//  Created by TELHA LUANA on 15/01/2023.
//

import Foundation
import UIKit

public struct AutocompleteModel {
    public var items: [AutocompleteSearchableItemProtocol]?
    public var hasAdditionalItem: Bool?
    public var textFieldView: UIView
    public var textFieldFrame: CGRect
    public var cellType: UITableViewCell.Type
    public var additionalItemType: UITableViewCell.Type?
    public var heightForCells: CGFloat
    public var heightForAdditionalItem: CGFloat?
    public var onItemSelection: ((_ item: AutocompleteSearchableItemProtocol) -> Void)?
    public var onAdditionalItemSelection: (() -> Void)?
    public var setupCell: ((UITableView, IndexPath, AutocompleteSearchableItemProtocol?) -> UITableViewCell)
    public var setupAdditionalCell: ((UITableView, IndexPath) -> UITableViewCell)?
}

public protocol AutocompleteSearchableItemProtocol {
    func search(_ searchText: String) -> Bool
}
