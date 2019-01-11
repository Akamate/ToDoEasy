//
//  Category.swift
//  ToDoEasy
//
//  Created by Aukmate  Chayapiwat on 11/1/2562 BE.
//  Copyright © 2562 Aukmate  Chayapiwat. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    @objc dynamic var name : String = ""
    var Items = List<Item>()
}
