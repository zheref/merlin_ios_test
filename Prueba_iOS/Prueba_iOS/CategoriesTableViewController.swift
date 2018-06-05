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
    
    // MARK: Subtypes
    
    struct Constants {
        static let cellHeight: CGFloat = 65.0
    }
    
    enum ControllerError : Error {
        case unableToHandleResponse
    }
    
    // MARK: Stored properties

    var dataSource: Results<Category>?
    var realm = try! Realm()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        clearsSelectionOnViewWillAppear = true
        load()
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private operations
    
    private func load() {
        let manager = AFNetworkReachabilityManager.shared()
        
        manager.setReachabilityStatusChange { [weak self] (status) in
            if status == .notReachable {
                let message = AGPushNote()
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
        FeedFetcher.shared.start(withUrl: K.UrlString.redditFeedUrl, completion: { [weak self] (dic, error) in
            if let error = error {
                print(error.localizedDescription)
                
                DispatchQueue.main.async { [weak self] in
                    self?.presentAlert(forError: error, withCompletion: nil)
                }
            } else if let dict = dic {
                FeedDataStore.shared.createDatabase(withJson: dict)
                    
                DispatchQueue.main.async { [weak self] in
                    self?.loadObjects()
                }
            } else {
                let error = ControllerError.unableToHandleResponse
                
                DispatchQueue.main.async { [weak self] in
                    self?.presentAlert(forError: error, withCompletion: nil)
                }
            }
        })
    }
    
    private func loadObjects() {
        dataSource = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    // MARK: UITableViewController overrides
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let data = dataSource {
            return data.count + 1
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.CategoryCell,
                                                 for: indexPath)
        
        if let cell = cell as? CategoryTableViewCell {
            if indexPath.row == 0 {
                cell.categoryLabel.text = "Mostrar todo"
                cell.categoryImage.image = UIImage(named: "all_iphone_image")
            } else {
                if let dataSource = dataSource {
                    let category = dataSource[indexPath.row - 1]
                    cell.set(model: category)
                }
            }
        }
        
        return cell
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
