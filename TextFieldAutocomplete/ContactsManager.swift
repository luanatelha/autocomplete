//
//  ContactsManager.swift
//  TextFieldAutocomplete
//
//  Created by Luana Telha on 20/02/2023.
//

import Foundation
import Contacts

class ContactsManager {
    
    static var shared: ContactsManager = ContactsManager()
    
    var contactStore: CNContactStore = CNContactStore()
    var contacts: [ContactItem] = []
    
    func contacts(completion: @escaping ([ContactItem]) -> Void) {
        contactStore.requestAccess(for: .contacts) { granted, error in
            guard granted, error == nil  else {
                NSLog("\(String(describing: error))")
                return
            }
            self.getContacts(completion: completion)
        }
    }
    
    private func getContacts(completion:  @escaping ([ContactItem]) -> Void) {
        
        let keysToFetch: [CNKeyDescriptor]? = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey
        ] as? [CNKeyDescriptor]
        
        let fetchRequest: CNContactFetchRequest = .init(keysToFetch: keysToFetch ?? [])
        
        do {
            try contactStore.enumerateContacts(with: fetchRequest) { (contact, _) -> Void in
                let formatter: CNContactFormatter = CNContactFormatter()
                formatter.style = .fullName
                let fullName = formatter.string(from: contact)
                let phoneNumber = contact.phoneNumbers.first?.value.stringValue
                
                self.contacts.append(
                    ContactItem(
                        name: fullName ?? "(empty)",
                        phoneNumber: phoneNumber ?? "(empty)"
                    )
                )
            }
        } catch let error as NSError {
            NSLog("\(error)")
        }
        
    }
}
