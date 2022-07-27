//
//  ShowReviewCell.swift
//  TV Shows
//
//  Created by Infinum on 27.07.2022..
//

import UIKit

final class ShowInfoCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showDescriptionLabel: UILabel!
    @IBOutlet private var ratingView: RatingView!
    
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
        showDescriptionLabel.text = show.title
        ratingView.setRoundedRating(show.averageRating!)
    }
    
}
