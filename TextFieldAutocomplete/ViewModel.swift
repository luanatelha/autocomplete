//
//  ViewModel.swift
//  TextFieldAutocomplete
//
//  Created by Luana Telha on 21/02/2023.
//

import Foundation

class ViewModel {
    
    // MARK: Input
    
    struct ViewModelInput {
        var loadData: (() -> Void)?
    }
    
    // MARK: Output
    
    struct ViewModelOutput {}
    
    // MARK: Initialization
    
    var input: ViewModelInput = .init()
    var output: ViewModelOutput = .init()
    
    var contacts: [ContactItem] = []
    
    init() {
        setupBinding()
    }
    
    // MARK: Bindings
    
    private func setupBinding() {
        input.loadData = { [weak self] in
            ContactsManager.shared.contacts { contacts in
                self?.contacts = contacts
            }
        }
    
    }
    
}
