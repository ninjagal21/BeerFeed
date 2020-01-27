//
//  FeedTableViewCell.swift
//  BeerFeed
//
//  Created by Alice Fox on 1/26/20.
//  Copyright © 2020 Alice Fox. All rights reserved.
//

import UIKit
import AlamofireImage

class FeedTableViewCell: UITableViewCell {

    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var taglineLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.af_cancelImageRequest()
        postImageView.image = nil
    }
    
    func setup(imageUrl: URL?, nameText: String?, tagText: String?, descriptionText: String?) {
        if let url = imageUrl {
            let filter = AspectScaledToFitSizeFilter(size: CGSize(width: postImageView.frame.width,
                                                                  height: postImageView.frame.height))
            postImageView?.af_setImage(withURL: url,
                                       placeholderImage: UIImage(named: "placeholderImage"),
                                       filter: filter)
        }
        nameLabel.text = nameText
        taglineLabel.text = tagText
        descriptionLabel.text = descriptionText
    }
}
