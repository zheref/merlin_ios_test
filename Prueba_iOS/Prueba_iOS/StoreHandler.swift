//
//  StoreHandler.swift
//  Prueba_iOS
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

import UIKit
import RealmSwift

class StoreHandler: NSObject {

    func imageNameFrom(_ categoryName:String) -> String?{
        
        var imageName: String? = nil
        
        switch categoryName
        {
            case "Undefined":
                imageName = "undefined_image"
            case "Sports":
                imageName = "sport_image"
            case "Games":
                imageName = "games_image"
            case "Lifestyles":
                imageName = "life_style_image"
            case "Entertainment":
                imageName = "entertainment_image"
            default:
                return nil
        }
        
        return imageName
    }
    
    func valueFor(_ element:Any?) -> String?{
        
        if element is NSNull
        {
            return nil
        }
        else
        {
            let tempElement: String = element as! String
            return ((tempElement.isEmpty) ? nil : tempElement)
        }
    }
    
    func createLocalDataBaseWith(_ json: Dictionary<String, Any>) -> Void{
     
        let realm = try! Realm()
        
        realm.beginWrite()
        realm.deleteAll()
        try! realm.commitWrite()
        
        var categories: Dictionary<String, Category>    = Dictionary()
        let data:       Dictionary<String, Any>         = json["data"]      as! Dictionary
        let children:   Array<Dictionary<String, Any>>  = data["children"]  as! Array
        
        for child in children
        {
            let interestingData: Dictionary<String, Any> = child["data"] as! Dictionary
            
            let newApp: App = App()
            newApp.bannerImg    = valueFor(interestingData["banner_img"])
            newApp._id          = valueFor(interestingData["id"])
            newApp.summitText   = valueFor(interestingData["submit_text"])
            newApp.displayText  = valueFor(interestingData["display_name"])
            newApp.title        = valueFor(interestingData["title"])
            newApp.iconImg      = valueFor(interestingData["icon_img"])
            
            var categoryName: String = ""
            
            if interestingData["advertiser_category"] is NSNull
            {
                categoryName = "Undefined"
            }
            else
            {
                categoryName = interestingData["advertiser_category"] as! String
            }
            
            if let currentCategory = categories[categoryName]
            {
                newApp.category = currentCategory;
            }
            else
            {
                let newCategory: Category   = Category()
                newCategory._id             = categoryName
                newCategory.name            = categoryName
                newCategory.imageName       = imageNameFrom(categoryName)
                categories[categoryName]    = newCategory
                
                try! realm.write {
                    
                    realm.add(newCategory)
                }
            }
            
            try! realm.write {
                
                realm.add(newApp)
            }
        }
    }
}
