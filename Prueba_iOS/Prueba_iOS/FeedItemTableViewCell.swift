//
//  AppTableViewCell.swift
//  Prueba_iOS
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

import UIKit

class FeedItemTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet var picImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Operations
    
    func set(model: FeedItem) {
        titleLabel.text = model.title
        descriptionLabel.text = model.summitText
        accessoryType = .disclosureIndicator
        
        var imageUrl: String?
        
        if let iconImg = model.iconImg {
            imageUrl = iconImg
        } else if let bannerImg = model.bannerImg {
            imageUrl = bannerImg
        }
        
        picImageView.layer.masksToBounds = true
        picImageView.layer.cornerRadius = picImageView.bounds.width / 2
        
        if let imageUrl = imageUrl {
            ImageCacher.shared.image(forUrlString: imageUrl, completion: { [weak self] (image) in
                DispatchQueue.main.async {
                    if let image = image {
                        self?.picImageView.image = image
                    } else {
                        self?.picImageView.image = UIImage(named: "no_image_black")
                    }
                }
            })
        }
    }

}
