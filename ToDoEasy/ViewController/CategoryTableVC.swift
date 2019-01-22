//
//  CategoryTableViewController.swift
//  ToDoEasy
//
//  Created by Aukmate  Chayapiwat on 9/1/2562 BE.
//  Copyright © 2562 Aukmate  Chayapiwat. All rights reserved.
//

import UIKit

class CategoryTableVC : SwipeVC {
    lazy var categoryTableVM : CategoryTableVM = {
        return CategoryTableVM()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        initVM()
    }

    func initVM(){
        categoryTableVM.fetchData()
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            self.categoryTableVM.addCategories(name: textField.text!)
            self.tableView.reloadData()
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
        return categoryTableVM.numberOfCells
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categoryTableVM.categories?[indexPath.row]{
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
            destinationVC.toDoVM.selectedCategory = categoryTableVM.categories?[indexPath.row]
        }
    }
    //update model when deleted
    override func updateModel(at indexPath: IndexPath) {
        categoryTableVM.deleteCategories(at: indexPath)
    }
}

