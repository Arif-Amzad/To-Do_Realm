//
//  Category.swift
//  To Do
//
//  Created by Arif Amzad on 2/11/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    
    @objc dynamic var color: String = ""
    
    let items = List<Item>() //List is an array element of Realm, Item is a model class from Data Model directory
}
