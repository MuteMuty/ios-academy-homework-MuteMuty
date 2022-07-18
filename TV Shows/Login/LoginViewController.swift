    //
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 11.07.2022..
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var loginTextLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Properties
    
    private var email: String = ""
    private var password: String = ""
    private var isPasswordShown: Bool = false
    private var isRememberMeClicked: Bool = false
    private let button = UIButton(frame: CGRect(x: 100, y: 100, width: 24, height: 24))
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        setUpUI()
    }
    
    // MARK: - Actions
    
    @IBAction func emailTextChanged() {
        email = emailTextField.text ?? ""
        setButtons()
    }
    @IBAction func passwordTextChanged() {
        password = passwordTextField.text ?? ""
        setButtons()
    }
    
    @IBAction func rememberMeButtonClicked() {
        if !isRememberMeClicked {
            rememberMeButton.setImage(UIImage(named: "ic-checkbox-selected.pdf"), for: .normal)
        } else {
            rememberMeButton.setImage(UIImage(named: "ic-checkbox-unselected.pdf"), for: .normal)
        }
        isRememberMeClicked = !isRememberMeClicked
    }
    
    
    // MARK: - Utility methods

    private func getColorValue() -> CGFloat {
        return CGFloat.random(in: 0..<1)
    }
    
    private func setUpUI() {
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "ic-visible.pdf") as UIImage?, for: .normal)
        button.addTarget(self, action: #selector(self.showPasswordButtonClicked), for: .touchUpInside)
        passwordTextField.rightViewMode = UITextField.ViewMode.always
        passwordTextField.rightView = button
        disableButtons()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    private func enableButtons() {
        loginButton.isEnabled = true
        registerButton.isEnabled = true
        loginButton.backgroundColor = UIColor(white: 1, alpha: 1)
        //loginButton.setTitleColor(UIColor(red: 82, green: 54, blue: 140, alpha: 1), for: .normal)
        loginButton.setTitleColor(UIColor(white: 0.2, alpha: 1), for: .normal)
        registerButton.setTitleColor(UIColor(white: 1, alpha: 1), for: .normal)
    }
    
    private func disableButtons() {
        loginButton.backgroundColor = UIColor(white: 1, alpha: 0.3)
        loginButton.setTitleColor(UIColor(white: 1, alpha: 0.4), for: .normal)
        registerButton.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .normal)
    }
    
    private func setButtons() {
        if !email.isEmpty && !password.isEmpty {
            enableButtons()
        } else {
            disableButtons()
            loginButton.isEnabled = false
            registerButton.isEnabled = false
        }
    }
    
    @objc private func showPasswordButtonClicked() {
        if !isPasswordShown {
            button.setImage(UIImage(named: "ic-invisible.pdf") as UIImage?, for: .normal)
            passwordTextField.isSecureTextEntry = false
        } else {
            button.setImage(UIImage(named: "ic-visible.pdf") as UIImage?, for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
        isPasswordShown = !isPasswordShown
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.emailTextField:
            self.passwordTextField.becomeFirstResponder()
        default:
            self.passwordTextField.resignFirstResponder()
        }
    }
}
