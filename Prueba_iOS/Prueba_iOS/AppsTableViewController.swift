//
//  AppsTableViewController.swift
//  Prueba_iOS
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

import UIKit
import RealmSwift

class AppsTableViewController: UITableViewController {

    var dataSource: Results<App>?
    var imageHandler: ImageCacheHandler = ImageCacheHandler()
    var category: Category?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let realm = try! Realm()
        
        if (self.category != nil)
        {
            let pred: NSPredicate = NSPredicate(format: "category.name = %@", self.category!.name!)            
            self.dataSource =  realm.objects(App.self).filter(pred)
        }
        else
        {
            self.dataSource =  realm.objects(App.self)
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 106.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if let data = dataSource
        {
            return data.count
        }
        else
        {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell: AppTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AppCell", for: indexPath) as! AppTableViewCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        let appCell: AppTableViewCell = cell as! AppTableViewCell
        let app: App = self.dataSource![indexPath.row]
       
        appCell.appTitle.text = app.title
        appCell.appDescription.text = app.summitText
        appCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
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
                appCell.appImage.image = UIImage(named: "no_image_black")
            }
            else
            {
                appCell.appImage.image = image
            }
        })
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath: IndexPath? = self.tableView.indexPathForSelectedRow;
        let controller: DetailTableViewController = segue.destination as! DetailTableViewController
        controller.app = self.dataSource![indexPath!.row];
    }
}
