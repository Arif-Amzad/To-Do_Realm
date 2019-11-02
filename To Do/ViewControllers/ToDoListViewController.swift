//
//  ViewController.swift
//  To Do
//
//  Created by Arif Amzad on 12/9/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    let cellID = "ToDoItemCell"
    
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet {
            
            // loadDataFromStorage()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //medium to read,update,destroy our data, through this we will comunicate with our persistent container

    override func viewDidLoad() {
        super.viewDidLoad()
                
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //loadDataFromStorage()
        
        navigationItem.title = selectedCategory?.name
    }
    
    
    
    //MARK - TableView DataSource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveFiles()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //MARK: - Data Manipulation Methods
//    func loadDataFromStorage(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//        //here "with" is external and "request" is internal parameter
//
//        // Item.fetchRequest() has been added later for the function which will work without parameter viewed in viewDidLoad
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        }
//        else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//        }catch {
//            print("Error fetching data from context ===== \(error) =====")
//        }
//
//        tableView.reloadData()
//    }
    
    func saveFiles() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new To Do item", message: "", preferredStyle: .alert)
        
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if !textField.text!.isEmpty {
                
//                let newItem = Item(context: self.context)
//
//                newItem.title = textField.text
//
//                newItem.done = false
//
//                newItem.parentCategory = self.selectedCategory
//
//                self.itemArray.append(newItem)
                
                self.saveFiles()
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
//extension ToDoListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//
//        request.sortDescriptors = [sortDescriptor]
//
//        loadDataFromStorage(with: request, predicate: predicate)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchBar.text?.count == 0 {
//
//            loadDataFromStorage()
//
//            DispatchQueue.main.async { //this line close keyboad when search canceled, remove cursor from search box, delete thread that was running for this job
//
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}





//    func exampleForLearning() {
//
//        let primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31]
//
//        for (n, prime) in primes.enumerated()
//        {
//            print("\(n) = \(prime)")
//        }
//    }
