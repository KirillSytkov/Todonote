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
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var topView: UIView!
    
    //MARK: - vars/lets
    let realm = try! Realm()
    var item: Results<Item>?
    var selectedCategory: Category?
    
    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    //MARK: - IBActions
    private func updateUI() {
        topView.layer.cornerRadius = 20
        saveButton.layer.cornerRadius = 10
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if titleTask.text != "" {
            let newItem = Item()
            newItem.title = titleTask.text ?? ""
            newItem.date = datePicker.date
            newItem.note = noteTask.text ?? ""
            saveTask(item: newItem)
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
    func saveTask(item: Item) {
        if titleTask.text != "" {
            if let selectedCategory = selectedCategory {
                do {
                    try realm.write ({
                        selectedCategory.items.append(item)
                    })
                } catch {
                    debugPrint(error)
                }
            }
        }
    }
    
}
