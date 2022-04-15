//
//  Manager.swift
//  Todonote
//
//  Created by Kirill Sytkov on 15.04.2022.
//

import Foundation
import RealmSwift

class Manager {
    
    static let shared = Manager()
    let realm = try! Realm()
    
    private init() {}
    
    func saveCategory(category: Category, completion: @escaping ()->()) {
        do {
            try realm.write({
                realm.add(category)
                completion()
            })
        } catch {
            debugPrint(error)
        }
    }
    
    func loadCategory(completion: @escaping (Results<Category>?) -> ()) {
        let categories = realm.objects(Category.self)
        completion(categories)
    }
    
    func deleteCategory(category: Category) {
        do {
            try realm.write({
                realm.delete(category)
            })
        } catch {
            debugPrint(error)
        }
    }
    
    

}
