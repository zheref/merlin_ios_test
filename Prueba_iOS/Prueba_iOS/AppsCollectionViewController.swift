//
//  AppsCollectionViewController.swift
//  Prueba_iOS
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

import UIKit
import RealmSwift

class AppsCollectionViewController: UICollectionViewController {

    var dataSource: Results<FeedItem>?
    var imageHandler: ImageCacheHandler = ImageCacheHandler()
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem;
        self.navigationItem.leftItemsSupplementBackButton = true;
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "shadow"), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage();
        
        if ((self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone && self.traitCollection.displayScale == 3.0))
        {
            self.navigationController?.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "shadow"), for: UIBarMetrics.default)
            self.navigationController?.navigationController?.navigationBar.shadowImage = UIImage();
        }
        
        let realm = try! Realm()
        
        if (self.category != nil)
        {
            let pred: NSPredicate = NSPredicate(format: "category.name = %@", self.category!.name!)
            self.dataSource =  realm.objects(FeedItem.self).filter(pred)
        }
        else
        {
            self.dataSource =  realm.objects(FeedItem.self)
        }
        
        self.collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPaths: Array? = self.collectionView?.indexPathsForSelectedItems;
        let indexPath: IndexPath? = indexPaths?.first;
        
        let navController: UINavigationController =  segue.destination as! UINavigationController
        let controller: DetailTableViewController = navController.viewControllers.first as! DetailTableViewController
        controller.item = self.dataSource![indexPath!.row];
    }
    

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let data = dataSource
        {
            return data.count
        }
        else
        {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppCell", for: indexPath)
        let appCell: AppCollectionViewCell = cell as! AppCollectionViewCell
        let app: FeedItem = self.dataSource![indexPath.row]
        
        appCell.appTitle.text = app.title
        appCell.appDescription.text = app.summitText
        appCell.appImage.contentMode = (app.bannerImg != nil) ? UIViewContentMode.scaleAspectFill: UIViewContentMode.scaleAspectFit;

        var imageUlr: String?
        
        if let iconImg = app.iconImg
        {
            imageUlr = iconImg
        }
        else if let bannerImg = app.bannerImg
        {
            imageUlr = bannerImg
        }
        
        self.imageHandler.imageForUrl(imageUlr, andReturn: { (image) in
            if image == nil
            {
                appCell.appImage.image = UIImage(named: "no_image")
            }
            else
            {
                appCell.appImage.image = image
            }
        })
        
        return appCell;
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
     
        return CGSize(width: 182, height: 182)
    }
    
    override func navigationShouldPopOnBackButton() -> Bool {
       
        if ((self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone && self.traitCollection.displayScale == 3.0))
        {
            self.navigationController?.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
            self.navigationController?.navigationController?.navigationBar.shadowImage = nil;
        }
        
        return true;
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
