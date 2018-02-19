//
//  ViewController.swift
//  Todoey
//
//  Created by Xiaoyun Zhi on 2/18/18.
//  Copyright © 2018 Xiaoyun Zhi. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Data]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Data()
        newItem.title = "read the lean starup"
        itemArray.append(newItem)
        
        let newItem2 = Data()
        newItem2.title = "read the lean starup"
        itemArray.append(newItem2)
        
        let newItem3 = Data()
        newItem3.title = "read the lean starup"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Data] {
            itemArray = items
        }
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
        print(itemArray[indexPath.row].title)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: add new item function
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add item", style: .default) { (action) in
            print("success, add item pressed") // what will happen when the add item is pressed
            
            let item = Data()
            item.title = textField.text!
            self.itemArray.append(item)
            
            self.defaults.setValue(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            print("addTextField completed")
            textField = alertTextField // NOTE!!
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    


}

