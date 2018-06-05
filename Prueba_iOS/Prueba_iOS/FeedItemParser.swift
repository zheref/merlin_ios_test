//
//  FeedItemParser.swift
//  Prueba_iOS
//
//  Created by Sergio Daniel L. García on 6/4/18.
//  Copyright © 2018 Humberto Cetina. All rights reserved.
//

import Foundation

protocol FeedItemParserProtocol : class {
    
    func createFeedItem(fromJson json: RegularDictionary) -> FeedItem
    
}

class FeedItemParser : FeedItemParserProtocol {
    
    // MARK: Class members
    
    static var shared: FeedItemParser = {
        return FeedItemParser()
    }()
    
    // MARK: Initializers
    
    private init() {}
    
    // MARK: Operations
    
    func createFeedItem(fromJson json: RegularDictionary) -> FeedItem {
        let item = FeedItem()
        item.bannerImg = stringValue(of: json["banner_img"])
        item._id = stringValue(of: json["id"])
        item.summitText = stringValue(of: json["submit_text"])
        item.displayText = stringValue(of: json["display_name"])
        item.title = stringValue(of: json["title"])
        item.iconImg = stringValue(of: json["icon_img"])
        return item
    }
    
}
