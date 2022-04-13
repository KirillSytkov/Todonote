//
//  AddTaskViewController.swift
//  Todonote
//
//  Created by Kirill Sytkov on 10.04.2022.
//

import UIKit
import RealmSwift

class AddTaskViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var titleTask: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteTask: UITextField!
     
    //MARK: - vars/lets
    let realm = try! Realm()
    var item: Results<Item>?
    
    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - IBActions
    @IBAction func addTaskNote(_ sender: UITextField) {
        
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if titleTask.text != "" {
            let newItem = Item()
            newItem.title = titleTask.text ?? ""
            newItem.date = datePicker.date
            newItem.note = noteTask.text ?? ""
        }

    }
     
    //MARK: - flow func
    func saveTask(item: Item) {
        if titleTask.text != "" {
            do {
                try realm.write ({
                    realm.add(item)
                })
            } catch {
                debugPrint(error)
            }
        }
    }
    
}
