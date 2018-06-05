//
//  Constants.swift
//  Prueba_iOS
//
//  Created by Sergio Daniel L. García on 6/3/18.
//  Copyright © 2018 Humberto Cetina. All rights reserved.
//

import Foundation

// MARK: Global type aliases

typealias RegularDictionary = [String: Any?]

typealias NetworkCallback = (RegularDictionary?, Error?) -> Void

// MARK: Global helper functions

func stringValue(of obj: Any?) -> String? {
    if let obj = obj as? String {
        return obj.isEmpty ? nil : obj
    } else {
        return nil
    }
}

struct K {
    
    struct Segue {
        static let categoriesToApps = "categoriesToApps"
    }
    
    struct UrlString {
        static let redditFeedUrl = "https://www.reddit.com/reddits.json"
    }
    
    struct CellIdentifier {
        static let CategoryCell = "CategoryCell"
        static let FeedItemCell = "FeedItemCell"
    }
    
    static let categoriesImages: [String: String] = [
        "Undefined": "undefined_image",
        "Sports": "sport_image",
        "Games": "games_image",
        "Lifestyles": "life_style_image",
        "Entertainment": "entertainment_image"
    ]
    
}
