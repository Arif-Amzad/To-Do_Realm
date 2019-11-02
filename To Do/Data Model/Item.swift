//
//  Item.swift
//  To Do
//
//  Created by Arif Amzad on 2/11/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {

    @objc dynamic var title: String = ""
    @objc dynamic var done:Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //this is the 'let items' of Items file
}
