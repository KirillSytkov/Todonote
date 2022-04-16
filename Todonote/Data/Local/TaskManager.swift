//
//  TaskManager.swift
//  Todonote
//
//  Created by Kirill Sytkov on 16.04.2022.
//

import Foundation
import RealmSwift

class TaskManager {
    static let shared = TaskManager()
    let realm = try! Realm()
    
    private init() {}
    
    func saveTask(_ selectedCategory: Category,task: Task) -> Bool {
        do {
            try realm.write({
                selectedCategory.tasks.append(task)
            })
            return true
        } catch {
            debugPrint(error)
            return false
        }
    }
    
    func deleteTask(task: Task) {
        do {
            try realm.write({
                realm.delete(task)
            })
        } catch {
            debugPrint(error)
        }
    }
}
