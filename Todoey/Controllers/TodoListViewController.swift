//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var items: Results<TodoeyItem>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = UIColor(hexString: selectedCategory!.color!)
        navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor(hexString: selectedCategory!.color!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = UIColor(named: "navBarColor")
        navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor(named: "navBarColor")
    }
    
    override func deleteCell(at indexPath: IndexPath) {
        deleteItem(at: indexPath)
    }
    
    override func editCell(at indexPath: IndexPath) {
        var alertTextField: UITextField? = nil
        let alert = UIAlertController(title: "Edit Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Edit item", style: .default) { action in
            guard let title = alertTextField?.text else {return}
            if title.isEmpty {return}
            self.changeItem(at: indexPath, newTitle: title)
        }
        alert.addTextField { textField in
            alertTextField = textField
            textField.text = self.items?[indexPath.row].title
            textField.placeholder = "Enter item..."
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let screenTitle = selectedCategory?.name else {
            fatalError("Selected category has not been set")
        }
        title = screenTitle
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodoeyItemCell.self, forCellReuseIdentifier: "TodoItemCell")
        setupSearchController()
    }
    
    func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.enablesReturnKeyAutomatically = false
    }
    
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        var alertTextField: UITextField? = nil
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { action in
            guard let title = alertTextField?.text else {return}
            if title.isEmpty {return}
            let item = TodoeyItem()
            item.title = title
            self.insert(item: item)
        }
        alert.addTextField { textField in
            alertTextField = textField
            textField.placeholder = "Enter item..."
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func deleteItem(at indexPath: IndexPath) {
        guard let todoeyItem = items?[indexPath.row] else {return}
        do {
            try realm.write{
                realm.delete(todoeyItem)
            }
        } catch {
            print("Error deleting item \(error.localizedDescription)")
        }
    }
    
    private func updateItem(at indexPath: IndexPath) {
        guard let todoeyItem = items?[indexPath.row] else {return}
        do {
            try realm.write {
                todoeyItem.isChecked = !todoeyItem.isChecked
            }
            tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        } catch {
            print("Error updating item \(error.localizedDescription)")
        }
    }
    
    private func changeItem(at indexPath: IndexPath, newTitle: String) {
        guard let todoeyItem = items?[indexPath.row] else {return}
        do {
            try realm.write {
                todoeyItem.title = newTitle
            }
            tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        } catch {
            print("Error updating item \(error.localizedDescription)")
        }
    }
    
    private func insert(item: TodoeyItem) {
        guard items != nil else {return}
        do {
            try realm.write {
                selectedCategory?.items.append(item)
            }
        } catch {
            print("Error saving context \(error.localizedDescription)")
        }
        let newIndexPath = IndexPath(row: 0, section: 0)
        tableView.reloadData()
        tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
    }
    
    
    private func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "createdAt", ascending: false)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath) as? TodoeyItemCell else {
            fatalError()
        }
        guard let item = items?[indexPath.row] else {
            cell.textLabel?.text = "No items found"
            return cell
        }
        cell.delegate = self
        let color = UIColor(hexString: selectedCategory!.color!)
        cell.backgroundColor = color!.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(items!.count))
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        cell.bindCellWithItem(item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard self.items != nil else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.updateItem(at: indexPath)
        }
    }
}

extension TodoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        if searchText == nil || searchText!.isEmpty {
            loadItems()
        } else {
            searchItems(with: searchText!.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        tableView.reloadData()
    }
    
    private func searchItems(with searchText: String) {
        items = selectedCategory?.items.filter("title BEGINSWITH[cd] %@ OR title CONTAINS[cd] %@", searchText, " \(searchText)").sorted(byKeyPath: "createdAt", ascending: false)
    }
}


