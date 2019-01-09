//
//  Item+CoreDataProperties.swift
//  
//
//  Created by Aukmate  Chayapiwat on 9/1/2562 BE.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var done: Bool
    @NSManaged public var title: String?
    @NSManaged public var category: Category?

}
