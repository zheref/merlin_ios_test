//
//  DetailTableViewController.swift
//  Prueba_iOS
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    // MARK: Subtypes
    
    struct Constants {
        static let contentCellHeight: CGFloat = 300.0
    }
    
    // MARK: Stored properties

    var item: FeedItem?
    
    // MARK: Outlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "shadow"), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        if parent?.childViewControllers.first != self {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        populateData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private operations
    
    private func populateData() {
        if let heading = item?.title {
            title = heading
        }
        
        if let summitText = item?.summitText {
            descriptionLabel.attributedText = MarkdownHelper.shared.parseFullScreen(fromString: summitText)
        } else {
            descriptionLabel.text = String()
        }
        
        var imageUrl: String?
        
        if let bannerImg = item?.bannerImg {
            imageUrl = bannerImg
        } else if let iconImg = item?.iconImg {
            imageUrl = iconImg
        }
        
        if let imageUrl = imageUrl {
            ImageCacher.shared.image(forUrlString: imageUrl) { [weak self] (image) in
                DispatchQueue.main.async { [weak self] in
                    if let image = image {
                        self?.imageView.image = image
                    } else {
                        self?.imageView.image = UIImage(named: "no_image_black")
                    }
                    
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: Actions

    @IBAction func dismissController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func navigationShouldPopOnBackButton() -> Bool {
        if traitCollection.userInterfaceIdiom == .phone && traitCollection.displayScale == 3.0 {
            navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
            navigationController?.navigationBar.shadowImage = nil
        }
        
        return true
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return Constants.contentCellHeight
    }

}
