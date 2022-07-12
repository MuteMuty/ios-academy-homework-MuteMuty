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
    
    @IBAction func countBtn(_ sender: Any) {
        counter += 1
        fontSize += 5.0
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
