//
//  ViewController.swift
//  UniversityConnect
//
//  Created by Abraham Calvillo on 2/11/21.
//
// EGR Building - (33.92833233, -117.4254362)
// Mission Hall - (33.92805191, -117.42417556)
// Chick-fil-a/ Yeager - (33.92946739, -117.42712679)
// Music Building - (33.92790127, -117.42591399)
// Events - (33.92714959, -117.4228487)







import UIKit
import Firebase
import FirebaseFirestore

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Buttons
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        setup()
        
        self.hideKeyboard()
    }

    
    func setup(){
        signInButton.layer.cornerRadius = signInButton.frame.height / 2.0
        signInButton.clipsToBounds = true
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        
        emailTextField.setBottomBorder(color: .lightGray, opacity: 0.75)
        passwordTextField.setBottomBorder(color: .lightGray, opacity: 0.75)
        passwordTextField.isSecureTextEntry = true
        
        // adding targets to change color of bottom bar when email/password fields
        // are selected/deselected or when a user is typing and the field is no longer
        // empty
        emailTextField.addTarget(self, action: #selector(ViewController.selectedField(_:)), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(ViewController.deselectField(_:)), for: UIControl.Event.editingDidEnd )
        passwordTextField.addTarget(self, action: #selector(ViewController.selectedField(_:)), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(ViewController.deselectField(_:)), for: UIControl.Event.editingDidEnd )
    }
    
    @objc func didTapSignInButton(){
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "university-connect-af50d.firebaseapp.com")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        
        if let email = emailTextField.text,
           let password = passwordTextField.text
        {
            if (!isValid(email: email, pass: password)){
                    return
                }
            Auth.auth().createUser(withEmail: email, password: password) {[weak self] (authResult, error) in
                if let user = authResult?.user {
                    if let strongSelf = self {
                        let user = User(uid: user.uid,
                                              email: user.email ?? "")
                        strongSelf.saveUserToServerIfNeeded(user: user, appIdentifier: "uniconnnect-ios")
                    }
                    
                    Auth.auth().currentUser?.sendEmailVerification { (error) in
                        if error != nil {
                          self?.showSignUpError(text: "Only users from verified Universities can join at this moment.")
                        return
                      }
                        self?.showSignUpError(text: "Check your email for a verfication link.")

                    }

                    
                }
                else {
                    self?.showSignUpError(text: error?.localizedDescription ?? "There was an error. Please try again later")
                }
            }
        }else {
            self.showGenericSignUpError()
        }
        
        return
    }
    
    fileprivate func showGenericSignUpError() {
        self.showSignUpError(text: "There was an error during the registration process. Please check all the fields and try again.")
    }

    fileprivate func showSignUpError(text: String) {
        let alert = UIAlertController(title: text, message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.display(alertController: alert)
    }
    
    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isValid(email: String, pass: String)-> Bool{
        
        if email.count < 2{
            return false
        }
        
        let emailRegEx = "[a-zA-Z0-9_.+-]+@(?:(?:[a-zA-Z0-9-]+\\.))?(calbaptist)\\.edu$"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if !emailPred.evaluate(with: email){
            showSignUpError(text: "Sorry! You must register with a CBU email address.")
            return false
        }
        
        return true
        
    }
    
    
    
    @objc func selectedField(_ sender: UITextField){
        sender.setBottomBorder(color: .systemTeal, opacity: 0.80)
    }
    @objc func deselectField (_ sender: UITextField){
        if(sender.text!.isEmpty){
            sender.setBottomBorder(color: .lightGray, opacity: 0.75)
        }
    }
    
    func saveUserToServerIfNeeded(user: User, appIdentifier: String) {
        let ref = Firestore.firestore().collection("user")
        if let uid = user.uid {
            var dict = user.representation
            dict["appIdentifier"] = appIdentifier
            ref.document(uid).setData(dict, merge: true)
        }
    }

}

