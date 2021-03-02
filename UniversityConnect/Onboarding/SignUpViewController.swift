//
//  SignUpViewController.swift
//  UniversityConnect
//
//  Created by Abraham Calvillo on 3/1/21.
//

import UIKit
import Hero
import Firebase
import FirebaseAuth



class SignUpViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var tos: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.hideKeyboard()
        setup()
        
    }
    
    
    func setup(){
        signUpBtn.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        
        setupDesign()
        terms()
    }
    
    
    
    
    // setting up the design layout for the current view
    func setupDesign(){
        nameTextField.setLeftPaddingPoints(10)
        emailTextField.setLeftPaddingPoints(10)
        passwordTextField.setLeftPaddingPoints(10)
        
        signUpBtn.layer.cornerRadius = 12
        signUpBtn.layer.shadowColor = #colorLiteral(red: 0.09411764706, green: 0.1333333333, blue: 0.4784313725, alpha: 1)
        signUpBtn.layer.shadowOffset = CGSize(width: 0, height: 5)
        signUpBtn.layer.shadowOpacity = 0.2
        signUpBtn.layer.shadowRadius = CGFloat(3)
        
        nameTextField.layer.cornerRadius = 15
        nameTextField.layer.borderColor = #colorLiteral(red: 0.1529411765, green: 0.2274509804, blue: 0.8980392157, alpha: 1)
        nameTextField.layer.borderWidth = CGFloat(2)
        nameTextField.layer.shadowColor = #colorLiteral(red: 0.1529411765, green: 0.1725490196, blue: 0.6117647059, alpha: 1)
        nameTextField.layer.shadowOffset = CGSize(width: 0, height: 12)
        nameTextField.layer.shadowRadius = CGFloat(8)
        nameTextField.layer.shadowOpacity = 0.1
        
        emailTextField.layer.cornerRadius = 15
        emailTextField.layer.borderColor = #colorLiteral(red: 0.1529411765, green: 0.2274509804, blue: 0.8980392157, alpha: 1)
        emailTextField.layer.borderWidth = CGFloat(2)
        emailTextField.layer.shadowColor = #colorLiteral(red: 0.1529411765, green: 0.1725490196, blue: 0.6117647059, alpha: 1)
        emailTextField.layer.shadowOffset = CGSize(width: 0, height: 12)
        emailTextField.layer.shadowRadius = CGFloat(8)
        emailTextField.layer.shadowOpacity = 0.1
        
        passwordTextField.layer.cornerRadius = 15
        passwordTextField.layer.borderColor = #colorLiteral(red: 0.1529411765, green: 0.2274509804, blue: 0.8980392157, alpha: 1)
        passwordTextField.layer.borderWidth = CGFloat(2)
        passwordTextField.layer.shadowColor = #colorLiteral(red: 0.1529411765, green: 0.1725490196, blue: 0.6117647059, alpha: 1)
        passwordTextField.layer.shadowOffset = CGSize(width: 0, height: 12)
        passwordTextField.layer.shadowRadius = CGFloat(8)
        passwordTextField.layer.shadowOpacity = 0.1
    }
    
    
    func terms(){
        let linkedText = "Terms of Service"
        let string = "By creating an account you agree with our " + linkedText + "."
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(.link,
                                      value: "https://pastebin.com/raw/nbJYQfAd",
                                      range: NSRange(location: string.count - 1 - linkedText.count, length: linkedText.count))
        tos.attributedText = attributedString
        tos.delegate = self
        tos.textColor = .gray
        tos.textAlignment = .center
        
    }
    @objc func didTapSignInButton(){
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "university-connect-af50d.firebaseapp.com")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        
        if let email = emailTextField.text,
           let password = passwordTextField.text,
           let name = nameTextField.text
        {
            // checks to see if the following parameters are valid before continuing
            if (!isValid(email: email, pass: password, username: name)){
                return
            }
            // if user is valid, then it will create a user in the authentication tab of firebase
            Auth.auth().createUser(withEmail: email, password: password) {[weak self] (authResult, error) in
                if let user = authResult?.user {
                    if let strongSelf = self {
                        let user = User(uid: user.uid,
                                        email: user.email ?? ""
                        )
                        strongSelf.saveUserToServerIfNeeded(user: user, appIdentifier: "uniconnnect-ios", username: name)
                    }
                    
                    // sends verification email to user. Before they are able to sign in they must
                    // verify their email
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
    
    
    // Checking to make sure that email, password and username are all valid
    // and not empty. If empty, then an error message will be displayed to the user
    func isValid(email: String, pass: String, username: String)-> Bool{
        if username.count < 2 || username.isEmpty{
            self.showSignUpError(text: "Name cannot be blank.")
            return false
        }
        if email.count < 2 || email.isEmpty{
            self.showSignUpError(text: "Email cannot be blank")
            return false
        }
        
        if pass.count < 2 || pass.isEmpty{
            self.showSignUpError(text: "{Password cannot be blank.")
            return false
        }
        
        /// currently, users must be from cbu and have a cbu email address
        let emailRegEx = "[a-zA-Z0-9_.+-]+@(?:(?:[a-zA-Z0-9-]+\\.))?(calbaptist)\\.edu$"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if !emailPred.evaluate(with: email){
            showSignUpError(text: "Sorry! You must register with a CBU email address.")
            return false
        }
        
        
        return true
        
    }
    
    // saves the users information to cloud firestore
    func saveUserToServerIfNeeded(user: User, appIdentifier: String, username: String) {
        let ref = Firestore.firestore().collection("user")
        if let uid = user.uid {
            var dict = user.representation
            dict["appIdentifier"] = appIdentifier
            dict["username"] = username
            ref.document(uid).setData(dict, merge: true)
        }
    }
    
}


// extension to set padding to the user textfield as appropriate
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
