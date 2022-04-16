//
//  CategoryViewModel.swift
//  Todonote
//
//  Created by Kirill Sytkov on 15.04.2022.
//

import Foundation
import RealmSwift

class CategoryViewModel {
    //MARK: - vars/lets
    let realm = try! Realm()
    var categories: Results<Category>?
    private var cellViewModel = [CategoryCellViewModel]() {
        didSet {
            self.reloadTableView?()
        }
    }
    
    var reloadTableView: (()->())?
    var numberOfCell: Int {
        categories?.count ?? 0
    }
    
    //MARK: - flow func
    func getCategory() {
        CategoryManager.shared.loadCategory { categories in
            self.createCell(categories: categories)
        }
    }
    
    func searchCategory(text: String) {
        if text.count != 0 {
            self.categories = categories?.where({
                $0.title.starts(with: text, options: .caseInsensitive)
            })
        } else {
            getCategory()
        }
        self.createCell(categories: categories)
        self.reloadTableView?()
        
    }
    
    func deleteCategory(indexPath: Int) {
        CategoryManager.shared.deleteCategory(category: categories![indexPath])
    }
    
    func addButtonPressed(textField: UITextField) {
        if textField.text != "" {
            let newCategory = Category()
            newCategory.title = textField.text!
                CategoryManager.shared.saveCategory(category: newCategory) {
                    self.createCell(categories: self.categories)
            }
        }
    }
    
    //MARK: - tableView func
    func getCellViewModel(at indexPath: IndexPath) -> CategoryCellViewModel {
        return cellViewModel[indexPath.row]
    }
    
    func createCell(categories: Results<Category>? ) {
        
        self.categories = categories
        var viewModelCell = [CategoryCellViewModel]()
        for category in categories! {
            viewModelCell.append(CategoryCellViewModel(title: category.title))
        }
        cellViewModel = viewModelCell
    }
}

struct CategoryCellViewModel{
    var title: String
}
