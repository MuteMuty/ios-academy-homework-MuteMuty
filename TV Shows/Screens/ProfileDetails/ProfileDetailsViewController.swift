//
//  ProfileDetailsViewController.swift
//  TV Shows
//
//  Created by Infinum on 30.07.2022..
//

import UIKit
import Kingfisher

class ProfileDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    // MARK: - Private Properties
    
    private var service: Service = Service()
    
    // MARK: - Public Properties
    
    var user: User?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        setUpUI()
    }
    
    // MARK: - Utility methods
    
    private func setUpUI() {
        emailLabel.text = user?.email
        profilePhotoImageView.kf.setImage(
            with: user?.imageUrl,
            placeholder: UIImage(named: "ic-profile-placeholder"),
            options: [.transition(.fade(0.3))]
        )
    }
    
    // MARK: - Actions
    
    @IBAction func changeProfilePhotoButtonClicked() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @IBAction func closeButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonClicked() {
        dismiss(animated: true) {
            KeychainManager.removeUserInfo()
            SessionManager.shared.authInfo = nil
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "logout")))
        }
    }
}

// MARK: - ImagePicker

extension ProfileDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        service.storeImage(image) { [weak self] dataResponse in
            guard let self = self else { return }
            
            switch dataResponse.result {
            case .success(let userResponse):
                self.user = userResponse.user
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        profilePhotoImageView.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
