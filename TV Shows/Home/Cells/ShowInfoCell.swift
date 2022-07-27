//
//  ShowReviewCell.swift
//  TV Shows
//
//  Created by Infinum on 27.07.2022..
//

import UIKit

struct ShowInfoItem {
    let image: UIImage?
    let showDescription: String
    let show: Show
}

final class ShowInfoCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showDescriptionLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    
    // MARK: - Properties
    
    var show: Show?
    
    // MARK: - Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code - small style and disable changing the rating
        ratingView.configure(withStyle: .small)
        ratingView.isEnabled = false
    }
    
    func setup(with item: ShowInfoItem) {
        showDescriptionLabel.text = item.showDescription
        showImage.image = item.image
        ratingView.setRoundedRating(3.5)
        show = item.show
    }
    
}