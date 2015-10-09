//
//  ViewController.swift
//  Contact
//
//  Created by Ankit Goel on 06/10/15.
//  Copyright © 2015 ankitgoel. All rights reserved.
//

import UIKit
import AddressBook

class ViewController: UIViewController {

    var contactArray: [nameNumber] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let permission: Bool = contactsPermission()
        if permission {
            contactArray = getArray()
            for element in contactArray {
                print("\(element.name): \(element.number)")
            }
        } else {
            // Redirect user to settings or show popup regarding permission
        }
    }
}

