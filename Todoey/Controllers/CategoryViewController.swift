//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Omar Assidi on 28/12/2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    var categories: Results<Category>?
    let realm = try! Realm()
    
    var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        title = "Todoey"
        loadCategories()
        setRightBarButtonItem()
    }
    
    private func setRightBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func deleteCell(at indexPath: IndexPath) {
        self.deleteCategory(at: indexPath)
    }
    
    override func editCell(at indexPath: IndexPath) {
        var alertTextField: UITextField? = nil
        let alert = UIAlertController(title: "Edit Todoey category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Edit category", style: .default) { action in
            guard let title = alertTextField?.text else {return}
            if title.isEmpty {return}
            self.changeItem(at: indexPath, newTtitle: title)
        }
        alert.addTextField { textField in
            alertTextField = textField
            textField.text = self.categories?[indexPath.row].name
            textField.placeholder = "Enter item..."
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
     @objc func addButtonPressed() {
        var alertTextField: UITextField? = nil
        let alert = UIAlertController(title: "Add new Todoey category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { action in
            guard let title = alertTextField?.text else {return}
            if title.isEmpty {return}
            let category = Category()
            category.name = title
            category.color = UIColor.randomFlat().hexValue()
            self.newItemInserted(category: category)
        }
        alert.addTextField { textField in
            alertTextField = textField
            textField.placeholder = "Enter item..."
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        guard let category = categories?[indexPath.row] else {
            cell.textLabel?.text = "No categories yet"
            return cell
        }
        cell.delegate = self
        cell.bindCellWithItem(category)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard categories != nil else { return }
        if let indexPath = tableView.indexPathForSelectedRow {
            coordinator?.navigateToList(selectedCategory: categories?[indexPath.row])
        }
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self).sorted(byKeyPath: "createdAt", ascending: false)
    }
    
    private func deleteCategory(at indexPath: IndexPath) {
        guard let category = categories?[indexPath.row] else {return}
        do {
            try realm.write{
                realm.delete(category)
            }
        } catch {
            print("Error deleting item \(error.localizedDescription)")
        }
    }
    private func newItemInserted(category: Category) {
        save(category: category)
        guard categories != nil else { return }
        let newIndexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .bottom)
        tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
    }
    
    private func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error.localizedDescription)")
        }
    }
    
    private func changeItem(at indexPath: IndexPath, newTtitle: String) {
        guard let category = categories?[indexPath.row] else {return}
        do {
            try realm.write {
                category.name = newTtitle
            }
            tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        } catch {
            print("Error updating item \(error.localizedDescription)")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
            
        }
    }
}
