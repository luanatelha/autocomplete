//
//  ContentView.swift
//  TextFieldAutocomplete
//
//  Created by Luana Telha on 20/02/2023.
//

import UIKit

class ContentView: UIView {
    
    // MARK: - Layout
    
    let textFieldContacts: UITextField = Subviews.textFieldContacts
    let textFieldCountries: UITextField = Subviews.textFieldCountries
    
    // MARK: - Variables
    
    var onChangeContact: ((String?) -> Void)?
    var onEndEditingContact: ((String?) -> Void)?
    
    var onChangeCountry: ((String?) -> Void)?
    var onEndEditingCountry: ((String?) -> Void)?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupLayout() {
        backgroundColor = .white
        addSubview(textFieldContacts)
        
        textFieldContacts.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textFieldContacts.heightAnchor.constraint(equalToConstant: 45),
            textFieldContacts.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            textFieldContacts.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textFieldContacts.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        textFieldContacts.delegate = self
        
        addSubview(textFieldCountries)
        
        textFieldCountries.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textFieldCountries.heightAnchor.constraint(equalToConstant: 45),
            textFieldCountries.topAnchor.constraint(equalTo: textFieldContacts.bottomAnchor, constant: 100),
            textFieldCountries.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textFieldCountries.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        textFieldCountries.delegate = self
    }
    
}

extension ContentView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textFieldContacts {
            onEndEditingContact?(textField.text)
        }
        if textField == textFieldCountries {
            onEndEditingCountry?(textField.text)
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == textFieldContacts {
            onChangeContact?(textField.text)
        }
        if textField == textFieldCountries {
            onChangeCountry?(textField.text)
        }
    }
    
}

private enum Subviews {
    
    static var textFieldContacts: UITextField {
        let textField = UITextField()
        textField.placeholder = "Search for contact"
        textField.borderStyle = .roundedRect
        return textField
    }
    
    static var textFieldCountries: UITextField {
        let textField = UITextField()
        textField.placeholder = "Search for country"
        textField.borderStyle = .roundedRect
        return textField
    }
    
}
