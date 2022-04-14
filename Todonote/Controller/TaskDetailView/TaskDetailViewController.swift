//
//  TaskDetailViewController.swift
//  Todonote
//
//  Created by Kirill Sytkov on 10.04.2022.
//

import UIKit
import RealmSwift

class TaskDetailViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskDate: UIDatePicker!
    @IBOutlet weak var taskNote: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var topView: UIView!
    
    //MARK: - vars/lets
    var item: Item?
    let realm = try! Realm()
    
    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    //MARK: - IBActions
    
    @IBAction func updateButtonPressed(_ sender: UIButton) {
        
        if taskTitle.text != "" {
            let newItem = Item()
            newItem.title = taskTitle.text ?? ""
            newItem.date = taskDate.date
            newItem.note = taskNote.text ?? ""
            
            saveTask(item: newItem)
            dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Add some title", message: "", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
        
    }
        
    //MARK: - flow func
    private func updateUI() {
        topView.layer.cornerRadius = 20
        guard let item = item else { return }
        updateButton.layer.cornerRadius = 10
        taskTitle.text = item.title
        taskNote.text = item.note
        taskDate.date = item.date
    }
    
    private func saveTask(item: Item) {
        do {
            try realm.write({
                item
            })
        } catch {
            debugPrint(error)
        }
    }
}

