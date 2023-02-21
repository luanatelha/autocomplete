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
    
    lazy var autocompleteContacts: AutocompleteViewController = {
        let model = AutocompleteModel(
            textFieldView: containableView.textFieldContacts,
            textFieldFrame: containableView.textFieldContacts.convert(containableView.textFieldContacts.bounds, to: view),
            cellType: ContactCell.self,
            heightForCells: 80,
            setupCell: { tableView, indexPath, item in
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactCell.self), for: indexPath) as? ContactCell,
                    let item = item as? ContactItem
                else {
                    return UITableViewCell()
                }
                cell.bind(name: item.name, number: item.phoneNumber)
                return cell
            }
        )

        let vc = AutocompleteViewController(viewModel: .init(model: model))
        vc.setupAutocomplete(for: view)
        return vc
    }()
    
    lazy var autocompleteCountries: AutocompleteViewController = {
        let model = AutocompleteModel(
            textFieldView: containableView.textFieldCountries,
            textFieldFrame: containableView.textFieldCountries.convert(containableView.textFieldCountries.bounds, to: view),
            cellType: CountryCell.self,
            heightForCells: 80,
            setupCell: { tableView, indexPath, item in
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CountryCell.self), for: indexPath) as? CountryCell,
                    let item = item as? CountryItem
                else {
                    return UITableViewCell()
                }
                cell.bind(name: item.name, image: item.flag)
                return cell
            }
        )

        let vc = AutocompleteViewController(viewModel: .init(model: model))
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
        containableView.onEndEditingContact = { _ in
            self.autocompleteContacts.textFieldDidEndEditing()
        }
        
        containableView.onChangeContact = { text in
            self.autocompleteContacts.filter(text, in: self.viewModel.contacts)
        }
        
        containableView.onEndEditingCountry = { _ in
            self.autocompleteCountries.textFieldDidEndEditing()
        }
        
        containableView.onChangeCountry = { text in
            self.autocompleteCountries.filter(text, in: self.viewModel.countries)
        }
    }

}
