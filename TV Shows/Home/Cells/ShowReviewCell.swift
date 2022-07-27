//
//  ShowReviewCell.swift
//  TV Shows
//
//  Created by Infinum on 27.07.2022..
//

import UIKit

final class ShowReviewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var reviewLable: UILabel!
    
    // MARK: - Properties
    
    var show: Show?
    
    // MARK: - Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code - small style and disable changing the rating
        ratingView.configure(withStyle: .small)
        ratingView.isEnabled = false
    }

    func configure(with show: Show) {
        profileImage.image = UIImage(named: "ic-profile.pdf")
        emailLabel.text = "neki@neki.neki"
        ratingView.setRoundedRating(4.0)
        reviewLable.text = "sfsd  sdfds sdf f dsaas sa ds dsg dvs dsf fds  dsf dsfsfa a sf saa dsasd a ds sadsa d"
    }
}
