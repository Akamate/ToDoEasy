//
//  CategoryTableViewController.swift
//  ToDoEasy
//
//  Created by Aukmate  Chayapiwat on 9/1/2562 BE.
//  Copyright © 2562 Aukmate  Chayapiwat. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableVC : SwipeVC {
    let realm = try! Realm()
    var categories : Results<Category>?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
              let category = Category()
              category.name = textField.text!
              self.saveCategories(category: category)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row]{
            cell.textLabel?.text = category.name
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoToDoList", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoVC
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    // MARK: - Data Manipulate
    func saveCategories(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
            
        }
        catch{
            print("Failed Saving Data \(error)")
        }
        self.tableView.reloadData()
    }
    func loadCategories(){
        categories = realm.objects(Category.self)
        self.tableView.reloadData()
    }
    //update model when deleted
    override func updateModel(at indexPath: IndexPath) {
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
        tableView.reloadData()
    }
}

