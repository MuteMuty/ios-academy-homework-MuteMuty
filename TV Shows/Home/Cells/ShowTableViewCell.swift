//
//  ShowTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 26.07.2022..
//

import UIKit

struct ShowItem {
    let showTitle: String
    let image: UIImage?
}

final class ShowTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setup(with item: ShowItem) {
        titleLabel.text = item.showTitle
        thumbnailImageView.image = item.image
    }

}
