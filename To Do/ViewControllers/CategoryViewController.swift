//
//  CategoryViewController.swift
//  To Do
//
//  Created by Arif Amzad on 30/10/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?  //Results work as auto updating container. no need to add anything like array.append(data). it will automatically update these things
    
    let cellID = "CategoryCell"
    
    var indexNumber = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.rowHeight = 80.0
        
        loadFromStorage()
    }

    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1 // nil coalising operator
        //meaning of categoryArray?.count =>> if category array is not nill then do this
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
        
        //cell.delegate = self
        
        return cell
    }
    
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        tableView.deselectRow(at: indexPath, animated: true)
        
        indexNumber = indexPath.row
        
        performSegue(withIdentifier: "category2Items", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! ToDoListViewController
        
        //let indexPath = tableView.indexPathForSelectedRow
        //it will identify which row is selected automatically
    
        destination.selectedCategory = categoryArray?[indexNumber]
    }
    
    
    
    //MARK: - Data Manipulation Methods
    func loadFromStorage() {
        
        categoryArray = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    func saveFiles(category: Category) {
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    
    //MARK: - Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new activity", message: "To Do", preferredStyle: .alert)
        
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if !textField.text!.isEmpty {
                
                let newCategory = Category()
                
                newCategory.name = textField.text!
                
                self.saveFiles(category: newCategory)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new category"
            
            textField = alertTextField
        }
        
        alert.addAction(cancel)
        alert.addAction(add)
        
        present(alert, animated: true, completion: nil)
    }
}


//MARK: - Swipe Cell Delegate Methods
extension CategoryViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil}
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            print("jgiofgoingonfogn")
            
            if let categoryForDeletion = self.categoryArray?[indexPath.row] {
                
                do{
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                        print("deleted")
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
