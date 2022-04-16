//
//  AddTaskViewModel.swift
//  Todonote
//
//  Created by Kirill Sytkov on 16.04.2022.
//

import Foundation
import RealmSwift

class AddTaskViewModel {
    //MARK: - vars/lets
    
    let realm = try! Realm()
    var selectedCategory: Category?
    var task: Results<Task>?
    
    //MARK: - flow func
    
    func saveTask(title: String, date: Date, note: String) -> Bool {
        if title != "" {
            let newTask = Task()
            newTask.title = title
            newTask.date = date
            newTask.note = note
            return TaskManager.shared.saveTask(selectedCategory!, task: newTask) ? true : false
        }
        return false
    }
    
}
