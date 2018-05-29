//
//  DetailTableViewController.swift
//  Prueba_iOS
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    var app: App?
    @IBOutlet var appImage: UIImageView!
    @IBOutlet var appTitle: UILabel!
    @IBOutlet var appDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "shadow"), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage();
        
        if self.parent?.childViewControllers.first != self
        {
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        self.appTitle.text = self.app?.title;
        self.appDescription.text = self.app?.summitText;
        
        var imageUlr: String?
        
        if let bannerImg = self.app!.bannerImg
        {
            imageUlr = bannerImg
        }
        else if let iconImg = self.app!.iconImg
        {
            imageUlr = iconImg
        }
        
        ImageCacheHandler().imageForUrl(imageUlr) { (image) in
            if image == nil
            {
                self.appImage.image = UIImage(named: "no_image_black")
            }
            else
            {
                self.appImage.image = image
            }
            
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dismissController(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func navigationShouldPopOnBackButton() -> Bool {
        
        if ((self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone && self.traitCollection.displayScale == 3.0))
        {
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = nil;
        }
        
        return true;
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return UITableViewAutomaticDimension;
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
