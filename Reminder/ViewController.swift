//
//  ViewController.swift
//  Reminder
//
//  Created by Gabriela Sillis on 20/07/21.
//

import UIKit

class ViewController: UIViewController {
    
    let tableview = UITableView()
    
    private var model = [TodoItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableview)
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableview.frame = view.bounds
    }
    
    
    //MARK: - Core Data
    func getAllItems() {
        do {
            model =  try context.fetch(TodoItem.fetchRequest())
        } catch  {
            //error
        }
    }
    
    func createdItem(name: String) {
        let newItem = TodoItem(context: context)
        newItem.task = name
        newItem.createdDate = Date()
        
        do {
            try context.save()
        } catch  {
            //error
        }
    }
    
    func deleteItem(item: TodoItem) {
        context.delete(item)
        
        do {
            try context.save()
        } catch  {
            //error
        }
    }
    
    func updateItem(item: TodoItem, newName: String) {
        item.task = newName
        
        do {
            try context.save()
        } catch  {
            //error
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let models = model[indexPath.row]
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models.task
        
        return cell
    }
}
