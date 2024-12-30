//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Omar Assidi on 28/12/2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    var categories: Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        loadCategories()
        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField: UITextField? = nil
        let alert = UIAlertController(title: "Add new Todoey category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { action in
            guard let title = alertTextField?.text else {return}
            if title.isEmpty {return}
            let category = Category()
            category.name = title
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
        cell.bindCellWithItem(category)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard categories != nil else { return }
        self.performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self).sorted(byKeyPath: "createdAt", ascending: false)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
            
        }
    }


}
