//
//  CategoryViewModel.swift
//  Todonote
//
//  Created by Kirill Sytkov on 15.04.2022.
//

import Foundation
import RealmSwift

class CategoryViewModel {
    
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
    
    func getCategory() {
        Manager.shared.loadCategory { categories in
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
        Manager.shared.deleteCategory(category: categories![indexPath])
    }
    
    func addButtonPressed(textField: UITextField) {
        let newCategory = Category()
        if let category = textField.text {
            newCategory.title = category
            Manager.shared.saveCategory(category: newCategory) {
                self.createCell(categories: self.categories)
            }
        }
    }
    
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
