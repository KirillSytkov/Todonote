//
//  ViewController.swift
//  Todonote
//
//  Created by Kirill Sytkov on 10.04.2022.
//

import UIKit

class CategoryViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bottonView: UIView!
    @IBOutlet weak var plusButton: UIButton!
    
    //MARK: - vars/lets
    var viewModel = CategoryViewModel()
    
    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    //MARK: - IBActions

    @IBAction func addPressed(_ sender: UIButton) {
        buttonAnimate(button: sender)
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Add", style: .default) { action in
            self.viewModel.addButtonPressed(textField: textField)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Category title..."
            textField = alertTextField
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }

    //MARK: - flow func
    private func updateUI() {
        plusButton.layer.cornerRadius = plusButton.frame.height / 2
        bottonView.layer.cornerRadius = 20
        tableView.layer.cornerRadius = 20
        searchBar.searchTextField.backgroundColor = .white
       
    }
    private func buttonAnimate(button: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear) {
            UIView.modifyAnimations(withRepeatCount: 1, autoreverses: true) {
                button.transform  = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        } completion: { _ in
            button.transform  = CGAffineTransform(scaleX: 1, y: 1)
        }

    }

    private func bind() {
        viewModel.reloadTableView = {
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
        viewModel.getCategory()
    }
    
}
//MARK: - Extensions

extension CategoryViewController: UITableViewDelegate,  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
        
        let cellViewModel = viewModel.getCellViewModel(at: indexPath)
        cell.configure(category: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "TasksViewController") as? TasksViewController
        else { return }
        
        controller.viewModel.selectedCategory = viewModel.categories?[indexPath.row]
        controller.categoryLabel = viewModel.categories?[indexPath.row].title
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            viewModel.deleteCategory(indexPath: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }

//    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let movedObject = self.headlines[sourceIndexPath.row]
//        headlines.remove(at: sourceIndexPath.row)
//        headlines.insert(movedObject, at: destinationIndexPath.row)
//    }
}

extension CategoryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchCategory(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchCategory(text: searchBar.text!)
        self.searchBar.endEditing(true)
    }
    
}

