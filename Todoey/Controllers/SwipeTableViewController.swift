//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Omar Assidi on 04/01/2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

protocol SwipeCellActions {
    func deleteCell(at indexPath: IndexPath)
    func editCell(at indexPath: IndexPath)
}

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate, SwipeCellActions {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.deleteCell(at: indexPath)
        }
        deleteAction.image = UIImage(named: "delete")
    
        let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
            self.editCell(at: indexPath)
        }
        editAction.image = UIImage(systemName: "pencil")
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func deleteCell(at indexPath: IndexPath) {}
    func editCell(at indexPath: IndexPath) {}
}
