//
//  ViewController.swift
//  TextFieldAutocomplete
//
//  Created by Luana Telha on 19/02/2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Variables
    
    var containableView: ContentView {
        guard let view = view as? ContentView else {
            fatalError("Please implement 'loadView()' with proper view type in \(type(of: self))")
        }
        return view
    }
    
    lazy var autocomplete: AutocompleteViewController = {
        let vc = AutocompleteViewController(viewModel: .init(hasAdditionalItem: false), delegate: self)
        vc.setupAutocomplete(for: view)
        return vc
    }()
    
    var viewModel: ViewModel = .init()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInputBinding()
        viewModel.input.loadData?()
    }
    
    override func loadView() {
        loadContentView()
    }

    // MARK: - Load view
    
    func loadContentView() {
        view = ContentView()
    }
    
    // MARK: - Setup bindings
    
    func setupInputBinding() {
        containableView.onEndEditing = { _ in
            self.autocomplete.textFieldDidEndEditing()
        }
        
        containableView.onChange = { text in
            self.autocomplete.filter(text, in: self.viewModel.contacts)
        }
    }

}

extension ViewController: AutocompleteProtocol {
    
    var searchText: String? { containableView.textField.text }
    
    var textFieldContainerView: UIView { containableView.textField }
    
    var textFieldContainerFrame: CGRect {
        containableView.textField.convert(containableView.textField.bounds, to: view)
    }
    
    var cellType: UITableViewCell.Type { ContactCell.self }
    
    var heightForCells: CGFloat { 80 }
    
    var onItemSelection: ((AutocompleteSearchableItemProtocol) -> Void)? {
        nil
    }
    
    func cell(_ tableView: UITableView, in indexPath: IndexPath, with item: AutocompleteSearchableItemProtocol?) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactCell.self), for: indexPath) as? ContactCell,
            let item = item as? ContactItem
        else {
            return UITableViewCell()
        }
        cell.bind(name: item.name, number: item.phoneNumber)
        return cell
    }
        
}
