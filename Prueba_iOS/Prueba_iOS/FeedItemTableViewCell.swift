//
//  AppTableViewCell.swift
//  Prueba_iOS
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

import UIKit
import EasyAnimation

class FeedItemTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
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
        
        if let summitText = model.summitText {
            descriptionLabel.attributedText = MarkdownHelper.shared.parseAsSummary(fromString: summitText)
        } else {
            descriptionLabel.text = String()
        }
        
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
                    
                    self?.picImageView.layer.frame.size = CGSize(width: 20.0, height: 20.0)
                    
                    UIView.animate(withDuration: 1.0, animations: {
                        self?.picImageView.layer.frame.size = CGSize(width: 85.0, height: 85.0)
                    })
                }
            })
        }
    }

}
