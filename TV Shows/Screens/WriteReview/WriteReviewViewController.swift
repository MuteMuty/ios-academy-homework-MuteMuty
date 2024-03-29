//
//  WriteReviewViewController.swift
//  TV Shows
//
//  Created by Infinum on 27.07.2022..
//

import UIKit
import MBProgressHUD

protocol ReloadData: AnyObject {
    func reloadData()
}

final class WriteReviewViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var commentTextField: UITextField!
    @IBOutlet private weak var ratingView: RatingView!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - Private Properties
    
    private var service = Service()
    
    // MARK: - Public Properties
    
    var show: Show?
    weak var delegate: ReloadData?

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        setUpUI()
    }

    // MARK: - Actions
    
    @IBAction func submitButtonClicked() {
        guard isOkToPost() else {
            animateStars()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.showAlter(message: "Select rating stars to post.")
            }
            return
        }
        MBProgressHUD.showAdded(to: view, animated: true)
        guard let show = show, let comment = commentTextField.text else { return }
        
        service.postReview(showId: show.id, rating: String(ratingView.rating), comment: comment) {  [weak self] dataResponse in
            guard let self = self else { return }
            MBProgressHUD.hide(for: self.view, animated: true)
            
            switch dataResponse.result {
            case .success:
                self.delegate?.reloadData()
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                self.showAlter(message: "Could not post review.")
                print("Error: \(error)")
            }
        }
    }
    
    @IBAction func closeClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Utility methods

    private func setUpUI() {
        commentTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(tapAwayDissmissKeyboard)
        )
        view.addGestureRecognizer(tap)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func isOkToPost() -> Bool {
        return ratingView.rating > 0
    }
    
    private func animateStars() {
        let newTransform = CGAffineTransform(translationX: 30.0, y: 0)
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.3,
            initialSpringVelocity: 0.8,
            options: [.curveEaseInOut, .autoreverse]
        ) {
            self.ratingView.transform = newTransform
        } completion: { _ in
            self.ratingView.transform = .identity
        }
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

extension WriteReviewViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        commentTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentTextField.endEditing(true)
        return true
    }
    
    @objc func tapAwayDissmissKeyboard() {
        view.endEditing(true)
    }
}
