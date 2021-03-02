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
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Buttons
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!

    let userManager: SocialManagerProtocol? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        setup()
        
        self.hideKeyboard()
    }

    
    func setup(){
        signInButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        setupDesign()
       
    }
    
    func setupDesign(){
        
        emailTextField.setLeftPaddingPoints(10)
        passwordTextField.setLeftPaddingPoints(10)
        
        signInButton.layer.cornerRadius = 12
        signInButton.layer.shadowColor = #colorLiteral(red: 0.09411764706, green: 0.1333333333, blue: 0.4784313725, alpha: 1)
        signInButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        signInButton.layer.shadowOpacity = 0.2
        signInButton.layer.shadowRadius = CGFloat(3)
        
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
    
    
    
    @objc func didTapLoginButton() {
            if let email = emailTextField.text,
                let password = passwordTextField.text {
//                let hud = CPKProgressHUD.progressHUD(style: .loading(text: "Loading"))
//                hud.show(in: loginScreen.view)
                Auth.auth().signIn(withEmail: email, password: password) {[weak self] (dataResult, error) in
//                    hud.dismiss()
                    if let user = dataResult?.user {
                        if user.isEmailVerified {
                            _ = User(uid: user.uid,
                                                  email: user.email ?? "")
                            print("tapped login btn")
                            
                           
                            let mainstoryboard = UIStoryboard.init(name: "Home", bundle: nil)
                            let mapViewController = mainstoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                            _ = mapViewController.view // this will make sure view is loaded
                            self?.present(mapViewController, animated: true, completion: nil)
                        }
                        else{
                            self!.verify()
                        }
                        
                        
                    } else {
                        self?.showLoginError()
                    }
                }
            } else {
                self.showLoginError()
            }
            return
        
//        self.delegate?.loginManagerDidCompleteLogin(self, user: nil)
    }
    
    fileprivate func verify(){
        let refreshAlert = UIAlertController(title: "Unverified account", message: "Please verify your email address.", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Resend", style: .default, handler: { (action: UIAlertAction!) in
            
            Auth.auth().currentUser?.sendEmailVerification { (error) in
                if let error = error {
                    self.showSignUpError(text: "There was an error.")
                    return
                }
                
                self.showSignUpError(text: "Please check your email for a verification link.")
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        
        self.display(alertController: refreshAlert)
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
    
    fileprivate func showLoginError() {
        let alert = UIAlertController(title: "The login credentials are invalid. Please try again", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.display(alertController: alert)
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

