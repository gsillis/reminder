//
//  ViewController.swift
//  Reminder
//
//  Created by Gabriela Sillis on 20/07/21.
//

import UIKit

class ViewController: UIViewController {
    
    private var model = [TodoItem]()
    let tableview = UITableView()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableview)
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        //adiciona o botão add no navVc
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableview.frame = view.bounds
    }
    
    //MARK: - adiciona um alert e um texfield ao clicar no botao add no navVc
    @objc private func addButtonTapped() {
        
        let alert:UIAlertController = UIAlertController(title: "Adicionar novo lembrete",
                                                                                message: "Deseja adicionar um novo lembrete?",
                                                                                preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        let submit: UIAlertAction = UIAlertAction(title: "Adicionar", style: .default) { action in
            guard let textfield = alert.textFields?.first, let text = textfield.text, !text.isEmpty else {
                return
            }
            self.createdItem(name: text)
        }
        alert.addAction(submit)
        self.present(alert, animated: true)
    }
    
    
    //MARK: - Core Data
    func getItems() {
        do {
            model =  try context.fetch(TodoItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
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
