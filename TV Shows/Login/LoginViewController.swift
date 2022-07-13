    //
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 11.07.2022..
//

import UIKit

class LoginViewController: UIViewController {
    
    var counter:Int = 0
    var fontSize:CGFloat = 20.0
    var isSpinning:Bool = true
    
    @IBAction func countBtn(_ sender: Any) {
        counter += 1
        fontSize += 5.0
        isSpinning = !isSpinning
        if isSpinning {
            indicator.stopAnimating()
        } else {
            indicator.startAnimating()
        }
        let redC:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let greenC:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let blueC:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        inc.layer.cornerRadius = 5
        inc.layer.borderWidth = 3
        inc.layer.borderColor = CGColor(
            red:   1.0 - redC,
            green: 1.0 - greenC,
            blue:  1.0 - blueC,
            alpha: 1.0
        )
        inc.backgroundColor = UIColor(
            red:   redC,
            green: greenC,
            blue:  blueC,
            alpha: 1.0
         )
        inc.setTitleColor(UIColor(
            red:   1.0 - redC,
            green: 1.0 - greenC,
            blue:  1.0 - blueC,
            alpha: 1.0
         ), for: .normal)
        stringLabel.font = stringLabel.font.withSize(fontSize)
        stringLabel.text = "\(counter)"
    }
    @IBAction func decrementBtn(_ sender: Any) {
        counter > 0 ? counter -= 1 : nil
        fontSize -= 5.0
        let redC:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let greenC:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let blueC:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        dec.layer.cornerRadius = 5
        dec.layer.borderWidth = 3
        dec.layer.borderColor = CGColor(
            red:   1.0 - redC,
            green: 1.0 - greenC,
            blue:  1.0 - blueC,
            alpha: 1.0
        )
        dec.backgroundColor = UIColor(
            red:   redC,
            green: greenC,
            blue:  blueC,
            alpha: 1.0
         )
        dec.setTitleColor(UIColor(
            red:   1.0 - redC,
            green: 1.0 - greenC,
            blue:  1.0 - blueC,
            alpha: 1.0
         ), for: .normal)
        stringLabel.font = stringLabel.font.withSize(fontSize)
        stringLabel.text = "\(counter)"
    }
    
    @IBOutlet weak var stringLabel: UILabel!
    @IBOutlet weak var inc: UIButton!
    @IBOutlet weak var dec: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.cyan
        inc.setImage(UIImage(named: "plus.png"), for: .normal)
        inc.imageView?.contentMode = .scaleAspectFit
        inc.contentHorizontalAlignment = .left;
        inc.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        //indicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.indicator.stopAnimating()
            self.isSpinning = false
        }

    }
    
}
