//
//  SwipeTableViewController.swift
//  To Do
//
//  Created by Arif Amzad on 3/11/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil}
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
//            if let categoryForDeletion = self.categoryArray?[indexPath.row] {
//                
//                do{
//                    try self.realm.write {
//                        self.realm.delete(categoryForDeletion)
//                    }
//                }catch{
//                    print("Error deleteing the category \(error)")
//                }
//            }
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
