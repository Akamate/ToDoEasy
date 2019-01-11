//
//  CategoryTableVM.swift
//  ToDoEasy
//
//  Created by Aukmate  Chayapiwat on 11/1/2562 BE.
//  Copyright © 2562 Aukmate  Chayapiwat. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class CategoryTableVM {
     var categories : Results<Category>?
     var numberOfCells : Int {
        return categories?.count ?? 1
     }
    
    let realm = try! Realm()
    
    func fetchData(){
        categories = realm.objects(Category.self)
    }
    
    func addCategories(name : String){
        let category = Category()
        category.name = name
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print(error)
        }
    }
    
    func deleteCategories(at indexPath : IndexPath){
        if let category = categories?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(category)
                }
            }
            catch {
                print(error)
            }
        }
    }
}
