//
//  TaskDetailViewModel.swift
//  Todonote
//
//  Created by Kirill Sytkov on 16.04.2022.
//

import Foundation
import RealmSwift

class TaskDetailViewModel {
    
    //MARK: - vars/lets
    var title = Bindable<String?>(nil)
    var date = Bindable<Date?>(nil)
    var note = Bindable<String?>(nil)
    
    private let realm = try! Realm()
    var task: Task?
    
    func updatePressed(title: UITextField, date: UIDatePicker, note: UITextField){
        
        if title.text != "" {
            do {
                try realm.write({
                    task!.title = title.text ?? ""
                    task!.date = date.date
                    task!.note = note.text ?? ""
                })
            } catch {
                debugPrint(error)
            }
        }
    }
    
    func getTaskDetail() {
        self.title.value = task?.title
        self.date.value = task!.date
        self.note.value = task?.note
    }
    
}
