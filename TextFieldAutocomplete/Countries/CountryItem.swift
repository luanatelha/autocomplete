//
//  Countries.swift
//  TextFieldAutocomplete
//
//  Created by Luana Telha on 21/02/2023.
//

import Foundation
import UIKit

struct CountryItem {
    let name: String
    let flag: UIImage
    
    init(name: String) {
        self.name = name
        self.flag = UIImage(named: name) ?? UIImage()
    }
}

extension CountryItem: AutocompleteSearchableItemProtocol {
    
    func search(_ searchText: String) -> Bool {
        return name.match(pattern: "(^\\Q\(searchText.lowercased())\\E)")
    }
    
}

let countriesList = [
    "African Union",
    "Andorra",
    "Armenia",
    "Austria",
    "Bahamas",
    "Barbados",
    "Belarus",
    "Belgium",
    "Benin",
    "Bolivia",
    "Bosnia and Herzegovina",
    "Botswana",
    "Brazil",
    "Bulgaria",
    "Burkina Faso",
    "Cameroon",
    "Canada",
    "Chad",
    "Chile",
    "China",
    "Colombia",
    "Congo",
    "Czech Republic",
    "Denmark",
    "Egypt",
    "England",
    "Estonia",
    "Finland",
    "Flag Of Europe",
    "France",
    "Gabon",
    "Germany",
    "Germana",
    "Germanu1",
    "Germanu2",
    "Germanu3",
    "Germanu4",
    "Germanu5",
    "Germanu6",
    "Germanu7",
    "Germanu8",
    "Germanu9",
    "Germanu10",
    "Germanu11",
    "Great Britain",
    "Hungary",
    "Iceland",
    "Iran",
    "Ireland",
    "Italy",
    "Jamaica",
    "Kuwait",
    "Latvia",
    "Liberia",
    "Lithuania",
    "Macedonia",
    "Mali",
    "Netherlands",
    "New Zealand",
    "Norway",
    "Philippines",
    "Poland",
    "Portugal",
    "Romania",
    "Russian Federation",
    "Slovakia",
    "Slovenia",
    "Spain",
    "Sweden",
    "Switzerland",
    "Togo",
    "Turkey",
    "Ukraine",
    "USA",
    "Wales"
]
