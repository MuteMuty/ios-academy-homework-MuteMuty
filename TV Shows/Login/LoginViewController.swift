    //
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 11.07.2022..
//

import UIKit
import MBProgressHUD
import Alamofire

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var loginTextLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var rememberMeButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    
    // MARK: - Properties
    
    private var isPasswordShown: Bool = false
    private var isRememberMeClicked: Bool = false
    private let passwordVisibilityButton = UIButton()
    private var service = Service()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        setUpUI()
        dismissKeyboard()
    }
    
    // MARK: - Actions
    
    @IBAction func emailTextChanged() {
        setButtons()
    }
    @IBAction func passwordTextChanged() {
        setButtons()
    }
    
    @IBAction func rememberMeButtonClicked() {
        rememberMeButton.setImage(UIImage(named: isRememberMeClicked ? "ic-checkbox-unselected.pdf" : "ic-checkbox-selected.pdf"), for: .normal)
        isRememberMeClicked.toggle()
    }
    
    @IBAction func loginButtonClicked() {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        service.login(email: email, password: password) {  [weak self] dataResponse in
            guard let self = self else { return }
            MBProgressHUD.hide(for: self.view, animated: true)
            
            switch dataResponse.result {
            case .success(let userResponse):
                let headers = dataResponse.response?.headers.dictionary ?? [:]
                let authInfo = self.handleSuccessfulLogin(headers: headers)
                SessionManager.shared.storeAuthInfo(headers: headers)
                homeViewController.user = userResponse.user
                homeViewController.authInfo = authInfo
                self.navigationController?.setViewControllers([homeViewController], animated: true)
            case .failure:
                let alert = UIAlertController(title: "", message: "Invalid login credentials. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func registerButtonClicked() {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        service.register(email: email, password: password) {  [weak self] dataResponse in
            guard let self = self else { return }
            MBProgressHUD.hide(for: self.view, animated: true)
            
            switch dataResponse.result {
            case .success(let userResponse):
                let headers = dataResponse.response?.headers.dictionary ?? [:]
                let authInfo = self.handleSuccessfulLogin(headers: headers)
                homeViewController.user = userResponse.user
                homeViewController.authInfo = authInfo
                self.navigationController?.setViewControllers([homeViewController], animated: true)
            case .failure:
                let alert = UIAlertController(title: "", message: "Email is not an email.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK: - Utility methods
    
    private func setUpUI() {
        passwordVisibilityButton.setTitle("", for: .normal)
        passwordVisibilityButton.setImage(UIImage(named: "ic-visible.pdf"), for: .normal)
        passwordVisibilityButton.addTarget(self, action: #selector(self.showPasswordButtonClicked), for: .touchUpInside)
        passwordTextField.rightViewMode = UITextField.ViewMode.always
        passwordTextField.rightView = passwordVisibilityButton
        disableButtons()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    private func enableButtons() {
        loginButton.isEnabled = true
        registerButton.isEnabled = true
    }
    
    private func disableButtons() {
        loginButton.isEnabled = false
        registerButton.isEnabled = false
    }
    
    private func setButtons() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        if !email.isEmpty && !password.isEmpty {
            enableButtons()
            loginButton.backgroundColor = UIColor(white: 1, alpha: 1)
        } else {
            disableButtons()
            loginButton.backgroundColor = UIColor(white: 1, alpha: 0.3)
        }
    }
    
    @objc private func showPasswordButtonClicked() {
        passwordVisibilityButton.setImage(UIImage(named: isPasswordShown ? "ic-visible.pdf" : "ic-invisible.pdf"), for: .normal)
        passwordTextField.isSecureTextEntry = isPasswordShown
        isPasswordShown.toggle()
    }
    
    private func handleSuccessfulLogin(headers: [String: String]) -> AuthInfo {
        guard let authInfo = try? AuthInfo(headers: headers) else {
            return try! AuthInfo(headers: [:])
        }
        return authInfo
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBasedNextTextField(textField)
        return true
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        default:
            passwordTextField.resignFirstResponder()
        }
    }
}

extension UIViewController {
    
    func dismissKeyboard() {
       let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(UIViewController.dismissKeyboardTouchOutside))
       tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboardTouchOutside() {
       view.endEditing(true)
    }
}
