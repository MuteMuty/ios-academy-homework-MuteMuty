//
//  ShowReviewCell.swift
//  TV Shows
//
//  Created by Infinum on 27.07.2022..
//

import UIKit

struct ShowReviewItem {
    let review: Review
}

final class ShowReviewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var reviewLable: UILabel!
    
    // MARK: - Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code - small style and disable changing the rating
        ratingView.configure(withStyle: .small)
        ratingView.isEnabled = false
    }
    
    func setup(with item: ShowReviewItem) {
        profileImage.kf.setImage(
            with: item.review.user.imageUrl,
            placeholder: UIImage(named: "ic-profile-placeholder"),
            options: [.transition(.fade(0.3))]
        )
        emailLabel.text = item.review.user.email
        ratingView.setRoundedRating(Double(item.review.rating))
        if item.review.comment.isEmpty {
            emptyView.isHidden = true
        }
        reviewLable.text = item.review.comment
    }
}
