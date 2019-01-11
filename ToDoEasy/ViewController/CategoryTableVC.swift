//
//  CategoryTableViewController.swift
//  ToDoEasy
//
//  Created by Aukmate  Chayapiwat on 9/1/2562 BE.
//  Copyright © 2562 Aukmate  Chayapiwat. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableVC : SwipeVC {
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let catagory = Category(context: self.context)
            catagory.name = textField.text!
            print(textField.text!)
            self.categories.append(catagory)
            self.saveCategories();
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
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoToDoList", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoVC
        if let indexPath = tableView.indexPathForSelectedRow{
            print(1341124)
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    // MARK: - Data Manipulate
    func saveCategories(){
        do{
            try context.save()
        }
        catch{
            print("Failed Saving Data \(error)")
        }
        self.tableView.reloadData()
    }
    func loadCategories(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categories = try context.fetch(request)
        }
        catch{
            print("Failed Fetching Data \(error)")
        }
        self.tableView.reloadData()
    }
    //update model when deleted
    override func updateModel(at indexPath: IndexPath) {
        context.delete(categories[indexPath.row])
        categories.remove(at: indexPath.row)
    }
}

