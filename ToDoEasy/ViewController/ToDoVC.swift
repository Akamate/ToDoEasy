//
//  ViewController.swift
//  ToDoEasy
//
//  Created by Aukmate  Chayapiwat on 1/1/2562 BE.
//  Copyright © 2562 Aukmate  Chayapiwat. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoVC: SwipeVC {
    let realm = try! Realm()
    var items : Results<Item>?
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //add Button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let item = Item()
                        item.title = textField.text!
                        currentCategory.Items.append(item)
                    }
                    self.tableView.reloadData()
                }
                catch{
                    print(error)
                }
                
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    //Load and Save Data
    func saveItems(item : Item){
        do{
            try realm.write {
                realm.add(item)
            }
        }
        catch{
            print("Failed Saving Data \(error)")
        }
        self.tableView.reloadData()
    }
    func loadItems(){
          items = selectedCategory?.Items.sorted(byKeyPath: "title", ascending: true)
          tableView.reloadData()
    }
    //update model when deleted
    override func updateModel(at indexPath: IndexPath) {
        if let item = items?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(item)
                }
            }
            catch {
                print(error)
            }
        }
    }
}

extension ToDoVC : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@ ",searchBar.text!).sorted(byKeyPath: "title", ascending: true)
       tableView.reloadData()
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


    
    

