//
//  ViewController.swift
//  Todoey
//
//  Created by Xiaoyun Zhi on 2/18/18.
//  Copyright © 2018 Xiaoyun Zhi. All rights reserved.
//

import UIKit
import CoreData // note Item(71) is a NSManagedObject, which only exists in the coredata framework

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet{ // happen as soon as selectedCategory has a value
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // note

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)) // where the data is being stored
        
    }
    
    //MARK: TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // get called initially when the tableview get loaded up, so you should reload tableview instead
        print("cellForRowAt indexPath called")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none // Ternary operator
        
        return cell
    }
    
    //MARK: TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row].title)
        
    
        // first remove the item from core data and then remove on the list (reason: indexPath)
        //context.delete(itemArray[indexPath.row]) // delete item from core data
        //itemArray.remove(at: indexPath.row) // remove item from the tableview
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: add new item function
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add item", style: .default) { (action) in
            print("success, add item pressed") // what will happen when the add item is pressed
            
            let item = Item(context: self.context) // ADD item in NSManagedObjectContext
            
            item.title = textField.text!
            item.done = false
            item.parentCategory = self.selectedCategory // NOTE
            
            self.itemArray.append(item)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            print("addTextField completed")
            textField = alertTextField // NOTE!!
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Model Munipulation Methods
    
    func saveItems() {
        
        do {
           try context.save() // SAVE from NSManagedObjectContext into the context's parent store
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) { // give a initail value
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!) // note
        
        // using optional wrapping to avoid a nil value 
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
        } else {
            request.predicate = categoryPredicate
        }

//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, categoryPredicate])
//
//        request.predicate = compoundPredicate // note
        do {
            itemArray = try context.fetch(request) // output is an array of items
            
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }

}

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // can be shortened into one line of code
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) // the title should contain %@
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true) // the result should be sorted by their title in a ascending format
        request.sortDescriptors = [sortDescriptor]
        
        print(searchBar.text!)
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // because of this line of code being run in the foregoround 
            }
        }
    }
}

