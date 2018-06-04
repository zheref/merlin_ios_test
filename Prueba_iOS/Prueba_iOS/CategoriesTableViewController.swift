//
//  CategoriesViewController.swift
//  Prueba_iOS
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

import UIKit
import RealmSwift
import AFNetworking

class CategoriesTableViewController: UITableViewController {
    
    // MARK: Stored properties

    var dataSource: Results<Category>?
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
        let manager = AFNetworkReachabilityManager.shared()
        
        manager.setReachabilityStatusChange { [weak self] (status) in
            if status == .notReachable {
                let message: AGPushNote = AGPushNote()
                message.setDefaultUI()
                message.message = "Funcionando en modo Offline"
                message.iconImage = UIImage(named: "no_wifi")
                message.showAtBottom = true
                
                AGPushNoteView.showNotification(message)
                AGPushNoteView.setCloseAction({})
                AGPushNoteView.setMessageAction({ (pushNote) in })
                self?.loadObjects()
            } else {
                AGPushNoteView.close(completion: {})
                self?.createDatabase()
            }
        }
        
        manager.startMonitoring()
    }
    
    private func createDatabase() {
        let networkHandler = NetworkHandler()
        
        networkHandler.jSonWith("https://www.reddit.com/reddits.json", andReturn: { [weak self] (dic, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let storeHandler: StoreHandler = StoreHandler()
                storeHandler.createLocalDataBaseWith(dic!)
                
                DispatchQueue.main.async { [weak self] in
                    self?.loadObjects()
                }
            }
        });
    }
    
    private func loadObjects() {
        dataSource = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    // MARK: UITableViewController overrides
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let data = dataSource {
            return data.count + 1
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        let categoryCell: CategoryTableViewCell = cell as! CategoryTableViewCell
        
        if (indexPath.row == 0) {
            categoryCell.categoryLabel.text = "Mostrar todo"
            categoryCell.categoryImage.image = UIImage(named: "all_iphone_image")
        } else {
            let category: Category = dataSource![indexPath.row - 1]
            categoryCell.categoryLabel.text = (category.name == "Undefined") ? "Sin Categoría" : category.name
            
            if let imageName = category.imageName {
                categoryCell.categoryImage.image = UIImage(named: imageName)
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.categoriesToApps {
            if let controller = segue.destination as? FeedTableViewController,
                let indexPath = tableView.indexPathForSelectedRow,
                let dataSource = dataSource {
                
                controller.category = indexPath.row == 0 ? nil : dataSource[indexPath.row - 1]
            }
        }
    }
}
