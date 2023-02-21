//
//  ContentView.swift
//  TextFieldAutocomplete
//
//  Created by Luana Telha on 20/02/2023.
//

import UIKit

class ContentView: UIView {
    
    let textField: UITextField = Subviews.textField
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupTextField() {
        backgroundColor = .white
        addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 45),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
}

private enum Subviews {
    
    static var textField: UITextField {
        let textField = UITextField()
        textField.placeholder = "Search for contact"
        textField.borderStyle = .roundedRect
        return textField
    }
    
}
