//
//  StoreHandler.swift
//  Prueba_iOS
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

import UIKit
import RealmSwift

protocol FeedDataStoreProtocol : class {
    
    func createDatabase(withJson json: RegularDictionary) -> Void
    
}

class FeedDataStore : FeedDataStoreProtocol {
    
    // MARK: Class members
    
    static var shared: FeedDataStore = {
        return FeedDataStore()
    }()
    
    // MARK: Initializers
    
    private init() {}
    
    // MARK: Operations
    
    func createDatabase(withJson json: RegularDictionary) -> Void {
        let realm = try! Realm()
        
        realm.beginWrite()
        realm.deleteAll()
        
        try! realm.commitWrite()
        
        var categories = [String: Category]()
        
        guard let data = json["data"] as? RegularDictionary,
            let children = data["children"] as? [RegularDictionary] else {
            return
        }
        
        for child in children {
            if let data = child["data"] as? RegularDictionary {
                let item = FeedItemParser.shared.createFeedItem(fromJson: data)
                
                var categoryName = ""
                
                if let advertiserCategory = data["advertiser_category"] as? String {
                    categoryName = advertiserCategory
                } else {
                    categoryName = "Undefined"
                }
                
                if let currentCategory = categories[categoryName] {
                    item.category = currentCategory
                } else {
                    let category = Category()
                    category._id = categoryName
                    category.name = categoryName
                    category.imageName = K.categoriesImages[categoryName]
                    categories[categoryName] = category
                    
                    try! realm.write {
                        realm.add(category)
                    }
                }
                
                try! realm.write {
                    realm.add(item)
                }
            }
        }
    }
}
