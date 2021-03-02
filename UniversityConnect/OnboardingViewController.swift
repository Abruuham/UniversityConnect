//
//  OnboardingViewController.swift
//  UniversityConnect
//
//  Created by Abraham Calvillo on 2/28/21.
//

import UIKit
import Hero
import Firebase
import FirebaseAuth

class OnboardingViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        
        setup()
    }
    
    
    func setup(){
        setupBtnDesign()
        
        
    }
    
    
    func setupBtnDesign(){
        signUpBtn.layer.cornerRadius = 12
        signUpBtn.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        signUpBtn.layer.shadowOffset = CGSize(width: 0, height: 5)
        signUpBtn.layer.shadowOpacity = 0.3
        
        signInBtn.layer.cornerRadius = 12
        signInBtn.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        signInBtn.layer.shadowOffset = CGSize(width: 0, height: 5)
        signInBtn.layer.shadowOpacity = 0.2
        signInBtn.layer.shadowRadius = CGFloat(3)
        
    }
    
    
}
