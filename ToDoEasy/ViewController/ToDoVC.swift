//
//  ViewController.swift
//  ToDoEasy
//
//  Created by Aukmate  Chayapiwat on 1/1/2562 BE.
//  Copyright © 2562 Aukmate  Chayapiwat. All rights reserved.
//

import UIKit
import CoreData

class ToDoVC: SwipeVC {
    var items = [Item]()
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadItems()
    }
    
    //Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        cell.accessoryType = items[indexPath.row].done ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].done = !items[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //add Button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let item = Item(context: self.context)
            item.title = textField.text!
            item.done = false
            item.category = self.selectedCategory
            self.items.append(item)
            self.saveItems();
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    //Load and Save Data
    func saveItems(){
        do{
            try context.save()
        }
        catch{
            print("Failed Saving Data \(error)")
        }
        self.tableView.reloadData()
    }
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil){
        print(123456)
        let categorypredicate = NSPredicate(format: "category.name MATCHES %@", selectedCategory!.name!)
        if let newPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate,newPredicate])
        }
        else{
            request.predicate = categorypredicate
        }
        do{
            items = try context.fetch(request)
        }
        catch{
            print("Failed Fetching Data \(error)")
        }
        tableView.reloadData()
    }
    //update model when deleted
    override func updateModel(at indexPath: IndexPath) {
        context.delete(items[indexPath.row])
        items.remove(at: indexPath.row)
    }
}

extension ToDoVC : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        let sorts = [NSSortDescriptor(key: "title", ascending: true)]
        request.sortDescriptors = sorts
        loadItems(with: request,predicate: predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text!.count == 0){
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


    
    

