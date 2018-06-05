//
//  CategoryTableViewCell.swift
//  Prueba_iOS
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    // MARK: Outlets

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: Operations
    
    func set(model: Category) {
        categoryLabel.text = model.name == "Undefined" ? "Sin Categoría" : model.name
        
        if let imageName = model.imageName {
            categoryImage.image = UIImage(named: imageName)
        }
    }

}
