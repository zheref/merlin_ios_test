//
//  App.swift
//  Prueba_iOS
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

import UIKit
import RealmSwift

class FeedItem: Object {

    @objc dynamic var bannerImg: String?
    @objc dynamic var _id: String?
    @objc dynamic var summitText: String?
    @objc dynamic var displayText: String?
    @objc dynamic var title: String?
    @objc dynamic var iconImg: String?
    @objc dynamic var category: Category?
    
}
