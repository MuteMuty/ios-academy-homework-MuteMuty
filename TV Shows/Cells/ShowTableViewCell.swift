//
//  ShowTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 26.07.2022..
//

import UIKit
import Kingfisher

struct ShowItem {
    let show: Show
}

final class ShowTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Functions
    
    func setup(with item: ShowItem) {
        titleLabel.text = item.show.title
        thumbnailImageView.kf.setImage(
            with: item.show.imageUrl,
            placeholder: UIImage(named: "ic-show-placeholder-vertical"),
            options: [.transition(.fade(0.3))]
        )
    }

}
