//
//  CategoryTableViewCell.swift
//  Todonote
//
//  Created by Kirill Sytkov on 12.04.2022.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var taskLabel: UILabel!
    
    func configure(category: CategoryCellViewModel) {
        taskLabel.text = category.title
    }

}
