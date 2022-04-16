//
//  TaskViewModel.swift
//  Todonote
//
//  Created by Kirill Sytkov on 16.04.2022.
//

import Foundation
import RealmSwift

class TasksViewModel {
    
    //MARK: - vars/lets
    var reloadTableView: (()->())?
    
    private let realm = try! Realm()
    var selectedCategory: Category?
    var tasks: Results<Task>?
    
    var numberOfCells: Int {
        tasks?.count ?? 0
    }
    
    private var cellViewModel = [TasksCellViewModel]() {
        didSet {
            self.reloadTableView?()
        }
    }
    
    //MARK: - flow func
    func getTask() {
        tasks = selectedCategory?.tasks.sorted(byKeyPath: "date" , ascending: true)
        createCell(tasks: tasks)
        self.reloadTableView?()
    }
    
    func deleteTask(indexPath: Int) {
        TaskManager.shared.deleteTask(task: tasks![indexPath])
    }
    
    //MARK: - tableView func
    func getCellViewModel(at  indexPath: IndexPath) -> TasksCellViewModel {
        return cellViewModel[indexPath.row]
    }
    
    func createCell(tasks: Results<Task>? ) {
        var viewModelCell = [TasksCellViewModel]()
        for task in tasks! {
            viewModelCell.append(TasksCellViewModel(taskTitle: task.title, taskDate: task.date))
        }
        cellViewModel = viewModelCell
    }
    
}

struct TasksCellViewModel {
    var taskTitle: String
    var taskDate: Date
}
