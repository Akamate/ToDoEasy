//
//  ToDoVM.swift
//  ToDoEasy
//
//  Created by Aukmate  Chayapiwat on 11/1/2562 BE.
//  Copyright © 2562 Aukmate  Chayapiwat. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class ToDoVM {
    var reloadTableViewClosure: (()->())?
    var items : Results<Item>?
    var selectedCategory : Category?{
        didSet{
            reloadTableViewClosure?()
        }
    }
    var numberOfCells : Int {
        return items?.count ?? 1
    }
    
    let realm = try! Realm()
    
    func fetchData() {
       items = selectedCategory?.Items.sorted(byKeyPath: "title", ascending: true)
    }
    
    func deleteData(at indexPath : IndexPath){
        if let item = items?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(item)
                }
            }
            catch{
                print(error)
            }
        }
    }
    
    func addData(title : String){
        if let currentCategory = self.selectedCategory{
            do{
                try self.realm.write {
                    let item = Item()
                    item.title = title
                    currentCategory.Items.append(item)
                }
            }
            catch{
                print(error)
            }
            
        }
    }
    
    //when use touch the item which finish it
    func toggleFinished(at indexPath : IndexPath){
        if let item = items?[indexPath.row]{
            do  {
                try realm.write {
                    item.done = !item.done
                }
            }
            catch{
                print(error)
            }
        }
    }
    
    //search item
    func searchItem(text : String){
        items = items?.filter("title CONTAINS[cd] %@ ",text).sorted(byKeyPath: "title", ascending: true)
    }
}
