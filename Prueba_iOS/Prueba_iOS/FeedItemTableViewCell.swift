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
    
    @IBOutlet var appImage: UIImageView!
    @IBOutlet var appTitle: UILabel!
    @IBOutlet var appDescription: UILabel!
    
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
        appTitle.text = model.title
        appDescription.text = model.summitText
        accessoryType = .disclosureIndicator
        
        var imageUlr: String?
        
        if let iconImg = model.iconImg {
            imageUlr = iconImg
        }
            
        else if let bannerImg = model.bannerImg {
            imageUlr = bannerImg
        }
        
        ImageCacheHandler().imageForUrl(imageUlr, andReturn: { [weak self] (image) in
            if let image = image {
                self?.appImage.image = image
            } else {
                self?.appImage.image = UIImage(named: "no_image_black")
            }
        })
    }

}
