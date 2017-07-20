//
//  UIViewControllerEx.swift
//  MyRecipez
//
//  Created by Dide van Berkel on 20/07/2017.
//  Copyright © 2017 Gary Grape Productions. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
