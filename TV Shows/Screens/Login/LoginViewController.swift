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
    @IBOutlet private weak var scrollView: UIScrollView!
    
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
            case .success:
                if self.isRememberMeClicked {
                    if let authInfo = SessionManager.shared.authInfo {
                        KeychainManager.addAuthInfo(authInfo: authInfo)
                    }
                }
                self.navigationController?.setViewControllers([homeViewController], animated: true)
            case .failure:
                self.animateEmailAndPasswordFields()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showAlter(message: "Invalid login credentials. Please try again.")
                }
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
            case .success:
                if self.isRememberMeClicked {
                    if let authInfo = SessionManager.shared.authInfo {
                        KeychainManager.addAuthInfo(authInfo: authInfo)
                    }
                }
                self.navigationController?.setViewControllers([homeViewController], animated: true)
            case .failure:
                self.showAlter(message: "Email is not an email.")
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
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        #if DEBUG
        emailTextField.text = "ee@ee.ee"
        passwordTextField.text = "eeeeeeee"
        loginButton.isEnabled = true
        #endif
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
    
    private func animateEmailAndPasswordFields() {
        emailTextField.transform = CGAffineTransform(translationX: 12.0, y: 0)
        passwordTextField.transform = CGAffineTransform(translationX: 12.0, y: 0)
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.3,
            initialSpringVelocity: 0.8,
            options: .curveEaseInOut
        ) {
            self.emailTextField.transform = CGAffineTransform.identity
            self.passwordTextField.transform = CGAffineTransform.identity
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
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
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
