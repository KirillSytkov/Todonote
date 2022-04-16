//
//  TaskDetailViewController.swift
//  Todonote
//
//  Created by Kirill Sytkov on 10.04.2022.
//

import UIKit

class TaskDetailViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskDate: UIDatePicker!
    @IBOutlet weak var taskNote: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    //MARK: - vars/lets
    var activeTextField: UITextField? = nil
    var viewModel = TaskDetailViewModel()
    
    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskTitle.delegate = self
        self.taskNote.delegate = self
        registerForKeyboardNotifications()
        bind()
        viewModel.getTaskDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    //MARK: - IBActions
    
    @IBAction func updateButtonPressed(_ sender: UIButton) {
        if taskTitle.text != "" {
            viewModel.updatePressed(title: taskTitle, date: taskDate, note: taskNote)
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
        updateButton.layer.cornerRadius = 10
    }
    
    private func bind() {
        self.viewModel.title.bind { [weak self] title in
            self?.taskTitle.text = title
        }
        self.viewModel.date.bind { [weak self] date in
            if let date = date {
                self?.taskDate.date = date
            }          
        }
        self.viewModel.note.bind { [weak self] note in
            self?.taskNote.text = note
        }
        
    }
    
    private func registerForKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }

     @IBAction  func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
         
         var shoulMoveViewUp = false
         
         if let activeTextField = activeTextField {
             
             let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
             let topOfKeyboard = self.view.frame.height - keyboardScreenEndFrame.height
             
             if bottomOfTextField > topOfKeyboard {
                 shoulMoveViewUp = true
             }
         }
         
         if shoulMoveViewUp {
            if notification.name == UIResponder.keyboardWillShowNotification {
                topConstraint.constant -= keyboardScreenEndFrame.height
                bottomConstraint.constant = keyboardScreenEndFrame.height
            }

         }
         
         UIView.animate(withDuration: 0.3) {
             self.view.layoutIfNeeded()
         }
        
    }


}

extension TaskDetailViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.activeTextField = nil
        topConstraint.constant = 0
        bottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}

