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
        navigationItem.title = "Reminder"
        getItems()
        
        //adiciona o botão add no navVc
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonTapped))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableview.frame = view.bounds
    }
    
    //MARK: - adiciona um alert e um texfield ao clicar no botao add no navVc
    @objc private func addButtonTapped() {
        let alert: UIAlertController = self.alertController(title: "Novo Lembrete", message: "Deseja adicionar um novo lembrete?", style: .alert)
        let submit: UIAlertAction = UIAlertAction(title: "Adicionar", style: .default) { [weak self] action in
            guard let textfield = alert.textFields?.first, let text = textfield.text, !text.isEmpty else {
                return
            }
            self?.createItem(name: text)
        }
        alert.addAction(submit)
    }
    
    //cria um alert controller
    func alertController(title: String, message: String? = nil, style: UIAlertController.Style) -> UIAlertController {
        let alert:UIAlertController = UIAlertController(title: title,
                                                        message: message,
                                                        preferredStyle: style)
        alert.addTextField(configurationHandler: nil)
        self.present(alert, animated: true)
        
        return alert
    }
    
    //MARK: - Core Data
    func getItems() {
        do {
            model =  try context.fetch(TodoItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func createItem(name: String) {
        let newItem = TodoItem(context: context)
        newItem.task = name
        newItem.createdDate = Date()
        
        do {
            try context.save()
            getItems()
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func deleteItem(item: TodoItem) {
        context.delete(item)
        
        do {
            try context.save()
            getItems()
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func updateItem(item: TodoItem, newName: String) {
        item.task = newName
        do {
            try context.save()
            self.getItems()
        } catch  {
            print(error.localizedDescription)
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
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
    
    //Deleta os valores da cell e do core data
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let models = model[indexPath.row]
        if editingStyle == .delete {
            self.deleteItem(item: models)
            tableview.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = model[indexPath.row]
        let alert: UIAlertController = self.alertController(title: "Editar lembrete", style: .alert)
        alert.textFields?.first?.text = model.task
        alert.addAction(UIAlertAction(title: "Salvar", style: .default) { [weak self] action in
            guard let textField = alert.textFields?.first, let newName = textField.text, !newName.isEmpty else { return }
            self?.updateItem(item: model, newName: newName)
        })
    }
}

