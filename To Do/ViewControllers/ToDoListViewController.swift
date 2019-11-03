//
//  ViewController.swift
//  To Do
//
//  Created by Arif Amzad on 12/9/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class ToDoListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    let cellID = "ToDoItemCell"
    
    var itemArray: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            
            loadDataFromStorage()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        navigationItem.title = selectedCategory?.name
        
        tableView.rowHeight = 80.0
    }
    
    
    
    //MARK - TableView DataSource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        if let item = itemArray?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else{
            
            cell.textLabel?.text = "No items added yet"
        }
        
        return cell
    }
    
    
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row]{
            
            do{
                try realm.write {
                    item.done = !item.done
                    //realm.delete(item)                 //to delete an item from database
                }
            }catch{
                print("Error updating items \(error)")
            }
            
            tableView.reloadData()
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //MARK: - Data Manipulation Methods
    func loadDataFromStorage() {
  
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    func saveFiles(items: Item) {
        
        do{
            try realm.write {
                realm.add(items)
            }
        }catch{
            print("Error saving new items \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new To Do item", message: "", preferredStyle: .alert)
        
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if !textField.text!.isEmpty {
                
                if let currentCategory = self.selectedCategory {
                    
                    do{
                        try self.realm.write {
                            
                            let newItem = Item()
                            
                            newItem.title = textField.text!
                            
                            newItem.dateCreated = Date()
                            
                            currentCategory.items.append(newItem)
                        }
                    }catch{
                        
                        print("Error saving new items \(error)")
                    }
                }
                
                self.tableView.reloadData()
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) {
            (action) in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(cancel)
        
        alert.addAction(add)
            
        present(alert, animated: true, completion: nil)
    }
}


//MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {

            loadDataFromStorage()

            DispatchQueue.main.async { //this line close keyboad when search canceled, remove cursor from search box, delete thread that was running for this job

                searchBar.resignFirstResponder()
            }
        }
    }
}


//MARK: - Swipe Cell Delegate Methods
extension ToDoListViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil}
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            if let categoryForDeletion = self.itemArray?[indexPath.row] {
                
                do{
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                    }
                }catch{
                    print("Error deleteing the category \(error)")
                }
            }
        }
        
        deleteAction.image = UIImage(named: "icondelete")
        
        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var option = SwipeTableOptions()
        
        option.expansionStyle = .destructive
        
        option.transitionStyle = .border
        
        return option
    }
}





//    func exampleForLearning() {
//
//        let primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31]
//
//        for (n, prime) in primes.enumerated()
//        {
//            print("\(n) = \(prime)")
//        }
//    }
