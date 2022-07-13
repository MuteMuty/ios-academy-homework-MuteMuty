    //
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 11.07.2022..
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var incrementButton: UIButton!
    @IBOutlet private weak var decrementButton: UIButton!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var counter: Int = 0
    private var fontSize: CGFloat = 20.0
    private var isSpinning: Bool = true
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        setUpUI()
        animateSpinner()
    }
    
    // MARK: - Actions
    
    @IBAction private func incrementButtonPressed() {
        counter += 1
        fontSize += 5.0
        isSpinning = !isSpinning
        if isSpinning {
            loadingIndicator.stopAnimating()
        } else {
            loadingIndicator.startAnimating()
        }
        let redC: CGFloat = getColorValue()
        let greenC: CGFloat = getColorValue()
        let blueC: CGFloat = getColorValue()
        incrementButton.layer.cornerRadius = 5
        incrementButton.layer.borderWidth = 3
        incrementButton.layer.borderColor = CGColor(
            red:   1.0 - redC,
            green: 1.0 - greenC,
            blue:  1.0 - blueC,
            alpha: 1.0
        )
        incrementButton.backgroundColor = UIColor(
            red:   redC,
            green: greenC,
            blue:  blueC,
            alpha: 1.0
         )
        incrementButton.setTitleColor(UIColor(
            red:   1.0 - redC,
            green: 1.0 - greenC,
            blue:  1.0 - blueC,
            alpha: 1.0
         ), for: .normal)
        counterLabel.font = counterLabel.font.withSize(fontSize)
        counterLabel.text = "\(counter)"
    }
    
    @IBAction private func decrementButtonPressed() {
        counter > 0 ? counter -= 1 : nil
        fontSize -= 5.0
        let redC: CGFloat = getColorValue()
        let greenC: CGFloat = getColorValue()
        let blueC: CGFloat = getColorValue()
        decrementButton.layer.cornerRadius = 5
        decrementButton.layer.borderWidth = 3
        decrementButton.layer.borderColor = CGColor(
            red:   1.0 - redC,
            green: 1.0 - greenC,
            blue:  1.0 - blueC,
            alpha: 1.0
        )
        decrementButton.backgroundColor = UIColor(
            red:   redC,
            green: greenC,
            blue:  blueC,
            alpha: 1.0
         )
        decrementButton.setTitleColor(UIColor(
            red:   1.0 - redC,
            green: 1.0 - greenC,
            blue:  1.0 - blueC,
            alpha: 1.0
         ), for: .normal)
        counterLabel.font = counterLabel.font.withSize(fontSize)
        counterLabel.text = "\(counter)"
    }
    
    // MARK: - Utility methods

    private func getColorValue() -> CGFloat {
        return CGFloat.random(in: 0..<1)
    }
    
    private func setUpUI() {
        view.backgroundColor = UIColor.cyan
        incrementButton.setImage(UIImage(named: "plus.png"), for: .normal)
    }
    
    private func animateSpinner() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [self] in
            loadingIndicator.stopAnimating()
            isSpinning = false
        }
    }
    
}
