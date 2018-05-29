//
//  Category.swift
//  Prueba_iOS
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

import UIKit
import RealmSwift

class Category: Object {

    dynamic var _id: String?
    dynamic var name: String?
    dynamic var imageName: String?
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
