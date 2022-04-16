//
//  TasksTableViewCell.swift
//  Todonote
//
//  Created by Kirill Sytkov on 13.04.2022.
//

import UIKit

class TasksTableViewCell: UITableViewCell {

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var dateTitle: UILabel!
    
    func configure(task: TasksCellViewModel) {
        let date = task.taskDate
        let formater = DateFormatter()
        formater.dateFormat = "HH:mm E, d MMM"
        let string = formater.string(from: date)
        
        taskTitle.text = task.taskTitle
        dateTitle.text = string
    }

}
