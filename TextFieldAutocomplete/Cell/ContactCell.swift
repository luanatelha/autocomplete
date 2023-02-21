//
//  ContactCell.swift
//  TextFieldAutocomplete
//
//  Created by Luana Telha on 21/02/2023.
//

import UIKit

class ContactCell: UITableViewCell {
    
    // MARK: Layout
    
    let nameLabel: UILabel = Subviews.nameLabel
    let numberLabel: UILabel = Subviews.numberLabel
    
    // MARK: Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupLayout() {
        let stackView = Subviews.stackView
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(numberLabel)
        
    }
    
    // MARK: - Bind
    
    func bind(name: String, number: String) {
        nameLabel.text = name
        numberLabel.text = number
    }
    
}

private enum Subviews {
    
    static var stackView: UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }
    
    static var nameLabel: UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .darkGray
        return label
    }
    
    static var numberLabel: UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }
    
}
