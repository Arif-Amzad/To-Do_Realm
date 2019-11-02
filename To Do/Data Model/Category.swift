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
    
    @objc var name: String = ""
    
    let items = List<Item>() 
}
