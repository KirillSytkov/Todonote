//
//  ViewController.swift
//  Todonote
//
//  Created by Kirill Sytkov on 10.04.2022.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottonView: UIView!
    
    //MARK: - vars/lets
    var categories: Results<Category>?
    var filteredCategories: Results<Category>?
    let realm = try! Realm()
    
    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        loadCategory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    //MARK: - IBActions
    @IBAction func textFieldUpdate(_ sender: UITextField) {
        self.searchCategory(text: sender.text ?? "")
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let newCategory = Category()
            if let category = textField.text {
                newCategory.title = category
                self.saveCategory(category: newCategory)
            }
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add some Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }

    //MARK: - flow func
    private func updateUI() {
        topView.layer.cornerRadius = 10
    }

    
    private func saveCategory(category: Category) {
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            debugPrint(error)
        }
        
        filteredCategories = categories
        self.tableView.reloadData()
    }
    
    private func loadCategory() {
        categories = realm.objects(Category.self)
        filteredCategories = categories
        self.tableView.reloadData()
    }
    
    private func deleteCategory(category: Category) {
        do {
            try realm.write({
                realm.delete(category)
            })
        } catch {
            debugPrint(error)
        }
    }
    private func searchCategory(text: String) {
        if text == "" {
            filteredCategories = categories
        } else {
            filteredCategories = categories?.where({ categories in
                categories.title.starts(with: text)
            })
        }
        self.tableView.reloadData()
    }
    
}
//MARK: - Extensions

extension CategoryViewController: UITableViewDelegate,  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let filteredCategories = filteredCategories else { return categories?.count ?? 1}
        return filteredCategories.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
        
        if let filterCategory = filteredCategories {
            cell.configure(category: filterCategory[indexPath.row])
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "TasksViewController") as? TasksViewController
        else { return }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let category = categories else { return }
    
        if editingStyle == .delete {
            self.deleteCategory(category: category[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension CategoryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            searchCategory(text: searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
}

