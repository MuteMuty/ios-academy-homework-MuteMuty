//
//  ShowReviewCell.swift
//  TV Shows
//
//  Created by Infinum on 27.07.2022..
//

import UIKit

struct ShowInfoItem {
    let show: Show
}

final class ShowInfoCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showDescriptionLabel: UILabel!
    @IBOutlet weak var noReviewsLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    
    // MARK: - Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code - small style and disable changing the rating
        ratingView.configure(withStyle: .small)
        ratingView.isEnabled = false
    }
    
    func setup(with item: ShowInfoItem) {
        showDescriptionLabel.text = item.show.description
        showImage.kf.setImage(
            with: item.show.imageUrl,
            placeholder: UIImage(named: "ic-show-placeholder-rectangle"),
            options: [.transition(.fade(0.3)), .progressiveJPEG(.init())]
        )
        if item.show.noOfReviews > 0 {
            noReviewsLabel.text = "\(item.show.noOfReviews) REVIEWS, \(item.show.averageRating!) AVERAGE"
            noReviewsLabel.textAlignment = .left
            ratingView.setRoundedRating(item.show.averageRating!)
        } else {
            ratingView.isHidden = true
        }
    }
    
}
