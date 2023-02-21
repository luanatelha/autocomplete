//
//  ContactItem.swift
//  TextFieldAutocomplete
//
//  Created by Luana Telha on 20/02/2023.
//

import Foundation

struct ContactItem {
    let name: String
    let phoneNumber: String
}

extension ContactItem: AutocompleteSearchableItemProtocol {
    
    func search(_ searchText: String) -> Bool {
        return (
            name.match(pattern: "(^\\Q\(searchText.lowercased())\\E)|([ -]\\Q\(searchText.lowercased())\\E)") ||
            phoneNumber.prefix(searchText.count) == searchText
            )
    }
    
}

extension String {
    
    func match(pattern: String) -> Bool {
        let range: NSRange = .init(location: 0, length: count)
        var regex = NSRegularExpression()
        do {
            regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options())
            let matchesCount = regex.numberOfMatches(in: lowercased(), options: NSRegularExpression.MatchingOptions(), range: range)
            return matchesCount > 0
        } catch {
            return false
        }
    }
    
}
