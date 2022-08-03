//
//  Alert.swift
//  TV Shows
//
//  Created by Infinum on 27.07.2022..
//

import UIKit

extension UIViewController {
    
    func showAlter(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
}
