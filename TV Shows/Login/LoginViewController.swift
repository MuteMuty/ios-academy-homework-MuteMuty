    //
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 11.07.2022..
//

import UIKit

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
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        setUpUI()
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
    
    
    // MARK: - Utility methods

    private func getColorValue() -> CGFloat {
        return CGFloat.random(in: 0..<1)
    }
    
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
        if !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {
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
