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
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var submitButton: UIButton!
    
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
        if !isOkToPost() {
            animateStars()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.showAlter(message: "Select rating stars to post.")
            }
            return
        }
        MBProgressHUD.showAdded(to: view, animated: true)
        service.postReview(showId: show!.id, rating: String(ratingView.rating), comment: commentTextField.text!) {  [weak self] dataResponse in
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
