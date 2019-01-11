//
//  Data.swift
//  ToDoEasy
//
//  Created by Aukmate  Chayapiwat on 11/1/2562 BE.
//  Copyright © 2562 Aukmate  Chayapiwat. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    var category = LinkingObjects(fromType: Category.self, property: "Items")
    
}
