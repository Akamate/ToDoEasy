//
//  ViewController.swift
//  ToDoEasy
//
//  Created by Aukmate  Chayapiwat on 1/1/2562 BE.
//  Copyright © 2562 Aukmate  Chayapiwat. All rights reserved.
//

import UIKit

class ToDoVC: SwipeVC {
    
    lazy var toDoVM : ToDoVM = {
        return ToDoVM()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVM()
    }
    
    func initVM(){
        toDoVM.reloadTableViewClosure = { [weak self] () in
            self?.tableView.reloadData()
        }
        toDoVM.fetchData()
    }
    //Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoVM.numberOfCells
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = toDoVM.items?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDoVM.toggleFinished(at : indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //add Button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.toDoVM.addData(title: textField.text!)
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    //update model when deleted
    override func updateModel(at indexPath: IndexPath) {
        toDoVM.deleteData(at: indexPath)
    }
}

extension ToDoVC : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       toDoVM.searchItem(text : searchBar.text!)
       tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text!.count == 0){
            toDoVM.fetchData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


    
    

