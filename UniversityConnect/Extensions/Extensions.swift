//
//  Extensions.swift
//  UniversityConnect
//
//  Created by Abraham Calvillo on 2/11/21.
//

import Foundation
import UIKit


extension UITextField {
    /// sets bottom border to text fields, such as in the sign in view controller
    func setBottomBorder(color: UIColor, opacity: Float) {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = 0.0
    }
}

extension UIViewController{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        //view.resignFirstResponder()
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
