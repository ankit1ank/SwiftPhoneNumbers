//
//  ContactArray.swift
//  Contact
//
//  Created by Ankit Goel on 06/10/15.
//  Copyright © 2015 ankitgoel. All rights reserved.
//

import Foundation
import AddressBook

struct nameNumber {
    let name: String
    let number: String
}

var addressBook: ABAddressBookRef?

func getArray() -> [nameNumber] {
    createAddressBook()
    return readFromAddressBook(addressBook!)
}

func createAddressBook() {
    var error: Unmanaged<CFError>?
    addressBook = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
}

func contactsPermission() -> Bool {
    switch ABAddressBookGetAuthorizationStatus() {
    case .Authorized:
        //print("Already Authorized")
        createAddressBook()
        return true
    case .Denied, .Restricted:
        //print("Access Denied")
        return false
    case .NotDetermined:
        //print("Access not determined")
        let access: Bool = false
        createAddressBook()
        if let theBook: ABAddressBookRef = addressBook {
            ABAddressBookRequestAccessWithCompletion(theBook,
                { (granted: Bool, error: CFError!) in
                    if granted {
                        print("Access granted")
                    } else {
                        print("Access denied")
                    }
            })
        }
        return access
    }
}

func readFromAddressBook(addressBook: ABAddressBookRef) -> [nameNumber] {
    var contactArray: [nameNumber] = []
    let allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray
    
    for person: ABRecordRef in allPeople {
        var compositeName = ""
        let cName = ABRecordCopyCompositeName(person)
        // Check if composite name is not nil
        if cName != nil {
            compositeName = cName.takeRetainedValue() as String
        }
        
        // Check if contact has atleast one phone number added
        let phones: ABMultiValueRef? = ABRecordCopyValue(person, kABPersonPhoneProperty)?.takeRetainedValue()
        if phones != nil && compositeName != "" {
            for counter in 0..<ABMultiValueGetCount(phones) {
                let phone = ABMultiValueCopyValueAtIndex(phones, counter).takeRetainedValue() as! String
                contactArray.append(nameNumber(name: compositeName, number: phone))
            }
        }
    }
    return contactArray
}