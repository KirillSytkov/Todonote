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
    
    func configure(task: Item) {
        taskTitle.text = task.title
    }

}
