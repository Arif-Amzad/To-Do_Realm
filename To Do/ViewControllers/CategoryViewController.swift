//
//  CategoryViewController.swift
//  To Do
//
//  Created by Arif Amzad on 30/10/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray = [Category]()
    
    let cellID = "CategoryCell"
    
    var indexNumber = Int()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadFromStorage()
    }

    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let cat = categoryArray[indexPath.row]
        
        cell.textLabel?.text = cat.name
        
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
    
        destination.selectedCategory = categoryArray[indexNumber]
        
        
    }
    
    
    
    //MARK: - Data Manipulation Methods
    func loadFromStorage() {
        
//        let request: NSFetchRequest<Category> = Category.fetchRequest()
//
//        do {
//            categoryArray = try  context.fetch(request)
//        }catch {
//            print("Error fetching data from context ===== \(error) =====")
//        }
        
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
                
                self.categoryArray.append(newCategory)
                
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
