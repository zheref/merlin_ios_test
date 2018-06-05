//
//  AppsTableViewController.swift
//  Prueba_iOS
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

import UIKit
import RealmSwift

class FeedTableViewController: UITableViewController {
    
    struct Constants {
        static let cellHeight: CGFloat = 106.0
    }
    
    // MARK: Stored properties

    var dataSource: Results<FeedItem>?
    var category: Category?
    var realm = try! Realm()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        loadData()
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private operations
    
    private func loadData() {
        guard let category = category,
            let name = category.name else {
                dataSource = realm.objects(FeedItem.self)
                return
        }
        
        let pred: NSPredicate = NSPredicate(format: "category.name = %@", name)
        dataSource = realm.objects(FeedItem.self).filter(pred)
        
        tableView.reloadData()
    }

    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return Constants.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let data = dataSource {
            return data.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.FeedItemCell,
                                                 for: indexPath)
        
        if let feedCell = cell as? FeedItemTableViewCell,
            let dataSource = dataSource {
            let item = dataSource[indexPath.row]
            feedCell.set(model: item)
        }
        
        return cell
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? DetailTableViewController,
            let dataSource = dataSource,
            let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        controller.item = dataSource[indexPath.row]
    }
}
